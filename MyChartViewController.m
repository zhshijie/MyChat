//
//  MyChartViewController.m
//  MyChat
//
//  Created by sky on 9/18/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "MyChartViewController.h"

@interface MyChartViewController ()
{
    NSMutableArray *_dataSource;
    User *user;
    int reloadTimes;
}
@end

@implementation MyChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"微信";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyChatTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    user = [User singleEample];
    [user getTheAllChartRooms];
    _dataSource = [NSMutableArray arrayWithArray:user.allChartRooms];
    [BmobQuery clearAllCachedResults];
    
    [self performSelector:@selector(uploadDatasource) withObject:self afterDelay:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

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
        [self uploadDatasource];
    }
    reloadTimes++;
}

-(void)uploadDatasource
{
    [user getTheAllChartRooms];
    _dataSource = [NSMutableArray arrayWithArray:user.allChartRooms];
    
    [self.tableView reloadData];
}


#pragma mark tableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    MyChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[MyChatTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    ChartRoom *charRoom = _dataSource[indexPath.row];
    NSString *name = [[NSString alloc] init];
    for (NSString *member in charRoom.members) {
        if ([member isEqualToString: user.userName]) {
            continue;
        }
        name = [name stringByAppendingFormat:@"%@",member];
    }
    cell.userName.text = name;
    int index = charRoom.chartMessage.count;
    NSString *message = charRoom.chartMessage[index-1];
    cell.chatMessage.text = message;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChartRoom *charRoom = _dataSource[indexPath.row];
    NSLog(@"charRoom.chartRoomId-----%@",charRoom.chartRoomId);
        user.OneChartRoom.chartRoomId = charRoom.chartRoomId;
    [user getTheChartRoom:charRoom.chartRoomId friendName:nil];
    ChatViewController *chatView = [[ChatViewController alloc] init];
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController pushViewController:chatView animated:YES];
}

#pragma mark tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}
@end
