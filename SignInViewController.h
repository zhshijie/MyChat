//
//  SignInViewController.h
//  MyChat
//
//  Created by sky on 9/23/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

@class User;
@protocol LoginDelegate <NSObject>

@required
-(void)login:(User*)user;
@optional
-(void)dismissAlert:(UIAlertView*)alert;

@end

#import "BaseViewController.h"
#import "LoginViewController.h"
//#import "AppDelegate.h"

@interface SignInViewController : BaseViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UIImageView *usernameImage;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIImageView *passwordImage;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UIImageView *emailImage;
@property (strong, nonatomic) IBOutlet UITextField *doublePassword;

@property (strong, nonatomic) IBOutlet UILabel *emailAlert;
@property (strong, nonatomic) IBOutlet UILabel *usernameAlert;

@property (retain,nonatomic) id<LoginDelegate> delegate;

- (IBAction)signInAction:(id)sender;
- (IBAction)cancleAction:(id)sender;

@end
