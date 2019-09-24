//
//  contactDetailViewController.m
//  RemiderApp
//
//  Created by mac on 22/01/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import "contactDetailViewController.h"
#import "AppDelegate.h"
#import "addNewEventViewController.h"
#import "Utilities.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "editEventViewController.h"

#import "APContact+Sorting.h"

@interface contactDetailViewController ()
{
    MBProgressHUD *HUD;

    NSMutableArray  *eventArray;
}
@property (nonatomic, strong) NSArray * contacts;

@end

@implementation contactDetailViewController
- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:name];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *addNewEvent = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addNewEvent addTarget:self action:@selector(addNewEvent:) forControlEvents:UIControlEventTouchUpInside];
    [addNewEvent setTitle:@" + ADD NEW EVENT" forState:UIControlStateNormal];
    addNewEvent.frame = CGRectMake(self.view.frame.size.width-130, tablev.frame.origin.y+5, 120, 26);
    addNewEvent.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:11];
    [addNewEvent setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:152/255.0 blue:213/255.0 alpha:1.0]];
    addNewEvent.layer.cornerRadius=13;
    
    [addNewEvent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scrv addSubview:addNewEvent];
    
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    
    APContact *contactr = appDelegate.contactArray[0];

//        NSLog(@"%@",contactr.phones[0].number);
//        NSLog(@"%@ %@",contactr.firstName , contactr.lastName);
//        NSLog(@"%@",contactr.emails[0]);
//        NSLog(@"%@",contactr.addresses);
    
    userName.text=[NSString stringWithFormat:@"%@ %@",contactr.firstName,contactr.lastName];
    useremail.text=contactr.emails[0];
    userPhone.text=contactr.phones[0].number;
    
   // Contact * _contact = [self personFromContact:(CNContact*)appDelegate.contactArray[appDelegate.contactid]];
//    userName.text=_contact.displayName;
    userImage.layer.cornerRadius=userImage.frame.size.width/2;
    userImage.layer.borderWidth=1.0;
    userImage.layer.borderColor=[UIColor lightGrayColor].CGColor;
   // userImage.image=_contact.thumb;
    userImage.clipsToBounds=YES;

//    userLocation.text=_contact.country;
//    useremail.text=_contact.emails[0];
//    userPhone.text=_contact.phones[0];
    
