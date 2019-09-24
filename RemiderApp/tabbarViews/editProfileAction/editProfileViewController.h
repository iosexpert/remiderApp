//
//  editProfileViewController.h
//  RemiderApp
//
//  Created by mac on 03/02/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface editProfileViewController : UIViewController
{
    IBOutlet AsyncImageView *userImage;
    IBOutlet UIScrollView *scrv;
    IBOutlet UITextField *name_field;
    IBOutlet UITextField *lastname_field;
    IBOutlet UITextField *birthday_field;
    IBOutlet UITextField *birthmonth_field;
    IBOutlet UITextField *birthyear_field;
    
    IBOutlet UITextField *phoneNo_field;
    IBOutlet UIButton *submitButton;

}
@end
