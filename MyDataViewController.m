//
//  MyDataViewController.m
//  MyChat
//
//  Created by sky on 10/4/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "MyDataViewController.h"

@interface MyDataViewController ()
{
    NSArray *_dataSource;
    NSMutableArray *_detailSource;
    User *user;
}
@end

@implementation MyDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = @[@[@"头像",@"名字",@"微信号",@"邮箱"],@[@"性别",@"地区"]];
    
    user = [User singleEample];
    
    NSMutableArray *tableOne = [[NSMutableArray alloc]initWithObjects:user.userImageView?user.userImageView:[UIImage imageNamed:@"my"],user.nickName?user.nickName:user.userName,user.userName,user.email, nil];
    
    NSMutableArray *tableTwo =[ [NSMutableArray alloc]initWithObjects:user.userSex?user.userSex:@"保密",user.userAddress?user.userAddress:@"未填写", nil];
    _detailSource = [[NSMutableArray alloc]initWithObjects:tableOne,tableTwo,nil];
    self.tableView.scrollEnabled = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource[section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    cell.textLabel.text = _dataSource[indexPath.section][indexPath.row];

    if (indexPath.section==0&&indexPath.row==0) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:_detailSource[0][0]];
        imageView.frame = CGRectMake(UiScreenWeight-60, 20, 40, 40);
        [cell.contentView addSubview:imageView];
    }
    else {
    cell.detailTextLabel.text = _detailSource[indexPath.section][indexPath.row];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==0) {
        return 80;
    }
    return 44;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==0) {
        UIActionSheet *pickView= [[UIActionSheet alloc]initWithTitle:@"获取照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册访问"otherButtonTitles:@"拍摄图像", nil];
        [pickView showInView:self.view];
        
    }
}


#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else if (buttonIndex == 1)
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
      
    }
}


#pragma  mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFninishSavingWithError:contextInfo:), nil);
    [user changeUserImageView:image];
    _detailSource[0][0] = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

-(void)image:(UIImage *)image didFninishSavingWithError:(NSError *)error contextInfo:(void*)contextInfo{
    if (!error) {
        NSLog(@"保存成功");
    }
}

@end
