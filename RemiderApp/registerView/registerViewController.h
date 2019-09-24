//
//  registerViewController.h
//  RemiderApp
//
//  Created by mac on 19/01/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface registerViewController : UIViewController<UIImagePickerControllerDelegate>
{
    IBOutlet UIImageView *userImage;
    IBOutlet UIScrollView *scrv;
    IBOutlet UITextField *emailid_field;
    IBOutlet UITextField *name_field;
    IBOutlet UITextField *lastname_field;
    IBOutlet UITextField *birthday_field;
    IBOutlet UITextField *birthmonth_field;
    IBOutlet UITextField *birthyear_field;

    IBOutlet UITextField *phoneNo_field;
    IBOutlet UITextField *password_field;
    IBOutlet UIButton *register_button;

}
@end
