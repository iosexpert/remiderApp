//
//  webViewController.m
//  RemiderApp
//
//  Created by mac on 03/02/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import "webViewController.h"

@interface webViewController ()<UIWebViewDelegate>

@end

@implementation webViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    topLable.text=[userDefaults valueForKey:@"lbel"];
    NSURL *url;
    if([topLable.text isEqualToString: @"HELP"])
    {
        url=[NSURL URLWithString:@"http://18.219.207.70/pages/help.php"];
    }
    else
    {
        url=[NSURL URLWithString:@"http://18.219.207.70/pages/faq.php"];
    }
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    webV.delegate = self;
    webV.scalesPageToFit = YES;
    [webV loadRequest:requestObj];
    
    
    // Do any additional setup after loading the view.
}
-(IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    //HUD.hidden=YES;
    NSLog(@"finish");
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
   // HUD.hidden=YES;
    NSLog(@"Error for WEBVIEW: %@", [error description]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
