//
//  VerificationFriendViewController.h
//  MyChat
//
//  Created by sky on 9/25/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "BaseViewController.h"

@interface VerificationFriendViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(retain,nonatomic)    NSMutableArray *dataSource;

@end
