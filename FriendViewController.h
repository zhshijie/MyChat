//
//  FriendViewController.h
//  MyChat
//
//  Created by sky on 9/26/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "BaseViewController.h"
#import "FriendsModel.h"
#import "ChatViewController.h"

@interface FriendViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *addFriendButton;
@property (strong,nonatomic) FriendsModel *friendMessage;
@property (assign,nonatomic)BOOL buttonIsHighted;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;

- (IBAction)addFriendAction:(id)sender;

- (IBAction)sendMessage:(id)sender;
@end
