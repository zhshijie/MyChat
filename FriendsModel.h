//
//  FriendsModel.h
//  MyChat
//
//  Created by sky on 9/24/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendsModel : NSObject<NSCopying,NSMutableCopying>

@property (copy,nonatomic)NSString *friendId;
@property (copy,nonatomic)NSString *friendName;
@property (copy,nonatomic)UIImage *friendImage;
@property(copy,nonatomic)NSString *friendNikeName;
@property (copy,nonatomic)NSString *friendPersonalitySignature;
@property (copy,nonatomic)NSString *chatRoomId;
@property(assign,nonatomic)BOOL verification;


/*!
 @method
 @abstract 获得好友列表的数据
 @discussion
 @result 返回一个好友信息的数组
 */
-(NSMutableArray*)getTheFriendsData;
@end
