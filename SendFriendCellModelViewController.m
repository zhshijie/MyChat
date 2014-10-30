//
//  SendFriendCellModelViewController.m
//  MyChat
//
//  Created by sky on 10/14/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "SendFriendCellModelViewController.h"

@interface SendFriendCellModelViewController ()
{
    UITextView *textView;
}
@end

@implementation SendFriendCellModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *addFriendbutton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(sendNewFriendModel)];
    self.navigationItem.rightBarButtonItem = addFriendbutton;
    
    textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(10, 70, 300, 70);
//    textView.contentSize = CGSizeMake(300, 70);
    textView.editable = YES;
    textView.scrollEnabled = NO;
    textView.backgroundColor = [UIColor colorWithWhite:00.8 alpha:0.5];
    [self.view addSubview:textView];
}

-(void)sendNewFriendModel
{
    FriendGroupCellModel *newModel = [[FriendGroupCellModel alloc] init];
    newModel.meaasge = textView.text;
    newModel.username  = [[BmobUser getCurrentUser] objectForKey:@"username"];
    newModel.userId = [BmobUser getCurrentUser].objectId;
    newModel.userImage = [User singleEample].userImageView;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置时区
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    //时间格式
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    //调用获取服务器时间接口，返回的是时间戳
    NSString  *timeString = [Bmob getServerTimestamp];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeString intValue]];
    newModel.time = [dateFormatter stringFromDate:date];
    
    FriendGroupModel *thefriendGroup = [[FriendGroupModel alloc] init];
    [thefriendGroup pushNewFriendGroupCell:newModel];
    [[NSNotificationCenter defaultCenter]postNotificationName:SJDIDADDFRIENDGROUP object:newModel];
    [self.navigationController popViewControllerAnimated:YES];
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

@end
