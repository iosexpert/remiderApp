//
//  selectContactViewController.m
//  RemiderApp
//
//  Created by mac on 01/02/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import "selectContactViewController.h"
#import "AppDelegate.h"
#import "addNewEventViewController.h"
@interface selectContactViewController ()
{
    CNContactStore * _contactStore;
    CNContactViewController *addContactVC;
}
@property (nonatomic, strong) NSArray * contacts;
@property (assign) BOOL contactsError;

@end

@implementation selectContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getContacts:^(NSArray *contacts, NSError *error) {
        _contacts = contacts;
        _contactsError = error != nil ? YES : NO;
        
        NSLog(@"%@",_contacts);
        [tablev reloadData];
    }];
}
- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact{
    [viewController dismissViewControllerAnimated:YES completion:NULL];
    //You will get the callback here
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(IBAction)Back_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    return _contacts.count ? _contacts.count : 1;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
        
        
        UILabel *phoneNo = [[UILabel alloc] initWithFrame:CGRectMake (65, 35, self.view.frame.size.width-90, 25)];
        [phoneNo setFont:[UIFont fontWithName:@"OpenSans-Regular" size:14]];
        phoneNo.lineBreakMode=NSLineBreakByWordWrapping;
        phoneNo.numberOfLines=15;
        phoneNo.textColor=[UIColor lightGrayColor];
        phoneNo.textAlignment=NSTextAlignmentLeft;
        phoneNo.backgroundColor=[UIColor clearColor];
        [phoneNo setText:_contact.phones[0]];
        [cell addSubview:phoneNo];
        
        
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
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( _contacts.count )
    {
        AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.contactid=(int)indexPath.row;
        appDelegate.contactArray=_contacts;
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
    else
    {
        if ( _contactsError ) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:name];
}
@end
