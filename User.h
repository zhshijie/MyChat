//
//  User.h
//  MyChat
//
//  Created by sky on 9/18/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
#import "FriendsModel.h"
#import "JSONKit.h"
#import "ChartRoom.h"
#import "ChartMessage.h"


@interface User : NSObject<BmobEventDelegate>
{
    NSString *_verificationId;
    NSString *_friendIdTable;
    BmobEvent *_bmoEvent;
}
@property (copy,nonatomic)NSString *nickName;
@property (copy,nonatomic)NSString *userSex;
@property (copy,nonatomic)UIImage *userImageView;
@property (copy,nonatomic)NSString *userAddress;
@property (copy,nonatomic)NSString *userID;
@property (copy,nonatomic)UIImageView *imageCode;
@property (copy ,nonatomic)NSString *userName;
@property (copy,nonatomic)NSString *email;

@property (retain,nonatomic)NSMutableArray *friends;
@property (retain,nonatomic)NSMutableArray *verificationFriends;
@property (retain,nonatomic)NSMutableArray *allChartRooms;
@property (retain ,nonatomic)ChartRoom *OneChartRoom;
@property (retain,nonatomic)FriendsModel *currentFriend;
/*!
 @method
 @abstract 该方法用于修改用户的昵称
 @discussion
 @param  newName 传入一个新的姓名
 @result 若修改成功，放回true
 */
-(BOOL)changeNickname:(NSString *)newName;

/*!
 @method
 @abstract 该方法用于修改用户的姓别
 @discussion
 @param  newName 传入一个新的性别
 @result 若修改成功，放回true
 */
-(BOOL)changeUserSex:(NSString*)newSex;

/*!
 @method
 @abstract 该方法用于修改用户的地址
 @discussion
 @param  newName 传入一个新的地址
 @result 若修改成功，放回true
 */
-(BOOL)changeUserAddress:(NSString *)newAddress;

/*!
 @method
 @abstract 该方法用于修改用户的头像
 @discussion
 @param  newName 传入一个新的头像
 @result 若修改成功，放回true
 */
-(BOOL)changeUserImageView:(UIImage*)newImage;

/*!
 @method
 @abstract 单例方法
 */
+(User*)singleEample;

/*!
 @method
 @abstract 重置User
 */
-(void)removeAllProperty;


/*!
 @method
 @abstract 获得用户的数据
 @discussion
 @param  user bmobUser获得的用户数据
 */
-(void)getTheData:(BmobUser*)user;


/*!
 @method
 @abstract 添加好友
 @discussion
 @param friendName 将要添加的好友的账号
 */
-(NSInteger)addFriend:(NSString *)friendName;
/*!
 @method
 @abstract 获得未验证的好友
 @discussion
 */
-(void)getVerificationFriend;

/*!
 @method
 @abstract 将某个用户加入另一个用户的好友列表
 @discussion PersonName 被加为好友的用户 otherName 添加好友的用户

 */
-(void)addPerson :(NSString *)PersonName ToOthersContacts:(NSString*)otherName;

/*!
 @method
 @abstract 接受好友的添加
 @discussion friendName 好友的用户名
 */

-(void)accessFriend:(NSString *)friendName;

/*!
 @method
 @abstract 获得已添加和验证的好友
 @discussion
 */
-(void)gettheFriends:(BmobUser*)user;


/*!
 @method
 @abstract 获得当前用户的所有聊天室
 @discussion
 */

-(void)getTheAllChartRooms;

/*!
 @method
 @abstract 获得当前用户的所有聊天室中特定的某一个聊天室
 @param key 聊天室的id friendName 好友的账号
 @discussion
 */

-(void)getTheChartRoom:(NSString *)chartRoomId friendName:(NSString *)friendName
;

/*!
 @method
 @abstract 发送信息
 @param message 信息内容
 @discussion
 */
-(void)sendMessage:(NSString *)message;

/*!
 @method
 @abstract 获得某个朋友的资料
 @param 朋友账号
 @discussion
 */
-(void)getTheFirendData:(NSString*)friendName;

/*!
 @method
 @abstract 设置推送信息的接收
 @discussion
 */
-(void)setAcceptPushMessage;

@end
