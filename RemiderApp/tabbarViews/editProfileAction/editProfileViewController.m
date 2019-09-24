//
//  editProfileViewController.m
//  RemiderApp
//
//  Created by mac on 03/02/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import "editProfileViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "Utilities.h"
@interface editProfileViewController ()
{
    MBProgressHUD *HUD;

}
@end

@implementation editProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userImage.layer.cornerRadius=45;
    userImage.layer.borderColor=[UIColor whiteColor].CGColor;
    userImage.layer.borderWidth=1.0;
    
    scrv.contentSize=CGSizeMake(0, self.view.frame.size.height);
    phoneNo_field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone number" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    birthday_field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"DD" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    name_field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    lastname_field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    if([Utilities CheckInternetConnection])//0: internet working
    {
        HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.label.text=@"Please Wait";
        
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://18.219.207.70"]];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                                path:[NSString stringWithFormat:@"/slim_api/public/users/show/%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"]]
                                                          parameters:nil];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            if (JSONdata != nil) {
                
                NSError *e;
                NSMutableDictionary *JSON =
                [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                                options: NSJSONReadingMutableContainers
                                                  error: &e];
                HUD.hidden=YES;
                
                if([[JSON valueForKey:@"code"]integerValue] ==1)
                {
                    name_field.text=[[JSON valueForKey:@"result"][0] valueForKey:@"name"];
                    lastname_field.text=[[JSON valueForKey:@"result"][0] valueForKey:@"last_name"];
                    phoneNo_field.text=[[JSON valueForKey:@"result"][0] valueForKey:@"phone_number"];
                    NSString *st=[[JSON valueForKey:@"result"][0]valueForKey:@"profile_image"];
                    userImage.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",st]];

                    NSArray *arr=[[[JSON valueForKey:@"result"][0] valueForKey:@"dob"] componentsSeparatedByString:@"-"];
                    if(arr.count==3)
                    {
                    birthday_field.text=arr[2];
                    birthmonth_field.text=arr[1];
                    birthyear_field.text=arr[0];
                    }

                    HUD.hidden=YES;
                    
                    
                }
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            HUD.hidden=YES;
            
        }];
        [operation start];
        
    }
    
    
    submitButton.layer.cornerRadius=20.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(IBAction)Back_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)submit_Action:(id)sender
{

        HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.label.text=@"Please Wait";
        NSString *postPath=@"/slim_api/public/users/editProfile";
        NSDictionary *params=@{
                               @"name"    : name_field.text,
                               @"last_name" : lastname_field.text,
                               @"phone_number" : phoneNo_field.text,
                               @"dob" : [NSString stringWithFormat:@"%@-%@-%@",birthyear_field.text,birthmonth_field.text,birthday_field.text],
                               @"id" : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"]
                               };
        NSData *imageData =  UIImageJPEGRepresentation(userImage.image, 0.1); // name of the image
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
-(void)registerUserComplete
{
    HUD.hidden=YES;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Profile Updated"
                                                        message:@""
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];

    
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
    
     [scrv setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
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
@end
