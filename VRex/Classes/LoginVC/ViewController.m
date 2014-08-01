//
//  ViewController.m
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/9/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RegistrationViewController.h"
#import "testViewController.h"
#import "DetailfeedViewController.h"
#import "CaputreViewController.h"
#import "GlobalVar.h"
#import "ForgotViewController.h"
#import <Accounts/Accounts.h>

#import "AppDelegate.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import "JSONKit.h"
#import "TSLanguageManager.h"

#import <ifaddrs.h>
#import <arpa/inet.h>
#import "constant.h"

@interface ViewController ()

@end
NSInteger twittewCallBack1 = 0;
NSString *selectedLanguage = @"en";
@implementation ViewController
@synthesize userTxtview,pwdTextview,scrollView,lbl_placehoder_user,lbl_placehoder_pwd,loginimg,registrationimg;
@synthesize viewname,responseData,alert,Detailfeedpage,indicator1,serviceURL,remembermeSwitch,standardDefaults;
@synthesize facebookloginbtnimg,twitterloginbtnimg,facebook_imgurl;
@synthesize webview = webview;

#pragma mark - viewcontroller methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (isiPad) {
        [scrollView setFrame:CGRectMake(0, 104, 768, 941)];
    }
    else{
        [scrollView setFrame:CGRectMake(0, 60, 320, 510)];
        [scrollView setContentSize:CGSizeMake(320, 480)];
    }
    
    //get ip address
	[self GetOurIpAddress];
    
	GlobalVar *service_url=[GlobalVar getServiceUrl];
	service_url.servieurl=@"http://54.191.200.49/videoblog_web/service";
	self.serviceURL=service_url.servieurl;
	userTxtview.text=@"";//@"daniel@php2india.com";
    pwdTextview.text=@"";//@"daniel123";
 
//  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//  NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
//	NSString *sel_language = [prefs stringForKey:@"sel_language"];
//	NSString *set_direct_camera = [prefs stringForKey:@"set_direct_camera"];
   
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
         self.responseData = [NSMutableData data];
        [self getCountries];
        [self getCategory];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
	
   
		//---- -- initialize facebook tab------
	self.facebookloginbtnimg.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_flogin =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(facebookLogin:)];
	[self.facebookloginbtnimg addGestureRecognizer:tab_flogin];
	[tab_flogin release];
    
		//------------twitter loging tab---------------------------
	self.twitterloginbtnimg.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_twitter =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twitterLogin:)];
	[self.twitterloginbtnimg addGestureRecognizer:tab_twitter];
	[tab_twitter release];
}
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *sel_language = [prefs stringForKey:@"sel_language"];

	if([sel_language isEqualToString:@""]){
		self.selectLang_view.layer.cornerRadius = 5;
		self.selectLang_view.layer.masksToBounds = YES;
		[self.view addSubview:self.selectLang_view];
	}
    else{
		if(sel_language == NULL){
			self.selectLang_view.layer.cornerRadius = 5;
			self.selectLang_view.layer.masksToBounds = YES;
			[self.view addSubview:self.selectLang_view];
		}
	}
	[self updateLabel];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Other methods
