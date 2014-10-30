//
//  RootTabBarViewController.m
//  MyChat
//
//  Created by sky on 9/18/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "RootTabBarViewController.h"

@interface RootTabBarViewController ()
{
}
@end

@implementation RootTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    MyChartViewController *mychartViewController = [[MyChartViewController alloc]init];
    ContactsViewController *contactsViewController = [[ContactsViewController alloc]init];
    SearchViewController *searchViewController = [[SearchViewController alloc]init];
    MyViewController *myViewController = [[MyViewController alloc]init];
    
    NSArray *viewControllers = @[mychartViewController,contactsViewController,searchViewController,myViewController];
    NSArray *viewControllerNames = @[@"微信",@"通讯录",@"发现",@"我"];
    NSArray *viewControllerImages = @[[UIImage imageNamed:@"chat"],[UIImage imageNamed:@"contacts"],[UIImage imageNamed:@"search"],[UIImage imageNamed:@"my"]];
    NSMutableArray *navigationViews = [[NSMutableArray alloc]initWithCapacity:4];
    for (int index = 0; index<4; index++) {
        BaseNavigationViewController *navigation = [[BaseNavigationViewController alloc]initWithRootViewController:viewControllers[index]];
        
        navigation.tabBarItem = [[UITabBarItem alloc]initWithTitle:viewControllerNames[index] image:viewControllerImages[index] selectedImage:nil];
        [navigationViews addObject:navigation];
    }
    
    self.viewControllers = navigationViews;
    self.tabBar.barTintColor = [UIColor blackColor];
//    LoginViewController *loginView = [[LoginViewController alloc]init];
//    [self.view addSubview:loginView.view];
    
    

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
