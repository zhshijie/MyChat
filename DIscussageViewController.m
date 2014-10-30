//
//  DIscussageViewController.m
//  MyChat
//
//  Created by sky on 10/14/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "DIscussageViewController.h"

@interface DIscussageViewController ()
{
    UITextField *textView;
    UITableView *talbeView;
    int reloadTimes;
}
@end

@implementation DIscussageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    self.title = @"评论";
    talbeView = [[UITableView alloc]init];
    talbeView.frame = CGRectMake(0, 0, 320, UiScreenHeight-40);
    talbeView.dataSource =self;
    talbeView.delegate = self;
    talbeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    talbeView.showsHorizontalScrollIndicator = NO;
    talbeView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:talbeView];
    
    [self.cellModel getTheDiscussage:self.cellId];
    UIBarButtonItem *addFriendbutton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(sendNewDiscussage)];
    self.navigationItem.rightBarButtonItem = addFriendbutton;
    
    textView = [[UITextField alloc] init];
    textView.delegate = self;
    textView.frame = CGRectMake(10, UiScreenHeight-40, 300, 30);
    textView.borderStyle = UITextBorderStyleRoundedRect;
    //    textView.contentSize = CGSizeMake(300, 70);
    [self.view addSubview:textView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableShouldUpload) name:SJDISTABLEUPDATA object:nil];
    // Do any additional setup after loading the view.
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)tableShouldUpload
{
    self.dataSource = self.cellModel.allDiscussage;
    [talbeView reloadData];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendNewDiscussage];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDelay:0.3];
    [UIView setAnimationDuration:0.3];
    CGRect rect = CGRectMake(10, UiScreenHeight-290, 300, 30);
    textView.frame  = rect;
    [UIView commitAnimations];
    return YES;
}// return NO to disallow editing.

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect rect = CGRectMake(10, UiScreenHeight-40, 300, 30);
    textView.frame  = rect;
    [UIView commitAnimations];
    return  YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGSize size = [self.cellModel.meaasge sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(320, 1000)];
    return size.height+100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]init];
    UILabel *message = [[UILabel alloc]init];
    message.text  = self.cellModel.meaasge;
    
    CGSize size = [self.cellModel.meaasge sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(320, 1000)];
    CGRect messageRect = CGRectMake(80,30 , size.width, size.height);
    message.frame = messageRect;
    message.font = [UIFont systemFontOfSize:14];
    message.numberOfLines = 0;
    [headView addSubview:message];
    
    UIImageView *image = [[UIImageView alloc]initWithImage:self.cellModel.userImage];
    image.frame = CGRectMake(10, 20, 50, 50);
    [headView addSubview:image];
    
    
    UIButton *greatB = [UIButton buttonWithType:UIButtonTypeSystem];
    [greatB setTitle:@"赞" forState:UIControlStateNormal];
    [greatB addTarget:self action:@selector(greatAC:) forControlEvents:UIControlEventTouchUpInside];
    CGRect greatBF = messageRect;
    greatBF.origin.y +=greatBF.size.height;
    greatBF.origin.y +=20;
    greatBF.size.height = 30;
    greatBF.size.width = 70;
    greatB.frame = greatBF;
    greatB.enabled = !self.cellModel.isgreat;
    [headView addSubview:greatB];
    
    
    
    UIButton *discussB = [UIButton buttonWithType:UIButtonTypeSystem];
    [discussB setTitle:@"评论" forState:UIControlStateNormal];
     [discussB addTarget:self action:@selector(discussAC:) forControlEvents:UIControlEventTouchUpInside];
    CGRect discussBF = greatBF;
    discussBF.origin.x = 200;
    discussB.frame = discussBF;
    [headView addSubview:discussB];
    
    headView.frame = CGRectMake(0, 0, 320, size.height+100);
    headView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textRegist)];
    tap.numberOfTapsRequired = 1;
    [headView addGestureRecognizer:tap];
    [talbeView addGestureRecognizer:tap];
    
    return headView;
}

-(void)textRegist
{
    [textView resignFirstResponder];
}
-(void)greatAC:(UIButton*)button
{
    [self.cellModel greatTheFriendGroupCell];
    button.enabled = NO;
    self.cellModel.isgreat = YES;
    self.cellModel.greatNumber++;
//    NSDictionary *dic = [[NSDictionary alloc]init];
//    [dic setValue:@"addGreat" forKey:@"style"];
//    [dic setValue:[NSNumber numberWithInt:_path] forKey:@"cellRow"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:SJDIDSENDDISCUSSAGE object:dic];
}

-(void)discussAC:(UIButton*)button
{
    [textView becomeFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [talbeView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
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

-(void)upDataSource
{
    [self.cellModel getTheDiscussage:self.cellId];
}

-(void)sendNewDiscussage
{
    [textView resignFirstResponder];
    if (textView.text.length) {
        FriendGroupModel *friMl = [[FriendGroupModel alloc]init];
        [friMl sendDiscussage:textView.text inFriendModelCell:self.cellId];
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self.dataSource];
        NSString *string = textView.text;
        NSString *name = [[BmobUser getCurrentUser] objectForKey:@"username"];
        NSString *dis = [name stringByAppendingFormat:@":%@",string];
        [array insertObject:dis atIndex:0];
        self.dataSource = [[NSMutableArray alloc]initWithArray:array];
//        [self.dataSource addObject:textView.text];
        [talbeView reloadData];
        textView.text = nil;
        self.cellModel.discussNumber++;
//        NSDictionary *dic = [[NSDictionary alloc]init];
//        [dic setValue:@"addDiscuss" forKey:@"style"];
////        [dic setValue:[NSNumber numberWithInt:_path] forKey:@"cellRow"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:SJDIDSENDDISCUSSAGE object:dic];
    }
 
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
