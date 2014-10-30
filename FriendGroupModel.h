//
//  FriendGroupModel.h
//  MyChat
//
//  Created by sky on 10/12/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendGroupCellModel.h"
#import <sqlite3.h>
@interface FriendGroupModel : NSObject
@property (nonatomic,copy)NSMutableArray *allFriendGroup;



-(instancetype)initWithDatabaseName:(NSString*)databaseName;
/*!
 @method
 @abstract 获得当前用户的所有的朋友圈留言
 @discussion
 */
-(void)getAllTheFriendGroupCell;



/*!
 @method
 @abstract 在朋友圈发表一条新的留言
 @param newFriendGroupCell 留言信息
 @discussion
 */
-(void)pushNewFriendGroupCell:(FriendGroupCellModel*)newFriendGroupCell;



/*!
 @method
 @abstract 在朋友圈发表一条评论
 @param newFriendGroupCell 评论信息  cellId:评论对象的id
 @discussion
 */
-(void)sendDiscussage:(NSString *)message inFriendModelCell:(NSString*)cellId;



/*!
 @method
 @abstract 获得当前用户自己的朋友圈留言
 @discussion
 */
-(void)getMyFriendGroupCell;


/*!
 @method
 @abstract 把数据缓存到本地
 @discussion
 */
-(void)saveTheData;

-(NSMutableArray*)getTheData;

-(void)uploadData:(NSString *)upString;


@end
