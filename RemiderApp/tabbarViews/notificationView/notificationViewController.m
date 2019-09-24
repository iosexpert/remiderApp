//
//  notificationViewController.m
//  RemiderApp
//
//  Created by mac on 19/01/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import "notificationViewController.h"
#import "filtersViewController.h"
#import "AFNetworking.h"
#import "Utilities.h"
#import "MBProgressHUD.h"
#import "addNewEventViewController.h"
#import "editEventViewController.h"
@interface notificationViewController ()
{
    NSMutableArray  *eventArray;
    MBProgressHUD *HUD;
    NSMutableArray *eventArrayyyy,*upcommingArrayyyyy;
}
@end

@implementation notificationViewController
-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if([Utilities CheckInternetConnection])//0: internet working
    {
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://18.219.207.70"]];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                                path:[NSString stringWithFormat:@"/slim_api/public/notifications/show/%@",[userDefaults valueForKey:@"userid"]]
                                                          parameters:nil];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            if (JSONdata != nil) {
                
                NSError *e;
                NSMutableDictionary *JSON =
                [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                                options: NSJSONReadingMutableContainers
                                                  error: &e];
                
                if([[JSON valueForKey:@"code"]integerValue] ==1)
                {
                    eventArray=[NSMutableArray new];
                    eventArray=[JSON valueForKey:@"result"];
                    [tablev reloadData];
                    
                }
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            // HUD.hidden=YES;
            
        }];
        [operation start];
        
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=true;

    
//    NSData *data1 =[[NSUserDefaults standardUserDefaults]valueForKey:@"upcommingArrayy"];
//    upcommingArrayyyyy = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
//
//    NSData *data =[[NSUserDefaults standardUserDefaults]valueForKey:@"eventArrayy"];
//    eventArrayyyy = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
   
    //
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)filters_Action:(id)sender
{
    filtersViewController *smvc;
    int height = [UIScreen mainScreen].bounds.size.height;
    if (height == 480) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"filtersViewController"];
        
    }
    else if (height == 568) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"filtersViewController"];
        
    }
    else if (height == 667) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"filtersViewController"];
        
    }
    else if (height == 736) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"filtersViewController"];
        
    }
    else if (height == 1024) {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"ipad" bundle:nil] instantiateViewControllerWithIdentifier:@"filtersViewController"];
        
    }
    else
    {
        
        
        smvc =[[UIStoryboard storyboardWithName:@"ipad2" bundle:nil] instantiateViewControllerWithIdentifier:@"filtersViewController"];
        
    }
    
    [self.navigationController pushViewController:smvc animated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(eventArray.count==0)
    {
        return 1;
    }
    else
        return eventArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if(eventArray.count==0)
    {
        UIFont * myFont =[UIFont fontWithName:@"OpenSans-Bold" size:15];
        CGRect labelFrame1 = CGRectMake (0, 20, self.view.frame.size.width, 25);
        UILabel *label1 = [[UILabel alloc] initWithFrame:labelFrame1];
        [label1 setFont:myFont];
        label1.lineBreakMode=NSLineBreakByWordWrapping;
        label1.numberOfLines=15;
        label1.textColor=[UIColor lightGrayColor];
        label1.textAlignment=NSTextAlignmentCenter;
        label1.backgroundColor=[UIColor clearColor];
        [label1 setText:@"No Notification Found"];
        [cell addSubview:label1];
    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 89, tableView.frame.size.width,1.7)];
        [view setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:241/255.0 blue:241/255.0 alpha:1.0]];
        [cell addSubview:view];
        
        
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 70, 70)];
        img.layer.cornerRadius=10;
        img.layer.borderColor=[UIColor colorWithRed:231.0/255.0 green:231/255.0 blue:231/255.0 alpha:1.0].CGColor;
        img.layer.borderWidth=2;
        //[cell addSubview:img];
        
        UIImageView *img1=[[UIImageView alloc]initWithFrame:CGRectMake(3, 24, 20, 20)];
        img1.image=[UIImage imageNamed:@"notti"];
        img1.backgroundColor=[UIColor whiteColor];
        [cell addSubview:img1];
        
        UIFont * myFont =[UIFont fontWithName:@"OpenSans-Bold" size:15];
        CGRect labelFrame1 = CGRectMake (30, 5, self.view.frame.size.width-75, 30);
        UILabel *label1 = [[UILabel alloc] initWithFrame:labelFrame1];
        [label1 setFont:myFont];
        label1.lineBreakMode=NSLineBreakByWordWrapping;
        label1.numberOfLines=15;
        label1.textColor=[UIColor blackColor];
        label1.textAlignment=NSTextAlignmentLeft;
        label1.backgroundColor=[UIColor clearColor];
        [label1 setText:[[eventArray objectAtIndex:indexPath.row]valueForKey:@"title"]];
        [cell addSubview:label1];
        
        
        UIFont * myFont1 =[UIFont fontWithName:@"OpenSans-Regular" size:12];
        CGRect labelFrame2 = CGRectMake (30, 35, self.view.frame.size.width-75, 25);
        UILabel *label2 = [[UILabel alloc] initWithFrame:labelFrame2];
        [label2 setFont:myFont1];
        label2.lineBreakMode=NSLineBreakByWordWrapping;
        label2.numberOfLines=15;
        label2.textColor=[UIColor lightGrayColor];
        label2.textAlignment=NSTextAlignmentLeft;
        label2.backgroundColor=[UIColor clearColor];
        [label2 setText:[[eventArray objectAtIndex:indexPath.row]valueForKey:@"message"]];
        [cell addSubview:label2];
        
        

        
        UIButton *crossButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        crossButton.frame = CGRectMake(self.view.frame.size.width-40, 19, 30, 30);
        [crossButton setTitle:@"" forState:UIControlStateNormal];
        crossButton.backgroundColor = [UIColor clearColor];
        [crossButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
        crossButton.tag=indexPath.row+1;
        [crossButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [crossButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:crossButton];
        
        
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
    
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(eventArray.count==0)
//    {
//
//    }
//    else
//    {
//        NSString *idd=[[eventArray objectAtIndex:indexPath.row]valueForKey:@"eid"];
//
//        if([[[eventArray objectAtIndex:indexPath.row]valueForKey:@"type"]isEqualToString:@"Upcoming Event"])
//        {
//            NSLog(@"%@",upcommingArrayyyyy[[[upcommingArrayyyyy valueForKey:@"id"]indexOfObject:idd]]);
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:upcommingArrayyyyy[[[upcommingArrayyyyy valueForKey:@"id"]indexOfObject:idd]]];
//        [[NSUserDefaults standardUserDefaults]setValue:data forKey:@"adNewSchedule"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//
//        addNewEventViewController *smvc;
//        int height = [UIScreen mainScreen].bounds.size.height;
//        if (height == 480) {
//
//
//            smvc =[[UIStoryboard storyboardWithName:@"iphone4" bundle:nil] instantiateViewControllerWithIdentifier:@"addNewEventViewController"];
//
//        }
//        else if (height == 568) {
//
//
//            smvc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"addNewEventViewController"];
//
//        }
//        else if (height == 667) {
//
//
//            smvc =[[UIStoryboard storyboardWithName:@"iphone6" bundle:nil] instantiateViewControllerWithIdentifier:@"addNewEventViewController"];
//
//        }
//        else if (height == 736) {
//
//
//            smvc =[[UIStoryboard storyboardWithName:@"iphone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"contactDetailViewController"];
//
//        }
//        else if (height == 1024) {
//
//
//            smvc =[[UIStoryboard storyboardWithName:@"ipad" bundle:nil] instantiateViewControllerWithIdentifier:@"addNewEventViewController"];
//
//        }
//        else
//        {
//
//
//            smvc =[[UIStoryboard storyboardWithName:@"ipad2" bundle:nil] instantiateViewControllerWithIdentifier:@"addNewEventViewController"];
//
//        }
//
//        [self.navigationController pushViewController:smvc animated:YES];
//        }
//        else
//        {
//            if(eventArrayyyy.count==0)
//            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WarmerMarket" message:@"Event Already deleted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//            }
//            else
//            {
//            NSLog(@"%@",eventArrayyyy[[[eventArrayyyy valueForKey:@"id"]indexOfObject:idd]]);
//            }
//        }
//    }
//}
-(void)deleteAction:(UIButton*)btn
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Do you really want to Delete?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *logOut = [UIAlertAction actionWithTitle:@"Delete Notification" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                             {
                                 HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                 HUD.label.text=@"Please Wait";
                                 AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://18.219.207.70"]];
                                 [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
                                 [httpClient setParameterEncoding:AFFormURLParameterEncoding];
                                 
                                 NSDictionary *params=@{
                                                        @"id"    : [[eventArray objectAtIndex:(int)btn.tag-1]valueForKey:@"id"],
                                                        };
                                 
                                 NSMutableURLRequest *request = [httpClient requestWithMethod:@"Delete"
                                                                                         path:@"/slim_api/public/notifications/delete"
                                                                                   parameters:params];
                                 AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                                 [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                                     // Success response.
                                     NSLog(@"Network-Response: %@", [operation responseString]);
                                     
                                     NSString *jsonString = operation.responseString;
                                     NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                                     
                                     if (JSONdata != nil) {
                                         
                                         NSError *e;
                                         NSMutableDictionary *JSON =
                                         [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                                                         options: NSJSONReadingMutableContainers
                                                                           error: &e];
                                         HUD.hidden=YES;
                                         [eventArray removeObjectAtIndex:(int)btn.tag-1];
                                         [tablev reloadData];
                                         [self removeResult:JSON];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSHTTPURLResponse *httpResponse = [operation response];
                                     NSLog(@"Network-Response: HTTP-Status Code: %ld, Error: %@", (long)[httpResponse statusCode],
                                           error);
                                     [self removeResult:nil];        }];
                                 [httpClient enqueueHTTPRequestOperation:operation];
                                 
                             }];
    [alert addAction:cancel];
    [alert addAction:logOut];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)removeResult:(NSDictionary*)dict_Response
{
    
    HUD.hidden=YES;
    
    if (dict_Response==NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WarmerMarket" message:@"Some Issue Occur, Please Try Again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];        alert.tag=10;
        
        [alert show];
    }
    else
    {
        
        
        if([[dict_Response valueForKey:@"code"] integerValue]==1){
            
        }
    }
}
@end
