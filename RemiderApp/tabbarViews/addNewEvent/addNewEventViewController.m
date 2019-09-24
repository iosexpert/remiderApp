//
//  addNewEventViewController.m
//  RemiderApp
//
//  Created by mac on 23/01/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import "addNewEventViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "Utilities.h"
#import "AsyncImageView.h"
#import "FLAnimatedImage.h"
#import "AppDelegate.h"
#import "customMemeViewController.h"
@interface addNewEventViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>
{
    UICollectionView *FeatureCollectionView;
    MBProgressHUD *HUD;
    NSMutableArray *gifArray,*memeArray,*cardArray,*favorateArr,*searchArr;
    int selectedImagePattarn,image_select,imageSelectOrNot,showGif;
    NSString *phoneNo,*selectedImageid;
    NSMutableArray *btnImageIDArray;
    UIImage *selectedFavorateImage;
    NSDictionary *imagesDictionary;
    NSMutableArray *occationArray;
    UITextView *textViewLbl;
    NSData *dataaaaaa;
    
    UIDatePicker *datePicker;
    UIView *popupscreen,*dateview;
    NSString *noti_time_hour,*noti_time_minute;
}
@property (nonatomic, strong) NSArray * contacts;

@end

@implementation addNewEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedImagePattarn=6;
    [textBtn setTitleColor:[UIColor colorWithRed:25.0/255.0 green:152/255.0 blue:213/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [gifBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [favorateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [memeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    imageSelectOrNot=5;
    
    
    image_select=2;
    
    
    
    
    
   
    occationArray=[[[NSUserDefaults standardUserDefaults]valueForKey:@"occationArray"]mutableCopy];
    if(occationArray.count==0)
        occationArray=[NSMutableArray arrayWithObjects:@"Birthday",@"Anniversary",@"Congratulations",@"Thank You",@"Just because",@"Holidays",@"Quotes" ,nil];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"0" forKey:@"custom"];
    [userDefaults synchronize];
    
    Contact * _contact;
    dataaaaaa =[[NSUserDefaults standardUserDefaults]valueForKey:@"adNewSchedule"];
    
    if(dataaaaaa==nil)
    {

        APContact *contactr = appDelegate.contactArray[0];
        
        //        NSLog(@"%@",contactr.phones[0].number);
        //        NSLog(@"%@ %@",contactr.firstName , contactr.lastName);
        //        NSLog(@"%@",contactr.emails[0]);
        //        NSLog(@"%@",contactr.addresses);
        
        userName.text=[NSString stringWithFormat:@"%@ %@",contactr.firstName,contactr.lastName];
        useremail.text=contactr.emails[0];
       // userPhone.text=contactr.phones[0].number;
        phoneNo=contactr.phones[0].number;
//    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    _contact = [self personFromContact:(CNContact*)appDelegate.contactArray[appDelegate.contactid]];
//    userName.text=_contact.displayName;
    userImage.layer.cornerRadius=userImage.frame.size.width/2;
    userImage.layer.borderWidth=1.0;
    userImage.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    userImage.image=_contact.thumb;
//    phoneNo=_contact.phones[0];
    }
    else
    {
        NSArray *arr=[NSKeyedUnarchiver unarchiveObjectWithData:dataaaaaa];
        //_contact = [self personFromContact:(CNContact*)[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        phoneNo=[arr valueForKey:@"phone"];
        userName.text=[arr valueForKey:@"name"];
        userImage.layer.cornerRadius=userImage.frame.size.width/2;
        userImage.layer.borderWidth=1.0;
        userImage.layer.borderColor=[UIColor lightGrayColor].CGColor;
        userImage.image=[UIImage imageNamed:@"default"];
        occationField.text=@"Birthday";
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        NSDate *today = _contact.birthday;
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:today];
        
        
        birthMonthFeild.text=[NSString stringWithFormat:@"%@",[arr valueForKey:@"month"]];
        birthDayField.text=[NSString stringWithFormat:@"%@",[arr valueForKey:@"day"]];
        [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"adNewSchedule"];

    }
    [self getAllImages];
    search_bar.barTintColor = [UIColor clearColor];
    search_bar.placeholder=@"Search By Name";
    search_bar.barTintColor = [UIColor clearColor];
    search_bar.backgroundImage = [UIImage new];


}
-(void)viewWillAppear:(BOOL)animated
{
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"custom"] isEqualToString:@"1"])
    {
        [self favorateAction:0];
//        UIButton *btn=[[UIButton alloc]init];
//        btn.tag=5000000+[[[NSUserDefaults standardUserDefaults] valueForKey:@"SavedMemeImages"]count]-1;
//        [self slectImage:btn];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [search_bar resignFirstResponder];
    search_bar.showsCancelButton=NO;
    if([Utilities CheckInternetConnection])
    {
        HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.label.text=@"Please Wait";
        
   
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://18.219.207.70"]];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                                path:[NSString stringWithFormat:@"/slim_api/public/category/search/%d/%@",selectedImagePattarn,search_bar.text]
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
                    
                    HUD.hidden=YES;
                    searchArr=[NSMutableArray new];
                 
                    for(int i=0;i<[[JSON valueForKey:@"result"]count];i++)
                    {
                        [searchArr addObject:[JSON valueForKey:@"result"][i]];
                    }
                    HUD.hidden=YES;
                    search_bar.text=@"";
                    selectedImagePattarn=5;
                    [self showAllDataOnScroll];

                }
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            HUD.hidden=YES;
        }];
        [operation start];
        
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    search_bar.showsCancelButton=NO;
    [search_bar resignFirstResponder];
    search_bar.text=@"";
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if(selectedImagePattarn==4)
        return NO;
    search_bar.showsCancelButton=YES;
    search_bar.returnKeyType=UIReturnKeySearch;
    
    return YES;
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

