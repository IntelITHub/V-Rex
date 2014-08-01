//
//  UserprofileViewController.m
//  MobiNesw
//77--91--102
//  Created by Snehasis Mohapatra on 1/23/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import "UserprofileViewController.h"
#import "userprofileTableCell.h"
#import "DetailfeedViewController.h"
#import "MypostsViewController.h"
#import "SearchViewController.h"
#import "CaputreViewController.h"
#import "NotificationViewController.h"
#import "EditprofileViewController.h"
#import "AccountSettingViewController.h"
#import "PostDetailViewController.h"
#import "GlobalVar.h"
#import "AppDelegate.h"
#import "TSLanguageManager.h"
#import "TSLanguageManager.h"
#import "constant.h"

@interface UserprofileViewController ()
@end

@implementation UserprofileViewController
@synthesize tableData,captuerview,searchView,editProfileimg,settingimg,backbtn;
@synthesize usernamelbl,Describtionlbl,followerslbl,followingslbl,postlbl,ueserProfileimg;
@synthesize Describtionlbl2,profiletype,Pub_profileid,editfollow,editfollowing,table,postimgArray;
@synthesize datatimeArray,descriptionArray,serviceURL;

#pragma mark - viewcontroller methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	if (!isiPad) {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            searchView=@"SearchViewController";
            captuerview=@"CaputreViewController";
        }
        else
        {
            // iPhone 5 or maybe a larger iPhone ??
            searchView=@"SearchViewIphone5";
            captuerview=@"CaputreViewControllerIphone5";
        }
	}
	else
    {
		searchView=@"SearchViewControllerIpad";
		captuerview=@"CaptureViewControllerIpad";
    }
    
    if (isiPad) {
        
    }
    else{
        if (isiPhone5) {
            if (iOS7) {
                [btnHome setFrame:CGRectMake(-1 ,522 ,70 ,50)];
                [btnSearch setFrame:CGRectMake(67 ,522 ,70 ,50)];
                [btnCamera setFrame:CGRectMake(133 ,522 ,69 ,50)];
                [btnCategory setFrame:CGRectMake(194 ,522 ,69 ,50)];
                [btnProfile setFrame:CGRectMake(255 ,522 ,69 ,50)];
            }
            else{
                [btnHome setFrame:CGRectMake(-1 ,522 ,70 ,20)];
                [btnSearch setFrame:CGRectMake(67 ,522 ,70 ,20)];
                [btnCamera setFrame:CGRectMake(133 ,522 ,69 ,20)];
                [btnCategory setFrame:CGRectMake(194 ,522 ,69 ,20)];
                [btnProfile setFrame:CGRectMake(255 ,522 ,69 ,20)];
            }
        }
        else{
            if (iOS7) {
                [btnHome setFrame:CGRectMake(-1 ,436 ,70 ,50)];
                [btnSearch setFrame:CGRectMake(67 ,436 ,70 ,50)];
                [btnCamera setFrame:CGRectMake(133 ,436 ,69 ,50)];
                [btnCategory setFrame:CGRectMake(194 ,436 ,69 ,50)];
                [btnProfile setFrame:CGRectMake(255 ,436 ,69 ,50)];
            }
            else{
                [btnHome setFrame:CGRectMake(-1 ,412 ,70 ,50)];
                [btnSearch setFrame:CGRectMake(67 ,412 ,70 ,50)];
                [btnCamera setFrame:CGRectMake(133 ,412 ,69 ,50)];
                [btnCategory setFrame:CGRectMake(194 ,412 ,69 ,50)];
                [btnProfile setFrame:CGRectMake(255 ,412 ,69 ,50)];
            }
        }
    }
    
    ueserProfileimg.layer.borderColor = [UIColor blackColor].CGColor;
    ueserProfileimg.layer.borderWidth = 5;
    //Follow websrvice call
    self.editfollow.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_follow =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FollowClicked:)];
	[self.editfollow addGestureRecognizer:tap_follow];
	[tap_follow release];
    
    //Edit Follow web sevice call
    self.editfollowing.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_folloing =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FollowingClicked:)];
	[self.editfollowing addGestureRecognizer:tap_folloing];
	[tap_folloing release];
    
    //Edit Profile
    self.editProfileimg.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_editpro =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gobackEditprfile:)];
	[self.editProfileimg addGestureRecognizer:tap_editpro];
	[tap_editpro release];
    
    //User Profile
    self.backbtn.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_backbtn =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gobackuserprfile:)];
	[self.backbtn addGestureRecognizer:tap_backbtn];
	[tap_backbtn release];
    
    //Setting
    self.settingimg.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_settngs =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Settingbtnclicked:)];
	[self.settingimg addGestureRecognizer:tap_settngs];
	[tap_settngs release];
}
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *sel_language = [prefs stringForKey:@"sel_language"];

	if([sel_language isEqualToString:@"pt"]){
		[TSLanguageManager setSelectedLanguage:kLMPortu];
	}else{
		[TSLanguageManager setSelectedLanguage:kLMEnglish];
	}
    
    //update label methods call
	[self updateLabel];
	
	GlobalVar *s_url=[GlobalVar getServiceUrl];
	serviceURL=s_url.servieurl;
	
    //initialise array
	tableData =  [[NSArray alloc]initWithObjects: nil];
	postimgArray =  [[NSArray alloc]initWithObjects: nil];
	datatimeArray =  [[NSArray alloc]initWithObjects: nil];
	descriptionArray =  [[NSArray alloc]initWithObjects: nil];
	
	if([self.profiletype isEqualToString:@"public"]){
		self.lbl_change_cover.hidden = YES;
        objAppDel.currentProfileView =self.Pub_profileid;
        
        //call websersvice
        BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
        if (isConnectionAvail) {
            [self getPublicProfileData];
        }
        else{
            DisplayAlert(NoNetworkConnection);
        }
	}
	else{
		self.lbl_change_cover.hidden = NO;
  
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
  
        objAppDel.currentProfileView  =savedMemderid;
        
        //call websrvice
        BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
        if (isConnectionAvail) {
            [self getProfileData];
        }
        else{
            DisplayAlert(NoNetworkConnection);
        }
	}
	
	self.editfollowing.hidden=YES;
	self.editProfileimg.hidden=NO;
	self.editfollow.hidden=YES;
	
	self.lbl_following_btn.hidden = YES;
	self.lbl_edit_profile_btn.hidden = NO;
	self.lbl_follow_btn.hidden = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Other methods