#pragma LoadiPhone
-(void)loadmethodIphone{
 
    [userTxtview setBorderStyle:UITextBorderStyleNone];
    [userTxtview.layer setMasksToBounds:YES];
    [userTxtview.layer setCornerRadius:6.0f];
    [userTxtview.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [userTxtview.layer setBorderWidth:1.5];
    userTxtview.textColor=[UIColor grayColor];
    [userTxtview setFont:[UIFont systemFontOfSize:16]];
    
    UIView *userpaddding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    userTxtview.leftView = userpaddding;
    userTxtview.leftViewMode = UITextFieldViewModeAlways;
    
    [pwdTextview setBorderStyle:UITextBorderStyleNone];
    [pwdTextview.layer setMasksToBounds:YES];
    [pwdTextview.layer setCornerRadius:6.0f];
    [pwdTextview.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [pwdTextview.layer setBorderWidth:1.5];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    pwdTextview.leftView = paddingView;
    pwdTextview.leftViewMode = UITextFieldViewModeAlways;
    pwdTextview.textColor=[UIColor grayColor];
    [pwdTextview setFont:[UIFont systemFontOfSize:16]];

    //-------------------placehoder for username-------------------------------
    lbl_placehoder_user = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0,userTxtview.frame.size.width - 10.0, 34.0)];
    [lbl_placehoder_user setText:[TSLanguageManager localizedString:@"LBL_EMAIL_OR_USERNAME"]];
    [lbl_placehoder_user setBackgroundColor:[UIColor clearColor]];
    [lbl_placehoder_user setTextColor:[UIColor lightGrayColor]];
    userTxtview.delegate = self;
    [userTxtview addSubview:lbl_placehoder_user];
    
    //---------place hoder for passwrod-------------------------------------------
    lbl_placehoder_pwd = [[UILabel alloc] initWithFrame:CGRectMake(7.0, 0.0,userTxtview.frame.size.width - 7.0, 42.0)];
    [lbl_placehoder_pwd setText:@"********"];
    [lbl_placehoder_pwd setBackgroundColor:[UIColor clearColor]];
    [lbl_placehoder_pwd setTextColor:[UIColor lightGrayColor]];
    pwdTextview.delegate = self;
    [pwdTextview addSubview:lbl_placehoder_pwd];
}
#pragma TwitterLogin
-(void)twitterLogin:(UITapGestureRecognizer *)recognizer{
	twittewCallBack1 = 0;
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        webview=[[UIWebView alloc]initWithFrame:CGRectMake(10, 40, result.width-20,result.height-80)];
        
        NSString *url=[NSString stringWithFormat:@"%@?action=loginWithTwitter",self.serviceURL];
        NSURL *nsurl=[NSURL URLWithString:url];
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
        self.webview.delegate = self;
        [webview loadRequest:nsrequest];
        
        self.close = [[UIButton alloc] initWithFrame:CGRectMake(result.width-40,20, 40, 40)];
        UIImage *buttonImage5 = [UIImage imageNamed:@"close.png"];
        [self.close setImage:buttonImage5 forState:UIControlStateNormal];
        
        self.close.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_close =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWebview:)];
        [self.close addGestureRecognizer:tap_close];
        [tap_close release];
        
        [self.view addSubview:webview];
        [self.view addSubview:self.close];
        [self.window makeKeyAndVisible];
        [webview release];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
}
#pragma Update Label
-(void) updateLabel
{
	self.userTxtview.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[TSLanguageManager localizedString:@"LBL_EMAIL"]];
	self.pwdTextview.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[TSLanguageManager localizedString:@"LBL_PASSWORD"]];
    
	[self.forgotpassword setTitle:[TSLanguageManager localizedString:@"FORGOT_PASSWORD_BUTTON"] forState:UIControlStateNormal];
	self.selectLang_header.text =[TSLanguageManager localizedString:@"SELECT_LANG_POP_HEADER"];
	self.selectLang_Desc.text =[TSLanguageManager localizedString:@"SELECT_LANG_POP_DESC"];
	[self.selectLang_btn_english setTitle:[TSLanguageManager localizedString:@"SELECT_LANG_POP_ENG_BTN"] forState:UIControlStateNormal];
	[self.selectLang_btn_portu setTitle:[TSLanguageManager localizedString:@"SELECT_LANG_POP_POR_BTN"] forState:UIControlStateNormal];
	[self.btn_login setTitle:[TSLanguageManager localizedString:@"LOGIN_BUTTON"] forState:UIControlStateNormal];
	[self.btn_register setTitle:[TSLanguageManager localizedString:@"REGISTER_NOW_BUTTON"] forState:UIControlStateNormal];
	
	self.label_login.text =[TSLanguageManager localizedString:@"LABEL_LOGIN"];
	self.label_remember_me.text =[TSLanguageManager localizedString:@"LABEL_REMEMBER_ME"];
	self.label_or_login_with.text =[TSLanguageManager localizedString:@"LABEL_OR_LOGIN_WITH"];
}
#pragma get IP Address
- (NSString *)GetOurIpAddress
{
	NSString *address = @"error";
	struct ifaddrs *interfaces = NULL;
	struct ifaddrs *temp_addr = NULL;
	int success = 0;
	success = getifaddrs(&interfaces);
	if (success == 0) {
        // Loop through linked list of interfaces
		temp_addr = interfaces;
		while(temp_addr != NULL) {
			if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
				if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
				}
			}
			temp_addr = temp_addr->ifa_next;
		}
	}
    // Free memory
	freeifaddrs(interfaces);
	objAppDel.deviceCurrentIP = [NSString stringWithFormat:@"%@",address];
	return address;
}
- (BOOL)prefersStatusBarHidden
{
	return YES;
}
#pragma CloseWebview
-(void)closeWebview:(UITapGestureRecognizer *)recognizer{
	self.webview.hidden = YES;
	self.close.hidden = YES;
}
#pragma NextTextField
- (void)nextTextField {
    if (userTxtview) {
        [userTxtview resignFirstResponder];
        [pwdTextview becomeFirstResponder];
    }
}
#pragma PreviousTextField
-(void)previousTextField
{
    if (pwdTextview) {
        [pwdTextview resignFirstResponder];
        [userTxtview becomeFirstResponder];
    }
}
#pragma resignKeyboard
-(void)resignKeyboard {
    [userTxtview resignFirstResponder];
    [pwdTextview resignFirstResponder];
}

