//
//  MyDataViewController.h
//  MyChat
//
//  Created by sky on 10/4/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "BaseViewController.h"

@interface MyDataViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
