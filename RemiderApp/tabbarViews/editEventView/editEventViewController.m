//
//  editEventViewController.m
//  RemiderApp
//
//  Created by mac on 07/02/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import "editEventViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "Utilities.h"
#import "AsyncImageView.h"
#import "FLAnimatedImage.h"
#import "AppDelegate.h"
#import "customMemeViewController.h"
@interface editEventViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>
{
    UIButton *changeImage,*updateEvent;;
    UICollectionView *FeatureCollectionView;
    MBProgressHUD *HUD;
    NSMutableArray *gifArray,*memeArray,*cardArray,*favorateArr,*searchArr;
    int selectedImagePattarn,image_select,imageSelectOrNot,showGif;
    NSString *phoneNo,*selectedImageid;
    NSMutableArray *btnImageIDArray;
    UIImage *selectedFavorateImage;
    NSDictionary *imagesDictionary,*eventDict;
    NSMutableArray *occationArray;
    int imagechangeornot;
    UITextView *textViewLbl;
    NSString *noti_time_hour,*noti_time_minute;

    UIDatePicker *datePicker;
    UIView *popupscreen,*dateview;
}

@end





@implementation editEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imagechangeornot=0;
    
    occationArray=[[[NSUserDefaults standardUserDefaults]valueForKey:@"occationArray"]mutableCopy];
    if(occationArray.count==0)
        occationArray=[NSMutableArray arrayWithObjects:@"Birthday",@"Anniversary",@"Congratulations",@"Thank You",@"Just because",@"Holidays",@"Quotes" ,nil];
    
    
    
    search_bar.barTintColor = [UIColor clearColor];
    search_bar.placeholder=@"Search By Name";
    search_bar.barTintColor = [UIColor clearColor];
    search_bar.backgroundImage = [UIImage new];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"0" forKey:@"custom"];
    [userDefaults synchronize];
    eventDict=[[[NSUserDefaults standardUserDefaults]valueForKey:@"editEventId"]mutableCopy];
    
    userImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[eventDict valueForKey:@"contact_image"]]]];
    occationField.text=[eventDict valueForKey:@"type"];
    birthDayField.text=[NSString stringWithFormat:@"%@",[eventDict valueForKey:@"day"]];
   birthMonthFeild.text=[NSString stringWithFormat:@"%@",[eventDict valueForKey:@"month"]];
    birthTimeFeild.text=[NSString stringWithFormat:@"%@:%@",[eventDict valueForKey:@"noti_time_hour"],[eventDict valueForKey:@"noti_time_minute"]];
    
    //userImage
    userName.text=[eventDict valueForKey:@"name"];
    selectedImageid=[NSString stringWithFormat:@"%@",[eventDict valueForKey:@"image_id"]];
    
    
//        if([[eventDict valueForKey:@"image_type"]intValue]==1)
//           [self memeAction:0];
//        if([[eventDict valueForKey:@"image_type"]intValue]==2)
//            [self gifAction:0];
//        if([[eventDict valueForKey:@"image_type"]intValue]==3)
//            [self cardAction:0];
  
    if([[eventDict valueForKey:@"image_select"]intValue]==1)
    {
        selectedImagePattarn=4;
        [self getAllImages];
//    changeImage = [UIButton buttonWithType:UIButtonTypeCustom];
//    changeImage.backgroundColor=[UIColor clearColor];
//    [changeImage setTitle:@"Change Image" forState:UIControlStateNormal];
//    changeImage.titleLabel.font=[UIFont fontWithName:@"OpenSans-Bold" size:13];
//    [changeImage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [changeImage addTarget:self action:@selector(changeImage) forControlEvents:UIControlEventTouchUpInside];
//    changeImage.tag=1000000;
//    changeImage.frame = CGRectMake(self.view.frame.size.width/2-85, memeBtn.frame.origin.y+30, 170, 30);
//    [scrv addSubview:changeImage];
//
//        memeBtn.hidden=true;
//        gifBtn.hidden=true;
//        cardBtn.hidden=true;
//        favorateBtn.hidden=true;
//        search_bar.hidden=true;

    }
    else if([[eventDict valueForKey:@"image_select"]intValue]==2)
    {
        selectedImagePattarn=[[eventDict valueForKey:@"image_type"]intValue];
       [self getAllImages];
    }
    else
    {
        selectedImagePattarn=[[eventDict valueForKey:@"image_type"]intValue];
        selectedImageid=[NSString stringWithFormat:@"%d",[[eventDict valueForKey:@"image_id"]intValue]+1000000 ];

        [self getAllImages];
    }
    updateEvent = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [updateEvent addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [updateEvent setTitle:@" √ UPDATE EVENT" forState:UIControlStateNormal];
        updateEvent.frame = CGRectMake(self.view.frame.size.width/2-85, memeBtn.frame.origin.y+130, 170, 30);
    updateEvent.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:13];
    [updateEvent setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:152/255.0 blue:213/255.0 alpha:1.0]];
    updateEvent.layer.cornerRadius=15;
    [updateEvent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scrv addSubview:updateEvent];
    
    
    
    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, updateEvent.frame.origin.y-30, self.view.frame.size.width, 2)];
    v.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    [scrv addSubview:v];
    
  
}