-(void)getAllImages
{
    if([Utilities CheckInternetConnection])//0: internet working
    {
        HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.label.text=@"Please Wait";
       
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://18.219.207.70"]];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                                path:[NSString stringWithFormat:@"slim_api/public/category/types/images"]
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
                    
                      HUD.hidden=YES;
                     gifArray=[NSMutableArray new];
                     memeArray=[NSMutableArray new];
                     cardArray=[NSMutableArray new];
                    favorateArr=[NSMutableArray new];
                    for(int i=0;i<[[JSON valueForKey:@"result"]count];i++)
                    {
                        
                       if([[[JSON valueForKey:@"result"][i]valueForKey:@"type_id"] isEqualToString:@"1"])
                       {
                           [memeArray addObject:[JSON valueForKey:@"result"][i]];
                       }
                       else if([[[JSON valueForKey:@"result"][i]valueForKey:@"type_id"] isEqualToString:@"2"])
                       {
                           [gifArray addObject:[JSON valueForKey:@"result"][i]];
                       }
                        else
                        {
                            [cardArray addObject:[JSON valueForKey:@"result"][i]];

                        }
                    }
                    [self showAllDataOnScroll];

                }
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            HUD.hidden=YES;
            
        }];
        [operation start];
        
    }
    
}
-(void)slectImage:(UIButton*)btn
{
    selectedImageid=[NSString stringWithFormat:@"%d",(int) btn.tag];
    
    if(selectedImagePattarn==4)
    {
        for(int i=0;i<btnImageIDArray.count;i++)
        {
            if([btnImageIDArray[(int) btn.tag-5000000] isEqualToString:btnImageIDArray[i]])
            {
                 UIButton *button = (UIButton *)[FeatureCollectionView viewWithTag:i+5000000];
                if([[button imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"imgSelect"]])
                {
                    [button setTitle:@"" forState: UIControlStateNormal];
                    [button setImage:nil forState:UIControlStateNormal];
                    button.backgroundColor=[UIColor clearColor];

                    imageSelectOrNot=0;
                }
                else
                {
                button.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
                [button setImage:[UIImage imageNamed:@"imgSelect"] forState:UIControlStateNormal];
                    imageSelectOrNot=1;
                }
            }
            else
            {
                UIButton *button = (UIButton *)[FeatureCollectionView viewWithTag:i+5000000];
                button.backgroundColor=[UIColor clearColor];
                [button setTitle:@"" forState: UIControlStateNormal];
                [button setImage:nil forState:UIControlStateNormal];
             }
           
        }
        
    }
    else
    {
    for(int i=0;i<btnImageIDArray.count;i++)
    {
        if([selectedImageid intValue]==[btnImageIDArray[i] intValue]+1000000)
       {
           UIButton *button = (UIButton *)[FeatureCollectionView viewWithTag:[btnImageIDArray[i] intValue]+1000000];
           if([[button imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"imgSelect"]])
           {
               [button setTitle:@"" forState: UIControlStateNormal];
               [button setImage:nil forState:UIControlStateNormal];
               button.backgroundColor=[UIColor clearColor];

               imageSelectOrNot=0;
           }
           else
           {
               button.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
               [button setImage:[UIImage imageNamed:@"imgSelect"] forState:UIControlStateNormal];
               imageSelectOrNot=1;
           }


       }
        else
        {
            UIButton *button = (UIButton *)[FeatureCollectionView viewWithTag:[btnImageIDArray[i] intValue]+1000000];
            button.backgroundColor=[UIColor clearColor];
            [button setTitle:@"" forState: UIControlStateNormal];
            [button setImage:nil forState:UIControlStateNormal];


        }
    }
    }
    
}
-(void)showAllDataOnScroll
{
    HUD.hidden=YES;
    for(UIView *subview in [scrv subviews]) {
        if(subview.tag!=2878)
        [subview removeFromSuperview];
    }
    int x=0;
    btnImageIDArray=[NSMutableArray new];
    search_bar.hidden=false;

    int y=search_bar.frame.size.height+search_bar.frame.origin.y+5;
    if(selectedImagePattarn==1)
    {
        y=search_bar.frame.size.height+search_bar.frame.origin.y+5;
        
        int p=0;
        double z = (double)memeArray.count/3 ;
        if(z>(int)memeArray.count/3)
            p=(int)(memeArray.count/3)+1;
        else
            p=(int)memeArray.count/3;
        
        
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        FeatureCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width,(self.view.frame.size.width/3)*p) collectionViewLayout:layout];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        FeatureCollectionView.tag=90909090;
        [FeatureCollectionView setCollectionViewLayout:layout];
        [FeatureCollectionView setDataSource:self];
        [FeatureCollectionView setDelegate:self];
        // FeatureCollectionView.pagingEnabled=true;
        FeatureCollectionView.scrollEnabled=false;
        [FeatureCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [FeatureCollectionView setBackgroundColor:[UIColor clearColor]];
        [scrv addSubview:FeatureCollectionView];
        
        
        y=y+FeatureCollectionView.frame.size.height;
        
    }
    else if(selectedImagePattarn==2)
    {
        
        y=search_bar.frame.size.height+search_bar.frame.origin.y+5;

        int p=0;
        double z = (double)gifArray.count/3 ;
        if(z>(int)gifArray.count/3)
            p=(int)(gifArray.count/3)+1;
        else
            p=(int)gifArray.count/3;
        
        
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        FeatureCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width,(self.view.frame.size.width/3)*p) collectionViewLayout:layout];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        FeatureCollectionView.tag=90909090;
        [FeatureCollectionView setCollectionViewLayout:layout];
        [FeatureCollectionView setDataSource:self];
        [FeatureCollectionView setDelegate:self];
       // FeatureCollectionView.pagingEnabled=true;
        FeatureCollectionView.scrollEnabled=false;
        [FeatureCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [FeatureCollectionView setBackgroundColor:[UIColor clearColor]];
        [scrv addSubview:FeatureCollectionView];
        
        
        y=y+FeatureCollectionView.frame.size.height;
      
    }
    else if(selectedImagePattarn==5)
    {
        y=search_bar.frame.size.height+search_bar.frame.origin.y+5;
        int p=0;
        double z = (double)searchArr.count/3 ;
        if(z>(int)searchArr.count/3)
            p=(int)(searchArr.count/3)+1;
        else
            p=(int)searchArr.count/3;
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        FeatureCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width,(self.view.frame.size.width/3)*p) collectionViewLayout:layout];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        FeatureCollectionView.tag=90909090;
        [FeatureCollectionView setCollectionViewLayout:layout];
        [FeatureCollectionView setDataSource:self];
        [FeatureCollectionView setDelegate:self];
        FeatureCollectionView.scrollEnabled=false;
        [FeatureCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [FeatureCollectionView setBackgroundColor:[UIColor clearColor]];
        [scrv addSubview:FeatureCollectionView];
        
        
        y=y+FeatureCollectionView.frame.size.height;


        
    }
    else if(selectedImagePattarn==4)
    {
       
        y=search_bar.frame.size.height+search_bar.frame.origin.y+5;
        favorateArr=[[[NSUserDefaults standardUserDefaults] valueForKey:@"SavedMemeImages"]mutableCopy];
        NSArray* reversedArray = [[favorateArr reverseObjectEnumerator] allObjects];
        favorateArr =[NSMutableArray arrayWithArray:reversedArray];
        int p=0;
         double z = (double)favorateArr.count/3 ;
        if(z>(int)favorateArr.count/3)
            p=(int)(favorateArr.count/3)+1;
        else
            p=(int)favorateArr.count/3;
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        FeatureCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width,(self.view.frame.size.width/3)*p) collectionViewLayout:layout];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        FeatureCollectionView.tag=90909090;
        [FeatureCollectionView setCollectionViewLayout:layout];
        [FeatureCollectionView setDataSource:self];
        [FeatureCollectionView setDelegate:self];
        FeatureCollectionView.scrollEnabled=false;
        [FeatureCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [FeatureCollectionView setBackgroundColor:[UIColor clearColor]];
        [scrv addSubview:FeatureCollectionView];
        
        
        y=y+FeatureCollectionView.frame.size.height;

    }
    else if(selectedImagePattarn==3)
    {
        y=search_bar.frame.size.height+search_bar.frame.origin.y+5;
        int p=0;
        double z = (double)cardArray.count/3 ;
        if(z>(int)cardArray.count/3)
            p=(int)(cardArray.count/3)+1;
        else
            p=(int)cardArray.count/3;
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        FeatureCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width,(self.view.frame.size.width/3)*p) collectionViewLayout:layout];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        FeatureCollectionView.tag=90909090;
        [FeatureCollectionView setCollectionViewLayout:layout];
        [FeatureCollectionView setDataSource:self];
        [FeatureCollectionView setDelegate:self];
        FeatureCollectionView.scrollEnabled=false;
        [FeatureCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [FeatureCollectionView setBackgroundColor:[UIColor clearColor]];
        [scrv addSubview:FeatureCollectionView];
        
        
        y=y+FeatureCollectionView.frame.size.height;
        
        }
    else
    {
        y=search_bar.frame.size.height+search_bar.frame.origin.y-30;
        search_bar.hidden=YES;
        textViewLbl=[[UITextView alloc]initWithFrame:CGRectMake(5, y, self.view.frame.size.width-10,100)];
        textViewLbl.layer.borderColor=[UIColor lightGrayColor].CGColor;
        textViewLbl.font=[UIFont fontWithName:@"OpenSans-Bold" size:14];
        textViewLbl.delegate=self;
        textViewLbl.text=@"Enter Text";
        [scrv addSubview:textViewLbl];
        y=y+60;
        imageSelectOrNot=5;

    }
    UIButton *addEvent = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addEvent addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [addEvent setTitle:@" √ CREATE EVENT" forState:UIControlStateNormal];
    if(selectedImagePattarn==2 && selectedImagePattarn==4 && selectedImagePattarn==3  && selectedImagePattarn==5)
    {
      addEvent.frame = CGRectMake(self.view.frame.size.width/2-85, y-100, 170, 30);
    }
    else if(selectedImagePattarn==1)
    {
            UIButton *customSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            customSelectBtn.backgroundColor=[UIColor clearColor];
            [customSelectBtn setTitle:@"Select Custom Meme" forState:UIControlStateNormal];
            customSelectBtn.titleLabel.font=[UIFont fontWithName:@"OpenSans-Bold" size:13];
            [customSelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [customSelectBtn addTarget:self action:@selector(customMEME:) forControlEvents:UIControlEventTouchUpInside];
            customSelectBtn.tag=1000000;
            customSelectBtn.frame = CGRectMake(self.view.frame.size.width/2-85, y+20, 170, 30);
            [scrv addSubview:customSelectBtn];
        
        addEvent.frame = CGRectMake(self.view.frame.size.width/2-85, y+90, 170, 30);

        
    }
    else if(x==0)
    {
        addEvent.frame = CGRectMake(self.view.frame.size.width/2-85, y+self.view.frame.size.width/3-30, 170, 30);

    }
    else
        addEvent.frame = CGRectMake(self.view.frame.size.width/2-85, y+self.view.frame.size.width/3+10, 170, 30);

    //addEvent.frame = CGRectMake(self.view.frame.size.width/2-85, y+self.view.frame.size.width/3+30, 170, 30);
    addEvent.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:13];
    [addEvent setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:152/255.0 blue:213/255.0 alpha:1.0]];
    addEvent.layer.cornerRadius=15;
    [addEvent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scrv addSubview:addEvent];
    
    
    
    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, addEvent.frame.origin.y-20, self.view.frame.size.width, 2)];
    v.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    [scrv addSubview:v];
    
    scrv.contentSize=CGSizeMake(0, addEvent.frame.origin.y+50);

    
    
