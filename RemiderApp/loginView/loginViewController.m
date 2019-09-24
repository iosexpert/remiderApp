//
//  loginViewController.m
//  RemiderApp
//
//  Created by mac on 19/01/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import "loginViewController.h"
#import "tabbarViewController.h"
#import "AFNetworking.h"
#import "registerViewController.h"
#import "MBProgressHUD.h"
#define APPURL @"http://18.219.207.70"
#define ACCEPTABLE_CHARACTERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.@"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface loginViewController ()
{
    MBProgressHUD *HUD;

    NSString *emailid123;
}
@end

@implementation loginViewController
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)exportAnimatedGif
{
    UIImage *shacho = [UIImage imageNamed:@"gift"];
    UIImage *bucho = [UIImage imageNamed:@"black"];
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"animated.gif"];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((CFURLRef)[NSURL fileURLWithPath:path],
                                                                        kUTTypeGIF,
                                                                        2,
                                                                        NULL);
    
    NSDictionary *frameProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:2] forKey:(NSString *)kCGImagePropertyGIFDelayTime]
                                                                forKey:(NSString *)kCGImagePropertyGIFDictionary];
    NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount]
                                                              forKey:(NSString *)kCGImagePropertyGIFDictionary];
    CGImageDestinationAddImage(destination, shacho.CGImage, (CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, bucho.CGImage, (CFDictionaryRef)frameProperties);
    CGImageDestinationSetProperties(destination, (CFDictionaryRef)gifProperties);
    CGImageDestinationFinalize(destination);
    CFRelease(destination);
    NSLog(@"animated GIF file created at %@", path);
    
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;

   // [self exportAnimatedGif];
    
    loginButton.layer.cornerRadius=25;
   // UIFont * myFont = [UIFont fontWithName:@"GillSans-Bold" size:12];

    emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email id" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    //emailField.font=myFont;
    passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
   // passwordField.font=myFont;

    
   

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)register_Action:(id)sender
{
    registerViewController *smvc;
    int height = [UIScreen mainScreen].bounds.size.height;
    if (height == 480) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"registerViewController"];
        
    }
    else if (height == 568) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"registerViewController"];
        
    }
    else if (height == 667) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"registerViewController"];
        
    }
    else if (height == 736) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"registerViewController"];
        
    }
    else if (height == 1024) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"ipad" bundle:nil] instantiateViewControllerWithIdentifier:@"registerViewController"];
        
    }
    else
    {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"ipad2" bundle:nil] instantiateViewControllerWithIdentifier:@"registerViewController"];
        
    }
    
    [self.navigationController pushViewController:smvc animated:YES];

}
-(IBAction)forgotAction:(id)sender
{
    UIAlertView* alert1 = [[UIAlertView alloc] init];
    [alert1 setDelegate:self];
    [alert1 setTitle:@"Enter Valid Email Id"];
    [alert1 setMessage:@" "];
    [alert1 addButtonWithTitle:@"Proceed"];
    [alert1 addButtonWithTitle:@"Cancel"];
    alert1.tag=1;
    alert1.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert1 show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag==1)
        
    {
        if(buttonIndex==0)
            
        {
            if([[alertView textFieldAtIndex:0].text isEqual:@""])
            {
                [self forgotAction:0];
            }
            else
            {
                emailid123 = [alertView textFieldAtIndex:0].text;
                NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
                NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
                BOOL myStringMatchesRegEx=[emailTest evaluateWithObject:emailid123];
                if(!myStringMatchesRegEx)
                {
                    UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"" message:@" Please enter valid email id " delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    al.tag=2;
                    [al show];
                }
                else
                {
                    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    HUD.label.text=@"Please Wait";
                    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://18.219.207.70"]];
                    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
                    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
                    
                    NSDictionary *params=@{
                                           @"email"    : emailid123,
                                           };
                    
                    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                                            path:@"/slim_api/public/users/forgetPassword"
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
                            
                            [self forgotResult:JSON];
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSHTTPURLResponse *httpResponse = [operation response];
                        NSLog(@"Network-Response: HTTP-Status Code: %ld, Error: %@", (long)[httpResponse statusCode],
                              error);
                        [self forgotResult:nil];        }];
                    [httpClient enqueueHTTPRequestOperation:operation];
                    
                    
                }
            }
        }
       
    }
    
}
-(void)forgotResult:(NSDictionary*)dict_Response
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WarmerMarket" message:[dict_Response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
        }
    }
}
-(IBAction)login_Action:(id)sender
{
    if([emailField.text isEqual:@""] ||  [passwordField.text isEqual:@""])
    {
        
        
        
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"WarmerMarket"
                                     message:@"Please Enter Valid Username and Password"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
        return;
    }
    else
    {
        NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
        NSString *emaillll=[u objectForKey:@"deviceToken"];
        HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.label.text=@"Please Wait";
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://18.219.207.70"]];
        [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        [httpClient setParameterEncoding:AFFormURLParameterEncoding];
        
        NSDictionary *params=@{
                               @"email"    : emailField.text,
                               @"password" : passwordField.text,
                               @"deviceType" : @"1",
                               @"deviceToken" : emaillll
                               };
        
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                                path:@"/slim_api/public/users/login"
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
                
                [self loginresult:JSON];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSHTTPURLResponse *httpResponse = [operation response];
            NSLog(@"Network-Response: HTTP-Status Code: %ld, Error: %@", (long)[httpResponse statusCode],
                  error);
            [self loginresult:nil];        }];
        [httpClient enqueueHTTPRequestOperation:operation];
        
        
        
        
        
    }
    
}
-(void)loginresult:(NSDictionary*)dict_Response
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
            
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[[dict_Response valueForKey:@"data"]valueForKey:@"id"][0] forKey:@"userid"];
            [userDefaults synchronize];
            
            
            NSLog(@"%@",[[dict_Response valueForKey:@"data"][0]valueForKey:@"id"]);
            
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
            
            
            [[[UIApplication sharedApplication] windows] objectAtIndex:0].rootViewController=hvm3;

        }
    
        else
        {

            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"WarmerMarket"
                                         message:@"Wrong Username or Password"
                                         preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Ok"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                        }];
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];

        }
    
}
}
#pragma mark- text feild deligate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    
//    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
//    
//    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//    
//    if ( [string isEqual:@" "]){
//        
//        return NO;
//    }
//    else {
//        return [string isEqualToString:filtered];
//    }
//}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField

{
    
//    if(textField.tag==33)
//    {
//        [scrv setContentOffset:CGPointMake(0, 100) animated:YES];
//
//    }
//    if(textField.tag==55)
//    {
//        [scrv setContentOffset:CGPointMake(0, 130) animated:YES];
//
//    }
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
//    [scrv setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}

@end
