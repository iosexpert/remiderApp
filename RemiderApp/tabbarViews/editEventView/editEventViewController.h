//
//  editEventViewController.h
//  RemiderApp
//
//  Created by mac on 07/02/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface editEventViewController : UIViewController
{
    IBOutlet UITextField *occationField;
    IBOutlet UITextField *birthDayField;
    IBOutlet UITextField *birthMonthFeild;
    IBOutlet UITextField *birthTimeFeild;

    IBOutlet UIImageView *userImage;
    IBOutlet UILabel *userName;
    IBOutlet UIScrollView *scrv;
    IBOutlet UIButton *memeBtn;
    IBOutlet UIButton *cardBtn;
    IBOutlet UIButton *gifBtn;
    IBOutlet UIButton *favorateBtn;
    IBOutlet UIButton *textBtn;

    IBOutlet UISearchBar *search_bar;
    
}
@end
