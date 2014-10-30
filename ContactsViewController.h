//
//  ContactsViewController.h
//  MyChat
//
//  Created by sky on 9/18/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "BaseViewController.h"
#import "User.h"
#import "FriendsModel.h"
#import "VerificationFriendViewController.h"
#import "AddFriendViewController.h"
#import "FriendViewController.h"

@interface ContactsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property(retain,nonatomic)    NSMutableArray *dataSource;
@end
