//
//  User.m
//  MyChat
//
//  Created by sky on 9/18/14.
//  Copyright (c) 2014 sky. All rights reserved.
//


#import "User.h"
#import "AppDelegate.h"

static User *user = nil;
@implementation User

+(User*)singleEample
{
    if (user ==nil) {
        user = [[User alloc]init];
        user.OneChartRoom = [[ChartRoom alloc]init];
        user.allChartRooms = [[NSMutableArray alloc] init];
    }
    return user;
}

-(BOOL)changeNickname:(NSString *)newName
{
   
    BmobUser *bUser = [BmobUser getCurrentUser];
    [bUser setObject:newName forKey:@"nickName"];
    [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (!isSuccessful) {
            NSLog(@"changeNickname error:%@",error);
        }
    }];
    return true;
}


-(BOOL)changeUserAddress:(NSString *)newAddress
{
    BmobUser *bUser = [BmobUser getCurrentUser];
    [bUser setObject:newAddress forKey:@"userAddress"];
    [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (!isSuccessful) {
            NSLog(@"changeUserAddress error:%@",error);
        }
    }];
    return true;
}

-(BOOL)changeUserImageView:(UIImage *)newImage
{
    BmobUser *bUser = [BmobUser getCurrentUser];
    NSData *imageData  = UIImageJPEGRepresentation(newImage,0);
    BmobFile *file = [[BmobFile alloc] initWithClassName:@"userimageData" withFileName:[bUser.objectId stringByAppendingString:@".jpeg"] withFileData:imageData];
    if ([file save]) {
        [bUser setObject:file forKey:@"userImage"];
        [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
           
            if (isSuccessful) {
                NSLog(@"save is successful");
            }else {
                NSLog(@"%@",error);
            }
        }];
        return true;
    }
    return false;
}

-(BOOL)changeUserSex:(NSString *)newSex
{
    BmobUser *bUser = [BmobUser getCurrentUser];
    [bUser setObject:newSex forKey:@"userSex"];
    [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (!isSuccessful) {
            NSLog(@"changeUserSex error:%@",error);
        }
    }];
    return true;
}

-(void)removeAllProperty{
    user = nil;
}

-(void)getTheData:(BmobUser*)_user
{
    self.userName = [_user objectForKey:@"username"];
    self.nickName = [_user objectForKey:@"nickName"];
    self.userSex = [_user objectForKey:@"userSex"];
    self.userAddress = [_user objectForKey:@"userAddress"];
    BmobFile *imageFile = (BmobFile*)[_user objectForKey:@"userImage"];
    self.userImageView = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageFile.url]]];
    self.email = [_user objectForKey:@"email"];
    [self gettheFriends:_user];
}


-(void)saveFriendDataInPhone
{
    sqlite3 *sql = nil;
    
}

-(void)gettheFriends:(BmobUser*)user
{
    NSString *friendDataName = [[NSString alloc]initWithFormat:@"friend%@",user.objectId];
    BmobQuery   *bquery = [BmobQuery queryWithClassName:friendDataName];
//    bquery.cachePolicy = kBmobCachePolicyCacheElseNetwork;
    NSMutableArray *friends = [[NSMutableArray alloc]initWithCapacity:10];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count) {
            for (BmobObject *obj in array) {
                FriendsModel *friend = [[FriendsModel alloc]init];
                friend.friendName = [obj objectForKey:@"username"];
                friend.friendNikeName = [obj objectForKey:@"nikename"];
                friend.chatRoomId = [obj objectForKey:@"chatRoomId"];
                friend.friendId = [obj objectForKey:@"friendId"];
                BmobQuery*qu = [BmobQuery queryForUser];
                [qu whereKey:@"objectId" equalTo:friend.friendId];
                [qu findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                    if (array.count) {
                        BmobUser *friendUser = array[0];
                        BmobFile *imageFile = (BmobFile*)[friendUser objectForKey:@"userImage"];
                        friend.friendImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageFile.url]]];
                    }
                }];
              
//                NSLog(@"------------%@",friend.chatRoomId);
//                NSLog(@"------------%@",(NSString*)[array[0] objectForKey:@"chatRoomId"]);

                
                [friends addObject:friend];
            }
            self.friends = friends;
            [self setAcceptPushMessage];
    }
    }];
}

