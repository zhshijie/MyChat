//
//  LoginViewController.h
//  MyChat
//
//  Created by sky on 9/23/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "BaseViewController.h"
#import "SignInViewController.h"
#import "BaseNavigationViewController.h"
#import "User.h"
#import "MyChartViewController.h"
#import "ContactsViewController.h"
#import "SearchViewController.h"
#import "MyViewController.h"
#import "RootTabBarViewController.h"
#import "SignInViewController.h"

@interface LoginViewController : BaseViewController<UITextFieldDelegate,LoginDelegate>
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UISwitch *savePassword;

- (IBAction)loginAction:(UIButton *)sender;
- (IBAction)signInAction:(UIButton *)sender;

@end
