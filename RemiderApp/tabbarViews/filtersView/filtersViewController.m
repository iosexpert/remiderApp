//
//  filtersViewController.m
//  RemiderApp
//
//  Created by mac on 20/01/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import "filtersViewController.h"
#import "loginViewController.h"
#import "AppDelegate.h"
#import "webViewController.h"
#import "editProfileViewController.h"
#import "AFNetworking.h"
#import "Utilities.h"
#import "MBProgressHUD.h"
#import "calenderSyncViewController.h"
@import EventKit;

@interface filtersViewController ()
{
    MBProgressHUD *HUD;

    int monthc,dayc,weekc;
}
@end

@implementation filtersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    monthc=0;
    weekc=0;
    dayc=0;
    notiView1.layer.cornerRadius=20;
    notiView1.layer.borderWidth=2.0;
    notiView1.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    saveButton.layer.cornerRadius=15;
    
    
    NSString *st=[[NSUserDefaults standardUserDefaults] valueForKey:@"syncCAL"];
    if(st == (id)[NSNull null]|| st.length == 0  || [st isEqual:@"(null)"]|| [st isEqual:@"no"])
    {
        [syncOnOff setImage:[UIImage imageNamed:@"switchOff"] forState:UIControlStateNormal];
    }
    
    
    notiView.alpha=0.0;
}
- (IBAction)saveSwitch:(UIButton*)sender
{
    notiView.alpha=0.0;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([Utilities CheckInternetConnection])
    {
        HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.label.text=@"Please Wait";
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://18.219.207.70"]];
        [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        [httpClient setParameterEncoding:AFFormURLParameterEncoding];
        
        NSDictionary *params=@{
                               @"uid"    : [userDefaults valueForKey:@"userid"],
                               @"notification" : @"1",
                               @"one_month"    : [NSString stringWithFormat:@"%d",monthc],
                               @"one_week" : [NSString stringWithFormat:@"%d",weekc],
                               @"twenty_four_hour" : [NSString stringWithFormat:@"%d",dayc]
                               };
        
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                                path:@"/slim_api/public/users/notifications"
                                                          parameters:params];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            NSLog(@"Network-Response: %@", [operation responseString]);
            NSString *jsonString = operation.responseString;
            NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            if (JSONdata != nil) {
                
                NSError *e;
                NSMutableDictionary *JSON =
                [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                                options: NSJSONReadingMutableContainers
                                                  error: &e];
                
                [self saveResult:JSON];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSHTTPURLResponse *httpResponse = [operation response];
            NSLog(@"Network-Response: HTTP-Status Code: %ld, Error: %@", (long)[httpResponse statusCode],
                  error);
            [self saveResult:nil];        }];
        [httpClient enqueueHTTPRequestOperation:operation];
    }
}
-(void)saveResult:(NSDictionary*)dict_Response
{
    HUD.hidden=YES;
    
    if (dict_Response==NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WarmerMarket" message:@"Re-establising lost connection May be its slow or not connected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];        alert.tag=10;
        
        [alert show];
    }
    else
    {
        
        
        if([[dict_Response valueForKey:@"code"] integerValue]==1){
            
            
        }
    }
}
- (IBAction)monthSwitch:(UIButton*)sender
{
    if([[monthCheck imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"uncheck"]])
    {
        [monthCheck setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        monthc=1;
    }
    else
    {
        monthc=0;
        [monthCheck setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];

    }
}
- (IBAction)daySwitch:(UIButton*)sender
{
    if([[dayCheck imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"uncheck"]])
    {
        [dayCheck setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        dayc=1;
    }
    else
    {
        dayc=0;
        [dayCheck setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        
    }
}
- (IBAction)weekSwitch:(UIButton*)sender
{
    if([[weekCheck imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"uncheck"]])
    {
        [weekCheck setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        weekc=1;
    }
    else
    {
        weekc=0;
        [weekCheck setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        
    }
}

- (IBAction)changeSwitch:(UIButton*)sender
{
    if([[sender imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"switchOff"]])
    {
        [notiOnOff setImage:[UIImage imageNamed:@"switch"] forState:UIControlStateNormal];
        
        notiView.alpha=1.0;
        
        
        
    }
    else
    {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        if([Utilities CheckInternetConnection])
        {
            
            HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.label.text=@"Please Wait";
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://18.219.207.70"]];
            [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
            [httpClient setParameterEncoding:AFFormURLParameterEncoding];
            
            NSDictionary *params=@{
                                   @"uid"    : [userDefaults valueForKey:@"userid"],
                                   @"notification" : @"0",
                                   @"one_month"    : [NSString stringWithFormat:@"%d",0],
                                   @"one_week" : [NSString stringWithFormat:@"%d",0],
                                   @"twenty_four_hour" : [NSString stringWithFormat:@"%d",0]
                                   };
            
            NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                                    path:@"/slim_api/public/users/notifications"
                                                              parameters:params];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                // Success response.
                NSLog(@"Network-Response: %@", [operation responseString]);
                
                NSString *jsonString = operation.responseString;
                NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                
                if (JSONdata != nil) {
                    
                    NSError *e;
                    NSMutableDictionary *JSON =
                    [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                                    options: NSJSONReadingMutableContainers
                                                      error: &e];
                    
                    [self saveResult:JSON];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSHTTPURLResponse *httpResponse = [operation response];
                NSLog(@"Network-Response: HTTP-Status Code: %ld, Error: %@", (long)[httpResponse statusCode],
                      error);
                [self saveResult:nil];        }];
            [httpClient enqueueHTTPRequestOperation:operation];
        }
        
        
        [notiOnOff setImage:[UIImage imageNamed:@"switchOff"] forState:UIControlStateNormal];
    }
    
}
- (IBAction)changeAnouce:(UIButton*)sender
{
    if([[sender imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"switchOff"] ])
    {
        [anouceOnOff setImage:[UIImage imageNamed:@"switch"] forState:UIControlStateNormal];
    }
    else
    {
        [anouceOnOff setImage:[UIImage imageNamed:@"switchOff"] forState:UIControlStateNormal];
    }
    
}
- (IBAction)changeSync:(UIButton*)sender
{
    if([[sender imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"switchOff"] ])
    {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Do you want to synchronize Apple Callender?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *logOut = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                             {
                                 
                                 
                                 
                                 
                                 [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"syncCAL"];
                                 [[NSUserDefaults standardUserDefaults]synchronize];
                                 [syncOnOff setImage:[UIImage imageNamed:@"switch"] forState:UIControlStateNormal];
                                 
                                 
                                 int height = [UIScreen mainScreen].bounds.size.height;
                                 
                                 
                                 calenderSyncViewController *hvm3;
                                 if (height == 480) {
                                     
                                     hvm3 =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"calenderSyncViewController"];
                                 }
                                 else if (height == 568) {
                                     
                                     hvm3 =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"calenderSyncViewController"];
                                 }
                                 else if (height == 667) {
                                     
                                     hvm3 =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"calenderSyncViewController"];
                                 }
                                 else if (height == 736) {
                                     
                                     hvm3 =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"calenderSyncViewController"];
                                 }
                                 else
                                 {
                                     
                                     hvm3 =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"calenderSyncViewController"];
                                 }
                                 
                                              [self.navigationController pushViewController:hvm3 animated:YES];
                             }];
                                         
                           
                            
    [alert addAction:cancel];
    [alert addAction:logOut];
    [self presentViewController:alert animated:YES completion:nil];
    
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"syncCAL"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [syncOnOff setImage:[UIImage imageNamed:@"switchOff"] forState:UIControlStateNormal];
    }
    
   
    
    


    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)filters_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)logout:(id)sender
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Do you really want to logout?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *logOut = [UIAlertAction actionWithTitle:@"Logout" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                             {
                                 NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                 [userDefaults setObject:@"" forKey:@"userid"];
                                 [userDefaults synchronize];
                                 
                                 int height = [UIScreen mainScreen].bounds.size.height;
                                 
                                 
                                 loginViewController *hvm3;
                                 if (height == 480) {
                                     
                                     hvm3 =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"];
                                 }
                                 else if (height == 568) {
                                     
                                     hvm3 =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"];
                                 }
                                 else if (height == 667) {
                                     
                                     hvm3 =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"];
                                 }
                                 else if (height == 736) {
                                     
                                     hvm3 =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"];
                                 }
                                 else
                                 {
                                     
                                     hvm3 =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"];
                                 }
                                 
                                 
                                 UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:hvm3];
                                 AppDelegate* blah = (AppDelegate*)[[UIApplication sharedApplication]delegate];
                                 blah.window.rootViewController= nav  ;
                                 
                             }];
    [alert addAction:cancel];
    [alert addAction:logOut];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
    
    
   
    
}

