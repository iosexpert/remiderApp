//
//  AppDelegate.h
//  RemiderApp
//
//  Created by mac on 19/01/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property int contactid;
@property NSArray *contactArray;
@property NSMutableArray *occationArray;
@property () NSMutableArray* notiNewsId;
@property () BOOL notification;

@end

