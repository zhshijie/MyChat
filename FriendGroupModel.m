//
//  FriendGroupModel.m
//  MyChat
//
//  Created by sky on 10/12/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "FriendGroupModel.h"

@implementation FriendGroupModel
{
    NSString         *_databaseName;

}

-(instancetype)initWithDatabaseName:(NSString*)databaseName{
    self = [super init];
    if (self) {
        _databaseName = [databaseName copy ];
        //        [self createDataBase];
    }
    return self;
}

-(void)getAllTheFriendGroupCell
{
    NSOperationQueue *thread = [[NSOperationQueue alloc]init];
    [thread addOperationWithBlock:^{
    NSMutableArray *array1 = [[NSMutableArray alloc] init];
    BmobQuery *query = [BmobQuery queryWithClassName:@"FriendGroup"];
//    query.cachePolicy = kBmobCachePolicyCacheThenNetwork;
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if(!error){
            for (BmobObject *obj in array) {
                FriendGroupCellModel *friendCell = [[FriendGroupCellModel alloc] init];
                friendCell.username = [obj objectForKey:@"username"];
                friendCell.meaasge = [obj objectForKey:@"message"];
                friendCell.greatNumber = [[obj objectForKey:@"greatNumber"] intValue];
                friendCell.discussNumber = [[obj objectForKey:@"discussNumber"] intValue];
                friendCell.userId = [obj objectForKey:@"userId"];
                friendCell.objectId = obj.objectId;
                NSDate *date = obj.updatedAt;
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息.
                [dateFormatter setDateFormat:@"yyyy/MM/dd"];
                friendCell.time = [dateFormatter stringFromDate:date];
                
                
                BmobFile *imageFile = (BmobFile*)[obj objectForKey:@"userImage"];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageFile.url]]];
                friendCell.userImage = image?image:[UIImage imageNamed:@"my"];
                NSArray *greatMember = [obj objectForKey:@"greatMember"];
                friendCell.isgreat = NO;
                for (NSString *name in greatMember) {
                    if ([name isEqual:[[BmobUser getCurrentUser]objectForKey:@"username"]]) {
                        friendCell.isgreat = YES;
                    }
                }
                
                [array1 addObject:friendCell];
            }
            self.allFriendGroup = array1;
            [[NSNotificationCenter defaultCenter]postNotificationName:SJTABLEUPDATA object:nil];
            [self saveTheData];
        }else{
            NSLog(@"find FriendGroup error %@",error);
        }
    }];
    }];
}


-(void)pushNewFriendGroupCell:(FriendGroupCellModel *)newFriendGroupCell
{
    
    //设置访问权限
    User *user = [User singleEample];
    
    NSMutableArray *friendName = [[NSMutableArray alloc] init];
    for (FriendsModel *friend in user.friends) {
        [friendName addObject:friend.friendName];
    }
    
    BmobQuery *quer = [BmobQuery queryForUser];
    [quer whereKey:@"username" containedIn:friendName];
    [quer findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BmobACL *acl = [BmobACL ACL];
//        BmobRole *friendTeam = [BmobRole roleWithName:@"Friends"];
//        BmobRelation *relation = [BmobRelation relation];
        for (BmobUser *Afriend in array) {
            [acl setReadAccessForUser:Afriend];
//            [relation addObject:Afriend];
            NSLog(@"%@",[Afriend objectForKey:@"username"]);
        }
//        [relation addObject:[BmobUser getCurrentUser]];
//        [friendTeam addUsersRelation:relation];
//        [friendTeam saveInBackground];
        BmobObject *obj = [BmobObject objectWithClassName:@"FriendGroup"];
        
        [obj setObject:newFriendGroupCell.username forKey:@"username"];
        [obj setObject:newFriendGroupCell.userId forKey:@"userId"];
        [obj setObject:newFriendGroupCell.meaasge forKey:@"message"];
        [obj setObject:[NSNumber numberWithInt:0] forKey:@"greatNumber"];
        [obj setObject:[NSNumber numberWithInt:0] forKey:@"discussNumber"];
        [obj setObject:[[BmobUser getCurrentObject] objectForKey:@"userImage"] forKey:@"userImage"];
        
        [acl setReadAccessForUserId:[BmobUser getCurrentUser].objectId];
        [acl setPublicWriteAccess];
        obj.ACL = acl;
        [obj saveInBackground];
    }];
    
    
}



