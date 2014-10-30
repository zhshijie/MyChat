//
//  DIscussageViewController.h
//  MyChat
//
//  Created by sky on 10/14/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "BaseViewController.h"
#import "FriendGroupCellModel.h"
#import "FriendGroupModel.h"

@interface DIscussageViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,retain)FriendGroupCellModel *cellModel;
@property (nonatomic,retain)NSString *cellId;
@property (nonatomic,copy)NSMutableArray *dataSource;
@property (nonatomic,assign)int path;

@end
