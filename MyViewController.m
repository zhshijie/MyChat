//
//  MyViewController.m
//  MyChat
//
//  Created by sky on 9/18/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我";
        _user = [User singleEample];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark sourceData delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
   else if (section==1) {
        return 3;
    }
   else if (section==2) {
        return 1;
    }
    else if (section==3) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell;
    if (indexPath.section==0) {
        UIImage *image = [UIImage imageNamed:@"my"];
        NSString *detail = @"微信号:";
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.imageView.image = _user.userImageView?_user.userImageView:image;
        cell.textLabel.text = _user.nickName.length==0?_user.userName:_user.nickName;
        cell.detailTextLabel.text = [detail stringByAppendingFormat:@"%@",_user.userName];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
     else if (indexPath.section==1) {
        NSArray *dataSource = @[@"相册",@"收藏",@"钱包"];
        NSArray *dataImage = @[[UIImage imageNamed:@"picture"],[UIImage imageNamed:@"like"],[UIImage imageNamed:@"payment_card"]];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.imageView.image = dataImage[indexPath.row];
        cell.textLabel.text = dataSource[indexPath.row];
         cell.textLabel.font = [UIFont systemFontOfSize:14];
     }else if(indexPath.section==2){
          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
         cell.imageView.image = [UIImage imageNamed:@"face"];
         cell.textLabel.text = @"表情";
         cell.textLabel.font = [UIFont systemFontOfSize:14];
     }else if(indexPath.section==3){
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
         cell.imageView.image = [UIImage imageNamed:@"settings"];
         cell.textLabel.text = @"设置";
         cell.textLabel.font = [UIFont systemFontOfSize:14];
     }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==0) {
        MyDataViewController *mydataView = [[MyDataViewController alloc] init];
        [self.navigationController pushViewController:mydataView animated:YES];
    }
    else if (indexPath.section==3) {
        SettingViewController *settingView = [[SettingViewController alloc]init];
        [self.navigationController pushViewController:settingView animated:YES];
    }
}
#pragma mark tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return 60;
    }
    else return 40;
}



@end
