//
//  loginViewController.h
//  RemiderApp
//
//  Created by mac on 19/01/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginViewController : UIViewController
{
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *passwordField;
    IBOutlet UIButton *loginButton;
    
}
-(IBAction)login_Action:(id)sender;
@end
