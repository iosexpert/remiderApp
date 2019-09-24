//
//  customMemeViewController.h
//  RemiderApp
//
//  Created by mac on 30/01/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customMemeViewController : UIViewController<UIImagePickerControllerDelegate,UITextViewDelegate>
{
    IBOutlet UIImageView *selectedImage;

    IBOutlet UIButton *btn1;
    IBOutlet UIButton *btn2;
    IBOutlet UIButton *btn3;
}
@end