-(void) updateLabel
{
	self.lbl_edit_profile_btn.text = [TSLanguageManager localizedString:@"LBL_EDIT_PROFILE"];
	self.lbl_follow_btn.text = [TSLanguageManager localizedString:@"LBL_FOLLOW"];
	self.lbl_followed.text = [TSLanguageManager localizedString:@"LBL_FOLLOWERS"];
	self.lbl_following.text = [TSLanguageManager localizedString:@"LBL_FOLLOWING"];
	self.lbl_following_btn.text = [TSLanguageManager localizedString:@"LBL_FOLLOWING"];
	self.lbl_posts.text = [TSLanguageManager localizedString:@"LBL_POSTS"];
	[self.lbl_change_cover setTitle:[TSLanguageManager localizedString:@"LBL_CHANGE_COVER_IMAGE"] forState:UIControlStateNormal];
}
- (BOOL)prefersStatusBarHidden
{
	return YES;
}

#pragma mark - Action methods
- (IBAction)home_footerClicked:(id)sender {
    DetailfeedViewController *feedhomeController = [[DetailfeedViewController alloc] initWithNibName:objAppDel.detailfeedView bundle:nil]; [self.navigationController pushViewController:feedhomeController animated:YES];
}
- (IBAction)search_footerClicked:(id)sender {
    SearchViewController *searchController = [[SearchViewController alloc] initWithNibName:objAppDel.searchView bundle:nil]; [self.navigationController pushViewController:searchController animated:YES];
}
- (IBAction)caputer_footerClicked:(id)sender {
    CaputreViewController *caputreviewController = [[CaputreViewController alloc] initWithNibName:objAppDel.captureView bundle:nil]; [self.navigationController pushViewController:caputreviewController animated:YES];
}
- (IBAction)notification_footerClicked:(id)sender {
	
    NotificationViewController *notiviewController = [[NotificationViewController alloc] initWithNibName:objAppDel.notificationView bundle:nil]; [self.navigationController pushViewController:notiviewController animated:YES];
}

