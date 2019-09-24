//
//  settingViewController.m
//  RemiderApp
//
//  Created by mac on 19/01/18.
//  Copyright © 2018 RohitMahajan. All rights reserved.
//

#import "settingViewController.h"
#import "filtersViewController.h"
#import "AFNetworking.h"
#import "Utilities.h"
#import "MBProgressHUD.h"
@interface settingViewController ()
{
    NSMutableArray  *eventArray;
    MBProgressHUD *HUD;
}
@end

@implementation settingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=true;

}
-(void)viewWillAppear:(BOOL)animated
{
    [self callAllTheSchdules];
}
-(void)callAllTheSchdules
{
    
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        if([Utilities CheckInternetConnection])//0: internet working
        {
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://18.219.207.70"]];
            NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                                    path:[NSString stringWithFormat:@"/slim_api/public/event/history/%@",[userDefaults valueForKey:@"userid"]]
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
    return 110;
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
        [label1 setText:@"No History Found"];
        [cell addSubview:label1];
    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 109, tableView.frame.size.width,1.7)];
        [view setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:241/255.0 blue:241/255.0 alpha:1.0]];
        [cell addSubview:view];
        
        
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 70, 70)];
        img.layer.cornerRadius=10;
        img.layer.borderColor=[UIColor colorWithRed:231.0/255.0 green:231/255.0 blue:231/255.0 alpha:1.0].CGColor;
        img.layer.borderWidth=2;
        [cell addSubview:img];
        
        UIImageView *img1=[[UIImageView alloc]initWithFrame:CGRectMake(20+35-7.5, 6, 15, 15)];
        img1.image=[UIImage imageNamed:@"gift"];
        img1.backgroundColor=[UIColor whiteColor];
        [cell addSubview:img1];
        
        UIFont * myFont =[UIFont fontWithName:@"OpenSans-Bold" size:25];
        CGRect labelFrame1 = CGRectMake (0, 8, 70, 30);
        UILabel *label1 = [[UILabel alloc] initWithFrame:labelFrame1];
        [label1 setFont:myFont];
        label1.lineBreakMode=NSLineBreakByWordWrapping;
        label1.numberOfLines=15;
        label1.textColor=[UIColor blackColor];
        label1.textAlignment=NSTextAlignmentCenter;
        label1.backgroundColor=[UIColor clearColor];
        [label1 setText:[[eventArray objectAtIndex:indexPath.row]valueForKey:@"day"]];
        [img addSubview:label1];
        
        
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM"];
        NSDate* myDate = [dateFormatter dateFromString:[[eventArray objectAtIndex:indexPath.row]valueForKey:@"month"]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMMM"];
        NSString *stringFromDate = [formatter stringFromDate:myDate];
        
        UILabel *monthLbl = [[UILabel alloc] initWithFrame:CGRectMake (0, 35, 70, 18)];
        [monthLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:12]];
        monthLbl.lineBreakMode=NSLineBreakByWordWrapping;
        monthLbl.numberOfLines=15;
        monthLbl.textColor=[UIColor blackColor];
        monthLbl.textAlignment=NSTextAlignmentCenter;
        monthLbl.backgroundColor=[UIColor clearColor];
        [monthLbl setText:[stringFromDate capitalizedString]];
        [img addSubview:monthLbl];
        
        
        NSAttributedString *attributedText =
        [[NSAttributedString alloc] initWithString:[[eventArray objectAtIndex:indexPath.row]valueForKey:@"name"]
                                        attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans-Bold" size:12]}];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){250, CGFLOAT_MAX}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake (110, 15, size.width+10, 20)];
        [nameLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:12]];
        nameLbl.lineBreakMode=NSLineBreakByWordWrapping;
        nameLbl.layer.borderWidth=1.5;
        nameLbl.layer.borderColor=[UIColor colorWithRed:231.0/255.0 green:231/255.0 blue:231/255.0 alpha:1.0].CGColor;
        nameLbl.layer.cornerRadius=10;
        nameLbl.textColor=[UIColor blackColor];
        nameLbl.textAlignment=NSTextAlignmentCenter;
        nameLbl.backgroundColor=[UIColor clearColor];
        [nameLbl setText:[[eventArray objectAtIndex:indexPath.row]valueForKey:@"name"]];
        [cell addSubview:nameLbl];
        
        
        UILabel *birthdayLbl = [[UILabel alloc] initWithFrame:CGRectMake (110, 40, 180, 45)];
        [birthdayLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:13]];
        birthdayLbl.textColor=[UIColor blackColor];
        birthdayLbl.textAlignment=NSTextAlignmentLeft;
        birthdayLbl.backgroundColor=[UIColor clearColor];
        birthdayLbl.lineBreakMode=NSLineBreakByWordWrapping;
        birthdayLbl.numberOfLines=2;
        [birthdayLbl setText:[NSString stringWithFormat:@"%@'S %@",[[[eventArray objectAtIndex:indexPath.row]valueForKey:@"name"]uppercaseString],[[[eventArray objectAtIndex:indexPath.row]valueForKey:@"type"]uppercaseString]] ];
        [cell addSubview:birthdayLbl];
        
        UIButton *crossButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        crossButton.frame = CGRectMake(self.view.frame.size.width-40, 16, 35, 35);
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
-(void)deleteAction:(UIButton*)btn
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Do you really want to Delete?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *logOut = [UIAlertAction actionWithTitle:@"Delete Post" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
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
                                                                                         path:@"/slim_api/public/event/delete"
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
