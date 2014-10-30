//
//  FriendViewController.m
//  MyChat
//
//  Created by sky on 9/26/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "FriendViewController.h"

@interface FriendViewController ()

@end

@implementation FriendViewController

@synthesize sendButton;
-(id)init{
    if (self = [super init]) {
        self.friendMessage = [[FriendsModel alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.buttonIsHighted) {
        self.addFriendButton.enabled = NO;
        self.addFriendButton.highlighted = YES;
    }else{
        self.sendButton.enabled = NO;
        self.sendButton.highlighted = YES;
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = NO;

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addFriendAction:(id)sender {
    User *user = [User singleEample];
    [user addFriend:self.friendMessage.friendName];
    self.addFriendButton.highlighted = YES;
    self.addFriendButton.enabled = NO;
}

- (IBAction)sendMessage:(id)sender {
    User *user = [User singleEample];
    if (self.friendMessage.chatRoomId.length==0) {
        self.friendMessage.chatRoomId = user.OneChartRoom.chartRoomId;
    }else {
        user.OneChartRoom = [[ChartRoom alloc]init];
        user.OneChartRoom.chartRoomId = self.friendMessage.chatRoomId;
    }
    [user getTheChartRoom:self.friendMessage.chatRoomId friendName:self.friendMessage.friendName];
    ChatViewController *chatView = [[ChatViewController alloc]init];
    self.navigationController.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}


#pragma mark UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.friendMessage.friendName;
    return cell;
}

@end