#pragma mark - Webservice Call methods
#pragma saveCover
- (void)saveCover {
    //alert
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
	self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[self.alert show];
    
	UIImage *ourImage=self.coverPhotoimg.image;//self.userimg;
	NSData * imageData = UIImageJPEGRepresentation(ourImage, 1.0);
	NSString *urlString = [NSString stringWithFormat:@"%@?action=setProfileCoverImage", serviceURL];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	NSMutableData *body = [NSMutableData data];
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: attachment; name=\"vCoverImage\"; filename=\"demo.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
    // Text parameter1
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
	NSString *param1 = savedMemderid;
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iMemberId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:param1] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
    // close form
	[body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
    // set request body
	[request setHTTPBody:body];
	
	[NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* receivedData, NSError* error)
	 {
         
         NSString *returnString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
         [self.alert dismissWithClickedButtonIndex:0 animated:YES];
         NSError *e = nil;
         
         id object = [NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
         id responseMessage=[object valueForKey:@"message"];
         
         NSMutableString *message=[responseMessage valueForKey:@"msg"];
         NSMutableString *success=[responseMessage valueForKey:@"success"];
         if([success integerValue] == 1){
         }
         else{
             UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_ALERT"] message:message delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
             [someError show];
             [someError release];
         }
     }];
}
#pragma Follow
- (void)FollowClicked:(UITapGestureRecognizer *)recognizer  {
    
    //alert
    self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[self.alert show];
    //activity indicator
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.center = CGPointMake(150, 100);
	[indicator startAnimating];
	[self.alert addSubview:indicator];
	
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        //    GlobalVar *obj=[GlobalVar getInstance];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
        NSString *memid=savedMemderid;
        NSString *pub_fid=self.Pub_profileid;
        
        UIImage *ourImage= [UIImage imageNamed:@"sports.png"];
        NSData * imageData = UIImageJPEGRepresentation(ourImage, 1.0);
        
        NSString *urlString = [NSString stringWithFormat:@"%@", serviceURL];
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSMutableData *body = [NSMutableData data];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: attachment; name=\"userfile\"; filename=\"demo.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Text parameter1
        NSString *param1 = memid;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iSessMemberId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param1] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Text parameter2
        NSString *param2 =pub_fid;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iProfilerId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param2] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Text parameter3
        NSString *param5 = @"setFollow";
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param5] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // set request body
        [request setHTTPBody:body];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse* response, NSData* receivedData, NSError* error)
         {
             NSString *returnString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
             
             NSError *e = nil;
             [self.alert dismissWithClickedButtonIndex:0 animated:YES];
             
             id object = [NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
             id message=[object valueForKey:@"message"];
             NSMutableString *msg=[message valueForKey:@"msg"];
	 		 NSMutableString *success=[message valueForKey:@"success"];
             
             if([success integerValue] == 1){
                 UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:msg delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 
                 [someError show];
                 [someError release];
                 self.editfollowing.hidden=NO;
                 self.editfollow.hidden=YES;
                 
                 self.lbl_following_btn.hidden = NO;
                 self.lbl_edit_profile_btn.hidden = YES;
                 self.lbl_follow_btn.hidden = YES;
             }else{
                 UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:msg delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 
                 [someError show];
                 [someError release];
             }
         }];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
}
#pragma Following
- (void)FollowingClicked:(UITapGestureRecognizer *)recognizer  {
    //alert
    self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[self.alert show];
    
    //activity indiacator
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.center = CGPointMake(150, 100);
	[indicator startAnimating];
	[self.alert addSubview:indicator];
    
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        //    GlobalVar *obj=[GlobalVar getInstance];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
        NSString *memid=savedMemderid;
        NSString *pub_fid=self.Pub_profileid;
        
        UIImage *ourImage= [UIImage imageNamed:@"sports.png"];
        NSData * imageData = UIImageJPEGRepresentation(ourImage, 1.0);
        
        //joinedString=@"http://192.168.1.41/php/videoblog/webservice?action=userRegistration&vEmail=daniel@php2india.com&vFirstName=daniel&vPassword=6d684af133efbbeb1445fe87d3a16765%20&vUsername=denim";
        NSString *urlString = [NSString stringWithFormat:@"%@", serviceURL];
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSMutableData *body = [NSMutableData data];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: attachment; name=\"userfile\"; filename=\"demo.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Text parameter1
        NSString *param1 = memid;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iSessMemberId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param1] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Text parameter2
        NSString *param2 =pub_fid;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iProfilerId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param2] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Text parameter3
        NSString *param5 = @"setUnFollow";
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param5] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // set request body
        [request setHTTPBody:body];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse* response, NSData* receivedData, NSError* error)
         {
             NSString *returnString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
             
             NSError *e = nil;
             [self.alert dismissWithClickedButtonIndex:0 animated:YES];
             
             id object = [NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
             NSMutableString *message=[object valueForKey:@"msg"];
             
             //alert
             UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:message delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
             [someError show];
             [someError release];
             
             self.editfollowing.hidden=YES;
             self.editfollow.hidden=NO;
             
             self.lbl_following_btn.hidden = YES;
             self.lbl_edit_profile_btn.hidden = YES;
             self.lbl_follow_btn.hidden = NO;
         }];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
}
#pragma PublicProfileData
-(void)getPublicProfileData{
    //alert
	self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[self.alert show];
    //activity indicator
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.center = CGPointMake(150, 100);
	[indicator startAnimating];
	[self.alert addSubview:indicator];
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
	NSString *memid=savedMemderid;
	
    NSString *pub_fid=self.Pub_profileid;

        UIImage *ourImage= [UIImage imageNamed:@"sports.png"];
        NSData * imageData = UIImageJPEGRepresentation(ourImage, 1.0);
        
        //joinedString=@"http://192.168.1.41/php/videoblog/webservice?action=userRegistration&vEmail=daniel@php2india.com&vFirstName=daniel&vPassword=6d684af133efbbeb1445fe87d3a16765%20&vUsername=denim";
        
        NSString *urlString = [NSString stringWithFormat:@"%@", serviceURL];
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSMutableData *body = [NSMutableData data];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: attachment; name=\"userfile\"; filename=\"demo.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Text parameter1
        NSString *param1 = memid;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iSessMemberId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param1] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        //Text parameter2
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iMemberId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param1] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Text parameter3
        NSString *param2 =pub_fid;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iProfilerId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param2] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Text parameter4
        NSString *param5 = @"getPublicProfile";
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param5] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // set request body
        [request setHTTPBody:body];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse* response, NSData* receivedData, NSError* error)
         {
             NSString *returnString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
             
             NSError *e = nil;
             [self.alert dismissWithClickedButtonIndex:0 animated:YES];
             
             id Responseobject = [NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
             
             id object=[Responseobject valueForKey:@"data"];
             id message=[Responseobject valueForKey:@"message"];
             id success=[message valueForKey:@"success"];
             
             if([success integerValue] == 1){
                 id feed_data=[object valueForKey:@"newsFeeds"];
                 id feed_data1=[NSJSONSerialization JSONObjectWithData:[feed_data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
                 id ob2=[feed_data1 valueForKey:@"data"];
                 id ob3=[feed_data1 valueForKey:@"message"];
                 NSString *suc_val=[[ob3 valueForKey:@"success"]stringValue];
                 NSMutableString *user_profileimg=[object valueForKey:@"vPicture"];
                 NSString *strCoverImage=[object valueForKey:@"vCoverImage"];
                 NSMutableString *user_name=[object valueForKey:@"vName"];
                 NSMutableString *Description=[object valueForKey:@"tDescription"];
                 NSMutableString *isfollowings=[object valueForKey:@"isFollowing"];
                 //             NSMutableString *match_curlogin=[object valueForKey:@"isCurrentUserLoginMatch"];
                 
                 if([isfollowings isEqualToString:@"NO"]){
                     self.editfollowing.hidden=YES;
                     self.editProfileimg.hidden=YES;
                     self.editfollow.hidden=NO;
                     
                     self.lbl_following_btn.hidden = YES;
                     self.lbl_edit_profile_btn.hidden = YES;
                     self.lbl_follow_btn.hidden = NO;
                 }
                 else{
                     self.editfollowing.hidden=NO;
                     self.editProfileimg.hidden=YES;
                     self.editfollow.hidden=YES;
                     
                     self.lbl_following_btn.hidden = NO;
                     self.lbl_edit_profile_btn.hidden = YES;
                     self.lbl_follow_btn.hidden = YES;
                 }
                 
                 if([suc_val isEqualToString:@"1"]){
                     
                     NSMutableArray *IDatetime=[ob2 valueForKey:@"dCreatedDate"];
                     NSMutableArray *IDescription=[ob2 valueForKey:@"tDescription"];
                     NSMutableArray *IUsername=[ob2 valueForKey:@"vUsername"];
                     NSMutableArray *image_url=[ob2 valueForKey:@"vFile"];
                     NSMutableArray *spostId=[ob2 valueForKey:@"iPostId"];
                     self.tableData=IUsername;
                     self.postimgArray=image_url;
                     self.datatimeArray=IDatetime;
                     self.descriptionArray=IDescription;
                     self.postId =spostId;
                     [self.table reloadData];
                 }
                 
                 if([usernamelbl isEqual: [NSNull null]] || user_name == nil){
                     usernamelbl.text=@"";
                 }else{
                     usernamelbl.text=[NSString stringWithFormat:@"%@", user_name];
                 }
                 
                 if([Description isEqual: [NSNull null]] || Description == nil){
                     Describtionlbl.text=@"";
                 }else{
                     Describtionlbl.text=[NSString stringWithFormat:@"%@", Description];
                 }
                 
                 followerslbl.text=[NSString stringWithFormat:@"%@k", [[object valueForKey:@"totalFollowers"] stringValue]];
                 followingslbl.text=[NSString stringWithFormat:@"%@k", [[object valueForKey:@"totalFollowings"] stringValue]];;
                 postlbl.text=[[object valueForKey:@"totalPostByProfiler"] stringValue];
                 
                 dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                 dispatch_async(queue, ^{
                     NSURL *url_img = [NSURL URLWithString:user_profileimg];
                     NSData *data1 = [NSData dataWithContentsOfURL:url_img];
                     NSLog(@"strCoverImage %@",strCoverImage);
                     NSURL *url_img1 = [NSURL URLWithString:strCoverImage];
                     NSData *data2 = [NSData dataWithContentsOfURL:url_img1];
                     
                     dispatch_sync(dispatch_get_main_queue(), ^{
                         ueserProfileimg.image=[UIImage imageWithData:data1];
                         self.coverPhotoimg.image=[UIImage imageWithData:data2];
                         self.coverPhotoimg.image = [self imageWithImage:self.coverPhotoimg.image scaledToWidth:self.coverPhotoimg.frame.size.width];
                     });
                 });
                 Describtionlbl2.hidden=YES;
             }
         }];
   
}
#pragma Profile data
-(void)getProfileData{
    //alert
	self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[self.alert show];
    //activity indicator
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.center = CGPointMake(150, 100);
	[indicator startAnimating];
	[self.alert addSubview:indicator];
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
	
    NSString *urlString = [NSString stringWithFormat:@"%@", serviceURL];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // Text parameter1
    NSString *param1 = savedMemderid;
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iMemberId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:param1] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Text parameter2
    NSString *param5 = @"getProfileDetails";
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:param5] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request setHTTPBody:body];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* receivedData, NSError* error)
     {
         NSString *returnString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
         
         NSError *e = nil;
         [self.alert dismissWithClickedButtonIndex:0 animated:YES];
         
         id Responseobject = [NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
         id messg=[Responseobject valueForKey:@"message"];
         
         NSString *suc_val=[[messg valueForKey:@"success"] stringValue];
         
         if([suc_val isEqualToString:@"1"]){
             
             id object=[Responseobject valueForKey:@"data"];
             id feed_data=[object valueForKey:@"newsFeeds"];
             NSLog(@" FEDS >>%@",feed_data);
             id feed_data1=[NSJSONSerialization JSONObjectWithData:[feed_data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
             id ob2=[feed_data1 valueForKey:@"data"];
             id ob3=[feed_data1 valueForKey:@"message"];
             NSLog(@"ere is data-->%@",ob3);
             NSString *suc_val1=[ob3 valueForKey:@"success"];
             if([suc_val1 integerValue] == 1){
                 NSMutableArray *IDatetime=[ob2 valueForKey:@"dCreatedDate"];
                 NSMutableArray *IDescription=[ob2 valueForKey:@"tDescription"];
                 NSMutableArray *IUsername=[ob2 valueForKey:@"vUsername"];
                 NSMutableArray *image_url=[ob2 valueForKey:@"vFile"];
                 NSMutableArray *spostId=[ob2 valueForKey:@"iPostId"];
                 
                 self.tableData=IUsername;
                 self.postimgArray=image_url;
                 self.datatimeArray=IDatetime;
                 self.descriptionArray=IDescription;
                 self.postId =spostId;
                 
                 [self.table reloadData];
             }
             NSString *user_profileimg=[object valueForKey:@"vPicture"];
             NSMutableString *user_name=[object valueForKey:@"vName"];
             NSMutableString *Description=[object valueForKey:@"tDescription"];
             NSString *strCoverImage=[object valueForKey:@"vCoverImage"];
             
             if([usernamelbl isEqual: [NSNull null]] || user_name == nil){
                 usernamelbl.text=@"";
             }else{
                 usernamelbl.text=[NSString stringWithFormat:@"%@", user_name];
             }
             
             if([Description isEqual: [NSNull null]] || Description == nil){
                 Describtionlbl.text=@"";
             }else{
                 Describtionlbl.text=[NSString stringWithFormat:@"%@", Description];
             }
             
             followerslbl.text=[NSString stringWithFormat:@"%@k", [[object valueForKey:@"totalFollowers"] stringValue]];;
             followingslbl.text=[NSString stringWithFormat:@"%@k", [[object valueForKey:@"totalFollowings"] stringValue]];;
             postlbl.text=[[object valueForKey:@"totalPostByProfiler"] stringValue];
             
             dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
             dispatch_async(queue, ^{
                 NSURL *url_img = [NSURL URLWithString:user_profileimg];
                 NSData *data1 = [NSData dataWithContentsOfURL:url_img];
                 NSLog(@"strCoverImage %@",strCoverImage);
                 NSURL *url_img1 = [NSURL URLWithString:strCoverImage];
                 NSData *data2 = [NSData dataWithContentsOfURL:url_img1];
                 
                 dispatch_sync(dispatch_get_main_queue(), ^{
                     ueserProfileimg.image=[UIImage imageWithData:data1];
                     self.coverPhotoimg.image=[UIImage imageWithData:data2];
                     self.coverPhotoimg.image = [self imageWithImage:self.coverPhotoimg.image scaledToWidth:self.coverPhotoimg.frame.size.width];
                 });
             });
             Describtionlbl2.hidden=YES;
             
         }else{
             //alert
             UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_ALERT"] message:[TSLanguageManager localizedString:@"LABEL_SOMETHING_WRONG"] delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
             
             [someError show];
             [someError release];
         }
     }];
}

#pragma mark - Gesture methods
#pragma Edit profile
- (void)gobackEditprfile:(UITapGestureRecognizer *)recognizer  {
	
    EditprofileViewController *editprfileController = [[EditprofileViewController alloc] initWithNibName:objAppDel.editProfileView bundle:nil]; [self.navigationController pushViewController:editprfileController animated:YES];
}
#pragma User Profile
- (void)gobackuserprfile:(UITapGestureRecognizer *)recognizer  {
  [self.navigationController popViewControllerAnimated:YES];
}
#pragma setting button
- (void)Settingbtnclicked:(UITapGestureRecognizer *)recognizer  {
	
    AccountSettingViewController *acController = [[AccountSettingViewController alloc] initWithNibName:objAppDel.accountSettingView bundle:nil]; [self.navigationController pushViewController:acController animated:YES];
}

#pragma mark - Tableview Delegate methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    userprofileTableCell *cell = (userprofileTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:objAppDel.userprofileTableCellView owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
   
    cell.time.text=[self.datatimeArray objectAtIndex:indexPath.row];
    cell.post_uname.text=[NSString stringWithFormat:@"@%@", [self.tableData objectAtIndex:indexPath.row]];
    cell.postDesc.text=[self.descriptionArray objectAtIndex:indexPath.row];
    

   
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
	dispatch_async(queue, ^{
		NSURL *url_img = [NSURL URLWithString:[self.postimgArray objectAtIndex:indexPath.row]];
        NSData *data1 = [NSData dataWithContentsOfURL:url_img];
		dispatch_sync(dispatch_get_main_queue(), ^{
            
			cell.postimg.image=[UIImage imageWithData:data1];
		});
	});
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     MypostsViewController *MypostsController = [[MypostsViewController alloc] initWithNibName:objAppDel.MypostsView bundle:nil];
     MypostsController.posts_id=[self.postId objectAtIndex:[indexPath row]];
     [self.navigationController pushViewController:MypostsController animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (!isiPad) {
      return 70;
	}else{
      return 90;
	}
}

#pragma mark - Actionsheet
- (IBAction)changeCoverImage:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"V-Rex" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Photo", nil];
	[actionSheet showInView:self.view];
}

