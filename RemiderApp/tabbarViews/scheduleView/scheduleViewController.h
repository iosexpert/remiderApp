//
//  scheduleViewController.h
//  RemiderApp
//
//  Created by mac on 19/01/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Contact.h"
@import Contacts;
@import ContactsUI;
@interface scheduleViewController : UIViewController
{
    IBOutlet UIButton *scheduleButton;
    IBOutlet UIButton *upcommingButton;
    IBOutlet UITableView *tablev;

}
- (void)didCancelContactSelection;
@end
