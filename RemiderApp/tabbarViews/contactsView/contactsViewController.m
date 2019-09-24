//
//  contactsViewController.m
//  RemiderApp
//
//  Created by mac on 19/01/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import "contactsViewController.h"
#import "filtersViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "AppDelegate.h"
#import "contactDetailViewController.h"
#import "MBProgressHUD.h"

//#import <AddressBook/ABAddressBook.h>
//#import <AddressBookUI/AddressBookUI.h>

#import "ZLPeoplePickerViewController.h"


#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "DemoTableViewController.h"


@interface contactsViewController ()<CNContactViewControllerDelegate>
//<ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate,ZLPeoplePickerViewControllerDelegate, MFMailComposeViewControllerDelegate>
{
    CNContactStore * _contactStore;
    CNContactViewController *addContactVC;
    NSMutableArray *searchArr;
    int searchWorking;
    UIView *popUpDelete;
    MBProgressHUD *HUD;
    MBProgressHUD *hud;

}
@property (nonatomic, strong) NSMutableArray * contacts;
@property (nonatomic, strong) NSMutableArray * contacts1;

@property (nonatomic, strong) ZLPeoplePickerViewController *peoplePicker;


@property (assign) BOOL contactsError;

@end

@implementation contactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    searchWorking=0;
    self.navigationController.navigationBarHidden=true;
    
    
    self.peoplePicker = [[ZLPeoplePickerViewController alloc] init];
    //self.peoplePicker.delegate = self;
    [self.navigationController pushViewController:self.peoplePicker
                                         animated:YES];
    
//    DemoTableViewController *smvc;
//    smvc =[[DemoTableViewController alloc]init];
//    [self.navigationController pushViewController:smvc animated:YES];

//    search_bar.barTintColor = [UIColor clearColor];
//    search_bar.placeholder=@"Search Contact By Name";
//    search_bar.barTintColor = [UIColor clearColor];
//    search_bar.backgroundImage = [UIImage new];
//
//    UIButton *addNewContact = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [addNewContact addTarget:self action:@selector(addnewcontactAction) forControlEvents:UIControlEventTouchUpInside];
//    [addNewContact setTitle:@" + ADD NEW CONTACT" forState:UIControlStateNormal];
//    addNewContact.frame = CGRectMake(self.view.frame.size.width-180, self.view.frame.size.height-90, 170, 30);
//    addNewContact.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:13];
//    [addNewContact setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:152/255.0 blue:213/255.0 alpha:1.0]];
//    addNewContact.layer.cornerRadius=15;
//    [addNewContact setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.view addSubview:addNewContact];
//
//
//
//    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.label.text=@"Fetching Contacts...";
//
////    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
////    [notificationCenter postNotificationName:@"hud" object:nil userInfo:nil];
//
//
//    _contacts=[NSMutableArray new];
//
//    NSData *data =[[NSUserDefaults standardUserDefaults]valueForKey:@"allContacts"];
//    _contacts = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    _contacts1=[NSMutableArray new];
//    _contacts1=[[NSUserDefaults standardUserDefaults]valueForKey:@"searchArr"];
//    if(_contacts==nil)
//    {
//
//        CNContactStore *store = [[CNContactStore alloc] init];
//        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
//            if (granted == YES) {
//
//                _contacts=[NSMutableArray new];
//                [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
//                NSString *containerId = store.defaultContainerIdentifier;
//                NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
//                NSError *error;
//                NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:[self contactKeys] error:&error];
//                if (error) {
//                    NSLog(@"error fetching contacts %@", error);
//                } else
//                {
//                    HUD.label.text=[NSString stringWithFormat:@"%d Contact Fetched",(int)cnContacts.count];
//                    for(int i=0;i<cnContacts.count;i++){
//                        Contact * _contact = [self personFromContact:(CNContact*)cnContacts[i]];
//                        if(_contact.phones.count>0)
//                           [_contacts addObject:_contact];
//                    }
//
//
//                    _contacts = [cnContacts mutableCopy];
//
//
//                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_contacts];
//                    [[NSUserDefaults standardUserDefaults]setValue:data forKey:@"allContacts"];
//                    [[NSUserDefaults standardUserDefaults]synchronize];
//
//
//                    [self getSearchArray];
//
//
//                   // [self addImageForAllContacts];
//                    [tablev reloadData];
//
//                    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
//                    [notificationCenter postNotificationName:@"upcomming" object:nil userInfo:nil];
////                    [notificationCenter postNotificationName:@"hud1" object:nil userInfo:nil];
//                    HUD.hidden=true;
//                    [[UIApplication sharedApplication] setIdleTimerDisabled:false];
//                }
//            }
//        }];
//    }
//    else
//    {
////        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
////        [notificationCenter postNotificationName:@"hud1" object:nil userInfo:nil];
//        HUD.hidden=true;
//
//        [tablev reloadData];
//    }
}



