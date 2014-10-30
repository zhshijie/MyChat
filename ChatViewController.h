//
//  ChatViewController.h
//  MyChat
//
//  Created by sky on 9/28/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "BaseViewController.h"
#import "ChartMessage.h"
#import "JSONKit.h"

@interface ChatViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,BmobEventDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *message;
@property (strong ,nonatomic )NSMutableArray *dataSource;
@end