-(void)sendDiscussage:(NSString *)message inFriendModelCell:(NSString *)cellId
{
    BmobObject *object1 = [BmobObject objectWithClassName:@"Discussage"];
    [object1 setObject:message forKey:@"message"];
    [object1 setObject:[[BmobUser getCurrentObject] objectForKey:@"username"] forKey:@"discussager"];
   
    [object1 saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            BmobQuery *query = [BmobQuery queryWithClassName:@"FriendGroup"];
            [query getObjectInBackgroundWithId:cellId block:^(BmobObject *object, NSError *error) {
                
                if (!error) {
                    BmobRelation *realation = [BmobRelation relation];
                    [realation addObject:[BmobObject objectWithoutDatatWithClassName:@"Discussage" objectId:object1.objectId]];
                    [object addRelation:realation forKey:@"Discussage"];
                    [object setObject:[NSNumber numberWithInt:[[object objectForKey:@"discussNumber"] intValue]+1] forKey:@"discussNumber"];
                    [object updateInBackground];
                }
            }];

        }
    }];}


-(void)saveTheData
{
    
    NSOperationQueue *thread = [[NSOperationQueue alloc]init];
    [thread addOperationWithBlock:^{
        if ([self checkName:@"FriendGroup"]) {
            
        }else{
            [self creatTheTabel];
        }
        
        
        for (FriendGroupCellModel *cellModel in self.allFriendGroup) {
            sqlite3 *db;
            char *error = NULL;
            int result;
            //        sqlite3_stmt *insert_statement = nil;
            if (sqlite3_open([[self databasePath] UTF8String], &db) == SQLITE_OK) {
                
//                NSData *data = UIImageJPEGRepresentation(cellModel.userImage,0.1);
                NSString *saveString = [NSString stringWithFormat:@"insert or replace into FriendGroup(username,nikeName,message,time,greatNumber,discussNumber,userId,objectId,isgreat) values('%@','%@','%@','%@',%ld,%ld,'%@','%@',%d)",cellModel.username,cellModel.nikeName,cellModel.meaasge,cellModel.time,(long)cellModel.greatNumber,(long)cellModel.discussNumber,cellModel.userId,cellModel.objectId,cellModel.isgreat];
                result = sqlite3_exec(db, [saveString UTF8String], NULL, NULL, &error);
            }
            if (result!= SQLITE_OK) {
                NSLog(@"插入失败，%s",error);
            }
            
            sqlite3_close(db);
        }
    }];
}


-(void)uploadData:(NSString *)upString
{
    NSOperationQueue *thread = [[NSOperationQueue alloc]init];
    [thread addOperationWithBlock:^{
    sqlite3 *db;
    char *error = NULL;
    int result;
    //        sqlite3_stmt *insert_statement = nil;
    if (sqlite3_open([[self databasePath] UTF8String], &db) == SQLITE_OK) {
        
        result = sqlite3_exec(db, [upString UTF8String], NULL, NULL, &error);
    }
    if (result!=SQLITE_OK) {
        NSLog(@"插入失败，%s",error);
    }
    
    sqlite3_close(db);
    }];
}

-(BOOL)checkName:(NSString *)name{
    
    char *err;
    
    sqlite3 *aql = nil;
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM sqlite_master where type='table' and name='%@';",name];
    
    const char *sql_stmt = [sql UTF8String];
    
    if(sqlite3_exec(aql, sql_stmt, NULL, NULL, &err) == 1){
        
        return YES;
        
    }else{
        
        return NO;
        
    }
    
}

-(void)creatTheTabel
{
    sqlite3 *sqlite = nil;
    NSString *filePath = [self databasePath];
    int result = sqlite3_open([filePath UTF8String], &sqlite);
    if (result!=SQLITE_OK) {
        NSLog(@"打开数据失败");
    }
    
    NSString *creatString = @"CREATE TABLE FriendGroup (username text NOT NULL  ,nikeName text,message text,time text,greatNumber int,discussNumber int,userId text,objectId text UNIQUE,isgreat bool,userImage blob)";
    char *error;
    result = sqlite3_exec(sqlite, [creatString UTF8String], NULL, NULL, &error);
    if (result!=SQLITE_OK) {
        NSLog(@"创建数据库失败 ,%s",error);
    }
}


