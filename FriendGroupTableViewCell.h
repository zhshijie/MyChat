//
//  FriendGroupTableViewCell.h
//  MyChat
//
//  Created by sky on 10/6/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendGroupCellModel.h"

@interface FriendGroupTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *messageImage;
@property (strong, nonatomic) IBOutlet UILabel *messageUser;
@property (strong, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) IBOutlet UILabel *updataTime;

@property (strong,nonatomic)UIButton *greatButton;
@property (strong,nonatomic)UIButton *discussButton;
@end