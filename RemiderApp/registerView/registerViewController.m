//
//  registerViewController.m
//  RemiderApp
//
//  Created by mac on 19/01/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import "registerViewController.h"
#import "tabbarViewController.h"
#import "AFNetworking.h"
#import "AFHTTPClient.h"
#import "MBProgressHUD.h"
@interface registerViewController ()
{
    UIDatePicker *datePicker;
    UIView *dateview;
    NSString *dateOfBirth,*timestamp;
    MBProgressHUD *HUD;

}
@end

@implementation registerViewController
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}- (void)viewDidLoad {
    [super viewDidLoad];
    userImage.layer.cornerRadius=45;
    userImage.layer.borderColor=[UIColor whiteColor].CGColor;
    userImage.layer.borderWidth=1.0;
    
    register_button.layer.cornerRadius=25;

    scrv.contentSize=CGSizeMake(200, register_button.frame.origin.y+100);
    emailid_field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email address" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

    password_field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

    phoneNo_field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone number" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

    birthday_field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"DD" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
     birthmonth_field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"MM" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
     birthyear_field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"YYYY" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

    name_field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

    lastname_field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)login_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)register_Action:(id)sender
{
    NSString *emailid = emailid_field.text;
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL myStringMatchesRegEx=[emailTest evaluateWithObject:emailid];
    
    NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
    NSString *emaillll=[u objectForKey:@"deviceToken"];
    
    if([emailid_field.text isEqual:@""]  ||  [name_field.text isEqual:@""] ||  [lastname_field.text isEqual:@""] ||  [password_field.text isEqual:@""] ||  [birthyear_field.text isEqual:@""] ||  [birthmonth_field.text isEqual:@""] ||  [birthday_field.text isEqual:@""])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter all of the empty fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag=10;
        
        [alert show];
        return;
    }
    else if(!myStringMatchesRegEx)
    {
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"" message:@" This email address is invalid. " delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        al.tag=10;
        
        [al show];
    }

    else
    {
        HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.label.text=@"Please Wait";
        NSString *postPath=@"/slim_api/public/users/signup";
        NSDictionary *params=@{
                               @"name"    : name_field.text,
                               @"last_name" : lastname_field.text,
                               @"email" : emailid_field.text,
                               @"password" : password_field.text,
                               @"phone_number" : phoneNo_field.text,
                               @"dob" : [NSString stringWithFormat:@"%@-%@-%@",birthyear_field.text,birthmonth_field.text,birthday_field.text],
                               @"deviceType" : @"1",
                               @"deviceToken" : emaillll


                               };
        NSData *imageData =  UIImageJPEGRepresentation(userImage.image, 0.5); // name of the image
        NSURL *url = [NSURL URLWithString:@"http://18.219.207.70"];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:postPath parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            [formData appendPartWithFileData:imageData name:@"profile_image" fileName:@"profile_image.jpg" mimeType:@"image/jpeg"];
        }];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSData *JSONData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",jsonObject);
            HUD.hidden=YES;
            if([[jsonObject valueForKey:@"code"]intValue]==1)
            {
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:[[jsonObject valueForKey:@"result"]valueForKey:@"id"][0] forKey:@"userid"];
                [userDefaults synchronize];
                [self registerUserComplete];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:[jsonObject valueForKey:@"message"]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            HUD.hidden=YES;

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please Try Again Later"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }];
        
        // 5
        [operation start];
    }

    //http://18.219.207.70/php/scheduleingApp/slim_api/public/users/signup 
}
-(void)registerUserComplete
{
    HUD.hidden=YES;
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
-(IBAction)choosePhoto_Action:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Image",@"Gallery", nil];
    [sheet showInView:self.view];
    [sheet setTag:2];
}
#pragma mark Actionsheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
 if (actionSheet.tag == 2){
        if (buttonIndex==0) {//Camera for image
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.allowsEditing = YES;
                [self presentViewController:imagePicker animated:YES completion:NULL];
                
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera Unavailable"
                                                               message:@"Unable to find a camera on your device."
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil, nil];
                [alert show];
                alert = nil;
            }
            
            
        }
        else if (buttonIndex==1) {//gallary
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:NULL];
            
            
        }
        else if (buttonIndex==2){//Video
            
            
            
            
            
        }
        
    }
    
    
    
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
      if(textField.tag==1)
      {
          [scrv setContentOffset:CGPointMake(0, 0) animated:YES];
   
      }
      else if(textField.tag==2)
      {
          [scrv setContentOffset:CGPointMake(0, 50) animated:YES];
   
      }
      else if(textField.tag==3)
      {
          [self.view endEditing:YES];
          [textField resignFirstResponder];
          UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select Date:"
                                                                                   message:nil preferredStyle:UIAlertControllerStyleActionSheet];
          for (int j =1 ; j<=31; j++){
              UIAlertAction *action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%d",j] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                  
                birthday_field.text=[NSString stringWithFormat:@"%d",j];
                  
                }];
              
              [alertController addAction:action];
          }
          UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                 style:UIAlertActionStyleCancel
                                                               handler:^(UIAlertAction *action) {
                                                               }];
          [alertController addAction:cancelAction];
          [self presentViewController:alertController animated:YES completion:nil];

          return NO;
      }
      else if(textField.tag==4)
      {
          [self.view endEditing:YES];
          [textField resignFirstResponder];
          UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select Month:"
                                                                                   message:nil
                                                                            preferredStyle:UIAlertControllerStyleActionSheet];
          for (int j =1 ; j<=12; j++){
              UIAlertAction *action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%d",j] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                  
                 birthmonth_field.text=[NSString stringWithFormat:@"%d",j];
    
              }];
              
              [alertController addAction:action];
          }
          UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                 style:UIAlertActionStyleCancel
                                                               handler:^(UIAlertAction *action) {
                                                               }];
          [alertController addAction:cancelAction];
          [self presentViewController:alertController animated:YES completion:nil];

          return NO;
      }
      else if(textField.tag==5)
      {
          [self.view endEditing:YES];
          [textField resignFirstResponder];

          UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select Year:"
                                                                                   message:nil
                                                                            preferredStyle:UIAlertControllerStyleActionSheet];
          
          NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
          [formatter setDateFormat:@"yyyy"];
          NSString *yearString = [formatter stringFromDate:[NSDate date]];
          for (int j =1960 ; j<=[yearString intValue]; j++){
              UIAlertAction *action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%d",j] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                  
                  
                  
                  
                  birthyear_field.text=[NSString stringWithFormat:@"%d",j];
                  
                  
              }];
              
              [alertController addAction:action];
          }
          UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                 style:UIAlertActionStyleCancel
                                                               handler:^(UIAlertAction *action) {
                                                               }];
          [alertController addAction:cancelAction];
          [self presentViewController:alertController animated:YES completion:nil];

          return NO;
          
      }
      else if(textField.tag==6)
      {
          [scrv setContentOffset:CGPointMake(0, 300) animated:YES];
          
      }
      else if(textField.tag==7)
      {
          [scrv setContentOffset:CGPointMake(0, 330) animated:YES];
          
      }
      else if(textField.tag==8)
      {
          [scrv setContentOffset:CGPointMake(0, 350) animated:YES];
          
      }
      else if(textField.tag==9)
      {
          [scrv setContentOffset:CGPointMake(0, 320) animated:YES];
          
      }
    
    return YES;
}
- (void)LabelChange:(id)sender{
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMM dd, yyyy"];
    birthday_field.text = [df stringFromDate:datePicker.date];
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"ddMMMyyyy"];
    NSString *d=[dateFormat stringFromDate:datePicker.date];
    NSDate *dateDOB = [dateFormat dateFromString:d];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *datee = [calendar dateBySettingHour:5 minute:30 second:0 ofDate:dateDOB options:0];
    int a=[datee timeIntervalSince1970];
    timestamp=[NSString stringWithFormat:@"%d",a];
    
}
- (void)doneClicked:(id)sender
{
    NSLog(@"Done Clicked.");
    [self.view endEditing:YES];
    if([birthday_field.text isEqualToString:@""])
    {
        NSDate *currDate = [NSDate date];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MMM dd, yyyy"];
        birthday_field.text = [df stringFromDate:currDate];
        
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat: @"ddMMMyyyy"];
        NSString *d=[dateFormat stringFromDate:currDate];
        NSDate *dateDOB = [dateFormat dateFromString:d];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *datee = [calendar dateBySettingHour:5 minute:30 second:0 ofDate:dateDOB options:0];
        int a=[datee timeIntervalSince1970];
        timestamp=[NSString stringWithFormat:@"%d",a];
        
    }
    [dateview removeFromSuperview];
    
    [UIView commitAnimations];
}
#pragma mark Image picker Delegates
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        userImage.image=chosenImage;
        [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    //    [scrv setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}
@end
