//
//  calenderSyncViewController.m
//  RemiderApp
//
//  Created by mac on 01/03/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "calenderSyncViewController.h"
#import "Contact.h"
#import "MBProgressHUD.h"
@import Contacts;
@import ContactsUI;

@import EventKit;
@interface calenderSyncViewController ()
{
    CNContactStore * _contactStore;
    NSMutableDictionary *contactExistDictionary;
    NSMutableArray *contactAllExistance;
    NSMutableArray *eventToShow;
    NSMutableDictionary *stateSave;
    NSString *statee;
        MBProgressHUD *HUD;
}
@property (nonatomic, strong) NSMutableArray * contacts;
@property (nonatomic, strong) NSMutableArray * contacts1;

@end

@implementation calenderSyncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    contactExistDictionary=[NSMutableDictionary new];
    contactAllExistance=[NSMutableArray new];
    eventToShow=[NSMutableArray new];
    stateSave=[NSMutableDictionary new];
    tableV.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor=[UIColor whiteColor];
    
    donebutton.hidden=YES;
    skipBtn.hidden=YES;

    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.label.text=@"Fetching Events";
    
    donebutton.layer.cornerRadius=donebutton.frame.size.height/2;
    skipBtn.layer.cornerRadius=skipBtn.frame.size.height/2;

    EKEventStore *store = [[EKEventStore alloc] init];
    
    
    // Get the appropriate calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    
    if ([store respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        /* iOS Settings > Privacy > Calendars > MY APP > ENABLE | DISABLE */
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
         {
            
             
             if ( granted )
             {
                 _contacts1=[NSMutableArray new];
                 _contacts1=[[NSUserDefaults standardUserDefaults]valueForKey:@"searchArr"];
                 
                 NSLog(@"User has granted permission!");
                 // Create the start date components
                 NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
                 oneDayAgoComponents.day = -1;
                 NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents
                                                               toDate:[NSDate date]
                                                              options:0];
                 
                 // Create the end date components
                 NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
                 oneYearFromNowComponents.year = 1;
                 NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents
                                                                    toDate:[NSDate date]
                                                                   options:0];
                 
                 // Create the predicate from the event store's instance method
                 NSPredicate *predicate = [store predicateForEventsWithStartDate:oneDayAgo
                                                                         endDate:oneYearFromNow
                                                                       calendars:nil];
                 
                 // Fetch all events that match the predicate
                 NSArray *events = [store eventsMatchingPredicate:predicate];
                 //NSLog(@"The content of array is%@",events);
                 
                 
                 NSData *data =[[NSUserDefaults standardUserDefaults]valueForKey:@"allContacts"];
                 _contacts = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                 
                 for(int i=0;i<events.count;i++)
                 {
                     contactAllExistance=[NSMutableArray new];
                     EKEvent *event = [events objectAtIndex:i];
//                     EKCalendar *cal=event.calendar;
//                     NSLog(@"--------------------------");
//                     NSLog(@"%@",event.title);
//                     NSLog(@"%@",[cal valueForKey:@"type"]);
//                     NSLog(@"%@",cal.title);
//                     NSLog(@"%@",event.endDate);
//                     NSLog(@"--------------------------");
                     
                     int count = 0;
                     for(int j=0;j<_contacts.count;j++)
                     {
                         NSArray *items = [event.title componentsSeparatedByString:@" "];   //take the one array for split the string

                         NSRange stringrange =[_contacts1[j] rangeOfString:items[0] options:NSCaseInsensitiveSearch];
                         
                         if(stringrange.location!= NSNotFound)
                         {
                             count++;
                             [contactAllExistance addObject:_contacts[j]];
                         }
 
                         
                         
                        
                         
                     }
                     if(i!=0)
                     {
                     NSData *data1 =[[NSUserDefaults standardUserDefaults]valueForKey:@"contactAllExistance"];
                     contactExistDictionary = [[NSKeyedUnarchiver unarchiveObjectWithData:data1]mutableCopy];
                     }
                     [contactExistDictionary setObject:contactAllExistance forKey:event.title];
                     NSData *data = [NSKeyedArchiver archivedDataWithRootObject:contactExistDictionary];
                     [[NSUserDefaults standardUserDefaults]setValue:data forKey:@"contactAllExistance"];
                     [[NSUserDefaults standardUserDefaults] synchronize];

                     if( count>0)
                     {
                         [eventToShow addObject:event];
                     }
                     
                     
                 }
                 
                if(eventToShow.count>0)
                {
                 [tableV reloadData];
                    donebutton.hidden=false;
                    skipBtn.hidden=false;
                    HUD.hidden=YES;
                }
                 else
                 {
                     HUD.hidden=YES;

                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                         message:@"No Event Found."
                                                                        delegate:nil
                                                               cancelButtonTitle:@"Ok"
                                                               otherButtonTitles:nil];
                     [alertView show];
                 }

             }
             else
             {
                 HUD.hidden=YES;

                 NSLog(@"User has not granted permission!");
             }
         }];

    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return eventToShow.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSData *data1 =[[NSUserDefaults standardUserDefaults]valueForKey:@"contactAllExistance"];
    contactExistDictionary = [[NSKeyedUnarchiver unarchiveObjectWithData:data1]mutableCopy];

    EKEvent *event = eventToShow[indexPath.row];
    
    NSArray *temp = [contactExistDictionary valueForKey:event.title];
    
    return 80 * temp.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    EKEvent *event = eventToShow[indexPath.row];
    
    
    NSArray *temp = [contactExistDictionary valueForKey:event.title];
    NSLog(@"%@",event.endDate);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    NSDate *today = event.endDate;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:today];
    
    UIImageView *img1=[[UIImageView alloc]initWithFrame:CGRectMake(5, ((70*temp.count)/2)-30, 15, 15)];
    img1.image=[UIImage imageNamed:@"gift"];
    img1.backgroundColor=[UIColor whiteColor];
    [cell addSubview:img1];
    
    
    NSDateFormatter* dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MM"];
    NSDate* myDate = [dateFormatter1 dateFromString:[NSString stringWithFormat:@"%ld",(long)components.month]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    NSString *stringFromDate = [formatter stringFromDate:myDate];
    UILabel *dateLbl = [[UILabel alloc] initWithFrame:CGRectMake (20, ((70*temp.count)/2)-33, cell.frame.size.width/3-40, 20)];
    [dateLbl setFont:[UIFont fontWithName:@"OpenSans-Regular" size:12]];
    dateLbl.lineBreakMode=NSLineBreakByWordWrapping;
    dateLbl.numberOfLines=2;
    dateLbl.textColor=[UIColor blackColor];
    dateLbl.textAlignment=NSTextAlignmentLeft;
    dateLbl.backgroundColor=[UIColor clearColor];
    [dateLbl setText:[NSString stringWithFormat:@"%ld %@",(long)components.day,stringFromDate]];
    [cell addSubview:dateLbl];
    
    
    
    
    
    UIImageView *userimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, ((70*temp.count)/2)+13, 15, 15)];
    userimg.image=[UIImage imageNamed:@"user"];
    [cell addSubview:userimg];
    
    
    
    NSArray *items = [event.title componentsSeparatedByString:@" "];
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:items[0]
                                    attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans-Bold" size:12]}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){250, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake (20, ((70*temp.count)/2)+13, size.width+10, 20)];
    [nameLbl setFont:[UIFont fontWithName:@"OpenSans-Regular" size:12]];
    nameLbl.lineBreakMode=NSLineBreakByWordWrapping;
    nameLbl.layer.borderWidth=1.5;
    nameLbl.layer.borderColor=[UIColor colorWithRed:231.0/255.0 green:231/255.0 blue:231/255.0 alpha:1.0].CGColor;
    nameLbl.layer.cornerRadius=10;
    nameLbl.textColor=[UIColor blackColor];
    nameLbl.textAlignment=NSTextAlignmentCenter;
    nameLbl.backgroundColor=[UIColor clearColor];
    [nameLbl setText:items[0]];
    [cell addSubview:nameLbl];
    
    if(temp.count>1)
    {
        img1.frame=CGRectMake(5, ((70*temp.count)/2)-35, 15, 15);
        dateLbl.frame=CGRectMake (20, ((70*temp.count)/2)-38, cell.frame.size.width/3-40, 20);
        userimg.frame=CGRectMake(5, ((70*temp.count)/2)+18, 15, 15);
        nameLbl.frame=CGRectMake (20, ((70*temp.count)/2)+18, size.width+10, 20);
    }
    
    UIFont * myFont =[UIFont fontWithName:@"OpenSans-Bold" size:11];
    CGRect labelFrame1 = CGRectMake (5, ((70*temp.count)/2)-18, cell.frame.size.width/3+10, 35);
    UILabel *label1 = [[UILabel alloc] initWithFrame:labelFrame1];
    [label1 setFont:myFont];
    label1.lineBreakMode=NSLineBreakByWordWrapping;
    label1.numberOfLines=2;
    label1.textColor=[UIColor blackColor];
    label1.textAlignment=NSTextAlignmentCenter;
    label1.backgroundColor=[UIColor clearColor];
    [label1 setText:event.title];
    [cell addSubview:label1];
    
    
    int y=5;
    for(int i=0;i<temp.count;i++)
    {
        Contact * _contact = [self personFromContact:(CNContact*)temp[i]];

        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake (cell.frame.size.width/3+55, y, cell.frame.size.width/3+cell.frame.size.width/3-40, 25)];
        [labelName setFont:[UIFont fontWithName:@"OpenSans-Bold" size:12.5]];
        labelName.lineBreakMode=NSLineBreakByWordWrapping;
        labelName.numberOfLines=2;
        labelName.textColor=[UIColor blackColor];
        labelName.textAlignment=NSTextAlignmentLeft;
        labelName.backgroundColor=[UIColor clearColor];
        [labelName setText:_contact.displayName];
        [cell addSubview:labelName];
        

        
        UILabel *labelphone = [[UILabel alloc] initWithFrame:CGRectMake (cell.frame.size.width/3+55, y+20, cell.frame.size.width/3+cell.frame.size.width/3-40, 25)];
        [labelphone setFont:[UIFont fontWithName:@"OpenSans-Regular" size:12]];
        labelphone.lineBreakMode=NSLineBreakByWordWrapping;
        labelphone.numberOfLines=2;
        labelphone.textColor=[UIColor blackColor];
        labelphone.textAlignment=NSTextAlignmentLeft;
        labelphone.backgroundColor=[UIColor clearColor];
        [labelphone setText:_contact.phones[0]];
        [cell addSubview:labelphone];
        
        
        UIButton *radioButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        radioButton.frame = CGRectMake(cell.frame.size.width/3+30, y+12, 20, 20);
        radioButton.backgroundColor = [UIColor clearColor];
        [radioButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
        NSString *t= [NSString stringWithFormat:@"%d000%d",(int)indexPath.row,i];
        radioButton.tag=t.intValue;
        
        if(statee.intValue == t.intValue)
        {
        [radioButton setBackgroundImage:[UIImage imageNamed:@"radios"] forState:UIControlStateNormal];
        }
        else
        {
            if(statee.intValue >= t.intValue && statee.intValue < t.intValue+10)
            {
                
                [radioButton setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
                int k=t.intValue;
                [stateSave setValue:@"no" forKey:[NSString stringWithFormat:@"%d",k]];
            }
            else if(statee.intValue <= t.intValue && statee.intValue > t.intValue-10)
            {
                [radioButton setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
                int k=t.intValue;
                [stateSave setValue:@"no" forKey:[NSString stringWithFormat:@"%d",k]];
            }
            else
            {
                int k=t.intValue;

                if([[stateSave valueForKey:[NSString stringWithFormat:@"%d",k]]isEqualToString:@"yes"])
                [radioButton setBackgroundImage:[UIImage imageNamed:@"radios"] forState:UIControlStateNormal];
                else
                    [radioButton setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];

            }


        }
        
      
        [radioButton addTarget:self action:@selector(radioButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:radioButton];
        
        UIImageView *img2=[[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width/3+30, y+12, 20, 20)];
        img2.image=[UIImage imageNamed:@"radio"];
        img2.backgroundColor=[UIColor whiteColor];
       // [cell addSubview:img2];
        
        y=y+50;
        
        }
    
    UIView *sep =[[UIView alloc]initWithFrame:CGRectMake(0, 80*temp.count, self.view.frame.size.width, 1)];
    sep.backgroundColor=[UIColor lightGrayColor];
    [cell addSubview:sep];
    
    UIView *sep1 =[[UIView alloc]initWithFrame:CGRectMake(cell.frame.size.width/3+20, 0, 1, 70*temp.count)];
    sep1.backgroundColor=[UIColor lightGrayColor];
    [cell addSubview:sep1];
    
    
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (Contact*)personFromContact:(CNContact*)contact
{
    Contact * _contact = [Contact new];
    
    _contact.firstname = contact.givenName;
    _contact.lastname = contact.familyName;
    _contact.nickname = contact.nickname;
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
-(void)radioButtonAction:(UIButton*)btn
{
    NSLog(@"%d",(int)btn.tag);
    statee=[NSString stringWithFormat:@"%d",(int)btn.tag];
    [stateSave setValue:@"yes" forKey:statee];
    tableV.scrollEnabled=false;
    [tableV reloadData];
    tableV.scrollEnabled=true;
}
-(IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)skipAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)doneAction:(id)sender
{
    NSMutableArray *upcommingArray=[NSMutableArray new];

    for(int i=0;i<eventToShow.count;i++)
    {
        EKEvent *event = eventToShow[i];
        NSArray *temp = [contactExistDictionary valueForKey:event.title];
        
        for(int j=0;j<temp.count;j++)
        {
            Contact * _contact = [self personFromContact:(CNContact*)temp[j]];
            NSString *t= [NSString stringWithFormat:@"%d000%d",(int)i,j];
            //int k=t.intValue;
            NSLog(@"%@",stateSave);
            if([[stateSave valueForKey:[NSString stringWithFormat:@"%d",t.intValue]]isEqualToString:@"yes"])
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
                break;
            }
            
            
        }
        if(i == eventToShow.count-1)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    
   
}
@end
