//
//  SettingViewController.m
//  MyChat
//
//  Created by sky on 9/23/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = @"退出登录";
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0&&indexPath.row==0) {
//        LoginViewController *log = [[LoginViewController alloc]init];
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"退出后不会删除任何历史数据，下次登录依然可以使用本账号" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil];
        [sheet showInView:self.view];
    }
}

#pragma mark actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        User *user = [User singleEample];
        [user removeAllProperty];
        [BmobUser logout];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"" forKey:@"password"];
        [(BaseNavigationViewController*)[[[[UIApplication sharedApplication]delegate]window]rootViewController] popToRootViewControllerAnimated:YES];
    }
}
@end
