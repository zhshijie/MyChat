//
//  FriendGroupModel.m
//  MyChat
//
//  Created by sky on 10/12/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "FriendGroupCellModel.h"

@implementation FriendGroupCellModel


-(id)init
{
    if (self = [super init]) {
        self.allDiscussage = [[NSMutableArray alloc]init];
        
    }
    return self;
}


-(void)getTheDiscussage:(NSString *)cellId
{
    NSMutableArray *array2= [[NSMutableArray alloc]init];
    BmobQuery *query = [BmobQuery queryWithClassName:@"FriendGroup"];
    [query getObjectInBackgroundWithId:cellId block:^(BmobObject *object, NSError *error) {
        if (object) {
            BmobQuery *quer = [BmobQuery queryWithClassName:@"Discussage"];
            [quer whereObjectKey:@"Discussage" relatedTo:object];
            [quer orderByDescending:@"updatedAt"];
            [quer findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (array.count) {
                    for (BmobObject *obj in array) {
                        NSString *diser = [obj objectForKey:@"discussager"];
                        NSString *message = [obj objectForKey:@"message"];
                        NSString *theDis = [diser stringByAppendingFormat:@":%@",message];
                        [array2 addObject:theDis];
                        NSLog(@"%@",theDis);
                    }
                    
                    self.allDiscussage = array2;
                    [[NSNotificationCenter defaultCenter]postNotificationName:SJDISTABLEUPDATA object:nil];

                }
            }];
        }
    }];
}


-(void)greatTheFriendGroupCell
{
    BmobQuery *que = [BmobQuery queryWithClassName: @"FriendGroup"];
    [que getObjectInBackgroundWithId:self.objectId block:^(BmobObject *object, NSError *error) {
        if (object) {
            
            BmobUser *us = [BmobUser getCurrentUser];
            NSMutableArray *arrayMM = [object objectForKey:@"greatMember"];
            if (arrayMM==nil) {
                arrayMM = [[NSMutableArray alloc]init];
            }
            [arrayMM addObject:[us objectForKey:@"username"]];
            [object setObject:arrayMM forKey:@"greatMember"];
            [object setObject:[NSNumber numberWithLong:self.greatNumber+1] forKey:@"greatNumber"];
            [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    self.isgreat = YES;
                    self.greatNumber++;
                }else{
                    self.isgreat = NO;
                    NSLog(@"error",error);
                }
            }];
            
        }
    }];
    
}
@end