-(void)changeImage
{
    memeBtn.hidden=false;
    gifBtn.hidden=false;
    cardBtn.hidden=false;
    favorateBtn.hidden=false;
    search_bar.hidden=false;
    
    [updateEvent removeFromSuperview];
    [changeImage removeFromSuperview];
    imagechangeornot=1;
    [self getAllImages];
}
-(void)viewWillAppear:(BOOL)animated
{
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"custom"] isEqualToString:@"1"])
    {
        [self favorateAction:0];
        UIButton *btn=[[UIButton alloc]init];
        btn.tag=5000000+[[[NSUserDefaults standardUserDefaults] valueForKey:@"SavedMemeImages"]count]-1;
        [self slectImage:btn];
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

                    if([[eventDict valueForKey:@"image_select"]intValue]==0)
                    {
                        selectedImagePattarn=[[eventDict valueForKey:@"image_type"]intValue];

                        if([[eventDict valueForKey:@"image_type"]intValue]==1)
                        {
                            [self memeAction:0];

                            for(int i=0;i<memeArray.count;i++)
                            {
                                [btnImageIDArray addObject:[[memeArray objectAtIndex:i]valueForKey:@"id"]];
                            }
                        }
                        else if([[eventDict valueForKey:@"image_type"]intValue]==2)
                        {
                            [self gifAction:0];

                            for(int i=0;i<gifArray.count;i++)
                            {
                                [btnImageIDArray addObject:[[gifArray objectAtIndex:i]valueForKey:@"id"]];
                            }
                        }
                        else if([[eventDict valueForKey:@"image_type"]intValue]==3)
                        {
                            [self cardAction:0];

                            for(int i=0;i<cardArray.count;i++)
                            {
                                [btnImageIDArray addObject:[[cardArray objectAtIndex:i]valueForKey:@"id"]];
                            }
                        }
                       
                        //[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(VideoTimeIncrease)userInfo:nil repeats:NO];

                        
                    }
                    else if([[eventDict valueForKey:@"image_select"]intValue]==1)
                    {
                        [self favorateAction:0];
                    }
                    else
                    {
                        if([[eventDict valueForKey:@"image_type"]intValue]==6)
                        {
                            [self textAction:0];
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
-(void)VideoTimeIncrease
{
    UIButton *btn=[[UIButton alloc]init];
    btn.tag=1000000+[[eventDict valueForKey:@"image_id"]intValue];
    [self slectImage:btn];
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
                UIButton *button = (UIButton *)[scrv viewWithTag:i+5000000];
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
                UIButton *button = (UIButton *)[scrv viewWithTag:i+5000000];
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
                UIButton *button = (UIButton *)[scrv viewWithTag:[btnImageIDArray[i] intValue]+1000000];
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
        if([[eventDict valueForKey:@"image_type"]intValue]==6)
            textViewLbl.text=[eventDict valueForKey:@"text"];
        else
            textViewLbl.text=@"Enter Text";
        [scrv addSubview:textViewLbl];
        y=y+60;
        imageSelectOrNot=5;
    }
    UIButton *addEvent = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addEvent addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [addEvent setTitle:@" √ UPDATE EVENT" forState:UIControlStateNormal];
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
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.label.text=@"Please Wait";
    NSString *postPath=@"/slim_api/public/event/edit";
     NSData *imageData;
     NSData *imgData1 = UIImageJPEGRepresentation(userImage.image, 0.1);

    
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
    
    
    
    NSDictionary *params=@{
                           @"id"                 : [eventDict valueForKey:@"id"],
                           @"phone_number"       : [eventDict valueForKey:@"phone_number"],
                           @"name"               : userName.text,
                           @"type"               : occationField.text,
                           @"day"                : birthDayField.text,
                           @"month"              : birthMonthFeild.text,
                           @"image_type"         : [NSString stringWithFormat:@"%d",selectedImagePattarn],
                           @"image_select"       : [NSString stringWithFormat:@"%d",image_select],
                           @"image_id"           : selectedImageid,
                           @"text"               : textSend,
                           @"noti_time_hour"     : noti_time_hour,
                           @"noti_time_minute"   : noti_time_minute
                           };
    
   
   
    

    NSURL *url = [NSURL URLWithString:@"http://18.219.207.70"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:postPath parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        if(image_select)
            [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
        
         [formData appendPartWithFileData:imgData1 name:@"contact_image" fileName:@"contact_image.jpg" mimeType:@"image/jpeg"];
        
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *JSONData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",jsonObject);
        HUD.hidden=YES;
        if([[jsonObject valueForKey:@"code"]intValue]==1)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Event Scheduled"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            [self.navigationController popViewControllerAnimated:YES];
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
        
    if([selectedImageid intValue]==[[[memeArray objectAtIndex:indexPath.row]valueForKey:@"id"]intValue]+1000000)
           {
    slectBtn.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
    [slectBtn setImage:[UIImage imageNamed:@"imgSelect"] forState:UIControlStateNormal];
    imageSelectOrNot=1;
           }
        
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
                            
                            UIButton *slectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                            slectBtn.backgroundColor=[UIColor clearColor];
                            [slectBtn addTarget:self action:@selector(slectImage:) forControlEvents:UIControlEventTouchUpInside];
                            ;
                            slectBtn.tag=[[[searchArr objectAtIndex:indexPath.row]valueForKey:@"id"]intValue]+1000000;
                            slectBtn.frame = CGRectMake(5,0, self.view.frame.size.width/3-10, self.view.frame.size.width/3-5);
                            [cell addSubview:slectBtn];
                            
                            [btnImageIDArray addObject:[[searchArr objectAtIndex:indexPath.row]valueForKey:@"id"]];
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
            
            UIButton *slectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            slectBtn.backgroundColor=[UIColor clearColor];
            [slectBtn addTarget:self action:@selector(slectImage:) forControlEvents:UIControlEventTouchUpInside];
            ;
            slectBtn.tag=[[[searchArr objectAtIndex:indexPath.row]valueForKey:@"id"]intValue]+1000000;
            slectBtn.frame = CGRectMake(5,0, self.view.frame.size.width/3-10, self.view.frame.size.width/3-5);
            [cell addSubview:slectBtn];
            
            [btnImageIDArray addObject:[[searchArr objectAtIndex:indexPath.row]valueForKey:@"id"]];
        }
        
        
        
        
        
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
                            
                            UIButton *slectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                            slectBtn.backgroundColor=[UIColor clearColor];
                            [slectBtn addTarget:self action:@selector(slectImage:) forControlEvents:UIControlEventTouchUpInside];
                            ;
                            [btnImageIDArray addObject:favorateArr[indexPath.row]];
                            slectBtn.tag=indexPath.row+5000000;
                            slectBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/3, self.view.frame.size.width/3);
                            [cell addSubview:slectBtn];
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
            
            UIButton *slectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            slectBtn.backgroundColor=[UIColor clearColor];
            [slectBtn addTarget:self action:@selector(slectImage:) forControlEvents:UIControlEventTouchUpInside];
            ;
            [btnImageIDArray addObject:favorateArr[indexPath.row]];
            slectBtn.tag=indexPath.row+5000000;
            slectBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/3, self.view.frame.size.width/3);
            [cell addSubview:slectBtn];
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
                        if([selectedImageid intValue]==[[[gifArray objectAtIndex:indexPath.row]valueForKey:@"id"]intValue]+1000000)
                        {
                            slectBtn.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
                            [slectBtn setImage:[UIImage imageNamed:@"imgSelect"] forState:UIControlStateNormal];
                            imageSelectOrNot=1;
                        }
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
                            
                            UIButton *slectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                            slectBtn.backgroundColor=[UIColor clearColor];
                            [slectBtn addTarget:self action:@selector(slectImage:) forControlEvents:UIControlEventTouchUpInside];
                            ;
                            slectBtn.tag=[[[cardArray objectAtIndex:indexPath.row]valueForKey:@"id"]intValue]+1000000;
                            slectBtn.frame = CGRectMake(5,0, self.view.frame.size.width/3-10, self.view.frame.size.width/3-5);
                            if([selectedImageid intValue]==[[[cardArray objectAtIndex:indexPath.row]valueForKey:@"id"]intValue]+1000000)
                            {
                                slectBtn.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
                                [slectBtn setImage:[UIImage imageNamed:@"imgSelect"] forState:UIControlStateNormal];
                                imageSelectOrNot=1;
                            }
                            [cell addSubview:slectBtn];
                            
                            [btnImageIDArray addObject:[[cardArray objectAtIndex:indexPath.row]valueForKey:@"id"]];
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
            
            UIButton *slectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            slectBtn.backgroundColor=[UIColor clearColor];
            [slectBtn addTarget:self action:@selector(slectImage:) forControlEvents:UIControlEventTouchUpInside];
            ;
            slectBtn.tag=[[[cardArray objectAtIndex:indexPath.row]valueForKey:@"id"]intValue]+1000000;
            slectBtn.frame = CGRectMake(5,0, self.view.frame.size.width/3-10, self.view.frame.size.width/3-5);
            if([selectedImageid intValue]==[[[cardArray objectAtIndex:indexPath.row]valueForKey:@"id"]intValue]+1000000)
            {
                slectBtn.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
                [slectBtn setImage:[UIImage imageNamed:@"imgSelect"] forState:UIControlStateNormal];
                imageSelectOrNot=1;
            }
            [cell addSubview:slectBtn];
            
            [btnImageIDArray addObject:[[cardArray objectAtIndex:indexPath.row]valueForKey:@"id"]];
        }
        
      
        
        
        
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
