//
//  FriendGroupViewController.h
//  MyChat
//
//  Created by sky on 10/6/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "BaseViewController.h"
#import "FriendGroupTableViewCell.h"
#import "FriendGroupCellModel.h"
#import "FriendGroupModel.h"
#import "SendFriendCellModelViewController.h"
#import "DIscussageViewController.h"

@interface FriendGroupViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property(copy,nonatomic)NSMutableArray *dataSource;
@end