//NSDictionary  *imgDict=[[[NSUserDefaults standardUserDefaults] valueForKey:@"SavedUserImages"]mutableCopy];
//if([imgDict valueForKey:@"_contact.phones[0]"])
//{
//    UIImage *img =[UIImage imageWithData:[NSData dataWithContentsOfFile:[self documentsPathForFileName:[imgDict valueForKey:_contact.phones[0]]]]];
//    imgv.image=img;//_contact.thumb;
//}
//else
//imgv.image=[UIImage imageNamed:@"default"];



-(void)addImageForAllContacts
{
//    NSString *st=@"";
//    NSString *imagePath;
//    st=[NSString stringWithFormat:@"image_%f.jpg", [NSDate timeIntervalSinceReferenceDate]];
//    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"default"], 0.5);
//    imagePath = [self documentsPathForFileName:st];
//    [imageData writeToFile:imagePath atomically:YES];
//    NSMutableDictionary *imgDicttt=[NSMutableDictionary new];
//    for(int i=0;i<_contacts.count;i++)
//    {
//        Contact * _contact = [self personFromContact:(CNContact*)_contacts[i]];
//        HUD.label.text=[NSString stringWithFormat:@"%d Contact Fetched",i];
//
//        imgDicttt=[[[NSUserDefaults standardUserDefaults] valueForKey:@"SavedUserImages"]mutableCopy];
//        if(imgDicttt.count==0)
//            imgDicttt=[NSMutableDictionary new];
//        [imgDicttt setObject:st forKey:[NSString stringWithFormat:@"%@",_contact.phones[0]]];
//        [[NSUserDefaults standardUserDefaults] setObject:imgDicttt forKey:@"SavedUserImages"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
   
}
-(void)viewWillAppear:(BOOL)animated
{
    //[tablev reloadData];
}
- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:name];
}
-(void)addnewcontactAction
{
    addContactVC = [CNContactViewController viewControllerForNewContact:nil];
    addContactVC.delegate=self;
    UINavigationController *navController   = [[UINavigationController alloc] initWithRootViewController:addContactVC];
    [self presentViewController:navController animated:NO completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact
{
    [viewController dismissViewControllerAnimated:YES completion:NULL];
}
- (void)doSomeWorkWithProgressObject:(NSProgress *)progressObject {
    // This just increases the progress indicator in a loop.
    while (progressObject.fractionCompleted < 1.0f) {
        if (progressObject.isCancelled) break;
        [progressObject becomeCurrentWithPendingUnitCount:1];
        [progressObject resignCurrent];
        usleep(50000);
    }
}
- (void)doSomeWorkWithProgress {
    self.canceled = NO;
    // This just increases the progress indicator in a loop.
    float progress = 0.0f;
    while (progress < 1.0f) {
        if (self.canceled) break;
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            // Instead we could have also passed a reference to the HUD
            // to the HUD to myProgressTask as a method parameter.
            [MBProgressHUD HUDForView:self.navigationController.view].progress = progress;
        });
        usleep(10000);
    }
}
-(IBAction)refresh_Action:(id)sender
{
    
//   UIView *blackHudView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    blackHudView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
//    blackHudView.userInteractionEnabled=true;
//    [self.tabBarController.view addSubview:blackHudView];
    
    
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//
//    // Set the annular determinate mode to show task progress.
//    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"Fetching Contacts...", @"HUD loading title");
//
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
//        // Do something useful in the background and update the HUD periodically.
//        [self doSomeWorkWithProgress];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [hud hideAnimated:YES];
//        });
//    });
//
//
//
//
////    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
////    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
////        // Do something...
////        HUD .hidden=YES;
////    });
//
////    HUD=[MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
////    HUD.labelText=@"Contact Fetching...";
//    [self getContacts:^(NSArray *contacts, NSError *error) {
//        _contacts = [contacts mutableCopy];
//        _contactsError = error != nil ? YES : NO;
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_contacts];
//        [[NSUserDefaults standardUserDefaults]setValue:data forKey:@"allContacts"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        [tablev reloadData];
//        NSMutableDictionary *imgDict=[NSMutableDictionary new];
//        NSString *st;//=[NSString stringWithFormat:@"image_%f.jpg", [NSDate timeIntervalSinceReferenceDate]];
//        NSString *imagePath;// = [self documentsPathForFileName:st];
//        for(int i=0;i<_contacts.count;i++)
//        {
//
//          //  [label1 setText:[NSString stringWithFormat:@"%d Contacts fetched",i]];
//
//            hud.label.text=[NSString stringWithFormat:@"%d Contacts fetched",i];
//
//            Contact * _contact = [self personFromContact1:(CNContact*)_contacts[i]];
//
//            if(i==0)
//            {
//            NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"default"], 0.5);
//            st=[NSString stringWithFormat:@"image_%f.jpg", [NSDate timeIntervalSinceReferenceDate]];
//            imagePath = [self documentsPathForFileName:st];
//            [imageData writeToFile:imagePath atomically:YES];
//            }
//            else
//            {
//
//            }
//            imgDict=[[[NSUserDefaults standardUserDefaults] valueForKey:@"SavedUserImages"]mutableCopy];
//            if(imgDict.count==0)
//                imgDict=[NSMutableDictionary new];
//            [imgDict setObject:st forKey:[NSString stringWithFormat:@"%@",_contact.phones[0]]];
//            [[NSUserDefaults standardUserDefaults] setObject:imgDict forKey:@"SavedUserImages"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
//        [notificationCenter postNotificationName:@"upcomming" object:nil userInfo:nil];
//
//        //HUD.hidden=YES;
//    }];
    
