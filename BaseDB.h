//
//  DataBaseModel.h
//  Track-tripStrategy
//
//  Created by ncg ncg-2 on 11-11-5.
//  Copyright 2011 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface BaseDB : NSObject 
{
	sqlite3 *database;
}

//创建表
-(void)createTable:(NSString *)sql;

/**
 * 接口描述：查询数据
 * 参数: sql:sql语句
 *      columns： 查询的字段数量
 * 返回值：[["字段值1","字段值2"],.....];
 */
- (NSMutableArray *)selectData:(NSString *)sql columns:(int)col;


/**
 * 接口描述：增，删，改数据库
 * 参数： sql：SQL语句
         paramarray： 参数
 * 返回值：是否执行成功
 * 
 */
- (BOOL)dealData:(NSString *)sql paramarray:(NSArray *)param;

/**
 *  接口描述：保存带"图片/文件"的字段
 */
- (BOOL)saveimage:(NSString *)sql paramarray:(NSMutableArray *)param;

/**
 * 接口描述：查询图片数据
 */
- (UIImage *)selectData:(NSString *)sql;

/**
 * 接口描述：查询某张表中数据的数量
 */
- (NSUInteger) selectCount:(NSString *)sql;

- (NSMutableArray *)selectFullData:(NSString *)sql columns:(int)col ;


+ (void)createAllTabel;

@end
