//
//  ChatViewController.m
//  MyChat
//
//  Created by sky on 9/28/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()
{
    User *user;
    BmobEvent *_bmobEvent;
    int reloadTimes;
}
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    user = [User singleEample];
    
    [self listen];

    self.dataSource = [NSMutableArray arrayWithArray:user.OneChartRoom.chartMessage];
    
//    if (DEVICE_IS_IPHONE5) {
//        
//        [self.message setFrame:CGRectMake(0, 538-30, 320,30)];
//    }else{
//        
//        
//        [self.message setFrame:CGRectMake(0, 480-30, 320, 30)];
//        [self.tableView setFrame:CGRectMake(0, 0, 320, 480-44-30)];
//    }
}

-(void)listen{
    //创建BmobEvent对象
    _bmobEvent          = [BmobEvent defaultBmobEvent];
    //设置代理
    _bmobEvent.delegate = self;
    //启动连接
    [_bmobEvent start];
}

-(void)bmobEvent:(BmobEvent *)event didReceiveMessage:(NSString *)message{
    //打印数据
    NSDictionary *dic =[message objectFromJSONString];
    NSDictionary *data = [dic objectForKey:@"data"];
    ChartMessage *chatmessage = [[ChartMessage alloc]init];
    chatmessage.chatMessage = [data objectForKey:@"chatMessage"];
    chatmessage.chaterName = [data objectForKey:@"charerName"];
    [_dataSource addObject:chatmessage];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    

//    self.message.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight;
    [super viewWillAppear:animated];
  
    NSLog(@"%@",NSStringFromCGRect(self.message.frame));

    self.dataSource = [NSMutableArray arrayWithArray:user.OneChartRoom.chartMessage];

    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//实习下拉刷新列表
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //康海涛测试Ok的
    
    //    BOOL flagShuaxin;
    //    CGPoint offset1 = scrollView.contentOffset;
    CGRect bounds1 = scrollView.bounds;
    //    CGSize size1 = scrollView.contentSize;
    //    UIEdgeInsets inset1 = scrollView.contentInset;
    float y = bounds1.origin.y;
    if (-y>=200 &&!(reloadTimes%10)) {
        [user getTheChartRoom:user.OneChartRoom.chartRoomId friendName:nil];

        NSString *theChartRoomId = [NSString stringWithFormat:@"theChartRoomId%@",user.OneChartRoom.chartRoomId];
        [_bmobEvent listenTableChange:BmobActionTypeUpdateTable tableName:theChartRoomId];
        
        self.dataSource = [NSMutableArray arrayWithArray:user.OneChartRoom.chartMessage];
        [self.tableView reloadData];
    }
    reloadTimes++;
}




#pragma mark uitalbeViewSource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = nil;
    ChartMessage *chatMessage = _dataSource[indexPath.row];
    if ([chatMessage.chaterName isEqualToString:user.userName]) {
        NSString *message = [NSString stringWithFormat:@"%@ : %@",chatMessage.chaterName,chatMessage.chatMessage];
        cell.textLabel.text = message;
        cell.textLabel.textColor = [UIColor redColor];
    }else{
        NSString *message = [NSString stringWithFormat:@"%@ : %@",chatMessage.chaterName,chatMessage.chatMessage];
        cell.textLabel.text = message;
        cell.textLabel.textColor = [UIColor blueColor];

    }
    return cell ;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *theChartRoomId = [NSString stringWithFormat:@"theChartRoomId%@",user.OneChartRoom.chartRoomId];
    [_bmobEvent listenTableChange:BmobActionTypeUpdateTable tableName:theChartRoomId];
    [textField resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.25];
    CGRect rect = self.view.bounds;
    rect.origin.y = 0;
    self.view.frame = rect;
    [UIView commitAnimations];
    if (textField.text.length) {
        [user sendMessage:textField.text];
        textField.text = nil;
    }
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.25];
    CGRect rect = self.view.bounds;
    rect.origin.y = -255;
    self.view.frame = rect;
    [UIView commitAnimations];
    return  YES;
}

@end
