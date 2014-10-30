//
//  ContactsViewController.m
//  MyChat
//
//  Created by sky on 9/18/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "ContactsViewController.h"

@interface ContactsViewController ()
{
    User *user;
    int reloadTimes;
}
@end

@implementation ContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"通讯录";

    }
    return self;
}

-(void)setDataSource:(NSMutableArray *)dataSource{
    if(_dataSource != nil)
    {
        _dataSource = nil;
    }
    _dataSource = [dataSource mutableCopy];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    user = [User singleEample];
//    [user gettheFriends:[BmobUser getCurrentObject]];
//    [user getVerificationFriend];
//    reloadTimes = 0;
//    self.dataSource = [[NSMutableArray alloc]initWithArray:user.friends];
//    [self randDataSoure:self.dataSource];
    
    UIBarButtonItem *addFriendbutton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriendAction)];
    self.navigationItem.rightBarButtonItem = addFriendbutton;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [user gettheFriends:[BmobUser getCurrentObject]];
    [user getVerificationFriend];
    reloadTimes = 0;
    self.dataSource = [[NSMutableArray alloc]initWithArray:user.friends];
    [self randDataSoure:self.dataSource];
    [self.tableView reloadData];
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
    if (-y>=150 &&!(reloadTimes%10)) {
        [user gettheFriends:[BmobUser getCurrentObject]];
        self.dataSource = [[NSMutableArray alloc]initWithArray:user.friends];
        [self randDataSoure:self.dataSource];
        [self.tableView reloadData];
    }
    reloadTimes++;
}



-(void)addFriendAction
{
//    [user addFriend:@"qqqq"];
    
    AddFriendViewController *addfriendView = [[AddFriendViewController alloc]init];
    [self.navigationController pushViewController:addfriendView animated:YES];
    
//    BmobUser *User = [BmobUser getCurrentObject];
//    [user getTheData:User];
//    [user getVerificationFriend];
//
//self.dataSource = [[NSMutableArray alloc]initWithArray:user.friends];
//    [self randDataSoure:self.dataSource];
//    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//对数据进行排列
/*
 *参数：dataSourceTemp
 *需要进行排列的数据源
 */
-(void)randDataSoure:(NSMutableArray *)dataSourceTemp
{
    NSLog(@"randDataSoure");
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    //创建于Section数目相同的空数组
    NSInteger sectionCount = [[theCollation sectionTitles]count];
    NSMutableArray *sectionArrays =[NSMutableArray arrayWithCapacity:sectionCount];
    //    NSLog(@"%ld",(long)sectionCount);
    for (int i=0; i<sectionCount; i++) {
        [sectionArrays addObject:[NSMutableArray arrayWithCapacity:1]];
    }
    
    
    //将数据放入上面的数组中
    for(FriendsModel * friend in dataSourceTemp){
        NSInteger sect = [theCollation sectionForObject:friend collationStringSelector:@selector(friendName)];
        [[sectionArrays objectAtIndex:sect] addObject:friend];
    }
    //将section中的数据追加到表格用数组中
    _dataSource = [NSMutableArray arrayWithCapacity:sectionCount];
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(friendName)];
        [_dataSource addObject:sortedSection];
    }
}
-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
        NSLog(@"sectionIndexTitlesForTableView");
    return [[UILocalizedIndexedCollation currentCollation]sectionTitles];
}



-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
        NSLog(@"sectionForSectionIndexTitle");
    return [[UILocalizedIndexedCollation currentCollation]sectionForSectionIndexTitleAtIndex:index];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section>0) {
    if ([[self.dataSource objectAtIndex:section-1] count]) {
        return [[[UILocalizedIndexedCollation currentCollation]sectionTitles]objectAtIndex:section-1];;
    }
    }
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else
    return [_dataSource[section-1] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
//    cell.imageView.image =((FriendsModel*) _dataSource[indexPath.section][indexPath.row]).friendImage;
//    cell.textLabel.text = ((FriendsModel*) _dataSource[indexPath.section][indexPath.row]).friendNikeName;
//    NSLog(@"%@",_dataSource[indexPath.section][indexPath.row]);
    if (indexPath.section>0) {
        FriendsModel *friend = [_dataSource[indexPath.section-1][indexPath.row] copy];
        cell.textLabel.text = friend.friendNikeName?friend.friendNikeName:friend.friendName;
        cell.imageView.image = friend.friendImage?friend.friendImage:[UIImage imageNamed:@"my"];
    }else{
        cell.textLabel.text = @"新的好友";
        cell.imageView.image = [UIImage imageNamed:@"newFriend"];
    }
    
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count+1;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row == 0) {
        VerificationFriendViewController *ver = [[VerificationFriendViewController alloc]init];
        [self.navigationController pushViewController:ver animated:YES];
    }else{
    FriendsModel *friend = _dataSource[indexPath.section-1][indexPath.row];
        user.currentFriend = friend;
        FriendViewController *friendView = [[FriendViewController alloc]init];
        friendView.friendMessage = friend;
        friendView.buttonIsHighted = YES;
        [self.navigationController pushViewController:friendView animated:YES];
    }
}

@end
