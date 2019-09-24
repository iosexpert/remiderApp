//
//  selectContactViewController.h
//  RemiderApp
//
//  Created by mac on 01/02/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
@import Contacts;
@import ContactsUI;
@interface selectContactViewController : UIViewController
{
    IBOutlet UITableView *tablev;
}
- (void)didCancelContactSelection;
@end
