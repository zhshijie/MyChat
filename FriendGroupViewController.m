//
//  FriendGroupViewController.m
//  MyChat
//
//  Created by sky on 10/6/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "FriendGroupViewController.h"

@interface FriendGroupViewController ()
{
    FriendGroupModel *friendGroup;
    int reloadTimes;
}
@end

@implementation FriendGroupViewController


-(void)setDataSource:(NSMutableArray *)dataSource
{
    if (_dataSource!=nil) {
        _dataSource=nil;
    }
    _dataSource = [dataSource mutableCopy];
}



- (void)viewDidLoad {
    self.tabBarController.tabBar.hidden = YES;
    [super viewDidLoad];
    self.title = @"朋友圈";
    reloadTimes = 0;
     friendGroup= [[FriendGroupModel alloc] initWithDatabaseName:[BmobUser getCurrentObject].objectId];
//    self.dataSource = friendGroup.allFriendGroup;
    self.dataSource = [friendGroup getTheData];
    if (self.dataSource==nil) {
        [friendGroup getAllTheFriendGroupCell];
        self.dataSource = [friendGroup getTheData];
    }else{
        [self performSelector:@selector(upDataSource) withObject:self afterDelay:1];
        
    }
    
    
    UIBarButtonItem *addFriendbutton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(sendNewFriendModel)];
    self.navigationItem.rightBarButtonItem = addFriendbutton;

    //注册为发表朋友圈留言的通知
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didAddFriendGroup:) name:SJDIDADDFRIENDGROUP object:nil];
    
    //发表评论通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSendDis:) name:SJDIDSENDDISCUSSAGE object:nil];
    
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableShouldUpload) name:SJTABLEUPDATA object:nil];

}

-(void)tableShouldUpload
{
    self.dataSource = friendGroup.allFriendGroup;
    [self.tableView reloadData];
}