#pragma mark - Action methods
- (IBAction)forgotPasswordClicked:(id)sender {
     ForgotViewController *DetailController = [[ForgotViewController alloc] initWithNibName:objAppDel.forgotView bundle:nil]; [self.navigationController pushViewController:DetailController animated:YES];
}
- (IBAction)loginClicked:(id)sender {
    //alert
    self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
    [self.alert show];
    //activity indiacator
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = CGPointMake(150, 100);
    [indicator startAnimating];
    [self.alert addSubview:indicator];

//    NSString *uname=self.userTxtview.text;
//    NSString *pwd = self.pwdTextview.text;
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        NSString *urlString = self.serviceURL;
        
        
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSMutableData *body = [NSMutableData data];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        // Text parameter1
        NSString *param1 = self.userTxtview.text;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vEmail\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param1] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param2 = self.pwdTextview.text;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vPassword\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param2] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param44 = @"REGISTER";
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"eLoginType\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param44] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param5 = @"userLogin";
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param5] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vDeviceid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:objAppDel.strDeviceId] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vType\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"IOS" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tDeviceToken\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:objAppDel.strDeviceToken] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vIP\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:objAppDel.deviceCurrentIP] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *sel_language = [prefs stringForKey:@"sel_language"];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iLangId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:sel_language] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // set request body
        [request setHTTPBody:body];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse* response, NSData* receivedData, NSError* error)
         {
             if(error){
                 [self.alert dismissWithClickedButtonIndex:0 animated:YES];
                 UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:[TSLanguageManager localizedString:@"LABEL_SOMETHING_WRONG"] delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 
                 [someError show];
                 [someError release];
             }
             else{
                 NSString *returnString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
                 [self.alert dismissWithClickedButtonIndex:0 animated:YES];
                 NSError *e = nil;
                 [self.alert dismissWithClickedButtonIndex:0 animated:YES];
                 
                 id object = [NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
                 id response_Data=[object valueForKey:@"data"];
                 id msgarr=[object valueForKey:@"message"];
                 
                 GlobalVar *obj=[GlobalVar getInstance];
                 obj.str= [response_Data valueForKey:@"iMemberId"];
                 
                 NSMutableString *message=[msgarr valueForKey:@"msg"];
                 NSMutableString *success=[msgarr valueForKey:@"success"];
                 
                 //"You are logged in"
                 if([success integerValue] == 1){
                     //				NSString *value = [[NSString alloc] initWithFormat:@"Value of Switch: %i",self.remembermeSwitch.isOn];
                     if (self.remembermeSwitch.isOn){
                         GlobalVar *obj=[GlobalVar getInstance];
                         
                         NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                         // saving an NSString
                         [prefs setObject:obj.str forKey:@"local_Memberid"];
                         NSString *vUsername= [response_Data valueForKey:@"vEmail"];
                         [prefs setObject:vUsername forKey:@"remember_username"];
                         NSString *eCameraON = [response_Data valueForKey:@"eCameraMode"];
                         NSString *iLangId = [response_Data valueForKey:@"iLangId"];
                         [prefs setObject:eCameraON forKey:@"set_direct_camera"];
                         [prefs setObject:iLangId forKey:@"sel_language"];
                         [prefs synchronize];
                         
                         if([eCameraON isEqualToString:@"ON"]){
                             CaputreViewController *caputreViewController = [[CaputreViewController alloc] initWithNibName:objAppDel.captureView bundle:nil]; [self.navigationController pushViewController:caputreViewController animated:YES];
                         }else{
                             DetailfeedViewController *DetailController = [[DetailfeedViewController alloc] initWithNibName:objAppDel.detailfeedView bundle:nil]; [self.navigationController pushViewController:DetailController animated:YES];
                         }
                     }
                     else{
                         [[NSUserDefaults standardUserDefaults]
                          setObject:@"" forKey:@"local_Memberid"];
                         [prefs setObject:@"" forKey:@"remember_username"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         //NSLog(@"null");
                     }
                 }
                 else{
                     UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:message delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                     [someError show];
                     [someError release];
                 }
             }
         }];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
}
#pragma Registration
- (IBAction)registrationClicked:(id)sender {
    //  NSLog(@"clickecd");
    RegistrationViewController *RegController = [[RegistrationViewController alloc]
                                                 initWithNibName:objAppDel.registerView bundle:nil];
    RegController.loginType1 = @"0";
    [self.navigationController pushViewController:RegController animated:YES];
}
#pragma English Language Selection
- (IBAction)englishLangSelected:(id)sender {
	selectedLanguage = @"en";
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:selectedLanguage forKey:@"sel_language"];
	[prefs synchronize];
	[TSLanguageManager setSelectedLanguage:kLMEnglish];
	[self updateLabel];
	[self.selectLang_view removeFromSuperview];
}
#pragma Portu Language Seleaction
- (IBAction)portuLangSelected:(id)sender {
	selectedLanguage = @"pt";
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:selectedLanguage forKey:@"sel_language"];
	[prefs synchronize];
	[TSLanguageManager setSelectedLanguage:kLMPortu];
	[self updateLabel];
	[self.selectLang_view removeFromSuperview];
}

