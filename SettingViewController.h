//
//  SettingViewController.h
//  MyChat
//
//  Created by sky on 9/23/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginViewController.h"
#import "User.h"

@interface SettingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableVIew;

@end
