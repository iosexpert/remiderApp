//
//  contactsViewController.h
//  RemiderApp
//
//  Created by mac on 19/01/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
@import Contacts;
@import ContactsUI;
@interface contactsViewController : UIViewController
{
    IBOutlet UISearchBar *search_bar;
    IBOutlet UITableView *tablev;
}
- (void)didCancelContactSelection;
@property (atomic, assign) BOOL canceled;


@end