#pragma mark - Actionsheet Delegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
	
	if  ([buttonTitle isEqualToString:@"Take Photo"]) {
		if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_ALERT"]
																					message:[TSLanguageManager localizedString:@"MSG_DEVICE_HAS_NO_CAMERA"]
																				  delegate:nil
																	  cancelButtonTitle:@"OK"
																	  otherButtonTitles: nil];
			
			[myAlertView show];
		}
		else{
			UIImagePickerController *picker = [[UIImagePickerController alloc] init];
			picker.delegate = self;
			picker.allowsEditing = YES;
			picker.sourceType = UIImagePickerControllerSourceTypeCamera;
			
			/*if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
				UIPopoverController *popover1 = [[UIPopoverController alloc] initWithContentViewController:picker];
				[popover1 presentPopoverFromRect:self.view.bounds inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
				self.popover = popover1;
                ;
			} else {
                [self presentViewController:picker animated:YES completion:nil];
			}*/
            [self presentViewController:picker animated:YES completion:nil];
		}
	}
	if  ([buttonTitle isEqualToString:@"Choose Photo"]) {
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.allowsEditing = YES;
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		
		[self presentViewController:picker animated:YES completion:NULL];
	}
}

#pragma  mark - Image Resize
- (CGSize) resizeOfFrameForFill:(CGSize)srcSize forBoundingSize:(CGSize)boundingSize{
    //    CGSize boundingSize = CGSizeMake(1024, 748);
    CGFloat wRatio = boundingSize.width / srcSize.width;
    CGFloat hRatio = boundingSize.height / srcSize.height;
    CGSize dstSize;
    
    if (wRatio > hRatio) {
        dstSize = CGSizeMake(boundingSize.width, floorf(srcSize.height * wRatio));
    } else {
        dstSize = CGSizeMake(floorf(srcSize.width * hRatio), boundingSize.height);
    }
    
    return dstSize;
}
- (UIImage*)imageWithImage: (UIImage *) sourceImage scaledToWidth: (float) i_width {
    
    CGSize size = [self resizeOfFrameForFill:sourceImage.size forBoundingSize:CGSizeMake(i_width, i_width)];
    
    UIGraphicsBeginImageContext(size);
    [sourceImage drawInRect:CGRectMake(0, 0, size.width,size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
+ (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height {
    CGFloat oldWidth = image.size.width;
    CGFloat oldHeight = image.size.height;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    return [self imageWithImage:image scaledToSize:newSize];
}
//
#pragma mark - ImagePickerController Delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    self.coverPhotoimg.image=chosenImage;
    self.coverPhotoimg.image = [self imageWithImage:chosenImage scaledToWidth:self.coverPhotoimg.frame.size.width];//self.coverPhotoimg.frame.size.width
    
	[picker dismissViewControllerAnimated:YES completion:NULL];
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        [self saveCover];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
}
/*
 UIImage * img = [UIImage imageNamed:@"someImage.png"];
 CGSize imgSize = img.size;
 calculate scale ratio on width
 
 float ratio=yourImageView.frame.size.width/imgSize.width;
 check scaled height (using same ratio to keep aspect)
 
 float scaledHeight=imgSize.height*ratio;
 if(scaledHeight < yourImageView.frame.size.height)
 {
 //update height of your imageView frame with scaledHeight
 }
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
