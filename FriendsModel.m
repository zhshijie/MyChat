//
//  FriendsModel.m
//  MyChat
//
//  Created by sky on 9/24/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "FriendsModel.h"

@implementation FriendsModel

-(NSMutableArray*)getTheFriendsData{
    NSMutableArray *friends = [[NSMutableArray alloc]init];
    return friends;
}

- (id)copyWithZone:(NSZone *)zone
{
    FriendsModel *friend = [[FriendsModel alloc]init];
    friend.friendId = self.friendId;
    friend.friendImage = self.friendImage;
    friend.friendName = self.friendName;
    friend.friendNikeName = self.friendNikeName;
    friend.friendPersonalitySignature = self.friendPersonalitySignature;
    return friend;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    FriendsModel *friend = [[FriendsModel alloc]init];
    friend.friendId = self.friendId;
    friend.friendImage = self.friendImage;
    friend.friendName = self.friendName;
    friend.friendNikeName = self.friendNikeName;
    friend.friendPersonalitySignature = self.friendPersonalitySignature;
    return friend;
}

@end