-(NSInteger)addFriend:(NSString *)friendName
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"正在添加" message:@"请稍等...." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    BmobQuery *query = [BmobQuery queryForUser];
    [query whereKey:@"username" equalTo:friendName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count) {/*
            BmobUser *user = [BmobUser getCurrentObject];
            id isfriend = [user objectForKey:@"friends"];
            NSString *friendDataName = [[NSString alloc]initWithFormat:@"friend%@",user.objectId];
            BmobObject *friend = [BmobObject objectWithClassName:friendDataName];
            BmobUser *friend_query = array[0];
            [friend setObject:[friend_query objectForKey:@"username"] forKey:@"username"];
            if (isfriend==nil) {
                
                [friend saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        NSLog(@"creat a table is successful");
                        BmobRelation *relation = [[BmobRelation alloc]init];
                        
                        [relation addObject:friend];
                        [user addRelation:relation forKey:@"friends"];
                        
                        [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (isSuccessful) {
                                NSLog(@"relation is successful");
                            }else {
                                NSLog(@"%@",error);
                            }
                        }];

                    }else {
                        NSLog(@"%@",error);
                    }
                }];
            }else{
            [friend saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    NSLog(@"relation is successful");
                }else {
                    NSLog(@"%@",error);
                }
            }];
            
        }*/
            BmobUser *user = [BmobUser getCurrentObject];
            BmobUser *friend = array[0];
            
//            BmobObject * iswillBeFriend = [friend objectForKey:@"willBeFriend"];
            NSString *friendDataName = [[NSString alloc]initWithFormat:@"willBeFriend%@",friend.objectId];
            
            BmobObject *willbeFriend = [BmobObject objectWithClassName:friendDataName];
            [willbeFriend setObject:[NSNumber numberWithBool:NO] forKey:@"verification"];
            [willbeFriend setObject:[user objectForKey:@"username"] forKey:@"username"];
//            if (iswillBeFriend==nil) {
            
                [willbeFriend saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
                    if (isSuccessful) {
                        NSLog(@"creat a table is successful");
//                        [friend setObject:friendDataName forKey:@"willBeFriend"];
//                        
//                        [friend updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//                            if (isSuccessful) {
//                                NSLog(@"relation is successful");
//                                _friendIdTable =friendDataName;
//                                _verificationId = willbeFriend.objectId;
////                                [self listen];
//                            }else {
//                                alert.message = @"添加好友失败";
//                                [alert addButtonWithTitle:@"确定"];
//                                [alert show];
//                                NSLog(@"%@",error);
//                            }
//                        }];
                        
                    }else {
                        alert.message = @"添加好友失败";
                        [alert addButtonWithTitle:@"确定"];
                        [alert show];
                        NSLog(@"%@",error);
                    }
                }];

            }
//            else{
//                [willbeFriend saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//                    [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
//                    if (isSuccessful) {
//                        NSLog(@"relation is successful");
//                        _friendIdTable =friendDataName;
//                        _verificationId = willbeFriend.objectId;
////                        [self listen];
//                    }else {
//                        alert.message = @"添加好友失败";
//                        [alert addButtonWithTitle:@"确定"];
//                        [alert show];
//                        NSLog(@"%@",error);
//                    }
//                }];
//
//            }
//        }
    }];

    return 0;
}

-(void)getVerificationFriend
{
    BmobUser *nowUser = [BmobUser getCurrentObject];
    NSString *nowUserverificationFriendStringId = [NSString stringWithFormat:@"willBeFriend%@",nowUser.objectId];
    NSMutableArray *verificationfriends = [[NSMutableArray alloc]init];
    BmobQuery *query = [BmobQuery queryWithClassName:nowUserverificationFriendStringId];
//    query.cachePolicy = kBmobCachePolicyCacheThenNetwork;
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count) {
            for (BmobObject *obj in array) {
                FriendsModel *friend = [[FriendsModel alloc]init];
                friend.friendName = [obj objectForKey:@"username"];
                friend.verification = [[obj objectForKey:@"verification"] boolValue];
                [verificationfriends addObject:friend];
            }
            self.verificationFriends = verificationfriends;
        }else{
            NSLog(@"%@",error);
        }
    }];
}