#pragma mark - Repsonse Delegate methods
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
    NSError *e = nil;
  
    NSString *json = [[NSString alloc] initWithData:self.responseData  encoding:NSUTF8StringEncoding];
    
    id object = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
    NSMutableString *message=[object valueForKey:@"msg"];
	NSMutableString *success=[object valueForKey:@"success"];
    
    if([success integerValue] == 1){
		 if (self.remembermeSwitch.on){
			 GlobalVar *obj=[GlobalVar getInstance];
			 NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
				 // saving an NSString
			 [prefs setObject:obj.str forKey:@"local_Memberid"];
			 NSString *vUsername= [object valueForKey:@"vEmail"];
			 [prefs setObject:vUsername forKey:@"remember_username"];
			 [prefs synchronize];
		 }
		 else{
			 [[NSUserDefaults standardUserDefaults]
			  setObject:@"" forKey:@"local_Memberid"];
			 [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"remember_username"];
			 NSLog(@"null");
			 [[NSUserDefaults standardUserDefaults] synchronize];
		 }
          DetailfeedViewController *DetailController = [[DetailfeedViewController alloc] initWithNibName:objAppDel.detailfeedView bundle:nil]; [self.navigationController pushViewController:DetailController animated:YES];
    }
    else{
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"]  message:message delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [someError show];
        [someError release];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
     [self.responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

    NSLog(@"Connection failed! Error - %@ %@",
          
          [error localizedDescription],
          
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

#pragma mark - Facebook methods
#pragma Facebook Login
-(void)facebookLogin:(UITapGestureRecognizer *)recognizer{
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        [self flogin];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
}
-(void)flogin
{
    //alert
	self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[self.alert show];
    //activity indicator
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.center = CGPointMake(150, 100);
	[indicator startAnimating];
	[self.alert addSubview:indicator];
	
	[FBSession openActiveSessionWithReadPermissions:@[@"email",@"user_location",@"user_birthday",@"user_hometown"]
												  allowLoginUI:YES
											completionHandler:^(FBSession *session, FBSessionState state, NSError *error)
    {
												
            switch (state) {
                case FBSessionStateOpen:
                    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
                     {
                        if (error) {
                            [self.alert dismissWithClickedButtonIndex:0 animated:YES];
                        }
                        else
                             {
                                 NSArray *permissions = [NSArray arrayWithObjects:@"publish_actions", nil];
                  
                                 [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES
                                                   completionHandler:^(FBSession *session, FBSessionState state, NSError *error)
                                 {
                                                    
                                    switch (state)
                                     {
                                            case FBSessionStateOpen:
                                                [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"error:%@",error);
                                                    }
                                                    else
                                                    {
                                                        NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
                                                        NSLog(@"Success:%@",fbAccessToken);
                                                        [self.alert dismissWithClickedButtonIndex:0 animated:YES];
                                           
                                                        NSString*f_murl=@"http://graph.facebook.com/";
                                                        NSString*f_uname=user.username;
                                                        NSString*f_last=@"/picture?type=square";
                                                        NSArray *myStrings = [[NSArray alloc] initWithObjects:f_murl, f_uname,f_last, nil];
                                                        
                                                        NSString *joinedString = [myStrings componentsJoinedByString:@""];
                                                        
                                                        NSURL *url_img = [NSURL URLWithString:joinedString];
                                                        NSData *data1 = [NSData dataWithContentsOfURL:url_img];
                                                        
                                                        facebook_imgurl=joinedString;
                                                        //alert
                                                        self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
                                                        [self.alert show];
                                                        //activity indiacator
                                                        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                                                        indicator.center = CGPointMake(150, 100);
                                                        [indicator startAnimating];
                                                        [self.alert addSubview:indicator];
                                                        [indicator release];
                                                        
                                                        UIImage *ourImage=[UIImage imageWithData:data1];
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
                                                        
                                                        // Another text parameter
                                                        NSString *param5 = @"userLogin";
                                                        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[[NSString stringWithString:param5] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                                                        
                                                        // Another text parameter
                                                        NSString *param7 = @"FACEBOOK";
                                                        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"eLoginType\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[[NSString stringWithString:param7] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                                                        
                                                        // Another text parameter
                                                        NSString *param6 = facebook_imgurl;
                                                        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vPicture\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[[NSString stringWithString:param6] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                                                        
                                                        NSString *param8 = user.id;
                                                        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vFacebookId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[[NSString stringWithString:param8] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                                                        
                                                        NSString *param9 = fbAccessToken;
                                                        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tFacebookToken\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[[NSString stringWithString:param9] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                                                        
                                                        
                                                        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vDeviceid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[[NSString stringWithString:objAppDel.strDeviceId] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                                                        
                                                        
                                                        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vType\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[@"IOS" dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                                                        
                                                        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tDeviceToken\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[[NSString stringWithString:objAppDel.strDeviceToken] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                                                        
                                                        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vIP\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[[NSString stringWithString:objAppDel.deviceCurrentIP] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                                                        
                                                        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                                                        NSString *sel_language = [prefs stringForKey:@"sel_language"];
                                                        
                                                        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iLangId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[[NSString stringWithString:sel_language] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                                                        
                                                        // close form
                                                        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                                                        
                                                        // set request body
                                                        [request setHTTPBody:body];
                                                        
                                                        //return and test
                                                        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                                                        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                                                        
                                                        NSLog(@"%@", returnString);
                                                        NSError *e = nil;
                                                        
                                                        id object = [NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
                                                        id messageData=[object valueForKey:@"message"];
                                                        NSMutableString *success=[messageData valueForKey:@"success"];
//                                                        NSMutableString *message=[messageData valueForKey:@"msg"];
                                                        
                                                        if([success integerValue] == 1){
                                                            id responseDatas=[object valueForKey:@"data"];
                                                            NSMutableString *iMemberId=[responseDatas valueForKey:@"iMemberId"];
                                                         
                                                            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                                                         
                                                         // saving an NSString
                                                        [prefs setObject:iMemberId forKey:@"local_Memberid"];
                                                         
                                                         NSString *vUsername= [responseDatas valueForKey:@"vEmail"];
                                                         [prefs setObject:vUsername forKey:@"remember_username"];
                                                         
                                                         NSString *eCameraON = [responseDatas valueForKey:@"eCameraMode"];
                                                         NSString *iLangId = [responseDatas valueForKey:@"iLangId"];
                                                         [prefs setObject:eCameraON forKey:@"set_direct_camera"];
                                                         [prefs setObject:iLangId forKey:@"sel_language"];
                                                         
                                                         [prefs synchronize];
                                                         
                                                         if([eCameraON isEqualToString:@"ON"]){
                                                          CaputreViewController *caputreViewController = [[CaputreViewController alloc] initWithNibName:objAppDel.captureView bundle:nil]; [self.navigationController pushViewController:caputreViewController animated:YES];
                                                         }else{
                                                          DetailfeedViewController *DetailController = [[DetailfeedViewController alloc] initWithNibName:objAppDel.detailfeedView bundle:nil]; [self.navigationController pushViewController:DetailController animated:YES];
                                                         }
                                                        }
                                                        else{
                                                            RegistrationViewController *registerController = [[RegistrationViewController alloc] initWithNibName:objAppDel.registerView bundle:nil];
                                                         
                                                            /* NSString*f_murl=@"http://graph.facebook.com/";
                                                             NSString*f_uname=user.username;
                                                             NSString*f_last=@"/picture?type=square";
                                                             NSArray *myStrings = [[NSArray alloc] initWithObjects:f_murl, f_uname,f_last, nil];
                                                             
                                                             NSString *joinedString = [myStrings componentsJoinedByString:@""];
                                                             
                                                             NSURL *url_img = [NSURL URLWithString:joinedString];
//                                                             NSData *data1 = [NSData dataWithContentsOfURL:url_img];
                                                            */
                                                             registerController.tempsocialId1 =user.id;
                                                             registerController.tempsoicialToken1 =fbAccessToken;
                                                         
                                                             registerController.regName1=user.first_name;
                                                             registerController.regUsername1=user.username;
                                                             registerController.regEmail1=[user objectForKey:@"email"];
                                                             registerController.Fname1=user.first_name;
                                                             registerController.FUname1=user.username;
                                                             registerController.FEmail1=[user objectForKey:@"email"];
                                                             registerController.loginType1 = @"1";
                                                         
                                                            [self.navigationController pushViewController:registerController animated:YES];
                                                        }
                                                        [self.alert dismissWithClickedButtonIndex:0 animated:YES];
                                                       }
                                                      }];
                                                      break;
                                                      
                                                     case FBSessionStateClosed:
                                                     case FBSessionStateClosedLoginFailed:
                                                      [FBSession.activeSession closeAndClearTokenInformation];
                                                     break;
                                                      
                                                     default:
                                                      break;
                                    }
                                }];
                            }
                    }];
                    break;
                case FBSessionStateClosed:
                case FBSessionStateClosedLoginFailed:
                    [FBSession.activeSession closeAndClearTokenInformation];
                    break;
                default:
                    break;
                }
    }];
}
-(void)fbookRegister{
}

#pragma mark - Webservice Call
#pragma getCountry
-(void)getCountries{
    //alert
	self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[self.alert show];
    //activity indicator
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.center = CGPointMake(150, 100);
	[indicator startAnimating];
	[self.alert addSubview:indicator];
	[indicator release];
	
	NSString *urlString = [NSString stringWithFormat:@"%@?action=getCountries", serviceURL];
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"GET"];
	
	NSMutableData *body = [NSMutableData data];
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
    // set request body
	[request setHTTPBody:body];
	
	[NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* receivedData, NSError* error)
	 {
         NSString *returnString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
         [self.alert dismissWithClickedButtonIndex:0 animated:YES];
         NSError *e = nil;
         [self.alert dismissWithClickedButtonIndex:0 animated:YES];
         
         id object = [NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
         id responseMessage=[object valueForKey:@"message"];
         
//         NSMutableString *msg=[responseMessage valueForKey:@"msg"];
         NSString *success=[responseMessage valueForKey:@"success"];
         
         if([success integerValue] == 1){
//             NSArray *responseDatas=[object valueForKey:@"data"];
//             NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:responseDatas];
             NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
             [prefs setObject:returnString forKey:@"countryData"];
             [prefs synchronize];
             objAppDel.countryStr = [NSString stringWithFormat:@"%@",returnString];
         }
         else{
//             UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_ALERT"]  message:msg delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
             //[someError show];
             //[someError release];
         }
         //call webservice
         BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
         if (isConnectionAvail) {
             [self getStates];
         }
         else{
             DisplayAlert(NoNetworkConnection);
         }
	 }];
}
#pragma getStates
-(void)getStates{
    //alert
	self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[self.alert show];
    //activity indiacator
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.center = CGPointMake(150, 100);
	[indicator startAnimating];
	[self.alert addSubview:indicator];
	[indicator release];
	
	NSString *urlString = [NSString stringWithFormat:@"%@?action=getState", serviceURL];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"GET"];
	
	NSMutableData *body = [NSMutableData data];
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
    // set request body
	[request setHTTPBody:body];
	
	[NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* receivedData, NSError* error)
	 {
         NSString *returnString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
         [self.alert dismissWithClickedButtonIndex:0 animated:YES];
         NSError *e = nil;
         [self.alert dismissWithClickedButtonIndex:0 animated:YES];
         
         id object = [NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
         id responseMessage=[object valueForKey:@"message"];
         
//         NSMutableString *msg=[responseMessage valueForKey:@"msg"];
         NSString *success=[responseMessage valueForKey:@"success"];
         
         if([success integerValue] == 1){
//             NSArray *responseDatas=[object valueForKey:@"data"];
//             NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:responseDatas];
             NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
             [prefs setObject:returnString forKey:@"stateData"];
             [prefs synchronize];
             objAppDel.stateStr = [NSString stringWithFormat:@"%@",returnString];
             [self.alert dismissWithClickedButtonIndex:0 animated:YES];
         }
         else{
//             UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_ALERT"] message:msg delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
             
             //[someError show];
             //[someError release];
         }
         
         NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
         NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
         NSString *remember_username = [prefs stringForKey:@"remember_username"];
         
         NSString *set_direct_camera = [prefs stringForKey:@"set_direct_camera"];
         NSLog(@"set_direct_camera %@",set_direct_camera);
         NSLog(@"Username %@",remember_username);
         if([savedMemderid intValue] > 0){
             self.userTxtview.text = remember_username;
         }
	 }];
}
#pragma category
-(void)getCategory{
	GlobalVar *gobal_service=[GlobalVar getServiceUrl];
//	GlobalVar *gobal_memid=[GlobalVar getInstance];
    
	NSString *urlString = [NSString stringWithFormat:@"%@?action=getCategories", gobal_service.servieurl];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"GET"];
	
	NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    // set request body
	[request setHTTPBody:body];
	
	[NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* receivedData, NSError* error)
	 {
         NSString *returnString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
         NSError *e = nil;
         id object = [NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
         id responseMessage=[object valueForKey:@"message"];
//         NSMutableString *msg=[responseMessage valueForKey:@"msg"];
         NSString *success=[responseMessage valueForKey:@"success"];
         
         if([success integerValue] == 1){
//             NSArray *responseDatas=[object valueForKey:@"data"];
//             NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:responseDatas];
             NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
             [prefs setObject:returnString forKey:@"categoryData"];
             [prefs synchronize];
             objAppDel.categoryStr = [NSString stringWithFormat:@"%@",returnString];
         }
         else{
//             NSLog(@"error");
//             UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_ALERT"] message:msg delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
             //[someError show];
             //[someError release];
         }
	 }];
}
#pragma Login Data
-(void)callLoginData{
    //alert
	self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[self.alert show];
    //activity indicator
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.center = CGPointMake(150, 100);
	[indicator startAnimating];
	[self.alert addSubview:indicator];
	[indicator release];
	
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        NSString *urlString = [NSString stringWithFormat:@"%@?action=getProfileDetails", serviceURL];
        //e?action=getPosts&iCategoryId=65
        
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSMutableData *body = [NSMutableData data];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
        
        // Text parameter1
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
             [self.alert dismissWithClickedButtonIndex:0 animated:YES];
             
             id object = [NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
             id responseMessage=[object valueForKey:@"message"];
             
             NSString *success=[responseMessage valueForKey:@"success"];
             NSMutableString *message=[responseMessage valueForKey:@"msg"];
             if([success integerValue] == 1){
                 id responseDatas=[object valueForKey:@"data"];
                 
                 NSString *eCameraON = [responseDatas valueForKey:@"eCameraMode"];
                 NSString *iLangId = [responseDatas valueForKey:@"iLangId"];
                 [prefs setObject:eCameraON forKey:@"set_direct_camera"];
                 [prefs setObject:iLangId forKey:@"sel_language"];
                 [prefs synchronize];
                 
                 if([eCameraON isEqualToString:@"ON"]){
                     CaputreViewController *caputreViewController = [[CaputreViewController alloc] initWithNibName:objAppDel.captureView bundle:nil]; [self.navigationController pushViewController:caputreViewController animated:YES];
                 }else{
                     DetailfeedViewController *DetailController = [[DetailfeedViewController alloc] initWithNibName:objAppDel.detailfeedView bundle:nil]; [self.navigationController pushViewController:DetailController animated:YES];
                 }
             }
             else{
                 UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_ALERT"] message:message delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 [someError show];
                 [someError release];
             }
         }];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
}

#pragma mark - webview Delegate methods
-(void)webViewDidFinishLoad:(UIWebView *)webView {
	if(twittewCallBack1 == 1){
		NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('pre')[0].innerHTML"];
		NSDictionary *myDictionary = [html objectFromJSONString];
		id responseMessage=[myDictionary valueForKey:@"data"];
		
		NSMutableString *vUsername=[responseMessage valueForKey:@"vUsername"];
		NSMutableString *tTwitterToken=[responseMessage valueForKey:@"tTwitterToken"];
		NSMutableString *vTwitterId=[responseMessage valueForKey:@"vTwitterId"];
		//alert
		self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
		[self.alert show];
        //activity indicator
		UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		indicator.center = CGPointMake(150, 100);
		[indicator startAnimating];
		[self.alert addSubview:indicator];
		[indicator release];

        BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
        if (isConnectionAvail) {
            // NSString *urlString = @"http://192.168.1.41/php/videoblog/webservice";
            NSString *urlString = [NSString stringWithFormat:@"%@", serviceURL];
            NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
            [request setURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            
            NSMutableData *body = [NSMutableData data];
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
            [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
            
            // Another text parameter
            NSString *param5 = @"userLogin";
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param5] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            // Another text parameter
            NSString *param7 = @"TWITTER";
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"eLoginType\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param7] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSString *param8 = vTwitterId;
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vTwitterId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param8] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSString *param9 = tTwitterToken;
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tTwitterToken\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param9] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSString *param10 = vTwitterId;
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vUsername\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param10] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSString *param11 = vTwitterId;
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vName\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param11] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vDeviceid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:objAppDel.strDeviceId] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vType\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"IOS" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tDeviceToken\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:objAppDel.strDeviceToken] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vIP\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:objAppDel.deviceCurrentIP] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSString *sel_language = [prefs stringForKey:@"sel_language"];
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iLangId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:sel_language] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            // close form
            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // set request body
            [request setHTTPBody:body];
            
            //return and test
            NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            
            NSError *e = nil;
            
            id object = [NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
            id messageData=[object valueForKey:@"message"];
            NSMutableString *message=[messageData valueForKey:@"success"];
            //		NSString *messagestr=[messageData valueForKey:@"msg"];
            
            if([message integerValue] == 1){
                id responseDatas=[object valueForKey:@"data"];
                //GlobalVar *obj=[GlobalVar getInstance];
                NSMutableString *iMemberId=[responseDatas valueForKey:@"iMemberId"];
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                // saving an NSString
                [prefs setObject:iMemberId forKey:@"local_Memberid"];
                NSString *vUsername= [responseDatas valueForKey:@"vEmail"];
                
                [prefs setObject:vUsername forKey:@"remember_username"];
                NSString *eCameraON = [responseDatas valueForKey:@"eCameraMode"];
                NSString *iLangId = [responseDatas valueForKey:@"iLangId"];
                [prefs setObject:eCameraON forKey:@"set_direct_camera"];
                [prefs setObject:iLangId forKey:@"sel_language"];
                [prefs synchronize];
                
                if([eCameraON isEqualToString:@"ON"]){
                    CaputreViewController *caputreViewController = [[CaputreViewController alloc] initWithNibName:objAppDel.captureView bundle:nil]; [self.navigationController pushViewController:caputreViewController animated:YES];
                }else{
                    DetailfeedViewController *DetailController = [[DetailfeedViewController alloc] initWithNibName:objAppDel.detailfeedView bundle:nil]; [self.navigationController pushViewController:DetailController animated:YES];
                }
            }
            else{
                RegistrationViewController *registerController = [[RegistrationViewController alloc] initWithNibName:objAppDel.registerView bundle:nil];
                registerController.twID1 =vTwitterId;
                registerController.twToken1 =tTwitterToken;
                registerController.twUsername1 =vUsername;
                
                registerController.loginType1 =@"2";
                [self.navigationController pushViewController:registerController animated:YES];
            }
            [self.alert dismissWithClickedButtonIndex:0 animated:YES];
            
            self.webview.hidden = YES;
            self.close.hidden = YES;
        }
        else{
            DisplayAlert(NoNetworkConnection);
        }
	}
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSString *URLString = [[request URL] absoluteString];
	if ([URLString rangeOfString:@"action=callBackTwitter"].location != NSNotFound) {
		if ([URLString rangeOfString:@"oauth_token="].location == NSNotFound) {
		} else {
			twittewCallBack1 = 1;
		}
	}

	return YES;
}