//    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
//    [notificationCenter postNotificationName:@"hud" object:nil userInfo:nil];
    
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            
            [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:[self contactKeys] error:&error];
            if (error) {
                NSLog(@"error fetching contacts %@", error);
            } else
            {
                HUD.label.text=[NSString stringWithFormat:@"%d Contact Fetched",(int)cnContacts.count];
                _contacts=[NSMutableArray new];

//                  for(int i=0;i<cnContacts.count;i++)
//                  {
//                      Contact * _contact = [self personFromContact:(CNContact*)cnContacts[i]];
//                      if(_contact.phones.count>0)
//                         [_contacts addObject:_contact];
//                  }
                
                _contacts = [cnContacts mutableCopy];

                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_contacts];
                [[NSUserDefaults standardUserDefaults]setValue:data forKey:@"allContacts"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                
                [self getSearchArray];
                NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
                [notificationCenter postNotificationName:@"upcomming" object:nil userInfo:nil];
                //[notificationCenter postNotificationName:@"hud1" object:nil userInfo:nil];
                hud.hidden=true;
                [tablev reloadData];
               // [blackHudView removeFromSuperview];
                [[UIApplication sharedApplication] setIdleTimerDisabled: false];
            }
        }
    }];
}
-(void)getSearchArray
{
    _contacts1=[NSMutableArray new];
                      for(int i=0;i<_contacts.count;i++)
                      {
                          Contact * _contact = [self personFromContact:(CNContact*)_contacts[i]];
                             [_contacts1 addObject:_contact.displayName];
                      }
    [[NSUserDefaults standardUserDefaults]setValue:_contacts1 forKey:@"searchArr"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
-(IBAction)filters_Action:(id)sender
{
    filtersViewController *smvc;
    int height = [UIScreen mainScreen].bounds.size.height;
    if (height == 480)
    {
                smvc =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"filtersViewController"];
    }
    else if (height == 568)
    {
                smvc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"filtersViewController"];
    }
    else if (height == 667)
    {
                smvc =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"filtersViewController"];
    }
    else if (height == 736)
    {
        smvc =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"filtersViewController"];
    }
    else if (height == 1024)
    {
        smvc =[[UIStoryboard storyboardWithName:@"ipad" bundle:nil] instantiateViewControllerWithIdentifier:@"filtersViewController"];
    }
    else
    {
        smvc =[[UIStoryboard storyboardWithName:@"ipad2" bundle:nil] instantiateViewControllerWithIdentifier:@"filtersViewController"];
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
            HUD.label.text =@"Fetching In Process...";
            NSMutableArray * _contactsTemp = [NSMutableArray new];
            CNContactFetchRequest * _contactRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:[self contactKeys]];
            [_contactStore enumerateContactsWithFetchRequest:_contactRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                //[self doSomeWorkWithProgress];
                HUD.label.text = [NSString stringWithFormat:@"%lu Contact fetched.In Process",(unsigned long)_contactsTemp.count];

                Contact * _contacttttt = [self personFromContact:(CNContact*)contact];
                if(_contacttttt.phones.count>0)
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
//- (void)picker:(WCSContactPicker *)picker didFailToAccessContacts:(NSError *)error {
//    NSLog(@"Failed to Access Contacts: %@", error.description);
//}
//- (void)picker:(WCSContactPicker *)picker didSelectContact:(Contact *)contact {
//    NSLog(@"Selected Contact: %@", contact.description);
////    _imageThumb.image = contact.photo;
////    _labelName.text = contact.displayName;
////    _labelPhone.text = contact.phones[0];
////    _labelEmail.text = contact.emails[0];
//}

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
- (Contact*)personFromContact1:(CNContact*)contact
{
    Contact * _contact = [Contact new];
    if ( contact.phoneNumbers.count )
    {
        NSMutableArray * _tempPhones = [NSMutableArray new];
        for ( CNLabeledValue * _contactPhone in contact.phoneNumbers ) {
            CNPhoneNumber * _phoneNumber = _contactPhone.value;
            [_tempPhones addObject:_phoneNumber.stringValue];
        }
        _contact.phones = _tempPhones;
    }
    return _contact;

}
- (Contact*)personFromContact:(CNContact*)contact
{
    Contact * _contact = [Contact new];
    /*
     <CNContact: 0x7f8e53534fb0: identifier=0A8D6C61-3D32-4001-AFE9-29EC1F9CD6AC, givenName=John, familyName=Appleseed, organizationName=, phoneNumbers=(
     "<CNLabeledValue: 0x7f8e53538470: identifier=7558D0EC-EC30-4DBD-A880-E9D5BCCA4361, label=_$!<Mobile>!$_, value=<CNPhoneNumber: 0x7f8e53538a10: countryCode=us, digits=8885555512>>",
     "<CNLabeledValue: 0x7f8e5358efa0: identifier=A012C265-FF72-47E4-9DDA-5330699B1034, label=_$!<Home>!$_, value=<CNPhoneNumber: 0x7f8e5355b150: countryCode=us, digits=8885551212>>"
     ), emailAddresses=(
     "<CNLabeledValue: 0x7f8e53538380: identifier=E58988F0-02AB-439A-8DF4-70DDA520016A, label=_$!<Work>!$_, value=John-Appleseed@mac.com>"
     ), postalAddresses=(
     "<CNLabeledValue: 0x7f8e5353c990: identifier=46402008-1878-43A4-A3FD-EDE315B5D616, label=_$!<Work>!$_, value=<CNPostalAddress: 0x7f8e5353cae0: street=3494 Kuhl Avenue, city=Atlanta, state=GA, postalCode=30303, country=USA, countryCode=ca, formattedAddress=(null)>>",
     "<CNLabeledValue: 0x7f8e5353cba0: identifier=7CD0A2D0-F7E1-4A80-933B-B4447BB4F041, label=_$!<Home>!$_, value=<CNPostalAddress: 0x7f8e5353cbe0: street=1234 Laurel Street, city=Atlanta, state=GA, postalCode=30303, country=USA, countryCode=us, formattedAddress=(null)>>"
     )>
     */
    //_contact.photo = [self contactImage:[UIImage imageWithData:contact.imageData]];
    //_contact.thumb = [self contactImage:[UIImage imageWithData:contact.thumbnailImageData]];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(searchWorking == 1)
        return searchArr.count ? searchArr.count :1;
    else
    return _contacts.count ? _contacts.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(searchWorking == 1)
    {
        if(searchArr.count==0)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
            if ( cell ) cell = nil;
            if ( ! cell ) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            cell.textLabel.text = NSLocalizedString(@"No Contacts", nil);
            cell.detailTextLabel.numberOfLines = 1;
            cell.detailTextLabel.text = NSLocalizedString(@"There are no Contacts available.", nil);
             return cell;
        }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            }


            Contact * _contact = [self personFromContact:(CNContact*)searchArr[indexPath.row]];
            
            UIFont * myFont =[UIFont fontWithName:@"OpenSans-Bold" size:15];
            CGRect labelFrame1 = CGRectMake (65, 10, self.view.frame.size.width-90, 25);
            UILabel *label1 = [[UILabel alloc] initWithFrame:labelFrame1];
            [label1 setFont:myFont];
            label1.lineBreakMode=NSLineBreakByWordWrapping;
            label1.numberOfLines=15;
            label1.textColor=[UIColor blackColor];
            label1.textAlignment=NSTextAlignmentLeft;
            label1.backgroundColor=[UIColor clearColor];
            [label1 setText:_contact.displayName];
            [cell addSubview:label1];
            
            
            UIImageView *imgv=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 50, 50)];
            imgv.layer.cornerRadius=imgv.frame.size.width/2;
          NSDictionary  *imgDict=[[[NSUserDefaults standardUserDefaults] valueForKey:@"SavedUserImages"]mutableCopy];
            if([imgDict valueForKey:_contact.phones[0]])
            {
          UIImage *img =[UIImage imageWithData:[NSData dataWithContentsOfFile:[self documentsPathForFileName:[imgDict valueForKey:_contact.phones[0]]]]];
            imgv.image=img;//_contact.thumb;
            }
            else
                imgv.image=[UIImage imageNamed:@"default"];
            imgv.layer.borderWidth=1.0;
            imgv.layer.borderColor=[UIColor lightGrayColor].CGColor;
            imgv.clipsToBounds=YES;
            [cell addSubview:imgv];
            