-(void)addPerson :(NSString *)PersonName ToOthersContacts:(NSString*)otherName;
{
    BmobQuery *query = [BmobQuery queryForUser];
    [query whereKey:@"username" equalTo:PersonName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count) {
            BmobUser *theperson = array[0];
            BmobQuery *query1 = [BmobQuery queryForUser];
            [query1 whereKey:@"username" equalTo:otherName];
            [query1 findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (array.count) {
                    BmobUser *other = array[0];
                    NSString *contactsName = [[NSString alloc]initWithFormat:@"friend%@",other.objectId];
                    BmobObject *person = [[BmobObject alloc]initWithClassName:contactsName];
                    [person setObject:[theperson objectForKey:@"username"] forKey:@"username"];
                    [person setObject:[theperson objectForKey:@"userImage"] forKey:@"userImage"];
                    [person setObject:theperson.objectId forKey:@"friendId"];
                    BmobQuery *query = [BmobQuery queryWithClassName:contactsName];
                    [query whereKey:@"username" equalTo:[theperson objectForKey:@"usernmae"]];
//                    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//                        
//                        if (!array.count) {
//                            
                            [person saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                
                                if (isSuccessful) {
                                    NSLog(@"save is successful");
                                    BmobInstallation  *currentIntallation = [BmobInstallation objectWithClassName:@"FriendInstallation"];
                                    [currentIntallation  subsccribeToChannels:@[PersonName]];
                                    [currentIntallation saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                        if (isSuccessful) {
                                            NSLog(@"intallation is save");
                                        }else{
                                            NSLog(@"error %@",error);
                                        }
                                    }];
                                }else{
                                    NSLog(@"%@",error);
                                }
                            }];
//                        }
//                    }];
                
                }
            }];
        }
    }];
}


-(void)accessFriend:(NSString *)friendName
{
    [user addPerson:friendName ToOthersContacts:user.userName];
    [user addPerson:user.userName ToOthersContacts:friendName];
    
    BmobUser *theuser = [BmobUser getCurrentUser];
    NSString *willBefriendString = [[NSString alloc]initWithFormat:@"willBeFriend%@",theuser.objectId];
    BmobQuery *query = [BmobQuery queryWithClassName:willBefriendString];
    [query whereKey:@"username" equalTo:friendName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count) {
            BmobObject *verification = array[0];
            [verification setObject:[NSNumber numberWithBool:YES] forKey:@"verification"];
            [verification updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    
                    NSLog(@"upload successful");
                }else{
                    NSLog(@"%@",error);
                }
            }];
        }
    }];
    
}


-(void)getTheAllChartRooms
{
    
    NSMutableArray *allRooms = [[NSMutableArray alloc]init];
    BmobUser *theUser = [BmobUser getCurrentObject];
    NSString *allChartRoomsId = [NSString stringWithFormat:@"allChartRooms%@",theUser.objectId];
    BmobQuery *query = [BmobQuery queryWithClassName:allChartRoomsId];
    [query orderByDescending:@"updatedAt"];
    query.cachePolicy = kBmobCachePolicyCacheThenNetwork;
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count) {
            for (BmobObject *obj in array) {
                ChartRoom *chartRoom = [[ChartRoom alloc]init];
                chartRoom.chartRoomId = [obj objectForKey:@"chartRoomId"]?[obj objectForKey:@"chartRoomId"]:obj.objectId;
                NSLog(@"%@",obj.objectId);
                chartRoom.numberInRoom = [[obj objectForKey:@"numberInRoom"]intValue];
                NSString *chartRoomMembersId = [NSString stringWithFormat:@"chartRoomMember%@",[obj objectForKey:@"chartRoomId"]?[obj objectForKey:@"chartRoomId"]:obj.objectId];
                BmobQuery *query1 = [BmobQuery queryWithClassName:chartRoomMembersId];
                query1.cachePolicy = kBmobCachePolicyCacheThenNetwork;
                [query1 findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                    
                    if (array.count) {
                        chartRoom.members = [[NSMutableArray alloc] init];
                        for (BmobObject *obj1 in array) {
                            NSString *menberName = [obj1 objectForKey:@"memberName"];
                            [chartRoom.members addObject:menberName];
                        }
                    }else{
                        NSLog(@"%@",error);
                    }
                }];
                
                [allRooms addObject:chartRoom];
                
            }
            self.allChartRooms = allRooms;
        }
    }];
}


