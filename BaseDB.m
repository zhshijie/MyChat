//
//  DataBaseModel.m
//  Track-tripStrategy
//
//  Created by ncg ncg-2 on 11-11-5.
//  Copyright 2011 www.iphonetrain.com 无限互联3G学院 All rights reserved.
//

#import "BaseDB.h"


@implementation BaseDB

#define kFilename    @"data.sqlite"

- (NSString *)dataFilePath 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
}


//创建表
-(void)createTable:(NSString *)sql
{
	//打开数据库
    if (sqlite3_open([[self dataFilePath] UTF8String], &database)!= SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
 

    char *errorMsg;
	//创建一个表
	if (sqlite3_exec (database, [sql  UTF8String],NULL, NULL, &errorMsg) != SQLITE_OK) 		
	{
        sqlite3_close(database);
        NSAssert1(0, @"Error creating table: %s", errorMsg);
    }
}


#pragma mark 查询数据库
/************
 sql：sql语句
 col：sql语句需要操作的表的所有字段数
 ***********/
- (NSMutableArray *)selectData:(NSString *)sql columns:(int)col 
{
	//打开数据库
    if (sqlite3_open([[self dataFilePath] UTF8String], &database)!= SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
	
 	NSMutableArray *returndata = [[NSMutableArray alloc] init] ;//所有记录
		sqlite3_stmt *statement = nil;
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
				NSMutableArray *row;//一条记录
				row = [[NSMutableArray alloc] init];
				for(int i=0; i<col; i++)
				{
					char* contentchar = (char*)sqlite3_column_text(statement, i);
					if (contentchar) 
					{
						[row addObject:[NSString stringWithFormat:@"%@",[NSString stringWithUTF8String:contentchar]]];
					}
				}
				[returndata addObject:row];
            }
        }else 
		{
			NSLog(@"Error: failed to prepare");
			return NO;
		}
		sqlite3_finalize(statement);
 		return returndata; 
}

#pragma mark 查询数据库
/************
 sql：sql语句
 col：sql语句需要操作的表的所有字段数
 ***********/
- (NSMutableArray *)selectFullData:(NSString *)sql columns:(int)col 
{
	//打开数据库
    if (sqlite3_open([[self dataFilePath] UTF8String], &database)!= SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
	
 	NSMutableArray *returndata = [[NSMutableArray alloc] init];//所有记录
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableArray *row;//一条记录
            row = [[NSMutableArray alloc] init];
            for(int i=0; i<col; i++)
            {
                char* contentchar = (char*)sqlite3_column_text(statement, i);
                if (contentchar) 
                {
                    [row addObject:[NSString stringWithFormat:@"%@",[NSString stringWithUTF8String:contentchar]]];
                }
                else
                {
                    [row addObject:@""];
                }
            }
            [returndata addObject:row];
        }
    }else 
    {
        NSLog(@"Error: failed to prepare");
        return NO;
    }
    sqlite3_finalize(statement);
	NSLog(@"%@",returndata);
    return returndata; 
}

/************
 sql：sql语句
 ***********/
- (UIImage *)selectData:(NSString *)sql
{
	UIImage *returnimg = [[UIImage alloc] init];
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *statement = nil;
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
				int bytes = sqlite3_column_bytes(statement, 0);
				const void *value = sqlite3_column_blob(statement, 0);
				if( value != NULL && bytes != 0 ){
					NSData *data = [NSData dataWithBytes:value length:bytes];
					returnimg=[UIImage imageWithData:data];
				}
				else{
					NSLog(@"img is null");
				}
            }
        }else {
			NSLog(@"Error: failed to prepare");
			return NO;
		}
		return returnimg;
        sqlite3_finalize(statement);
    } else {
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }//end if
	sqlite3_close(database);
	return returnimg ;
}



#pragma mark 增，删，改数据库
/************
 sql：sql语句
 param：sql语句中?对应的值组成的数组
 ***********/
- (BOOL)dealData:(NSString *)sql paramarray:(NSArray *)param 
{
//	sql = @"INSERT OR REPLACE INTO FIELDS (ROW, FIELD_DATA) VALUES (?, ?);";

//	sql = @"INSERT  INTO TravelPointTable ( trackId , latitude , longitude) VALUES ( ?,?,?);";
//	param = [NSArray arrayWithObjects:@"11111",@"22222",@"3333",nil];
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK)
	{
        sqlite3_stmt *statement = nil;
        int success = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
		if (success != SQLITE_OK) {
			NSLog(@"Error: failed to prepare");
			return NO;
		}
		//绑定参数
		for (int i=0; i<[param count]; i++) 
		{
			NSString *temp = [param objectAtIndex:i];
			sqlite3_bind_text(statement, i+1, [temp UTF8String], -1, SQLITE_TRANSIENT);
		}
		success = sqlite3_step(statement);
        sqlite3_finalize(statement);
		if (success == SQLITE_ERROR) 
		{
			NSLog(@"Error: failed to insert into the database");
			return NO;
		}
    }

	
	sqlite3_close(database);   
	NSLog(@"处理成功！");
	return TRUE;
}

#pragma  查询某个东西的合计
- (NSUInteger) selectCount:(NSString *)sql
{
    NSUInteger total = 0;
//    const char *sql = "SELECT COUNT(*) AS amount FROM xxx";

    if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK)
	{
        sqlite3_stmt *statement = nil;

        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
        
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            total = sqlite3_column_int(statement, 0);
        }
        
        sqlite3_finalize(statement);
    }
	return total;
}

#pragma mark 向数据库保存图片
/************
 sql：sql语句
 param：
 ***********/
- (BOOL)saveimage:(NSString *)sql paramarray:(NSMutableArray *)param {
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *statement = nil;
		int success =sqlite3_prepare(database,[sql UTF8String],-1,&statement,0);
		// int success = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
		if (success != SQLITE_OK) {
			NSLog(@"Error: failed to prepare");
			return NO;
		}
		//绑定参数
		for (int i=0; i<[param count]; i++) {
			if (i==2) {
				NSData *imgdata = [param objectAtIndex:2];
				sqlite3_bind_blob(statement, 3, [imgdata bytes], [imgdata length], NULL);//如果是nsdata型
			}
			else {
				NSString *temp = [param objectAtIndex:i];
				sqlite3_bind_text(statement, i+1, [temp UTF8String], -1, SQLITE_TRANSIENT);
			}
		}
		success = sqlite3_step(statement);
        sqlite3_finalize(statement);
		if (success == SQLITE_ERROR) {
			NSLog(@"Error: failed to insert into the database");
			return NO;
		}
    }
	NSLog(@"处理成功！");
	
	return TRUE;
}




@end
