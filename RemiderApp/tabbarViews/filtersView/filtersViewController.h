//
//  filtersViewController.h
//  RemiderApp
//
//  Created by mac on 20/01/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface filtersViewController : UIViewController
{
    IBOutlet UIButton *notiOnOff;
    IBOutlet UIButton *anouceOnOff;
    IBOutlet UIButton *syncOnOff;
    
    IBOutlet UIView *notiView;
    IBOutlet UIView *notiView1;

    IBOutlet UIButton *monthCheck;
    IBOutlet UIButton *weekCheck;
    IBOutlet UIButton *dayCheck;
 IBOutlet UIButton *saveButton;
}
@end