-(void)getTheChartRoom:(NSString *)chartRoomId friendName:(NSString *)friendName
{
    
    
    NSString *theChartRoomId = [NSString stringWithFormat:@"theChartRoomId%@",chartRoomId];
    
    if(chartRoomId.length==0){
        [self creatNewChatRoom:chartRoomId friendName:friendName];
    }else{
    BmobQuery *query = [BmobQuery queryWithClassName:theChartRoomId];
    [query orderByDescending:@"updatedAt"];
    query.cachePolicy =  kBmobCachePolicyCacheThenNetwork;
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count) {
            self.OneChartRoom.chartMessage = [[NSMutableArray alloc]init];
            int all = (int)array.count<10?(int)array.count:9;
            for (int index = all-1 ; index>=0; index--) {
                BmobObject *obj = array[index];
                ChartMessage *chartDetail = [[ChartMessage alloc]init];
                chartDetail.chaterId = [obj objectForKey:@"charterId"];
                chartDetail.chaterName = [obj objectForKey:@"charerName"];
                chartDetail.chatMessage = [obj objectForKey:@"chatMessage"];
                NSLog(@"%@",chartDetail.chatMessage);
                if (chartDetail.chaterName==nil) {
                    continue;
                }
//                chartDetail.chaterImage = [obj objectForKey:@"chatImage"];
                [self.OneChartRoom.chartMessage addObject:chartDetail];
            }
            NSLog(@"--------------------");
        }
    }];
    }
}


-(void)creatNewChatRoom:(NSString *)chartRoomId friendName:(NSString *)friendName
{
    
    self.OneChartRoom = [[ChartRoom alloc]init];
    BmobUser *theUser = [BmobUser getCurrentObject];
    NSString *allChartRoomsId = [NSString stringWithFormat:@"allChartRooms%@",theUser.objectId];
    BmobObject *newChatRoom = [BmobObject objectWithClassName:allChartRoomsId];
    [newChatRoom setObject:[NSNumber numberWithInt:2] forKey:@"numberInRoom"];
    [newChatRoom setObject:newChatRoom.objectId forKey:@"chartRoomId"];
    NSLog(@"%@",newChatRoom.objectId);
    [newChatRoom saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            NSLog(@"allRoomsave");
            self.OneChartRoom.chartRoomId = newChatRoom.objectId;
            NSString *theChartRoomId = [NSString stringWithFormat:@"theChartRoomId%@",newChatRoom.objectId];
            
            BmobObject *newRoom = [BmobObject objectWithClassName:theChartRoomId];
            [newRoom saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                
                if (isSuccessful) {
                    
                    NSLog(@"creat new chart");
                    NSString *friendDataName = [[NSString alloc]initWithFormat:@"friend%@",[BmobUser getCurrentObject].objectId];
                    BmobQuery   *bquery = [BmobQuery queryWithClassName:friendDataName];
                    [bquery whereKey:@"username" containedIn:@[friendName]];
                    
                    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                        if (array.count) {
                            BmobObject *obj = array[0];
                            [obj setObject:newChatRoom.objectId forKey:@"chatRoomId"];
                            [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                if (isSuccessful) {
                                    NSLog(@"upload is successful");
                                }
                            }];
                        }
                    }];
                    
                    
                    
                    NSString *friendDataName1 = [[NSString alloc]initWithFormat:@"friend%@",user.currentFriend.friendId];
                    BmobQuery   *bquery1 = [BmobQuery queryWithClassName:friendDataName1];
                    [bquery1 whereKey:@"username" containedIn:@[user.userName]];
                    
                    [bquery1 findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                        if (array.count) {
                            BmobObject *obj = array[0];
                            [obj setObject:newChatRoom.objectId forKey:@"chatRoomId"];
                            [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                if (isSuccessful) {
                                    NSLog(@"upload is successful");
                                }
                            }];
                        }
                    }];

                    
                    
                    
                }
                NSLog(@"%@",error);
            }];
            
            NSString *chartRoomMembersId = [NSString stringWithFormat:@"chartRoomMember%@",newChatRoom.objectId];
            BmobObject *obj = [BmobObject objectWithClassName:chartRoomMembersId];
            [obj setObject:friendName forKey:@"memberName"];
            BmobQuery*quer = [BmobQuery queryForUser];
            [quer whereKey:@"username" equalTo:friendName];
            [quer findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (array.count) {
                    BmobUser *fri = array[0];
                    [obj setObject:[fri objectId] forKey:@"memberId"];
                    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if(isSuccessful)
                        {
                            NSLog(@" memberName save successful");
                        }
                    }];
                }
            }];
            
            BmobObject *obj1 = [BmobObject objectWithClassName:chartRoomMembersId];
            [obj1 setObject:user.userName forKey:@"memberName"];
            [obj1 setObject:user.userID forKey:@"memberId"];
            [obj1 saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if(isSuccessful)
                {
                    NSLog(@" memberName save successful");
                }
            }];
            
        }
    }];
    
    NSLog(@"newChatRoom.objectId----%@",newChatRoom.objectId);

}
-(void)getTheFirendData:(NSString*)friendName
{
    if ([self.currentFriend.friendName isEqualToString:friendName]) {
        return;
    }
    NSString *friendDataName = [[NSString alloc]initWithFormat:@"friend%@",[BmobUser getCurrentObject].objectId];
    BmobQuery *query = [BmobQuery queryWithClassName:friendDataName];
    [query whereKey:@"username" equalTo:friendName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count) {
            BmobObject *obj = array[0];
            FriendsModel *friend1 = [[FriendsModel alloc]init];
            friend1.friendName = (NSString*)[obj objectForKey:@"username"];
            friend1.chatRoomId = (NSString *)[obj objectForKey:@"chatRoomId"];
            self.currentFriend = friend1;
        }
    }];
}

