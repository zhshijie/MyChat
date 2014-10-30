//
//  VerificationFriendViewController.m
//  MyChat
//
//  Created by sky on 9/25/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "VerificationFriendViewController.h"

@interface VerificationFriendViewController ()
{
    User *user;
}

@end

@implementation VerificationFriendViewController

-(id)init
{
    if (self = [super init]) {
        user = [User singleEample];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [user getVerificationFriend];
    self.dataSource = [[NSMutableArray alloc]initWithArray:user.verificationFriends];
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadButton)];
    self.navigationItem.rightBarButtonItem = reloadButton;
}

-(void)reloadButton
{
    [user getVerificationFriend];
    self.dataSource = [[NSMutableArray alloc]initWithArray:user.verificationFriends];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        UIButton *accessButton = [UIButton buttonWithType:UIButtonTypeSystem];
        accessButton.frame = CGRectMake(320-60, 0, 60, 44);
        [cell.contentView addSubview:accessButton];
        accessButton.tag = indexPath.row+100;
        [accessButton addTarget:self action:@selector(accessFriend:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    FriendsModel *friend = _dataSource[indexPath.row];
    cell.textLabel.text = friend.friendNikeName?friend.friendNikeName:friend.friendName;
    cell.imageView.image = friend.friendImage?friend.friendImage:[UIImage imageNamed:@"my"];
    UIButton *button =  (UIButton*)[cell.contentView viewWithTag:indexPath.row+100];
    if (friend.verification) {
        
        [button setTitle:@"已验证" forState:UIControlStateDisabled];
        button.enabled = NO;
    }else{
        [button setTitle:@"验证" forState:UIControlStateNormal];
        button.enabled = YES;
//        button.highlighted = YES;
    }
    
    return cell;
}

-(void)accessFriend:(UIButton*)button
{
    FriendsModel *friend = _dataSource[button.tag-100];
    [user accessFriend:friend.friendName];
    [user getVerificationFriend];
    [self.tableView reloadData];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



@end
