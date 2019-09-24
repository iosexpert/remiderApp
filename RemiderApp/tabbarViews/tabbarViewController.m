//
//  tabbarViewController.m
//  MYScores
//
//  Created by Apple on 05/09/16.
//  Copyright © 2016 SuperSports. All rights reserved.
//

#import "tabbarViewController.h"
#import "settingViewController.h"
#import "scheduleViewController.h"
#import "notificationViewController.h"
#import "contactsViewController.h"
#import "MBProgressHUD.h"

@interface tabbarViewController ()
{
      MBProgressHUD *HUD;
    UIView *blackHudView;
}
@end

@implementation tabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addHud) name:@"hud" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeHud) name:@"hud1" object:nil];

    self.viewControllers = [self initializeViewControllers];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSArray *) initializeViewControllers
{
    
    scheduleViewController *hvm;
    int height = [UIScreen mainScreen].bounds.size.height;
    if (height == 480) {
        
        hvm =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"scheduleViewController"];
    }
    else if (height == 568) {
        
        hvm =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"scheduleViewController"];
    }
    else if (height == 667) {
        
        hvm =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"scheduleViewController"];
    }
    else if (height == 736) {
        
        hvm =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"scheduleViewController"];
    }
    else
    {
        
        hvm =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"scheduleViewController"];
    }
    
    
    scheduleViewController *hvm1;
    if (height == 480) {
        
        hvm1 =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"contactsViewController"];
    }
    else if (height == 568) {
        
        hvm1 =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"contactsViewController"];
    }
    else if (height == 667) {
        
        hvm1 =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"contactsViewController"];
    }
    else if (height == 736) {
        
        hvm1 =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"contactsViewController"];
    }
    else
    {
        
        hvm1 =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"contactsViewController"];
    }
    
    
    notificationViewController *hvm2;
    if (height == 480) {
        
        hvm2 =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"notificationViewController"];
    }
    else if (height == 568) {
        
        hvm2 =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"notificationViewController"];
    }
    else if (height == 667) {
        
        hvm2 =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"notificationViewController"];
    }
    else if (height == 736) {
        
        hvm2 =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"notificationViewController"];
    }
    else
    {
        
        hvm2 =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"notificationViewController"];
    }
    
    
    settingViewController *hvm3;
    if (height == 480) {
        
        hvm3 =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"settingViewController"];
    }
    else if (height == 568) {
        
        hvm3 =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"settingViewController"];
    }
    else if (height == 667) {
        
        hvm3 =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"settingViewController"];
    }
    else if (height == 736) {
        
        hvm3 =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"settingViewController"];
    }
    else
    {
        
        hvm3 =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"settingViewController"];
    }
    
    UIImage *img = [[UIImage imageNamed:@"29"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    UIImage *imgSelected = [[UIImage imageNamed:@"shedSelected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *img1 = [[UIImage imageNamed:@"cont"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *imgSelected1 = [[UIImage imageNamed:@"contSelected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *img2 = [[UIImage imageNamed:@"noti"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *imgSelected2 = [[UIImage imageNamed:@"notiSelected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *img3 = [[UIImage imageNamed:@"setting"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *imgSelected3 = [[UIImage imageNamed:@"settingSelected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UIImage* tabBarBackground = [UIImage imageNamed:@"FullContact"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    [UITabBar appearance].layer.borderWidth = 0.0f;
    [UITabBar appearance].clipsToBounds = true;
    hvm.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:img selectedImage:imgSelected];
    hvm1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:img1 selectedImage:imgSelected1];
    hvm2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:img2 selectedImage:imgSelected2];
    hvm3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:img3 selectedImage:imgSelected3];

    hvm.navigationController.navigationBarHidden=true;
    hvm1.navigationController.navigationBarHidden=true;
    hvm2.navigationController.navigationBarHidden=true;
    hvm3.navigationController.navigationBarHidden=true;

    hvm.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    hvm1.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    hvm2.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    hvm3.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

    UINavigationController *nav1=[[UINavigationController alloc]initWithRootViewController:hvm];
    UINavigationController *nav2=[[UINavigationController alloc]initWithRootViewController:hvm1];
    UINavigationController *nav3=[[UINavigationController alloc]initWithRootViewController:hvm2];
    UINavigationController *nav4=[[UINavigationController alloc]initWithRootViewController:hvm3];

    
    NSMutableArray *tabViewControllers = [[NSMutableArray alloc] init];
    [tabViewControllers addObject:nav1];
    [tabViewControllers addObject:nav2];
    [tabViewControllers addObject:nav3];
    [tabViewControllers addObject:nav4];

    return tabViewControllers;
   
}
-(void)addHud
{
    blackHudView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    blackHudView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    blackHudView.userInteractionEnabled=true;
    [self.tabBarController.view addSubview:blackHudView];
    //[[[[UIApplication sharedApplication] delegate] window] addSubview:blackHudView];
//    HUD=[MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
//    HUD.label.text=@"Fetching Contacts...";
    
    UIFont * myFont =[UIFont fontWithName:@"OpenSans-Bold" size:14];
    CGRect labelFrame1 = CGRectMake (5, 10, self.view.frame.size.width-10, 35);
    UILabel *label1 = [[UILabel alloc] initWithFrame:labelFrame1];
    [label1 setFont:myFont];
    label1.lineBreakMode=NSLineBreakByWordWrapping;
    label1.numberOfLines=2;
    label1.textColor=[UIColor blackColor];
    label1.textAlignment=NSTextAlignmentCenter;
    label1.backgroundColor=[UIColor clearColor];
    [label1 setText:@"Fetching Contacts..."];
    [blackHudView addSubview:label1];

}
-(void)removeHud
{
    HUD.hidden=true;
    [blackHudView removeFromSuperview];
}

@end