#pragma mark - TextField Delegate methods
-(BOOL)textFieldShouldBeginEditing: (UITextField *)textField
{
     CGSize result = [[UIScreen mainScreen] bounds].size;
     UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, result.width, 50)];
     
     keyboardToolBar.barStyle = UIBarStyleDefault;
     [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                 [[UIBarButtonItem alloc]initWithTitle:[TSLanguageManager localizedString:@"LBL_PREV"] style:UIBarButtonItemStyleBordered target:self action:@selector(previousTextField)],
                                 
                                 [[UIBarButtonItem alloc] initWithTitle:[TSLanguageManager localizedString:@"LBL_NEXT"] style:UIBarButtonItemStyleBordered target:self action:@selector(nextTextField)],
                                 [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                 nil]];
     textField.inputAccessoryView = keyboardToolBar;
     return true;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
 //------for scrolling view when keyboardshows
	if(textField == userTxtview){
		[scrollView setContentOffset:CGPointMake(0, 80)];
        lbl_placehoder_user.hidden = YES;
	}
	else if(textField==pwdTextview){
        if (!isiPhone5) {
            [scrollView setContentOffset:CGPointMake(0, 95)];
        }
        lbl_placehoder_pwd.hidden = YES;
    }
	else
    {
    }
}
- (BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
    [userTxtview resignFirstResponder];
    [pwdTextview resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
     if ([userTxtview.text length]==0) {
      lbl_placehoder_user.hidden = NO;
     }
     if ([pwdTextview.text length]==0) {
      lbl_placehoder_pwd.hidden = NO;
     }
     [UIView animateWithDuration:0.25 animations:^{
      [scrollView setContentSize:CGSizeMake(320, 480)];
      [scrollView setContentOffset:CGPointMake(0, 0)];
     }];
}

@end
