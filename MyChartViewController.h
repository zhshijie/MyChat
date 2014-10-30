//
//  MyChartViewController.h
//  MyChat
//
//  Created by sky on 9/18/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "BaseViewController.h"
#import "MyChatTableViewCell.h"
#import "ChatViewController.h"

@interface MyChartViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *dataSource;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
