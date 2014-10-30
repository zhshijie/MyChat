//
//  AddFriendViewController.m
//  MyChat
//
//  Created by sky on 9/25/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()

@end

@implementation AddFriendViewController

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


#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"搜索中"message:@"请稍等" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    BmobQuery *query = [BmobQuery queryForUser];
    [query whereKey:@"username" containedIn:@[textField.text]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
         [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
        if (array.count) {
            BmobObject *user =array[0];
            NSLog(@"%@",array);
            if (array.count==1&&![[user objectForKey:@"username"] isEqual:[[BmobUser getCurrentUser] objectForKey:@"username"]]) {
                
                FriendViewController *friendView = [[FriendViewController alloc]init];
                friendView.friendMessage.friendName = [array[0] objectForKey:@"username"];
                NSString *friendDataName = [[NSString alloc]initWithFormat:@"friend%@",user.objectId];
                BmobQuery   *bquery = [BmobQuery queryWithClassName:friendDataName];
                [bquery whereKey:@"username" equalTo:[[BmobUser getCurrentUser] objectForKey:@"username"]];
                [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
                    
                    if (array.count) {
                        friendView.friendMessage.chatRoomId = [array[0] objectForKey:@"chatRoomId"];
                        friendView.buttonIsHighted = true;
                        friendView.sendButton.enabled = YES;
                    }else{
                        friendView.buttonIsHighted = NO;
                    }
                    [self.navigationController pushViewController:friendView animated:YES];

                
                }];
                
            }
        }else{
            NSLog(@"%@",error);
            if (error==nil) {
                self.alertMessage.text = @"该账号不存在";
                self.alertMessage.textColor = [UIColor redColor];
            }else{
                self.alertMessage.text = @"请输入好友的账号";
                self.alertMessage.textColor = [UIColor grayColor];
            }
        }
    }];
    return YES;
}
@end
