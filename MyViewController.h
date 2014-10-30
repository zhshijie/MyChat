//
//  MyViewController.h
//  MyChat
//
//  Created by sky on 9/18/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "BaseViewController.h"
#import "User.h"
#import "SettingViewController.h"
#import "MyDataViewController.h"

@interface MyViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    User *_user;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