//            NSLog(@"%@",_contact.birthday);
//            NSLog(@"%@",_contact.displayName);
            
            UILabel *phoneNo = [[UILabel alloc] initWithFrame:CGRectMake (65, 35, self.view.frame.size.width-90, 25)];
            [phoneNo setFont:[UIFont fontWithName:@"OpenSans-Regular" size:14]];
            phoneNo.lineBreakMode=NSLineBreakByWordWrapping;
            phoneNo.numberOfLines=15;
            phoneNo.textColor=[UIColor lightGrayColor];
            phoneNo.textAlignment=NSTextAlignmentLeft;
            phoneNo.backgroundColor=[UIColor clearColor];
            [phoneNo setText:_contact.phones[0]];
            [cell addSubview:phoneNo];
            
            UIButton *crossButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            crossButton.frame = CGRectMake(self.view.frame.size.width-40, 9, 29, 29);
            [crossButton setTitle:@"" forState:UIControlStateNormal];
            crossButton.backgroundColor = [UIColor clearColor];
            [crossButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
            crossButton.tag=indexPath.row;
            [crossButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
            [crossButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:crossButton];
            
            UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            editButton.frame = CGRectMake(self.view.frame.size.width-40, 40, 29, 29);
            [editButton setTitle:@"" forState:UIControlStateNormal];
            editButton.backgroundColor = [UIColor clearColor];
            [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
            editButton.tag=indexPath.row;
            [editButton setBackgroundImage:[UIImage imageNamed:@"edit35"] forState:UIControlStateNormal];
            [editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:editButton];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    else
    {
    if ( _contacts.count )
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        
        
        
        Contact * _contact = [self personFromContact:(CNContact*)_contacts[indexPath.row]];
        
        UIFont * myFont =[UIFont fontWithName:@"OpenSans-Bold" size:15];
        CGRect labelFrame1 = CGRectMake (65, 10, self.view.frame.size.width-90, 25);
        UILabel *label1 = [[UILabel alloc] initWithFrame:labelFrame1];
        [label1 setFont:myFont];
        label1.lineBreakMode=NSLineBreakByWordWrapping;
        label1.numberOfLines=15;
        label1.textColor=[UIColor blackColor];
        label1.textAlignment=NSTextAlignmentLeft;
        label1.backgroundColor=[UIColor clearColor];
        [label1 setText:_contact.displayName];
        [cell addSubview:label1];
        
        
        UIImageView *imgv=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 50, 50)];
        imgv.layer.cornerRadius=imgv.frame.size.width/2;
        NSDictionary  *imgDict=[[[NSUserDefaults standardUserDefaults] valueForKey:@"SavedUserImages"]mutableCopy];
        if([imgDict valueForKey:_contact.phones[0]])
        {
            UIImage *img =[UIImage imageWithData:[NSData dataWithContentsOfFile:[self documentsPathForFileName:[imgDict valueForKey:_contact.phones[0]]]]];
            imgv.image=img;//_contact.thumb;
        }
        else
            imgv.image=[UIImage imageNamed:@"default"];
        
        imgv.layer.borderWidth=1.0;
        imgv.layer.borderColor=[UIColor lightGrayColor].CGColor;
        imgv.clipsToBounds=YES;
        [cell addSubview:imgv];
        
        //NSLog(@"%@",_contact.birthday);
        //NSLog(@"%@",_contact.displayName);
        
        UILabel *phoneNo = [[UILabel alloc] initWithFrame:CGRectMake (65, 35, self.view.frame.size.width-90, 25)];
        [phoneNo setFont:[UIFont fontWithName:@"OpenSans-Regular" size:14]];
        phoneNo.lineBreakMode=NSLineBreakByWordWrapping;
        phoneNo.numberOfLines=15;
        phoneNo.textColor=[UIColor lightGrayColor];
        phoneNo.textAlignment=NSTextAlignmentLeft;
        phoneNo.backgroundColor=[UIColor clearColor];
        [phoneNo setText:_contact.phones[0]];
        [cell addSubview:phoneNo];
        
        UIButton *crossButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        crossButton.frame = CGRectMake(self.view.frame.size.width-40, 6, 29, 29);
        [crossButton setTitle:@"" forState:UIControlStateNormal];
        crossButton.backgroundColor = [UIColor clearColor];
        [crossButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
        crossButton.tag=indexPath.row;
        [crossButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [crossButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:crossButton];

        UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        editButton.frame = CGRectMake(self.view.frame.size.width-40, 40, 29, 29);
        [editButton setTitle:@"" forState:UIControlStateNormal];
        editButton.backgroundColor = [UIColor clearColor];
        [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
        editButton.tag=indexPath.row;
        [editButton setBackgroundImage:[UIImage imageNamed:@"edit35"] forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:editButton];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
        if ( cell ) cell = nil;
        if ( ! cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        if ( _contactsError )
        {
            cell.textLabel.text = NSLocalizedString(@"Contacts Error", nil);
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.text = NSLocalizedString(@"Enable Contacts under iOS Settings -> Privacy -> Contacts.", nil);
        }
        else
        {
            cell.textLabel.text = NSLocalizedString(@"No Contacts", nil);
            cell.detailTextLabel.numberOfLines = 1;
            cell.detailTextLabel.text = NSLocalizedString(@"There are no Contacts available.", nil);
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    }
    return nil;
}




-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([tablev respondsToSelector:@selector(setSeparatorInset:)]) {
        [tablev setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tablev respondsToSelector:@selector(setLayoutMargins:)]) {
        [tablev setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(searchWorking == 1)
    {
        AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.contactid=(int)indexPath.row;
        appDelegate.contactArray=searchArr;
        contactDetailViewController *smvc;
        int height = [UIScreen mainScreen].bounds.size.height;
        if (height == 480) {
            
            
            smvc =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
            
        }
        else if (height == 568) {
            
            
            smvc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
            
        }
        else if (height == 667) {
            
            
            smvc =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
            
        }
        else if (height == 736) {
            
            
            smvc =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
            
        }
        else if (height == 1024) {
            
            
            smvc =[[UIStoryboard storyboardWithName:@"ipad" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
            
        }
        else
        {
            
            
            smvc =[[UIStoryboard storyboardWithName:@"ipad2" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
            
        }
        
        [self.navigationController pushViewController:smvc animated:YES];
    }
    else
    {
        if ( _contacts.count )
        {
            AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            appDelegate.contactid=(int)indexPath.row;
            appDelegate.contactArray=_contacts;
            contactDetailViewController *smvc;
            int height = [UIScreen mainScreen].bounds.size.height;
            if (height == 480) {
                
                
                smvc =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
                
            }
            else if (height == 568) {
                
                
                smvc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
                
            }
            else if (height == 667) {
                
                
                smvc =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
                
            }
            else if (height == 736) {
                
                
                smvc =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
                
            }
            else if (height == 1024) {
                
                
                smvc =[[UIStoryboard storyboardWithName:@"ipad" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
                
            }
            else
            {
                
                
                smvc =[[UIStoryboard storyboardWithName:@"ipad2" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
                
            }
            
            [self.navigationController pushViewController:smvc animated:YES];
        }
        else
        {
            if ( _contactsError ) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }
    }
    
    
}
-(void)closeAction:(UIButton*)btn
{
    
    
    popUpDelete=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    popUpDelete.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height/2-150, self.view.frame.size.width-40, 300)];
    v.backgroundColor=[UIColor whiteColor];
    v.layer.cornerRadius=10.0;
    Contact * contact;
    if(searchWorking == 1)
     contact  = [self personFromContact:(CNContact*)searchArr[btn.tag]];
    else
     contact = [self personFromContact:(CNContact*)_contacts[btn.tag]];
    
    UIImageView *imgv=[[UIImageView alloc]initWithFrame:CGRectMake(v.frame.size.width/2-35, 10, 70, 70)];
    imgv.layer.cornerRadius=imgv.frame.size.width/2;
    imgv.image=contact.thumb;
    imgv.layer.borderWidth=1.0;
    imgv.layer.borderColor=[UIColor lightGrayColor].CGColor;
    imgv.clipsToBounds=YES;
    [v addSubview:imgv];

    UIFont * myFont1 =[UIFont fontWithName:@"OpenSans-Bold" size:18];
    CGRect labelFrame = CGRectMake (v.frame.size.width/2-100,100 , 200, 50);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setFont:myFont1];
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.numberOfLines=2;
    label.textColor=[UIColor blackColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.backgroundColor=[UIColor clearColor];
    [label setText:[NSString stringWithFormat:@"DELETE CONTACT %@?",contact.displayName]];
    [v addSubview:label];

    UIButton *yesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    yesButton.frame = CGRectMake(20, v.frame.size.height-100, v.frame.size.width-40, 40);
    [yesButton setTitle:@"YES" forState:UIControlStateNormal];
    yesButton.layer.cornerRadius=20;
    yesButton.tag=btn.tag;
    yesButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:85/255.0 blue:35/255.0 alpha:1.0];
    [yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [yesButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:yesButton];
    
    UIButton *noButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    noButton.frame = CGRectMake(20, v.frame.size.height-50, v.frame.size.width-40, 40);
    [noButton setTitle:@"NO" forState:UIControlStateNormal];
    noButton.backgroundColor = [UIColor clearColor];
    [noButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    [noButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:noButton];
    

    [self.view addSubview:popUpDelete];
    [popUpDelete addSubview:v];
    
 
}
-(void)deleteAction:(UIButton*)btn
{
    [_contacts removeObjectAtIndex:btn.tag];
    [tablev reloadData];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_contacts];
    [[NSUserDefaults standardUserDefaults]setValue:data forKey:@"allContacts"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [popUpDelete removeFromSuperview];
}
-(void)cancelAction:(UIButton*)btn
{
    [popUpDelete removeFromSuperview];
}
-(void)editAction:(UIButton*)btn
{
    
    if(searchWorking == 1)
    {
        AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.contactid=(int)btn.tag;
        appDelegate.contactArray=searchArr;
        contactDetailViewController *smvc;
        int height = [UIScreen mainScreen].bounds.size.height;
        if (height == 480) {
            
            
            smvc =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
            
        }
        else if (height == 568) {
            
            
            smvc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
            
        }
        else if (height == 667) {
            
            
            smvc =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
            
        }
        else if (height == 736) {
            
            
            smvc =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
            
        }
        else if (height == 1024) {
            
            
            smvc =[[UIStoryboard storyboardWithName:@"ipad" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
            
        }
        else
        {
            
            
            smvc =[[UIStoryboard storyboardWithName:@"ipad2" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
            
        }
        
        [self.navigationController pushViewController:smvc animated:YES];
    }
    else
    {
        if ( _contacts.count )
        {
            AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            appDelegate.contactid=(int)btn.tag;
            appDelegate.contactArray=_contacts;
            contactDetailViewController *smvc;
            int height = [UIScreen mainScreen].bounds.size.height;
            if (height == 480) {
                
                
                smvc =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
                
            }
            else if (height == 568) {
                
                
                smvc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
                
            }
            else if (height == 667) {
                
                
                smvc =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
                
            }
            else if (height == 736) {
                
                
                smvc =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
                
            }
            else if (height == 1024) {
                
                
                smvc =[[UIStoryboard storyboardWithName:@"ipad" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
                
            }
            else
            {
                
                
                smvc =[[UIStoryboard storyboardWithName:@"ipad2" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
                
            }
            
            [self.navigationController pushViewController:smvc animated:YES];
        }
        else
        {
            if ( _contactsError ) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }
    }
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [search_bar resignFirstResponder];
    search_bar.showsCancelButton=NO;
    
    
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{    //searchWorking=0;

        search_bar.text=@"";

        return YES;
    }
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    searchWorking=0;
    search_bar.showsCancelButton=NO;
    [search_bar resignFirstResponder];
    search_bar.text=@"";
    [tablev reloadData];
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    searchArr=[NSMutableArray new];
    search_bar.showsCancelButton=YES;
    search_bar.returnKeyType=UIReturnKeyDone;
    searchWorking=1;
  
    
    return YES;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    
    searchArr=[NSMutableArray new];


//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//    dispatch_async(queue, ^(void) {

        for(int i=0;i<_contacts1.count;i++)
        {

            NSRange stringrange =[_contacts1[i] rangeOfString:searchText options:NSCaseInsensitiveSearch];

            if(stringrange.location!= NSNotFound)
            {
                [searchArr addObject:_contacts[i]];
            }
        }


//            dispatch_async(dispatch_get_main_queue(), ^{

                [tablev reloadData];

//            });

//    });
    
    
    

}
//    [self getContacts:^(NSArray *contacts, NSError *error)
//     {
//
//
//
//         _contacts = [contacts mutableCopy];
//         _contactsError = error != nil ? YES : NO;
//         NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_contacts];
//         [[NSUserDefaults standardUserDefaults]setValue:data forKey:@"allContacts"];
//         [[NSUserDefaults standardUserDefaults]synchronize];
//         [tablev reloadData];
//         NSMutableDictionary *imgDict=[NSMutableDictionary new];
//         NSString *st;//=[NSString stringWithFormat:@"image_%f.jpg", [NSDate timeIntervalSinceReferenceDate]];
//         NSString *imagePath;// = [self documentsPathForFileName:st];
//         for(int i=0;i<_contacts.count;i++)
//         {
//            // HUD.labelText=[NSString stringWithFormat:@"%d Contacts fetched",i];
//
//             Contact * _contact = [self personFromContact:(CNContact*)_contacts[i]];
//
//             if(i==0)
//             {
//                 NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"default"], 0.5);
//                 st=[NSString stringWithFormat:@"image_%f.jpg", [NSDate timeIntervalSinceReferenceDate]];
//                 imagePath = [self documentsPathForFileName:st];
//                 [imageData writeToFile:imagePath atomically:YES];
//             }
//             else
//             {
//
//             }
//             imgDict=[[[NSUserDefaults standardUserDefaults] valueForKey:@"SavedUserImages"]mutableCopy];
//             if(imgDict.count==0)
//                 imgDict=[NSMutableDictionary new];
//             [imgDict setObject:st forKey:[NSString stringWithFormat:@"%@",_contact.phones[0]]];
//             [[NSUserDefaults standardUserDefaults] setObject:imgDict forKey:@"SavedUserImages"];
//             [[NSUserDefaults standardUserDefaults] synchronize];
//         }
//         NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
//         [notificationCenter postNotificationName:@"upcomming" object:nil userInfo:nil];
//         [[UIApplication sharedApplication] setIdleTimerDisabled: false];
//
//         HUD.hidden=YES;
//     }];
//    }
@end
