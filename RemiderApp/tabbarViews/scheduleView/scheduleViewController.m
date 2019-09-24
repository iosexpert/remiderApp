//
//  scheduleViewController.m
//  RemiderApp
//
//  Created by mac on 19/01/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import "scheduleViewController.h"
#import "filtersViewController.h"
#import "addNewEventViewController.h"
#import "Utilities.h"
#import "AFNetworking.h"
#import "selectContactViewController.h"
#import "editEventViewController.h"
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
@interface scheduleViewController ()<MFMessageComposeViewControllerDelegate>


{
    NSMutableArray  *eventArray,*upcommingArray,*finalUpcommingArray,*finalUpcommingArray1;
 MBProgressHUD *HUD;
    CNContactStore * _contactStore;
    CNContactViewController *addContactVC;
    int counter,buttonSelected;
}
@property (nonatomic, strong) NSArray * contacts;
@property (assign) BOOL contactsError;

@end

@implementation scheduleViewController
-(void)notificationApiCall
{
    [self.tabBarController setSelectedIndex:0];
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.label.text=@"Please Wait";
    
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSMutableArray *st = appDelegate.notiNewsId;
    
    
    if([[st valueForKey:@"type"]intValue]==3)
    {
        [self schedules_Action:0];
        HUD.hidden=true;
        [self.tabBarController setSelectedIndex:0];

    }
    else if([[st valueForKey:@"type"]intValue]==2)
    {
        [self upcomming_Action:0];
        HUD.hidden=true;
        [self.tabBarController setSelectedIndex:0];

    }
    else if([[st valueForKey:@"type"]intValue]==1)
    {
       if([[st valueForKey:@"text"] isEqualToString:@""])
       {
           dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
           dispatch_async(queue, ^(void) {
               
               NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[st valueForKey:@"image"]]];
               
               if (imageData) {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       NSArray *arr=[[NSArray alloc]initWithObjects:[st valueForKey:@"phonenumber"], nil];
                       MFMessageComposeViewController* messageComposer = [MFMessageComposeViewController new];
                       messageComposer.messageComposeDelegate = self;
                       [messageComposer setBody:@""];
                       [messageComposer setRecipients:arr];
                       NSData *attachment = UIImageJPEGRepresentation([UIImage imageWithData:imageData],.5);
                       [messageComposer addAttachmentData:attachment typeIdentifier:@"image/jpeg" filename:@"shotnote.jpg"];
                       HUD.hidden=true;
                       [self presentViewController:messageComposer animated:YES completion:nil];
                   });
               }
           });
       }
        else
        {
            NSArray *arr=[[NSArray alloc]initWithObjects:[st valueForKey:@"phonenumber"], nil];
            MFMessageComposeViewController* messageComposer = [MFMessageComposeViewController new];
            messageComposer.messageComposeDelegate = self;
            [messageComposer setBody:[st valueForKey:@"text"]];
            [messageComposer setRecipients:arr];
            HUD.hidden=true;
            [self presentViewController:messageComposer animated:YES completion:nil];
        }
    }
    else
    {
        HUD.hidden=true;

    }
    
    

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    int height = [UIScreen mainScreen].bounds.size.height;
//    int width = [UIScreen mainScreen].bounds.size.width;
//
//    NSString *message = [[NSString alloc]initWithFormat:@"This screen is \n\n%i pixels high and\n%i pixels wide", height, width];
//    NSLog(@"%@", message);
    
    
   // [self updateUpcommingArr];

    NSData *data1 =[[NSUserDefaults standardUserDefaults]valueForKey:@"upcommingArrayy"];
    upcommingArray = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    counter=0;buttonSelected=1;
    UIButton *addNewShedule = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addNewShedule addTarget:self action:@selector(addNewEvent:) forControlEvents:UIControlEventTouchUpInside];
    [addNewShedule setTitle:@" + ADD NEW SCHEDULE" forState:UIControlStateNormal];
    addNewShedule.frame = CGRectMake(self.view.frame.size.width-180, self.view.frame.size.height-90, 170, 30);
    addNewShedule.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:13];
    [addNewShedule setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:152/255.0 blue:213/255.0 alpha:1.0]];
    addNewShedule.layer.cornerRadius=15;
    [addNewShedule setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:addNewShedule];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationApiCall) name:@"notification" object:nil];

    
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if(appDelegate.notification)
    {
        [self notificationApiCall];
    }
    else
    {
        [self.tabBarController setSelectedIndex:1];
    }

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUpcommingArr) name:@"upcomming" object:nil];

    

    

    
    scheduleButton.layer.borderColor=[UIColor colorWithRed:25.0/255.0 green:152/255.0 blue:213/255.0 alpha:1.0].CGColor;
    scheduleButton.layer.borderWidth=1.0;
    upcommingButton.layer.borderColor=[UIColor colorWithRed:25.0/255.0 green:152/255.0 blue:213/255.0 alpha:1.0].CGColor;
    upcommingButton.layer.borderWidth=1.0;

    
    self.navigationController.navigationBarHidden=true;
    // Do any additional setup after loading the view.
}
-(void)updateUpcommingArr
{
    NSData *data =[[NSUserDefaults standardUserDefaults]valueForKey:@"allContacts"];
    _contacts = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    
    upcommingArray=[NSMutableArray new];
    
    for(int i=0;i<_contacts.count;i++)
    {
        Contact * _contact = [self personFromContact:(CNContact*)_contacts[i]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        NSDate *today = _contact.birthday;
        NSString *dateString = [dateFormatter stringFromDate:today];

        if(![dateString  isEqualToString:[dateFormatter stringFromDate:[NSDate date]]])
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            NSDate *today = _contact.birthday;
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:today];
            
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setValue:_contact.phones[0] forKey:@"phone"];
            [dict setValue:_contact.displayName forKey:@"name"];
            [dict setValue:[NSString stringWithFormat:@"%d",(int)components.day] forKey:@"day"];
            [dict setValue:[NSString stringWithFormat:@"%d",(int)components.month] forKey:@"month"];

            NSData *data1 =[[NSUserDefaults standardUserDefaults]valueForKey:@"upcommingArrayy"];
            upcommingArray = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
           if(upcommingArray == nil)
           {
               upcommingArray=[NSMutableArray new];
           }
            NSMutableArray *arr = [[[NSUserDefaults standardUserDefaults]valueForKey:@"deletedUpcomming"]mutableCopy];
            NSMutableArray *arr1=[upcommingArray valueForKey:@"phone"];
            if(![arr containsObject:_contact.phones[0]] && ![arr1 containsObject:_contact.phones[0]])
            {
                [upcommingArray addObject:dict];
            }

            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:upcommingArray];
            [[NSUserDefaults standardUserDefaults]setValue:data forKey:@"upcommingArrayy"];
            [[NSUserDefaults standardUserDefaults] synchronize];

    }
    }
        
    
   
    
    for(int i=0;i<upcommingArray.count;i++)
    {
        for(int j=1;j<=upcommingArray.count-1;j++)
        {
            NSMutableDictionary *dict = [upcommingArray[j] mutableCopy];
            NSMutableDictionary *dict1 = [upcommingArray[j-1] mutableCopy];
            
            if([[dict valueForKey:@"day"]intValue]<[[dict1 valueForKey:@"day"]intValue] && [[dict valueForKey:@"month"]intValue]<=[[dict1 valueForKey:@"month"]intValue])
            {
                NSMutableDictionary *temp= [dict1 mutableCopy];
                [upcommingArray replaceObjectAtIndex:j-1 withObject:dict];
                [upcommingArray replaceObjectAtIndex:j withObject:temp];
            }
        }
        
        
    }
    for(int i=0;i<upcommingArray.count;i++)
    {
        for(int j=1;j<=upcommingArray.count-1;j++)
        {
            NSMutableDictionary *dict = [upcommingArray[j] mutableCopy];
            NSMutableDictionary *dict1 = [upcommingArray[j-1] mutableCopy];
            
            if([[dict valueForKey:@"month"]intValue]<[[dict1 valueForKey:@"month"]intValue])
            {
                NSMutableDictionary *temp= [dict1 mutableCopy];
                [upcommingArray replaceObjectAtIndex:j-1 withObject:dict];
                [upcommingArray replaceObjectAtIndex:j withObject:temp];
            }
        }
        
        
    }
    NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:upcommingArray];
    [[NSUserDefaults standardUserDefaults]setValue:data1 forKey:@"upcommingArrayy"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *namestr,*phonestr,*daystr,*monthstr,*typrstr;

    for(int i=0;i<upcommingArray.count;i++)
    {
        NSDictionary *dict=upcommingArray[i];

        
        if(i==0)
        {
        namestr=[NSString stringWithFormat:@"%@",[dict valueForKey:@"name"]];
        phonestr=[NSString stringWithFormat:@"%@",[dict valueForKey:@"phone"]];
        daystr=[NSString stringWithFormat:@"%@",[dict valueForKey:@"day"]];
        monthstr=[NSString stringWithFormat:@"%@",[dict valueForKey:@"month"]];
        typrstr=[NSString stringWithFormat:@"%@",@"BIRTHDAY"];
        }
        else
        {
            namestr=[NSString stringWithFormat:@"%@%@%@",namestr,@"@",[dict valueForKey:@"name"]];
            phonestr=[NSString stringWithFormat:@"%@%@%@",phonestr,@"@",[dict valueForKey:@"phone"]];
            daystr=[NSString stringWithFormat:@"%@%@%@",daystr,@"@",[dict valueForKey:@"day"]];
            monthstr=[NSString stringWithFormat:@"%@%@%@",monthstr,@"@",[dict valueForKey:@"month"]];
            typrstr=[NSString stringWithFormat:@"%@%@%@",typrstr,@"@",@"BIRTHDAY"];
        }
        
        
        
       if(i==upcommingArray.count-1)
       {
           NSDictionary *params=@{
                                  @"uid"            : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                                  @"name"           : namestr,
                                  @"phone_number"   : phonestr,
                                  @"day"            : daystr,
                                  @"month"          : monthstr,
                                  @"type"           : typrstr
                                  };
           AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://18.219.207.70"]];
           [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
           [httpClient setParameterEncoding:AFFormURLParameterEncoding];
           NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                                   path:@"/slim_api/public/contacts/add"
                                                             parameters:params];
           AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
           [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
               
          
              
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               NSHTTPURLResponse *httpResponse = [operation response];
               NSLog(@"Network-Response: HTTP-Status Code: %ld, Error: %@", (long)[httpResponse statusCode],
                     error);
                      }];
           [httpClient enqueueHTTPRequestOperation:operation];
       }
        
            }

    [tablev reloadData];
    HUD.hidden=true;

}
-(void)viewWillAppear:(BOOL)animated
{
    finalUpcommingArray1=[NSMutableArray new];
    [self callAllTheSchdules];
    //[self getUpcommingArray];
    [self schedules_Action:0];

    [tablev reloadData];

    counter=0;
}

- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact{
    [viewController dismissViewControllerAnimated:YES completion:NULL];
}

-(void)callAllTheSchdules
{
    
    
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

        if([Utilities CheckInternetConnection])//0: internet working
        {
            NSLog(@"%@",[userDefaults valueForKey:@"userid"]);
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://18.219.207.70"]];
            NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                                    path:[NSString stringWithFormat:@"/slim_api/public/event/show/%@",[userDefaults valueForKey:@"userid"]]
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
                    
                    if([[JSON valueForKey:@"code"]integerValue] ==1)
                    {
                        eventArray=[NSMutableArray new];
                        eventArray=[JSON valueForKey:@"result"];
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:eventArray];
                        [[NSUserDefaults standardUserDefaults]setValue:data forKey:@"eventArrayy"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [tablev reloadData];
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
    selectContactViewController *smvc;
    int height = [UIScreen mainScreen].bounds.size.height;
    if (height == 480) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"selectContactViewController"];
        
    }
    else if (height == 568) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"selectContactViewController"];
        
    }
    else if (height == 667) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"selectContactViewController"];
        
    }
    else if (height == 736) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"selectContactViewController"];
        
    }
    else if (height == 1024) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"ipad" bundle:nil] instantiateViewControllerWithIdentifier:@"selectContactViewController"];
        
    }
    else
    {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"ipad2" bundle:nil] instantiateViewControllerWithIdentifier:@"selectContactViewController"];
        
    }
    
    [self.navigationController pushViewController:smvc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)schedules_Action:(id)sender
{
    buttonSelected=1;
    scheduleButton.backgroundColor=[UIColor colorWithRed:25.0/255.0 green:152/255.0 blue:213/255.0 alpha:1.0];
    upcommingButton.backgroundColor=[UIColor whiteColor];
    [scheduleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [upcommingButton setTitleColor:[UIColor colorWithRed:25.0/255.0 green:152/255.0 blue:213/255.0 alpha:1.0] forState:UIControlStateNormal];
    [tablev reloadData];

}
-(IBAction)upcomming_Action:(id)sender
{
    
//    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
//    [notificationCenter postNotificationName:@"hud" object:nil userInfo:nil];

    
    buttonSelected=2;
    upcommingButton.backgroundColor=[UIColor colorWithRed:25.0/255.0 green:152/255.0 blue:213/255.0 alpha:1.0];
    scheduleButton.backgroundColor=[UIColor whiteColor];
    [upcommingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scheduleButton setTitleColor:[UIColor colorWithRed:25.0/255.0 green:152/255.0 blue:213/255.0 alpha:1.0] forState:UIControlStateNormal];
    [tablev reloadData];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}
-(IBAction)filters_Action:(id)sender
{
    
//    NSString *sms = @"sms:+1234567890&body=This is sms body.";
//    NSString *url = [sms stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
   

    filtersViewController *smvc;
    int height = [UIScreen mainScreen].bounds.size.height;
    if (height == 480) {


        smvc =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"filtersViewController"];

    }
    else if (height == 568) {


        smvc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"filtersViewController"];

    }
    else if (height == 667) {


        smvc =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"filtersViewController"];

    }
    else if (height == 736) {


        smvc =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"filtersViewController"];

    }
    else if (height == 1024) {


        smvc =[[UIStoryboard storyboardWithName:@"ipad" bundle:nil] instantiateViewControllerWithIdentifier:@"filtersViewController"];

    }
    else
    {


        smvc =[[UIStoryboard storyboardWithName:@"ipad2" bundle:nil] instantiateViewControllerWithIdentifier:@"filtersViewController"];

    }

    [self.navigationController pushViewController:smvc animated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(buttonSelected==1)
    {
    if(eventArray.count==0)
    {
        return 1;
    }
    else
        return eventArray.count;
    }
    else
    {
        if(upcommingArray.count==0)
        {
            return 1;
        }
        else
            return upcommingArray.count;
    }
    
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
    if(buttonSelected==1)
    {
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
        
        
        UILabel *birthdayLbl = [[UILabel alloc] initWithFrame:CGRectMake (110, 40, 165, 55)];
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
        editButton.frame = CGRectMake(self.view.frame.size.width-40, 50, 35, 35);
        [editButton setTitle:@"" forState:UIControlStateNormal];
        editButton.backgroundColor = [UIColor clearColor];
        [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
        editButton.tag=indexPath.row;
        [editButton setBackgroundImage:[UIImage imageNamed:@"edit35"] forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:editButton];
        
    }
    }
    else
    {
        if(upcommingArray.count==0)
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
            [label1 setText:@"No Upcomming Schedule yet"];
            [cell addSubview:label1];
        }
        else
        {
            NSDictionary *dict=upcommingArray[indexPath.row];
            

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
            [label1 setText:[NSString stringWithFormat:@"%@",[dict valueForKey:@"day"]]];
            [img addSubview:label1];
            
           
            NSDateFormatter* dateFormatter1 = [[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"MM"];
            NSDate* myDate = [dateFormatter1 dateFromString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"month"]]];
            
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
            [[NSAttributedString alloc] initWithString:[dict valueForKey:@"name"]
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
            [nameLbl setText:[dict valueForKey:@"name"]];
            [cell addSubview:nameLbl];
            
            
            UILabel *birthdayLbl = [[UILabel alloc] initWithFrame:CGRectMake (110, 40, 165, 55)];
            [birthdayLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:13]];
            birthdayLbl.textColor=[UIColor blackColor];
            birthdayLbl.textAlignment=NSTextAlignmentLeft;
            birthdayLbl.backgroundColor=[UIColor clearColor];
            birthdayLbl.lineBreakMode=NSLineBreakByWordWrapping;
            birthdayLbl.numberOfLines=2;
            [birthdayLbl setText:[NSString stringWithFormat:@"%@'S %@",[[dict valueForKey:@"name"] uppercaseString],@"BIRTHDAY"] ];
            [cell addSubview:birthdayLbl];
            
            UIButton *crossButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            crossButton.frame = CGRectMake(self.view.frame.size.width-40, 9, 35, 35);
            [crossButton setTitle:@"" forState:UIControlStateNormal];
            crossButton.backgroundColor = [UIColor clearColor];
            [crossButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
            crossButton.tag=indexPath.row;
            [crossButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
            [crossButton addTarget:self action:@selector(deleteupcommingAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:crossButton];
            
            UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            editButton.frame = CGRectMake(self.view.frame.size.width-40, 50, 35, 35);
            [editButton setTitle:@"" forState:UIControlStateNormal];
            editButton.backgroundColor = [UIColor clearColor];
            [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
            editButton.tag=indexPath.row;
            [editButton setBackgroundImage:[UIImage imageNamed:@"29"] forState:UIControlStateNormal];
            [editButton addTarget:self action:@selector(editupcommingAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:editButton];
            
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(buttonSelected==1){
         if(eventArray.count==0)
         {
             
         }
        else
        {
        UIButton *btn=[[UIButton alloc]init];
        btn.tag=indexPath.row;
        [self editAction:btn];
        }
        
    }
    else
    {
        if(upcommingArray.count==0)
        {
            
        }
        else
        {
        UIButton *btn=[[UIButton alloc]init];
        btn.tag=indexPath.row;
        [self editupcommingAction:btn];
        }
    }
}
-(void)onTick:(NSTimer *)timer {
    //do smth
    NSDictionary *dict1 = [timer userInfo];
    int tagg=[[dict1 valueForKey:@"tag"]intValue];
    NSDictionary *dict=upcommingArray[tagg];
    
    NSMutableArray *arr = [[[NSUserDefaults standardUserDefaults]valueForKey:@"deletedUpcomming"]mutableCopy];
    if(arr == nil)
    {
        arr=[NSMutableArray new];
    }
    [arr addObject:[dict valueForKey:@"phone"]];
    [[NSUserDefaults standardUserDefaults]setValue:arr forKey:@"deletedUpcomming"];
    [upcommingArray removeObjectAtIndex:tagg];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:upcommingArray];
    [[NSUserDefaults standardUserDefaults]setValue:data forKey:@"upcommingArrayy"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //[tablev reloadData];
    [self updateUpcommingArr];
}
-(void)deleteupcommingAction:(UIButton*)btn
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Do you really want to Delete?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *logOut = [UIAlertAction actionWithTitle:@"Delete Post" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                             {
                                 HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                 HUD.label.text=@"Please Wait";
                                 NSMutableDictionary *cb = [[NSMutableDictionary alloc] init];
                                 [cb setObject:[NSString stringWithFormat:@"%d",(int)btn.tag] forKey:@"tag"];
                                 [NSTimer scheduledTimerWithTimeInterval:0.4
                                                                  target:self
                                                                selector:@selector(onTick:)
                                                                userInfo:cb
                                                                 repeats:NO];
      }];
    [alert addAction:cancel];
    [alert addAction:logOut];
    [self presentViewController:alert animated:YES completion:nil];

}
-(void)deleteupcomingfromserver:(NSDictionary*)dict
{
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://18.219.207.70"]];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    
     [tablev reloadData];
    NSDictionary *params=@{
                           @"id"            : [dict valueForKey:@"id"][0],
                           };
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"/slim_api/public/contacts/delete"
                                                      parameters:params];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSString *jsonString = operation.responseString;
        NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        if (JSONdata != nil) {
            HUD.hidden=true;

            NSError *e;
            NSMutableDictionary *JSON =
            [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                            options: NSJSONReadingMutableContainers
                                              error: &e];
            
            NSLog(@"%@",JSON);
            [tablev reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *httpResponse = [operation response];
        NSLog(@"Network-Response: HTTP-Status Code: %ld, Error: %@", (long)[httpResponse statusCode],
              error);
        
    }];
    [httpClient enqueueHTTPRequestOperation:operation];

     [tablev reloadData];
}
-(void)editupcommingAction:(UIButton*)btn
{
     NSData *data = [NSKeyedArchiver archivedDataWithRootObject:upcommingArray[btn.tag]];
    [[NSUserDefaults standardUserDefaults]setValue:data forKey:@"adNewSchedule"];
    [[NSUserDefaults standardUserDefaults]synchronize];

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
- (void)getContacts:(void (^)(NSArray * contacts, NSError * error))completion
{
    if ( !_contactStore )
        _contactStore = [[CNContactStore alloc] init];
    
    NSError * _contactError = [NSError errorWithDomain:@"WCSContactsErrorDomain" code:1 userInfo:@{NSLocalizedDescriptionKey:@"Not authorized to access Contacts."}];
    
    switch ( [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] )
    {
        case CNAuthorizationStatusDenied:
        case CNAuthorizationStatusRestricted: {
            //            if ( [self.delegate respondsToSelector:@selector(picker:didFailToAccessContacts:)] )
            //                [self.delegate picker:self didFailToAccessContacts:_contactError];
            completion(nil, _contactError);
            break;
        }
        case CNAuthorizationStatusNotDetermined:
        {
            [_contactStore requestAccessForEntityType:CNEntityTypeContacts
                                    completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                        if ( ! granted ) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                completion(nil, _contactError);
                                            });
                                        }
                                        else
                                            [self getContacts:completion];
                                    }];
            break;
        }
            
        case CNAuthorizationStatusAuthorized:
        {
            NSMutableArray * _contactsTemp = [NSMutableArray new];
            CNContactFetchRequest * _contactRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:[self contactKeys]];
            [_contactStore enumerateContactsWithFetchRequest:_contactRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                [_contactsTemp addObject:contact];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(_contactsTemp, nil);
            });
            break;
        }
    }
}
#pragma mark - WCSContactPicker Delegates

- (void)didCancelContactSelection {
    NSLog(@"Canceled Contact Selection.");
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

- (NSArray*)contactKeys
{
    return @[CNContactNamePrefixKey,
             CNContactGivenNameKey,
             CNContactMiddleNameKey,
             CNContactFamilyNameKey,
             CNContactPreviousFamilyNameKey,
             CNContactNameSuffixKey,
             CNContactNicknameKey,
             CNContactPhoneticGivenNameKey,
             CNContactPhoneticMiddleNameKey,
             CNContactPhoneticFamilyNameKey,
             CNContactOrganizationNameKey,
             CNContactDepartmentNameKey,
             CNContactJobTitleKey,
             CNContactBirthdayKey,
             CNContactNonGregorianBirthdayKey,
             CNContactNoteKey,
             CNContactImageDataKey,
             CNContactThumbnailImageDataKey,
             CNContactImageDataAvailableKey,
             CNContactTypeKey,
             CNContactPhoneNumbersKey,
             CNContactEmailAddressesKey,
             CNContactPostalAddressesKey,
             CNContactDatesKey,
             CNContactUrlAddressesKey,
             CNContactRelationsKey,
             CNContactSocialProfilesKey,
             CNContactInstantMessageAddressesKey];
}
@end