//    UIImage *img;
//    NSDictionary  *imgDict=[[[NSUserDefaults standardUserDefaults] valueForKey:@"SavedUserImages"]mutableCopy];
//    if([imgDict valueForKey:@"_contact.phones[0]"])
//    {
//        img =[UIImage imageWithData:[NSData dataWithContentsOfFile:[self documentsPathForFileName:[imgDict valueForKey:_contact.phones[0]]]]];
//    }
//    else
//    img=[UIImage imageNamed:@"default"];
//
//    userImage.image=img;

    
    UIButton *crossButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    crossButton.frame = CGRectMake(self.view.frame.size.width-50, userImage.frame.origin.y+10, 29, 29);
    [crossButton setTitle:@"" forState:UIControlStateNormal];
    crossButton.backgroundColor = [UIColor clearColor];
    [crossButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [crossButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [crossButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    [scrv addSubview:crossButton];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    editButton.frame = CGRectMake(self.view.frame.size.width-50, userImage.frame.origin.y+50, 29, 29);
    [editButton setTitle:@"" forState:UIControlStateNormal];
    editButton.backgroundColor = [UIColor clearColor];
    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [editButton setBackgroundImage:[UIImage imageNamed:@"edit35"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editImage:) forControlEvents:UIControlEventTouchUpInside];
    [scrv addSubview:editButton];
    
    
    
    
    NSMutableDictionary *dict =  [[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetail"]mutableCopy];
    userDetail.text= [dict valueForKey:userPhone.text];
    
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [saveButton addTarget:self action:@selector(saveUserDetail:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
    saveButton.frame = CGRectMake(self.view.frame.size.width-90, userDetail.frame.origin.y+5, 80, 26);
    saveButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:11];
    [saveButton setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:152/255.0 blue:213/255.0 alpha:1.0]];
    saveButton.layer.cornerRadius=13;
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scrv addSubview:saveButton];
    
    
    // Do any additional setup after loading the view.
}
-(void)deleteImage:(UIButton *)btn
{
    userImage.image=[UIImage imageNamed:@"default"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Do you really want to Delete Image?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *logOut = [UIAlertAction actionWithTitle:@"Delete Image" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                             {
                                 NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"default"], 0.1);
                                 NSString *st=[NSString stringWithFormat:@"image_%f.jpg", [NSDate timeIntervalSinceReferenceDate]];
                                 NSString *imagePath = [self documentsPathForFileName:st];
                                 [imageData writeToFile:imagePath atomically:YES];
                                 
                                 
                                 NSMutableDictionary *imgDict=[[[NSUserDefaults standardUserDefaults] valueForKey:@"SavedUserImages"]mutableCopy];
                                 if(imgDict.count==0)
                                     imgDict=[NSMutableDictionary new];
                                 [imgDict setObject:st forKey:[NSString stringWithFormat:@"%@",userPhone.text]];
                                 [[NSUserDefaults standardUserDefaults] setObject:imgDict forKey:@"SavedUserImages"];
                                 [[NSUserDefaults standardUserDefaults] synchronize];
                                 
                             }];
    [alert addAction:cancel];
    [alert addAction:logOut];
    [self presentViewController:alert animated:YES completion:nil];
 
}
-(void)editImage:(UIButton *)btn
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
        
        
    }
}
#pragma mark Image picker Delegates
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    userImage.image=chosenImage;
    userImage.clipsToBounds=YES;
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.1);
    NSString *st=[NSString stringWithFormat:@"image_%f.jpg", [NSDate timeIntervalSinceReferenceDate]];
    NSString *imagePath = [self documentsPathForFileName:st];
    [imageData writeToFile:imagePath atomically:YES];
    
    
    NSMutableDictionary *imgDict=[[[NSUserDefaults standardUserDefaults] valueForKey:@"SavedUserImages"]mutableCopy];
    if(imgDict.count==0)
        imgDict=[NSMutableDictionary new];
    [imgDict setObject:st forKey:[NSString stringWithFormat:@"%@",userPhone.text]];
    [[NSUserDefaults standardUserDefaults] setObject:imgDict forKey:@"SavedUserImages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
-(void)saveUserDetail:(UIButton *)btn
{
    NSMutableDictionary *dict =  [[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetail"]mutableCopy];
    if(dict == nil)
        dict=[NSMutableDictionary new];
    [dict setValue:userDetail.text forKey:userPhone.text];
    [[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"userdetail"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [userDetail resignFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self getEventByContact];
}
-(IBAction)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getEventByContact
{
   // http://18.219.207.70/php/scheduleingApp/slim_api/public/event/show_events/12345
    
    if([Utilities CheckInternetConnection])//0: internet working
    {
//        HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        HUD.labelText=@"Please Wait";
        
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://18.219.207.70"]];
        
        NSString *phno = [userPhone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        phno = [phno stringByReplacingOccurrencesOfString:@"\\U00a" withString:@""];
        phno = [phno stringByReplacingOccurrencesOfString:@"\u00a0" withString:@""];
        phno = [[phno componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];

        NSLog(@"%@",phno);
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                                path:[NSString stringWithFormat:@"/slim_api/public/event/show_events/%@",phno]
                                                          parameters:nil];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            // Print the response body in text
            //NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            
            
            
            NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            if (JSONdata != nil) {
                
                NSError *e;
                NSMutableDictionary *JSON =
                [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                                options: NSJSONReadingMutableContainers
                                                  error: &e];
                //HUD.hidden=YES;
                
                if([[JSON valueForKey:@"code"]integerValue] ==1)
                {
                    eventArray=[NSMutableArray new];
                    eventArray=[JSON valueForKey:@"result"];
                    tablev.frame=CGRectMake(0,tablev.frame.origin.y,tablev.frame.size.width,[eventArray count]*110+200);
                    if([eventArray count]==0)
                        tablev.frame=CGRectMake(0,tablev.frame.origin.y,tablev.frame.size.width,130+50);
                    [tablev reloadData];
                    scrv.contentSize=CGSizeMake(0, tablev.frame.origin.y+tablev.contentSize.height + 155);
                    tablev.scrollEnabled=false;
                }
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
           // HUD.hidden=YES;
            
        }];
        [operation start];
        
    }
}
-(void)addNewEvent:(UIButton*)btn
{
    addNewEventViewController *smvc;
    int height = [UIScreen mainScreen].bounds.size.height;
    if (height == 480) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"addNewEventViewController"];
        
    }
    else if (height == 568) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"addNewEventViewController"];
        
    }
    else if (height == 667) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"addNewEventViewController"];
        
    }
    else if (height == 736) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
        
    }
    else if (height == 1024) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"ipad" bundle:nil] instantiateViewControllerWithIdentifier:@"addNewEventViewController"];
        
    }
    else
    {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"ipad2" bundle:nil] instantiateViewControllerWithIdentifier:@"addNewEventViewController"];
        
    }
    
    [self.navigationController pushViewController:smvc animated:YES];
}
- (UIImage*)contactImage:(UIImage*)original
{
    if ( original == nil )
        original = [UIImage imageNamed:@"default"];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(60, 60), NO, [UIScreen mainScreen].scale);
    
    UIBezierPath* clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(0, 0, 60, 60), 0.5,0.5)];
    [clipPath addClip];
    
    [original drawInRect:CGRectMake(0, 0, 60, 60)];
    
    UIImage * renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return renderedImage;
}
- (Contact*)personFromContact:(CNContact*)contact
{
    Contact * _contact = [Contact new];
   
    _contact.photo = [self contactImage:[UIImage imageWithData:contact.imageData]];
    _contact.thumb = [self contactImage:[UIImage imageWithData:contact.thumbnailImageData]];
    _contact.firstname = contact.givenName;
    _contact.lastname = contact.familyName;
    _contact.nickname = contact.nickname;
    _contact.company = contact.organizationName;
    _contact.birthday = contact.birthday != nil ? [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] dateFromComponents:contact.birthday] : [NSDate date];
    
    if ( contact.phoneNumbers.count )
    {
        NSMutableArray * _tempPhones = [NSMutableArray new];
        for ( CNLabeledValue * _contactPhone in contact.phoneNumbers ) {
            CNPhoneNumber * _phoneNumber = _contactPhone.value;
            [_tempPhones addObject:_phoneNumber.stringValue];
        }
        _contact.phones = _tempPhones;
    }
    
    if ( contact.emailAddresses.count )
    {
        NSMutableArray * _tempEmails = [NSMutableArray new];
        for ( CNLabeledValue * _contactEmail in contact.emailAddresses )
            [_tempEmails addObject:_contactEmail.value];
        _contact.emails = _tempEmails;
    }
    
    if ( contact.postalAddresses.count )
    {
        CNLabeledValue * _contactAddress = contact.postalAddresses[0];
        CNPostalAddress * _address = _contactAddress.value;
        _contact.street1 = _address.street;
        _contact.city = _address.city;
        _contact.state = _address.state;
        _contact.zip = _address.postalCode;
        _contact.country = _address.country;
    }
    
    if ( contact.urlAddresses.count )
    {
        NSMutableArray * _tempUrls = [NSMutableArray new];
        for ( CNLabeledValue * _contactUrl in contact.urlAddresses )
            [_tempUrls addObject:_contactUrl.value];
        _contact.urls = _tempUrls;
    }
    
    return _contact;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,40)];
    [view setBackgroundColor:[UIColor whiteColor]]; //your background color...
    
    
    UIFont * myFont =[UIFont fontWithName:@"OpenSans-Bold" size:15];

    CGRect labelFrame = CGRectMake (10, 5, self.view.frame.size.width-20, 30);
    UILabel *label0 = [[UILabel alloc] initWithFrame:labelFrame];
    [label0 setFont:myFont];
    label0.lineBreakMode=NSLineBreakByWordWrapping;
    label0.numberOfLines=10;
    label0.textColor=[UIColor colorWithRed:25.0/255.0 green:152/255.0 blue:213/255.0 alpha:1.0];
    label0.textAlignment=NSTextAlignmentLeft;
    label0.backgroundColor=[UIColor clearColor];
    [label0 setText:@"EVENTS"];
    [view addSubview:label0];
    
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
        return 40;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(eventArray.count==0)
    {
        return 1;
    }
    else
    return eventArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
    
     if(eventArray.count==0)
     {
         UIFont * myFont =[UIFont fontWithName:@"OpenSans-Bold" size:15];
         CGRect labelFrame1 = CGRectMake (0, 20, self.view.frame.size.width, 25);
         UILabel *label1 = [[UILabel alloc] initWithFrame:labelFrame1];
         [label1 setFont:myFont];
         label1.lineBreakMode=NSLineBreakByWordWrapping;
         label1.numberOfLines=15;
         label1.textColor=[UIColor lightGrayColor];
         label1.textAlignment=NSTextAlignmentCenter;
         label1.backgroundColor=[UIColor clearColor];
         [label1 setText:@"No Schedules yet"];
         [cell addSubview:label1];
     }
    else
    {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 109, tableView.frame.size.width,1.7)];
    [view setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:241/255.0 blue:241/255.0 alpha:1.0]];
    [cell addSubview:view];
    
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 70, 70)];
    img.layer.cornerRadius=10;
    img.layer.borderColor=[UIColor colorWithRed:231.0/255.0 green:231/255.0 blue:231/255.0 alpha:1.0].CGColor;
    img.layer.borderWidth=2;
    [cell addSubview:img];
    
    UIImageView *img1=[[UIImageView alloc]initWithFrame:CGRectMake(20+35-7.5, 6, 15, 15)];
    img1.image=[UIImage imageNamed:@"gift"];
    img1.backgroundColor=[UIColor whiteColor];
    [cell addSubview:img1];
        
        UIFont * myFont =[UIFont fontWithName:@"OpenSans-Bold" size:25];
        CGRect labelFrame1 = CGRectMake (0, 8, 70, 30);
        UILabel *label1 = [[UILabel alloc] initWithFrame:labelFrame1];
        [label1 setFont:myFont];
        label1.lineBreakMode=NSLineBreakByWordWrapping;
        label1.numberOfLines=15;
        label1.textColor=[UIColor blackColor];
        label1.textAlignment=NSTextAlignmentCenter;
        label1.backgroundColor=[UIColor clearColor];
        [label1 setText:[[eventArray objectAtIndex:indexPath.row]valueForKey:@"day"]];
        [img addSubview:label1];
        
        
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM"];
        NSDate* myDate = [dateFormatter dateFromString:[[eventArray objectAtIndex:indexPath.row]valueForKey:@"month"]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMMM"];
        NSString *stringFromDate = [formatter stringFromDate:myDate];
        
        UILabel *monthLbl = [[UILabel alloc] initWithFrame:CGRectMake (0, 35, 70, 18)];
        [monthLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:11]];
        monthLbl.lineBreakMode=NSLineBreakByWordWrapping;
        monthLbl.numberOfLines=15;
        monthLbl.textColor=[UIColor blackColor];
        monthLbl.textAlignment=NSTextAlignmentCenter;
        monthLbl.backgroundColor=[UIColor clearColor];
        [monthLbl setText:[stringFromDate uppercaseString]];
        [img addSubview:monthLbl];
        
        
        NSAttributedString *attributedText =
        [[NSAttributedString alloc] initWithString:[[eventArray objectAtIndex:indexPath.row]valueForKey:@"name"]
                                        attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans-Bold" size:12]}];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){250, CGFLOAT_MAX}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake (110, 15, size.width+10, 20)];
        [nameLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:12]];
        nameLbl.lineBreakMode=NSLineBreakByWordWrapping;
        nameLbl.layer.borderWidth=1.5;
        nameLbl.layer.borderColor=[UIColor colorWithRed:231.0/255.0 green:231/255.0 blue:231/255.0 alpha:1.0].CGColor;
        nameLbl.layer.cornerRadius=10;
        nameLbl.textColor=[UIColor blackColor];
        nameLbl.textAlignment=NSTextAlignmentCenter;
        nameLbl.backgroundColor=[UIColor clearColor];
        [nameLbl setText:[[eventArray objectAtIndex:indexPath.row]valueForKey:@"name"]];
        [cell addSubview:nameLbl];
        
        
        UILabel *birthdayLbl = [[UILabel alloc] initWithFrame:CGRectMake (110, 40, 180, 45)];
        [birthdayLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:13]];
        birthdayLbl.textColor=[UIColor blackColor];
        birthdayLbl.textAlignment=NSTextAlignmentLeft;
        birthdayLbl.backgroundColor=[UIColor clearColor];
        birthdayLbl.lineBreakMode=NSLineBreakByWordWrapping;
        birthdayLbl.numberOfLines=2;
        [birthdayLbl setText:[NSString stringWithFormat:@"%@'S %@",[[[eventArray objectAtIndex:indexPath.row]valueForKey:@"name"]uppercaseString],[[[eventArray objectAtIndex:indexPath.row]valueForKey:@"type"]uppercaseString]] ];
        [cell addSubview:birthdayLbl];
        
        UIButton *crossButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        crossButton.frame = CGRectMake(self.view.frame.size.width-40, 9, 35, 35);
        [crossButton setTitle:@"" forState:UIControlStateNormal];
        crossButton.backgroundColor = [UIColor clearColor];
        [crossButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
        crossButton.tag=indexPath.row+1;
        [crossButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [crossButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:crossButton];
        
        UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        editButton.frame = CGRectMake(self.view.frame.size.width-40, 52, 35, 35);
        [editButton setTitle:@"" forState:UIControlStateNormal];
        editButton.backgroundColor = [UIColor clearColor];
        [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
        editButton.tag=indexPath.row;
        [editButton setBackgroundImage:[UIImage imageNamed:@"edit35"] forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:editButton];
        
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;

    
}
-(void)deleteAction:(UIButton*)btn
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Do you really want to Delete?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *logOut = [UIAlertAction actionWithTitle:@"Delete Post" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                             {
                                 HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                 HUD.label.text=@"Please Wait";
                                 AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://18.219.207.70"]];
                                 [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
                                 [httpClient setParameterEncoding:AFFormURLParameterEncoding];
                                 
                                 NSDictionary *params=@{
                                                        @"id"    : [[eventArray objectAtIndex:(int)btn.tag-1]valueForKey:@"id"],
                                                        @"method" :@"delete"
                                                        };
                                 
                                 NSMutableURLRequest *request = [httpClient requestWithMethod:@"Delete"
                                                                                         path:@"/slim_api/public/event/delete"
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
                                         HUD.hidden=YES;
                                         [eventArray removeObjectAtIndex:(int)btn.tag-1];
                                         [tablev reloadData];
                                         [self removeResult:JSON];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSHTTPURLResponse *httpResponse = [operation response];
                                     NSLog(@"Network-Response: HTTP-Status Code: %ld, Error: %@", (long)[httpResponse statusCode],
                                           error);
                                     [self removeResult:nil];        }];
                                 [httpClient enqueueHTTPRequestOperation:operation];
                                 
                             }];
    [alert addAction:cancel];
    [alert addAction:logOut];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
    
    
    
}
-(void)removeResult:(NSDictionary*)dict_Response
{

    HUD.hidden=YES;

    if (dict_Response==NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WarmerMarket" message:@"Some Issue Occur, Please Try Again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];        alert.tag=10;
        
        [alert show];
    }
    else
    {
        
        
        if([[dict_Response valueForKey:@"code"] integerValue]==1){
            
        }
    }
}
-(void)editAction:(UIButton*)btn
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[eventArray objectAtIndex:btn.tag] forKey:@"editEventId"];
    [userDefaults synchronize];
    editEventViewController *smvc;
    int height = [UIScreen mainScreen].bounds.size.height;
    if (height == 480) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"editEventViewController"];
        
    }
    else if (height == 568) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"editEventViewController"];
        
    }
    else if (height == 667) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"editEventViewController"];
        
    }
    else if (height == 736) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"editEventViewController"];
        
    }
    else if (height == 1024) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"ipad" bundle:nil] instantiateViewControllerWithIdentifier:@"editEventViewController"];
        
    }
    else
    {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"ipad2" bundle:nil] instantiateViewControllerWithIdentifier:@"editEventViewController"];
        
    }
    
    [self.navigationController pushViewController:smvc animated:YES];

}
#pragma mark - Text view deligates
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        if([textView.text isEqualToString:@""])
        {
            textView.text=@"User Information";
        }

        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [scrv setContentOffset:CGPointMake(0, 150) animated:YES];
if([textView.text isEqualToString:@"User Information"])
{
    textView.text=@"";
}
    return YES;
}
@end
