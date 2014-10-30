//
//  LoginViewController.m
//  MyChat
//
//  Created by sky on 9/23/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "LoginViewController.h"



@interface LoginViewController ()
{
    SignInViewController *signInView;
}
@end

@implementation LoginViewController

-(id)init
{
    if (self = [super init]) {
        
        
        }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.username.text = [defaults objectForKey:@"username"];
    self.password.text = [defaults objectForKey:@"password"];
    
    if (self.password.text.length != 0 && self.username.text.length!=0) {
        [self loginAction:nil];
    }
    self.username.delegate = self;
    self.password.delegate = self;
    self.password.secureTextEntry = YES;//输入数字变为星号
   
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
  
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)loginAction:(UIButton *)sender {
    [self.password resignFirstResponder];
    [self.username resignFirstResponder];
    int errorCode = 200;
    if (self.username.text.length == 0||self.password.text.length == 0) {
        if (self.username.text.length == 0&&self.password.text.length == 0) {
            errorCode = 500;
            [self error:errorCode];
            return;
        }
        if (self.username.text.length == 0) {
            errorCode = 501;
        }
        if (self.password.text.length == 0) {
            errorCode = 502;
        }
        [self error:errorCode];
        return;
    }
    
    if (self.savePassword.isOn) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.username.text forKey:@"username"];
        [defaults setObject:self.password.text forKey:@"password"];
    }else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.username.text forKey:@"username"];
        [defaults setObject:@"" forKey:@"password"];
    }
    
    
    UIAlertView *_alert;
    _alert = [[UIAlertView alloc]initWithTitle:@"登录" message:@"正在自动登录>>>" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [_alert show];
    //向服务器发送登陆请求
    [BmobUser logInWithUsernameInBackground:self.username.text password:self.password.text block:^(BmobUser *user, NSError *error) {
        [_alert dismissWithClickedButtonIndex:[_alert cancelButtonIndex] animated:YES];
        if (user) {
            NSLog(@"logIn successful");
            User *theUser = [User singleEample];
//            theUser.userName = [user objectForKey:@"username"];
            [theUser getTheData:user];
            [self login:theUser];
        }else{
            NSLog(@"%@",error);
            [self error:(int)error.code];
            
        }
    }];
    
}

- (IBAction)signInAction:(UIButton *)sender {
    signInView = [[SignInViewController alloc]init];
    [self.navigationController pushViewController:signInView animated:YES];
}


-(void)error:(int)errorCode
{
    UIAlertView *alert = [[UIAlertView alloc]init];
    NSString *alertMessage = [[NSString alloc]init];
    NSString *alertTitle = @"提示";
    switch (errorCode) {
        case 200:
            break;
        case 500: alertMessage  = @"账号和密码都不能为空";break;
        case 501: alertMessage  = @"账号不能为空";break;
        case 502: alertMessage  = @"密码不能为空";break;
        case 503: alertMessage  = @"登陆失败";break;
        case 20002: alertMessage = @"请检查是否有网络连接";break;
        default:
            break;
    }
    alert.message= alertMessage;
    alert.title = alertTitle;
    alert.cancelButtonIndex = 0;
    [alert addButtonWithTitle:@"确定"];
    [alert show];
}


#pragma mark LoginDelegate

-(void)login:(User*)user
{
    RootTabBarViewController *rootView = [[RootTabBarViewController alloc]init];
    [self.navigationController pushViewController:rootView animated:YES];

}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect rect =self.view.frame;
    rect.origin.y=-200;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.2];
    self.view.frame = rect;
    [UIView commitAnimations];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    CGRect rect =self.view.frame;
    rect.origin.y=0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.2];
    self.view.frame = rect;
    [UIView commitAnimations];
    return YES;
}
@end
