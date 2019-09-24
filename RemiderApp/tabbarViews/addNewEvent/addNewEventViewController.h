//
//  addNewEventViewController.h
//  RemiderApp
//
//  Created by mac on 23/01/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
@import Contacts;
@import ContactsUI;
@interface addNewEventViewController : UIViewController
{
    IBOutlet UITextField *occationField;
    IBOutlet UITextField *birthDayField;
    IBOutlet UITextField *birthMonthFeild;
    IBOutlet UIImageView *userImage;
    IBOutlet UILabel *userName;
    IBOutlet UIScrollView *scrv;
    IBOutlet UIButton *memeBtn;
    IBOutlet UIButton *cardBtn;
    IBOutlet UIButton *gifBtn;
    IBOutlet UIButton *favorateBtn;
    IBOutlet UIButton *textBtn;

    IBOutlet UITextField *birthTimeFeild;

    IBOutlet UISearchBar *search_bar;

}
@end
