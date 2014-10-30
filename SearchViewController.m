//
//  SearchViewController.m
//  MyChat
//
//  Created by sky on 9/18/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()
{
    NSArray *_dataSource;
    NSArray *_imageSource;
}
@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"发现";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    BmobInstallation  *currentIntallation = [BmobInstallation objectWithoutDatatWithClassName:@"tuisong" objectId:@"szK8444I"];
//    [currentIntallation subsccribeToChannels:@[@"Giants"]];
//    [currentIntallation saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//        if (error) {
//            NSLog(@"error --- %@",error);
//        }
//    }];
    BmobPush *push = [BmobPush push];
    [push setMessage:@"推送给某个苹果用户的消息"];
    [push setChannel:@"Giants"];
    [push sendPushInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        NSLog(@"error %@",[error description]);
    }];
    self.tableView.scrollEnabled = NO;
    _dataSource = @[@[@"朋友圈"],@[@"扫一扫",@"摇一摇"],@[@"附近的人",@"漂流瓶"],@[@"购物",@"游戏"]];
    NSLog(@"%@",[UIImage imageNamed:@"friendquan.png"]);
    
        _imageSource = @[@[[UIImage imageNamed:@"friendquan.png"]],@[[UIImage imageNamed:@"saoyisao"],[UIImage imageNamed:@"yaoyiyao"]],@[[UIImage imageNamed:@"fujingderen"],[UIImage imageNamed:@"piaoliuping"]],@[[UIImage imageNamed:@"gouwu"],[UIImage imageNamed:@"youxi"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource[section] count];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = _dataSource[indexPath.section][indexPath.row];
    cell.imageView.image = _imageSource[indexPath.section][indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0&&indexPath.section==0) {
        FriendGroupViewController *friendView = [[FriendGroupViewController alloc] init];
        [self.navigationController pushViewController:friendView animated:YES];
    }
}

@end