-(void)sendMessage:(NSString *)message
{
    
    
    NSString *theChartRoomId = [NSString stringWithFormat:@"theChartRoomId%@",self.OneChartRoom.chartRoomId];
    BmobObject *object = [BmobObject objectWithClassName:theChartRoomId];
    [object setObject:user.userName forKey:@"charerName"];
    [object setObject:user.userID forKey:@"charterId"];
    [object setObject:message forKey:@"chatMessage"];
    [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"send the message is successful");
            BmobPush *push = [BmobPush push];
            NSString *pushMessage = [user.userName stringByAppendingFormat:@" : %@",message];
            [push setMessage:pushMessage];
            [push setChannels:self.OneChartRoom.members];
            [push sendPushInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                NSLog(@"error %@",[error description]);
            }];
            [self addChatRoomToFriend];
        }
    }];
}

-(void)addChatRoomToFriend
{
   
    NSString *memid = [NSString stringWithFormat:@"chartRoomMember%@",self.OneChartRoom.chartRoomId];
    
    BmobQuery *qure = [BmobQuery queryWithClassName:memid];
    [qure whereKey:@"memberName" notEqualTo:self.userName];
    [qure findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count) {
            BmobObject *obj = array[0];
            
            NSString *allChartRoomsId = [NSString stringWithFormat:@"allChartRooms%@",[obj objectForKey:@"memberId"]];
            
            BmobQuery *query = [BmobQuery queryWithClassName:allChartRoomsId];
            [query whereKey:@"chartRoomId" equalTo:self.OneChartRoom.chartRoomId];
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                
                if (array.count==0) {
                    BmobObject *obj = [BmobObject objectWithClassName:allChartRoomsId];
                    [obj setObject:[NSNumber numberWithInt:2] forKey:@"numberInRoom"];
                    [obj setObject:self.OneChartRoom.chartRoomId forKey:@"chartRoomId"];
                    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            NSLog(@"save is successful");
                            
                        }else{
                            NSLog(@"%@",error);
                        }
                    }];
                }
            }];
        }
    }];
    
}

-(void)setAcceptPushMessage
{
    NSMutableArray *friendName = [[NSMutableArray alloc]initWithCapacity:20];
    for (FriendsModel *fri in self.friends) {
        [friendName addObject:fri.friendName];
    }
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    BmobInstallation  *currentIntallation = [BmobInstallation currentInstallation];
    //设置token
    [currentIntallation setDeviceTokenFromData:appdelegate.Token];
    //设置订阅渠道
    [currentIntallation subsccribeToChannels:friendName];
    //保存数据
    [currentIntallation saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"setAccessPushMessage is successful");
        }else {
            NSLog(@"%@",error);
        }
    }];
}

@end
