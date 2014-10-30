//
//  FriendGroupModel.h
//  MyChat
//
//  Created by sky on 10/12/14.
//  Copyright (c) 2014 sky. All rights reserved.
//


#define  SJDIDADDFRIENDGROUP  @"didaddFriendgroup"
#define  SJDIDSENDDISCUSSAGE @"sjdisSendDiscussage"
#define  SJTABLEUPDATA @"tableUpload"
#define  SJDISTABLEUPDATA @"disTableUpload"

#import <Foundation/Foundation.h>

@interface FriendGroupCellModel : NSObject


@property (nonatomic,copy)NSString *username;
@property (nonatomic,copy)NSString *nikeName;
@property (nonatomic,copy)NSString *meaasge;
@property (nonatomic,copy)NSString *time;
@property (nonatomic,assign)NSInteger greatNumber;
@property (nonatomic,copy)UIImage *userImage;
@property (nonatomic,copy)NSMutableArray *discuss;
@property (nonatomic,assign)NSInteger discussNumber;
@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *objectId;
@property (nonatomic,copy)NSMutableArray *allDiscussage;
@property (nonatomic,assign)BOOL isgreat;



/*!
 @method
 @abstract 获得某条留言的评论
 @param newFriendGroupCell 留言的id
 @discussion
 */
-(void)getTheDiscussage:(NSString*)cellId;

/*!
 @method
 @abstract 给当前的留言点赞
 @discussion
 */
-(void)greatTheFriendGroupCell;
@end