-(IBAction)helpAction:(id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"HELP" forKey:@"lbel"];
    [userDefaults synchronize];   int height = [UIScreen mainScreen].bounds.size.height;

    webViewController *hvm3;
    if (height == 480) {
        
        hvm3 =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"webViewController"];
    }
    else if (height == 568) {
        
        hvm3 =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"webViewController"];
    }
    else if (height == 667) {
        
        hvm3 =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"webViewController"];
    }
    else if (height == 736) {
        
        hvm3 =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"webViewController"];
    }
    else
    {
        
        hvm3 =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"webViewController"];
    }
    [self.navigationController pushViewController:hvm3 animated:YES];
}
-(IBAction)faqAction:(id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"FAQ" forKey:@"lbel"];
    [userDefaults synchronize];    int height = [UIScreen mainScreen].bounds.size.height;

    webViewController *hvm3;
    if (height == 480) {
        
        hvm3 =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"webViewController"];
    }
    else if (height == 568) {
        
        hvm3 =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"webViewController"];
    }
    else if (height == 667) {
        
        hvm3 =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"webViewController"];
    }
    else if (height == 736) {
        
        hvm3 =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"webViewController"];
    }
    else
    {
        
        hvm3 =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"webViewController"];
    }
    [self.navigationController pushViewController:hvm3 animated:YES];

}
-(IBAction)manageProfileAction:(id)sender
{
    int height = [UIScreen mainScreen].bounds.size.height;
    editProfileViewController *hvm3;
    if (height == 480) {
        
        hvm3 =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"editProfileViewController"];
    }
    else if (height == 568) {
        
        hvm3 =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"editProfileViewController"];
    }
    else if (height == 667) {
        
        hvm3 =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"editProfileViewController"];
    }
    else if (height == 736) {
        
        hvm3 =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"editProfileViewController"];
    }
    else
    {
        
        hvm3 =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"editProfileViewController"];
    }
    [self.navigationController pushViewController:hvm3 animated:YES];
}
@end
