//
//  AppDelegate.m
//  RemiderApp
//
//  Created by mac on 19/01/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import "AppDelegate.h"
#import "loginViewController.h"
#import "tabbarViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()<UNUserNotificationCenterDelegate>
{
    NSString *userid;
    
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.contactid=0;
    self.contactArray=[NSArray new];
    
    
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
                if(!error){
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                }
            }];
        } else {
            // Fallback on earlier versions
        }

    if (!launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        
    }
    else {
        NSDictionary *info = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        self.notification=true;
        self.notiNewsId=[[info valueForKey:@"aps"]valueForKey:@"alert"];

    }
    NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
    userid = [NSString stringWithFormat:@"%@",[userDefaults1 objectForKey:@"userid"]];
    
    NSString *at = [NSString stringWithFormat:@"%@",[userDefaults1 objectForKey:@"syncCAL"]];
    if(at == (id)[NSNull null]|| at.length == 0  || [at isEqual:@"(null)"])
    {
        [userDefaults1 setObject:@"no" forKey:@"syncCAL"];
        [userDefaults1 synchronize];
    }
    if(userid == (id)[NSNull null]|| userid.length == 0  || [userid isEqual:@"(null)"])
    {
        loginViewController *smvc;
        int height = [UIScreen mainScreen].bounds.size.height;
        if (height == 480) {
            
            
            smvc =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"];
            
        }
        else if (height == 568) {
            
            
            smvc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"];
            
        }
        else if (height == 667) {
            
            
            smvc =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"];
            
        }
        else if (height == 736) {
            
            
            smvc =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"];
            
        }
        else if (height == 1024) {
            
            
            smvc =[[UIStoryboard storyboardWithName:@"ipad" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"];
            
        }
        else
        {
            
            
            smvc =[[UIStoryboard storyboardWithName:@"ipad2" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"];
            
        }
        
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
    
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:smvc];
        self.window.rootViewController=nav;
    }
    else
    {
        int height = [UIScreen mainScreen].bounds.size.height;
        
        
        tabbarViewController *hvm3;
        if (height == 480) {
            
            hvm3 =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"tabbarViewController"];
        }
        else if (height == 568) {
            
            hvm3 =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabbarViewController"];
        }
        else if (height == 667) {
            
            hvm3 =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"tabbarViewController"];
        }
        else if (height == 736) {
            
            hvm3 =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"tabbarViewController"];
        }
        else
        {
            
            hvm3 =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"tabbarViewController"];
        }
        self.window.rootViewController=hvm3;
    }
        
    // Override point for customization after application launch.
    return YES;
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    self.notification=true;
    self.notiNewsId=[[notification.request.content.userInfo valueForKey:@"aps"]valueForKey:@"alert"];
    [notificationCenter postNotificationName:@"notification" object:nil userInfo:nil];

    
}

//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    self.notification=true;
    self.notiNewsId=[[response.notification.request.content.userInfo valueForKey:@"aps"]valueForKey:@"alert"];

   // self.notiNewsId=[[[response.notification.request.content.userInfo valueForKey:@"aps"]valueForKey:@"alert"]valueForKey:@"phonenumber"];
   // [notificationCenter postNotificationName:@"notification" object:nil userInfo:nil];

    completionHandler();
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSString *dt=[NSString stringWithFormat:@"%@",deviceToken];
    NSString *stringWithoutSpaces = [dt stringByReplacingOccurrencesOfString:@" " withString:@""];
    stringWithoutSpaces = [stringWithoutSpaces stringByReplacingOccurrencesOfString:@"<" withString:@""];
    stringWithoutSpaces = [stringWithoutSpaces stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", stringWithoutSpaces);
    
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:stringWithoutSpaces forKey:@"deviceToken"];
    [userDefaults synchronize];
    
    
    
    // custom stuff we do to register the device with our AWS middleman
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
    
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //NSLog(@"userInfo%@",userInfo);
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        self.notiNewsId=[[userInfo valueForKey:@"aps"]valueForKey:@"alert"];
        NSLog(@"%@",[[[userInfo valueForKey:@"aps"]valueForKey:@"alert"]valueForKey:@"phonenumber"]);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"userInfo.plist"];
        [userInfo writeToFile:filePath atomically:YES];

    if(application.applicationState == UIApplicationStateBackground){
        
        [notificationCenter postNotificationName:@"notification" object:nil userInfo:nil];
        
    }else if(application.applicationState == UIApplicationStateInactive){
        
        [notificationCenter postNotificationName:@"notification" object:nil userInfo:nil];
        
    }
    
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
