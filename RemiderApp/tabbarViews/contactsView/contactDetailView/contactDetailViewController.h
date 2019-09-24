//
//  contactDetailViewController.h
//  RemiderApp
//
//  Created by mac on 22/01/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
@import Contacts;
@import ContactsUI;
@interface contactDetailViewController : UIViewController
{
    IBOutlet UIScrollView *scrv;
    IBOutlet UITableView *tablev;
    IBOutlet UIImageView *userImage;
    IBOutlet UIImageView *emailImage;
    IBOutlet UIImageView *phoneImge;
    IBOutlet UIImageView *locationImage;
    IBOutlet UILabel *userName;
    IBOutlet UILabel *userLocation;
    IBOutlet UILabel *userPhone;
    IBOutlet UILabel *useremail;
    IBOutlet UITextView *userDetail;
}
@end