-(NSString*)filePath{
    NSArray  *paths     = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirecotry =[paths objectAtIndex:0];
    return documentDirecotry;
}

-(NSString*)databasePath{
    NSString *path = [[self filePath] stringByAppendingPathComponent:_databaseName];
    return path;
};

-(NSMutableArray*)getTheData
{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    sqlite3 *db;
    sqlite3_stmt *statement = nil;
    if (sqlite3_open([[self databasePath] UTF8String], &db) == SQLITE_OK) {
        NSString *queryString = @"select * from FriendGroup";
        if (sqlite3_prepare_v2(db, [queryString UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                FriendGroupCellModel *cellMode = [[FriendGroupCellModel alloc]init];
                const char *uin          = (char *)sqlite3_column_text(statement, 0);
                if (uin) {
                    NSString *username = [[NSString alloc]initWithUTF8String:uin];
                    cellMode.username = username;
                }
                
                
                const char *nikeN          = (char *)sqlite3_column_text(statement, 1);
                if (nikeN) {
                    NSString *nikeName = [[NSString alloc]initWithUTF8String:nikeN];
                    cellMode.nikeName = nikeName;
                }
                
                const char *mes          = (char *)sqlite3_column_text(statement, 2);
                if (mes) {
                    NSString *message = [[NSString alloc]initWithUTF8String:mes];
                    cellMode.meaasge = message;
                }
                
                
                const char *time          = (char *)sqlite3_column_text(statement, 3);
                if (time) {
                    NSString *tiemSt = [[NSString alloc]initWithUTF8String:time];
                    cellMode.time = tiemSt;
                }
                
                const int greatN          = (int)sqlite3_column_int(statement, 4);
                cellMode.greatNumber = greatN;
                
                const int disN          = (int)sqlite3_column_int(statement, 5);
                cellMode.discussNumber = disN;
                
                
                const char *userId          = (char *)sqlite3_column_text(statement, 6);
                if (userId) {
                    NSString *userIdString = [[NSString alloc]initWithUTF8String:userId];
                    cellMode.userId = userIdString;
                }
                
                const char *objId          = (char *)sqlite3_column_text(statement, 7);
                if (objId) {
                    NSString *objIdString = [[NSString alloc]initWithUTF8String:objId];
                    cellMode.objectId = objIdString;
                }
                
                const BOOL isgreat = (BOOL)sqlite3_column_int(statement, 8);
                cellMode.isgreat = isgreat;
                
                
//                int length = sqlite3_column_bytes(statement, 9);
//                NSData *   data       = [NSData dataWithBytes:sqlite3_column_blob(statement, 9) length:length];
//                UIImage *image = [[UIImage alloc]initWithData:data scale:1];
//                cellMode.userImage = image;
                
//                BmobChatUser *user       = [[BmobChatUser alloc] init];
//                const char *uid          = (char *)sqlite3_column_text(statement, 1);
//                if (uid) {
//                    NSString *uidString      = [[NSString alloc] initWithUTF8String:uid];
//                    user.objectId            = uidString;
//                }
//                
//                const char *username     = (char*)sqlite3_column_text(statement, 2);
//                if (username) {
//                    NSString *usernameString = [[NSString alloc] initWithUTF8String:username];
//                    user.username            = usernameString;
//                }
//                
//                const char *nick         = (char*)sqlite3_column_text(statement, 3);
//                if (nick) {
//                    NSString *nickString     = [[NSString alloc] initWithUTF8String:nick];
//                    user.nick                = nickString;
//                }
//                
//                const char *avatar = (char *)sqlite3_column_text(statement, 4);
//                if (avatar) {
//                    NSString *avatarString = [[NSString alloc] initWithUTF8String:avatar];
//                    user.avatar = avatarString;
//                }
                
                [array addObject:cellMode];
            }
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    self.allFriendGroup = array;
    return array;
}

@end
