//
//  AddFriendViewController.h
//  MyChat
//
//  Created by sky on 9/25/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "BaseViewController.h"
#import "FriendViewController.h"

@interface AddFriendViewController : BaseViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *friendUserName;
@property (strong, nonatomic) IBOutlet UILabel *alertMessage;

@end
