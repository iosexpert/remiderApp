//
//  customMemeViewController.m
//  RemiderApp
//
//  Created by mac on 30/01/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import "customMemeViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface customMemeViewController ()
    {
          float firstX;
            float firstY;
       
        UITextView *text_View;
    }
@end

@implementation customMemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    btn1.layer.cornerRadius=20.0;
    btn2.layer.cornerRadius=20.0;
    btn3.layer.cornerRadius=20.0;

    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Image",@"Gallery", nil];
    [sheet showInView:self.view];
    [sheet setTag:2];
    
    // Do any additional setup after loading the view.
}
-(IBAction)Done_Action:(id)sender
{
    selectedImage.image= [self capture];
    
    NSData *imageData = UIImageJPEGRepresentation(selectedImage.image, 1);
    
    NSString *st=[NSString stringWithFormat:@"image_%f.jpg", [NSDate timeIntervalSinceReferenceDate]];
    NSString *imagePath = [self documentsPathForFileName:st];
        [imageData writeToFile:imagePath atomically:YES];
    NSMutableArray *arr=[[[NSUserDefaults standardUserDefaults] valueForKey:@"SavedMemeImages"]mutableCopy];
    if(arr.count==0)
        arr=[NSMutableArray new];
    [arr addObject:st];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"SavedMemeImages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"1" forKey:@"custom"];
    [userDefaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:name];
}
-(UIImage *)capture{
    
    
    UIGraphicsBeginImageContextWithOptions(selectedImage.bounds.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [selectedImage.layer renderInContext:context];
    UIImage *imgs = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgs;
    
    
    
    
}
-(IBAction)Back_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)addTextOnImage_Action:(id)sender
{
    selectedImage.userInteractionEnabled=true;
     text_View=[[UITextView alloc]initWithFrame:CGRectMake(10, 150, self.view.frame.size.width-20, 50)];
    text_View.text=@"ADD YOUR TEXT";
    text_View.userInteractionEnabled=true;
    text_View.delegate=self;
    text_View.backgroundColor=[UIColor clearColor];
    text_View.font= [UIFont fontWithName:@"OpenSans-Bold" size:13];
    text_View.textColor=[UIColor colorWithRed:25.0/255.0 green:152/255.0 blue:213/255.0 alpha:1.0];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:1];
    
    [text_View addGestureRecognizer:panGesture];

    [selectedImage addSubview:text_View];
}
-(void)handlePanGesture:(id)sender
{
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        firstX = [[sender view] center].x;
        firstY = [[sender view] center].y;
    }
    translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY+translatedPoint.y);
    [[sender view] setCenter:translatedPoint];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            
            [self.navigationController popViewControllerAnimated:YES];

            
            
        }
        
    }
    
    
    
    
}
#pragma mark Image picker Delegates
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    selectedImage.image=chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
#pragma mark - Text view deligates
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        if([textView.text isEqualToString:@""])
        {
            textView.text=@"ADD YOUR TEXT";
        }
        
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"ADD YOUR TEXT"])
    {
        textView.text=@"";
    }
    return YES;
}
@end