-(void)didSendDis:(NSNotification*)noti
{
    NSDictionary *dic = [noti object];
    NSString *style = [dic objectForKey:@"style"];
    NSNumber *num = [dic objectForKey:@"cellRow"];
    FriendGroupCellModel *friendModel = _dataSource[num.intValue];
    if ([style isEqual:@"addGreat"]) {
        friendModel.greatNumber++;
        friendModel.isgreat = YES;
    }
    if ([style isEqual:@"addDiscuss"]) {
        friendModel.discussNumber++;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
-(void)didAddFriendGroup:(NSNotification*)nsontification
{
     FriendGroupCellModel *newFriendGroupModel = (FriendGroupCellModel*)[nsontification object];
    [self.dataSource insertObject:newFriendGroupModel atIndex:0];
   
    [self.tableView reloadData];
}


-(void)sendNewFriendModel
{
   
    SendFriendCellModelViewController *send = [[SendFriendCellModelViewController alloc] init];
    [self.navigationController pushViewController:send animated:YES];
    
    [self performSelector:@selector(upDataSource) withObject:nil afterDelay:3];
}

-(void)upDataSource
{
    [friendGroup getAllTheFriendGroupCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendGroupTableViewCell *friendCell = (FriendGroupTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"friendCell"];
    if (friendCell==nil) {
        // 3. 把 WPaperCell.xib 放入数组中
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendGroupTableViewCell" owner:self options:nil] ;
        
        // 获取nib中的第一个对象
        for (id oneObject in nib){
            // 判断获取的对象是否为自定义cell
            if ([oneObject isKindOfClass:[FriendGroupTableViewCell class]]){
                // 4. 修改 cell 对象属性
                friendCell = [(FriendGroupTableViewCell *)oneObject initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friendCell"];
            }
            [friendCell.contentView removeFromSuperview];
        }

    }
    FriendGroupCellModel *friendCellModel = _dataSource[indexPath.row];
    friendCell.message.numberOfLines = 0;

    CGSize size = [friendCellModel.meaasge sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(320, 70)];
    CGRect rect = friendCell.message.frame;
    rect.origin.x = 80;
    rect.origin.y = 50;
    rect.size.height = size.height;
    friendCell.message.frame = rect;

    friendCell.messageUser.text = friendCellModel.username;
    friendCell.message.font = [UIFont systemFontOfSize:14];
    friendCell.message.text = friendCellModel.meaasge;
    friendCell.updataTime.text = friendCellModel.time;
    friendCell.updataTime.font = [UIFont systemFontOfSize:12];
    friendCell.updataTime.textColor = [UIColor grayColor];
    friendCell.messageImage.image = friendCellModel.userImage;
    [friendCell.greatButton setTitle:[NSString stringWithFormat:@"赞(%ld)",(long)friendCellModel.greatNumber
] forState:UIControlStateNormal];
    friendCell.greatButton.tag = indexPath.row;
    [friendCell.greatButton addTarget:self action:@selector(greatAction:) forControlEvents:UIControlEventTouchUpInside];
    rect.origin.x = 80;
    rect.origin.y = 55;
    
    rect.origin.y+=rect.size.height;
    rect.size.width = 100;
    rect.size.height = 40;
   friendCell.greatButton.frame = rect;
    friendCell.greatButton.enabled = !friendCellModel.isgreat;
    if(friendCellModel.isgreat)
    {
        [friendCell.greatButton setTitle:[NSString stringWithFormat:@"已赞(%ld)",(long)friendCellModel.greatNumber
                                          ] forState:UIControlStateNormal];
    }
    
    [friendCell.discussButton setTitle:[NSString stringWithFormat:@"评论(%ld)",(long)friendCellModel.discussNumber
                                        ]  forState:UIControlStateNormal];
    friendCell.discussButton.tag = indexPath.row;
    [friendCell.discussButton addTarget:self action:@selector(discussAction:) forControlEvents:UIControlEventTouchUpInside];
    rect.origin.x  = 200;
    friendCell.discussButton.frame = rect;
    
    
    return friendCell;
}


-(void)greatAction:(UIButton *)button
{
    FriendGroupCellModel *friM = _dataSource[button.tag];
    [friM greatTheFriendGroupCell];
    [button setTitle:[NSString stringWithFormat:@"已赞(%ld)",(long)friM.greatNumber+1
                      ] forState:UIControlStateNormal];
    button.enabled = NO;
    FriendGroupModel *thefrien = [[FriendGroupModel alloc]initWithDatabaseName:[BmobUser getCurrentObject].objectId];
    NSString *upString = [NSString stringWithFormat:@"insert or replace into FriendGroup(username,greatNumber,objectId,isgreat) values('%@',%ld,'%@',%d)",friM.username,(long)friM.greatNumber+1,friM.objectId,YES];
    [thefrien uploadData:upString];
}

-(void)discussAction:(UIButton *)button{
    FriendGroupCellModel *friM = _dataSource[button.tag];
    DIscussageViewController *disV = [[DIscussageViewController alloc]init];
    disV.cellId = friM.objectId;
    disV.cellModel = friM;
    disV.path =button.tag;
    [self.navigationController pushViewController:disV animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //康海涛测试Ok的
    
    //    BOOL flagShuaxin;
    //    CGPoint offset1 = scrollView.contentOffset;
    CGRect bounds1 = scrollView.bounds;
    //    CGSize size1 = scrollView.contentSize;
    //    UIEdgeInsets inset1 = scrollView.contentInset;
    float y = bounds1.origin.y;
    if (-y>=150 &&!(reloadTimes%10)) {
        [self upDataSource];
    }
    reloadTimes++;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendGroupCellModel *friendCellModel = _dataSource[indexPath.row];
    NSString *mess = friendCellModel.meaasge;
    CGSize size = [mess sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(320, 70)];
    
    return size.height+100;
}

- (BOOL)tableView:(UITableView *)tableView     shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

@end