//    if(selectedImagePattarn==2 && selectedImagePattarn==4  && selectedImagePattarn==3 && selectedImagePattarn==5)
//        scrv.contentSize=CGSizeMake(0, y+self.view.frame.size.width/3-60);
//    else if(x==0)
//        scrv.contentSize=CGSizeMake(0, y+self.view.frame.size.width/3+self.view.frame.size.width/3-60);
//    else
//        scrv.contentSize=CGSizeMake(0, y+self.view.frame.size.width/3+self.view.frame.size.width/3+self.view.frame.size.width/7-60);
    
}
- (NSString *)documentsPathForFileName:(NSString *)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}
-(void)loadMoreGif:(UIButton*)btn
{
    showGif=showGif+3;
    [self showAllDataOnScroll];
}
-(void)customMEME:(UIButton*)btn
{
    customMemeViewController *smvc;
    int height = [UIScreen mainScreen].bounds.size.height;
    if (height == 480) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"customMemeViewController"];
        
    }
    else if (height == 568) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"customMemeViewController"];
        
    }
    else if (height == 667) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"customMemeViewController"];
        
    }
    else if (height == 736) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"customMemeViewController"];
        
    }
    else if (height == 1024) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"ipad" bundle:nil] instantiateViewControllerWithIdentifier:@"customMemeViewController"];
        
    }
    else
    {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"ipad2" bundle:nil] instantiateViewControllerWithIdentifier:@"customMemeViewController"];
        
    }
    
    [self.navigationController pushViewController:smvc animated:YES];
}
-(IBAction)doneAction:(id)sender
{
    
    if(imageSelectOrNot==0 )
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please select event type"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    else if(imageSelectOrNot==5 && ([textViewLbl.text isEqualToString:@""] || [textViewLbl.text isEqualToString:@"Enter Text"]))
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please enter text"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    else if ( [occationField.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please select occasion for event"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    else if ( [birthTimeFeild.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please select time"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    //

    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.label.text=@"Please Wait";
    NSString *postPath=@"/slim_api/public/event/add";
    NSString *phno = [phoneNo stringByReplacingOccurrencesOfString:@" " withString:@""];
    phno = [phno stringByReplacingOccurrencesOfString:@"\\U00a" withString:@""];
    phno = [phno stringByReplacingOccurrencesOfString:@"\u00a0" withString:@""];
    phno = [[phno componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    
    NSLog(@"%@",phno);
    
    NSData *imageData1 = UIImageJPEGRepresentation(userImage.image, 0.1);

    NSData *imageData;
    NSString *textSend=@"";
    if(selectedImagePattarn==4)
    {
        image_select=1;
        UIImage *img;
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"custom"] isEqualToString:@"1"])
        {
            img =[UIImage imageWithData:[NSData dataWithContentsOfFile:[self documentsPathForFileName:favorateArr.lastObject]]];
        }
        else
        {
         img =[UIImage imageWithData:[NSData dataWithContentsOfFile:[self documentsPathForFileName:favorateArr[[selectedImageid intValue]-5000000]]]];
        }
        
        NSData *imgData = UIImageJPEGRepresentation(img, 0.1);

       // NSString *imagePath = [self documentsPathForFileName:favorateArr[[selectedImageid intValue]-5000000]];
        imageData=imgData;//[NSData dataWithContentsOfFile:imagePath];
        selectedImageid=@"0";
        selectedImagePattarn =4;
        
    }
    else if(selectedImagePattarn==6)
    {
        image_select=2;
        textSend=textViewLbl.text;
        selectedImageid=@"0";
    }
    else
    {
        selectedImageid=[NSString stringWithFormat:@"%d",[selectedImageid intValue]-1000000 ];
       image_select=0;
        imageData=nil;
    }
    
   

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *params=@{
                           @"uid"    : [userDefaults valueForKey:@"userid"],
                           @"phone_number" : phno,
                           @"name" : userName.text,
                           @"type" : occationField.text,
                           @"day" : birthDayField.text,
                           @"month" : birthMonthFeild.text,
                           @"image_type" : [NSString stringWithFormat:@"%d",selectedImagePattarn],
                           @"image_select" : [NSString stringWithFormat:@"%d",image_select],
                           @"image_id" : selectedImageid,
                           @"text"     :  textSend,
                           @"noti_time_hour"     : noti_time_hour,
                           @"noti_time_minute"   : noti_time_minute
                           };
    NSURL *url = [NSURL URLWithString:@"http://18.219.207.70"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:postPath parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        if(image_select!=0 && image_select!=2)
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
        
        [formData appendPartWithFileData:imageData1 name:@"contact_image" fileName:@"contact_image.jpg" mimeType:@"image/jpeg"];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *JSONData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",jsonObject);
        HUD.hidden=YES;
        if([[jsonObject valueForKey:@"code"]intValue]==1)
        {
            
            if(dataaaaaa!=nil)
            {
                NSArray *arrrrr=[NSKeyedUnarchiver unarchiveObjectWithData:dataaaaaa];
               
                NSMutableArray *arr = [[[NSUserDefaults standardUserDefaults]valueForKey:@"deletedUpcomming"]mutableCopy];
                if(arr == nil)
                {
                    arr=[NSMutableArray new];
                }
                [arr addObject:[arrrrr valueForKey:@"phone"]];
                [[NSUserDefaults standardUserDefaults]setValue:arr forKey:@"deletedUpcomming"];
                
                NSData *data1 =[[NSUserDefaults standardUserDefaults]valueForKey:@"upcommingArrayy"];
                NSMutableArray *upcommingArray = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
                NSLog(@"%lu",(unsigned long)[upcommingArray indexOfObject:arrrrr]);
                [upcommingArray removeObjectAtIndex:[upcommingArray indexOfObject:arrrrr]];
                NSData *dataa = [NSKeyedArchiver archivedDataWithRootObject:upcommingArray];
                [[NSUserDefaults standardUserDefaults]setValue:dataa forKey:@"upcommingArrayy"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Event Scheduled"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            [self.navigationController popToRootViewControllerAnimated :YES];
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
    

    [operation start];
}
-(IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)memeAction:(id)sender
{
    selectedImagePattarn=1;
    [memeBtn setTitleColor:[UIColor colorWithRed:25.0/255.0 green:152/255.0 blue:213/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [gifBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [favorateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [textBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self showAllDataOnScroll];

}

-(IBAction)cardAction:(id)sender
{
    selectedImagePattarn=3;
    [cardBtn setTitleColor:[UIColor colorWithRed:25.0/255.0 green:152/255.0 blue:213/255.0 alpha:1.0] forState:UIControlStateNormal];
    [gifBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [memeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [favorateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [textBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self showAllDataOnScroll];

}
-(IBAction)gifAction:(id)sender
{
    selectedImagePattarn=2;
    [gifBtn setTitleColor:[UIColor colorWithRed:25.0/255.0 green:152/255.0 blue:213/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [memeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [favorateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [textBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self showAllDataOnScroll];

}
-(IBAction)favorateAction:(id)sender
{
    selectedImagePattarn=4;
    [favorateBtn setTitleColor:[UIColor colorWithRed:25.0/255.0 green:152/255.0 blue:213/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [gifBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [memeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [textBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self showAllDataOnScroll];
    

    
}
-(IBAction)textAction:(id)sender
{
    selectedImagePattarn=6;
    [textBtn setTitleColor:[UIColor colorWithRed:25.0/255.0 green:152/255.0 blue:213/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [gifBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [favorateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [memeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    imageSelectOrNot=5;
    [self showAllDataOnScroll];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag==1)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select option:"
                                                                                 message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        for (int i=0;i<occationArray.count;i++)
        {
            UIAlertAction *action = [UIAlertAction actionWithTitle:occationArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
             
                occationField.text=occationArray[i];
                
            }];
            [alertController addAction:action];
        }
        UIAlertAction *Custom = [UIAlertAction actionWithTitle:@"Custom"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
                                                                 
                                                                 UIAlertView* alert1 = [[UIAlertView alloc] init];
                                                                 [alert1 setDelegate:self];
                                                                 [alert1 setTitle:@"Write custom occasion"];
                                                                 [alert1 setMessage:@" "];
                                                                 [alert1 addButtonWithTitle:@"Add"];
                                                                 [alert1 addButtonWithTitle:@"Cancel"];
                                                                 alert1.tag=1;
                                                                 alert1.alertViewStyle = UIAlertViewStylePlainTextInput;
                                                                 [alert1 show];
                                                             }];
        [alertController addAction:Custom];
        
       
//            [alertController addAction:action];
//
//            [alertController addAction:action1];
//        [alertController addAction:action2];
//        [alertController addAction:action3];
//        [alertController addAction:action4];
//        [alertController addAction:action5];
//        [alertController addAction:action6];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                             }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return NO;
    }
    else if(textField.tag==2)
    {
        [self.view endEditing:YES];
        [textField resignFirstResponder];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select Date:"
                                                                                 message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        for (int j =1 ; j<=31; j++){
            UIAlertAction *action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%d",j] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                birthDayField.text=[NSString stringWithFormat:@"%d",j];
                
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
    else if(textField.tag==3)
    {
        [self.view endEditing:YES];
        [textField resignFirstResponder];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select Month:"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        for (int j =1 ; j<=12; j++){
            UIAlertAction *action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%d",j] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                birthMonthFeild.text=[NSString stringWithFormat:@"%d",j];
                
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
    
    dateview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    dateview.backgroundColor=[UIColor grayColor];
    dateview.alpha=1.0;
    
    UIView *tape=[[UIView alloc]initWithFrame:CGRectMake(0, 200, 320, 50)];
    tape.backgroundColor=[UIColor blackColor];
    UIButton *button31 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button31 addTarget:self action:@selector(doneClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button31 setTitle:@"Done" forState:UIControlStateNormal];
    button31.frame = CGRectMake(30, 10, 90, 30);
    button31.titleLabel.font = [UIFont systemFontOfSize:16];
    button31.backgroundColor=[UIColor clearColor];
    [button31 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tape addSubview:button31];
    
    
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 250, 320, 300)];
    datePicker.datePickerMode = UIDatePickerModeTime;
    datePicker.hidden = NO;
    datePicker.date = [NSDate date];
    
    [datePicker addTarget:self action:@selector(LabelChange:) forControlEvents:UIControlEventValueChanged];
    [dateview addSubview:datePicker];
    [dateview addSubview:tape];
    [self.view addSubview:dateview];
    return NO;
}
    return YES;
}
- (void)doneClicked:(id)sender
{
    NSLog(@"Done Clicked.");
    [self.view endEditing:YES];
    [dateview removeFromSuperview];
    
}
- (void)LabelChange:(id)sender{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm"]; //24hr time format
    NSString *dateString = [outputFormatter stringFromDate:datePicker.date];
    
    birthTimeFeild.text = dateString;
    
     [outputFormatter setDateFormat:@"HH"];
    noti_time_hour=[outputFormatter stringFromDate:datePicker.date];
     [outputFormatter setDateFormat:@"mm"];
    noti_time_minute=[outputFormatter stringFromDate:datePicker.date];

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   if(selectedImagePattarn==2)
        return gifArray.count;
    else if(selectedImagePattarn==4)
        return favorateArr.count;
    else if(selectedImagePattarn==1)
        return memeArray.count;
    else if(selectedImagePattarn==5)
        return searchArr.count;
    else
    return cardArray.count;
   
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag==1)
        
    {
        if(buttonIndex==0)
            
        {
            if([[alertView textFieldAtIndex:0].text isEqual:@""])
            {
                occationField.text=@"";
            }
            else
            {
                [occationArray addObject:[alertView textFieldAtIndex:0].text];
                occationField.text = [alertView textFieldAtIndex:0].text;
                [[NSUserDefaults standardUserDefaults] setObject:occationArray forKey:@"occationArray"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
        }
        
    }
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    
    for(UIView *view in cell.subviews)
    {
        for(UIView *subView in view.subviews)
        {
            
            [subView removeFromSuperview];
        }
        [view removeFromSuperview];
    }
    if(selectedImagePattarn==1)
    {
        
            AsyncImageView *ascImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(5,0, self.view.frame.size.width/3-10, self.view.frame.size.width/3-5)];
            ascImage.imageURL=[NSURL URLWithString:[[memeArray objectAtIndex:indexPath.row]valueForKey:@"filepath"]];
            [cell addSubview:ascImage];
            
            UIButton *slectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            slectBtn.backgroundColor=[UIColor clearColor];
            [slectBtn addTarget:self action:@selector(slectImage:) forControlEvents:UIControlEventTouchUpInside];
        slectBtn.tag=[[[memeArray objectAtIndex:indexPath.row]valueForKey:@"id"]intValue]+1000000;
            
            slectBtn.frame = CGRectMake(5,0, self.view.frame.size.width/3-10, self.view.frame.size.width/3-5);
            [cell addSubview:slectBtn];

            [btnImageIDArray addObject:[[memeArray objectAtIndex:indexPath.row]valueForKey:@"id"]];
        
    }
    else if(selectedImagePattarn==5)
    {
        
            if([[[searchArr objectAtIndex:indexPath.row]valueForKey:@"extension"]isEqualToString:@".gif"])
            {
                
                cell.tag = indexPath.row;
                
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue, ^(void) {
                    
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[searchArr objectAtIndex:indexPath.row]valueForKey:@"filepath"]]];
                    
                    if (imageData) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (cell.tag == indexPath.row) {
                                FLAnimatedImage *ascImage = [FLAnimatedImage animatedImageWithGIFData:imageData];
                                FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
                                imageView.animatedImage = ascImage;
                                imageView.frame = CGRectMake(5,0, self.view.frame.size.width/3-10, self.view.frame.size.width/3-5);
                                [cell addSubview:imageView];
                                [cell setNeedsLayout];
                            }
                        });
                    }
                });
                
            }
            else
            {
                AsyncImageView *ascImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(5,0, self.view.frame.size.width/3-10, self.view.frame.size.width/3-5)];
                ascImage.imageURL=[NSURL URLWithString:[[searchArr objectAtIndex:indexPath.row]valueForKey:@"filepath"]];
                [cell addSubview:ascImage];
            }
            
            UIButton *slectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            slectBtn.backgroundColor=[UIColor clearColor];
            [slectBtn addTarget:self action:@selector(slectImage:) forControlEvents:UIControlEventTouchUpInside];
            ;
            slectBtn.tag=[[[searchArr objectAtIndex:indexPath.row]valueForKey:@"id"]intValue]+1000000;
            slectBtn.frame = CGRectMake(5,0, self.view.frame.size.width/3-10, self.view.frame.size.width/3-5);
            [cell addSubview:slectBtn];
            
            [btnImageIDArray addObject:[[searchArr objectAtIndex:indexPath.row]valueForKey:@"id"]];
            
            
        
    }
    else if(selectedImagePattarn==4)
    {
        
            NSArray *array = [favorateArr[indexPath.row] componentsSeparatedByString:@"."];
            
            if([array.lastObject isEqualToString:@"gif"])
            {
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue, ^(void) {
                    
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:favorateArr[indexPath.row]]];
                    
                    if (imageData) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (cell.tag == indexPath.row) {
                                FLAnimatedImage *ascImage = [FLAnimatedImage animatedImageWithGIFData:imageData];
                                FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
                                imageView.animatedImage = ascImage;
                                imageView.frame = CGRectMake(5,0, self.view.frame.size.width/3-10, self.view.frame.size.width/3-5);
                                [cell addSubview:imageView];
                                [cell setNeedsLayout];
                            }
                        });
                    }
                });
                
            }
            else
            {
                
                AsyncImageView *ascImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(5,0, self.view.frame.size.width/3-10, self.view.frame.size.width/3-5)];
                NSString *imagePath = [self documentsPathForFileName:favorateArr[indexPath.row]];
                
                ascImage.imageURL=[[NSURL alloc] initFileURLWithPath:imagePath];//=img;
                [cell addSubview:ascImage];
            }
            
            UIButton *slectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            slectBtn.backgroundColor=[UIColor clearColor];
            [slectBtn addTarget:self action:@selector(slectImage:) forControlEvents:UIControlEventTouchUpInside];
            ;
            [btnImageIDArray addObject:favorateArr[indexPath.row]];
            slectBtn.tag=indexPath.row+5000000;
            slectBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/3, self.view.frame.size.width/3);
            [cell addSubview:slectBtn];
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"custom"] isEqualToString:@"1"] && indexPath.row==favorateArr.count-1)
        {
            slectBtn.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
            [slectBtn setImage:[UIImage imageNamed:@"imgSelect"] forState:UIControlStateNormal];
            imageSelectOrNot=1;
        }
    }
    else if(selectedImagePattarn==2)
    {
    cell.tag = indexPath.row;
  
  
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^(void) {
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[gifArray objectAtIndex:indexPath.row]valueForKey:@"filepath"]]];
                                 
                                 if (imageData) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         if (cell.tag == indexPath.row) {
                                             FLAnimatedImage *ascImage = [FLAnimatedImage animatedImageWithGIFData:imageData];
                                             FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
                                             imageView.animatedImage = ascImage;
                                             imageView.frame = CGRectMake(5,0, self.view.frame.size.width/3-10, self.view.frame.size.width/3-5);
                                             [cell addSubview:imageView];
                                             [cell setNeedsLayout];
                                             
                                             UIButton *slectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                                             slectBtn.backgroundColor=[UIColor clearColor];
                                             [slectBtn addTarget:self action:@selector(slectImage:) forControlEvents:UIControlEventTouchUpInside];
                                             slectBtn.tag=[[[gifArray objectAtIndex:indexPath.row]valueForKey:@"id"]intValue]+1000000;
                                             slectBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/3, self.view.frame.size.width/3);
                                             [cell addSubview:slectBtn];
                                             [btnImageIDArray addObject:[[gifArray objectAtIndex:indexPath.row]valueForKey:@"id"]];
                                         }
                                     });
                                 }
                                 });

        
    
    
    }
    else
    {
            if([[[cardArray objectAtIndex:indexPath.row]valueForKey:@"extension"]isEqualToString:@".gif"])
            {
                
                cell.tag = indexPath.row;
                
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue, ^(void) {
                    
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[cardArray objectAtIndex:indexPath.row]valueForKey:@"filepath"]]];
                    
                    if (imageData) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (cell.tag == indexPath.row) {
                                FLAnimatedImage *ascImage = [FLAnimatedImage animatedImageWithGIFData:imageData];
                                FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
                                imageView.animatedImage = ascImage;
                                imageView.frame = CGRectMake(5,0, self.view.frame.size.width/3-10, self.view.frame.size.width/3-5);
                                [cell addSubview:imageView];
                                [cell setNeedsLayout];
                            }
                        });
                    }
                });

            }
            else
            {
                AsyncImageView *ascImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(5,0, self.view.frame.size.width/3-10, self.view.frame.size.width/3-5)];
                ascImage.imageURL=[NSURL URLWithString:[[cardArray objectAtIndex:indexPath.row]valueForKey:@"filepath"]];
                [cell addSubview:ascImage];
            }
            
            UIButton *slectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            slectBtn.backgroundColor=[UIColor clearColor];
            [slectBtn addTarget:self action:@selector(slectImage:) forControlEvents:UIControlEventTouchUpInside];
            ;
            slectBtn.tag=[[[cardArray objectAtIndex:indexPath.row]valueForKey:@"id"]intValue]+1000000;
            slectBtn.frame = CGRectMake(5,0, self.view.frame.size.width/3-10, self.view.frame.size.width/3-5);
            [cell addSubview:slectBtn];
            
            [btnImageIDArray addObject:[[cardArray objectAtIndex:indexPath.row]valueForKey:@"id"]];
            
        
            
    }
    

    
        

    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  
        return CGSizeMake(self.view.frame.size.width/3,self.view.frame.size.width/3);
    
}

#pragma mark - Text view deligates
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        if([textView.text isEqualToString:@""])
        {
            textView.text=@"Enter Text";
            
        }
        [scrv setContentOffset:CGPointMake(0, 0) animated:YES];

        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [scrv setContentOffset:CGPointMake(0, 150) animated:YES];
    if([textView.text isEqualToString:@"Enter Text"])
    {
        textView.text=@"";
    }
    return YES;
}


@end
