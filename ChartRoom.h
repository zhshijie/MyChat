//
//  ChartRoom.h
//  MyChat
//
//  Created by sky on 9/28/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartRoom : NSObject

@property (assign,nonatomic)int numberInRoom;
@property (retain,nonatomic)NSMutableArray *members;
@property (retain,nonatomic)NSString *chartRoomId;
@property (retain,nonatomic)NSMutableArray *chartMessage;

@end
