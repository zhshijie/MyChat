//
//  SignInViewController.m
//  MyChat
//
//  Created by sky on 9/23/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "SignInViewController.h"
#import "AppDelegate.h"

@interface SignInViewController ()
{
    UIAlertView *_alert;
}
@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.password.secureTextEntry = YES;
    self.doublePassword.secureTextEntry = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signInAction:(id)sender {
    BmobUser *user = [[BmobUser alloc]init];
    UIImage *falseImage = [UIImage imageNamed:@"false"];

    if(self.username.text.length==0||self.password.text.length == 0||self.email.text.length==0){
        if(self.username.text.length==0)
        {
            self.usernameImage.image = falseImage;
        }else{
            self.usernameImage.image = nil;
        }
        if (self.password.text.length==0) {
            self.passwordImage.image = falseImage;
        }else{
            self.passwordImage.image = nil;

        }
        if (self.email.text.length==0) {
            self.emailImage.image = falseImage;
        }else{
            self.emailImage.image = nil;
        }
        return;
    }
    if (![self.password.text isEqual:self.doublePassword.text]) {
        self.passwordImage.image = falseImage;
    }else{
        self.passwordImage.image = nil;

    }
    
    AppDelegate *apple = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [user setUserName:self.username.text];
    [user setPassword:self.password.text];
    [user setEmail:self.email.text];
    [user setObject:apple.Token forKey:@"deviceToken"];
//    [user signUpInBackground];
    _alert = [[UIAlertView alloc]initWithTitle:@"注册成功" message:@"正在自动登录>>>" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [_alert show];
    [user signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            User *theUser = [User singleEample];
            [BmobUser logInWithUsernameInBackground:self.username.text password:self.password.text block:^(BmobUser *user, NSError *error) {
                if (user) {
                    [_alert dismissWithClickedButtonIndex:[_alert cancelButtonIndex] animated:YES];
                    theUser.userName = [user objectForKey:@"username"];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:self.username.text forKey:@"username"];
                    [defaults setObject:self.password.text forKey:@"password"];
                    [self login];
                }
            }];

        }else{
            NSLog(@"%@",error);
            NSString *emailError = [[NSString alloc]init];
            NSString *userNameError = @"8个字符以上，只能包含数字和字母";
            switch(error.code){
                    
                case 301: emailError = @"邮箱格式错误";
                    self.emailImage.image = falseImage;
                    break;
                case 203: emailError = @"该邮箱已经注册";
                    self.emailImage.image = falseImage;
                    break;
                case 202: userNameError = @"该账号已经注册";
                    self.usernameImage.image = falseImage;
                    break;
            }
            self.emailAlert.text = emailError;
            self.usernameAlert.text = userNameError;
            
        }
    }];
}

- (IBAction)cancleAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];

}


-(void)login{
    RootTabBarViewController *rootView = [[RootTabBarViewController alloc]init];
    [self.navigationController pushViewController:rootView animated:YES];
}

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect rect =self.view.frame;
    rect.origin.y=-60;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.1];
    self.view.frame = rect;
    [UIView commitAnimations];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    CGRect rect =self.view.frame;
    rect.origin.y=0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.1];
    self.view.frame = rect;
    [UIView commitAnimations];
    return YES;
}
@end
