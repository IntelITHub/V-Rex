//
//  ForgotViewController.m
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 2/10/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import "ForgotViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "TSLanguageManager.h"
#import "GlobalVar.h"
#import "constant.h"

@interface ForgotViewController ()

@end

@implementation ForgotViewController
@synthesize forgot_txt;
@synthesize responseData;
@synthesize spinner_cmplist;
@synthesize lbl_placehoder_forgotpassword;

#pragma mark - viewcontroller methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.responseData = [NSMutableData data];
    if (isiPad) {
        
    }
    else{
        if (isiPhone5) {
            
        }
        else{
            [scrollVW setFrame:CGRectMake(0, 145, 320, 450)];
        }
  
    }
    [forgot_txt setBorderStyle:UITextBorderStyleNone];
    [forgot_txt.layer setMasksToBounds:YES];
    [forgot_txt.layer setCornerRadius:6.0f];
    [forgot_txt.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [forgot_txt.layer setBorderWidth:1.5];
    forgot_txt.textColor=[UIColor grayColor];
    [forgot_txt setFont:[UIFont systemFontOfSize:16]];
    
    UIView *userpaddding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    forgot_txt.leftView = userpaddding;
    forgot_txt.leftViewMode = UITextFieldViewModeAlways;
    
    lbl_placehoder_forgotpassword = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0,forgot_txt.frame.size.width - 10.0, 34.0)];
    [lbl_placehoder_forgotpassword setText:@"Email "];
    [lbl_placehoder_forgotpassword setBackgroundColor:[UIColor clearColor]];
    [lbl_placehoder_forgotpassword setTextColor:[UIColor lightGrayColor]];
    forgot_txt.delegate = self;
    [forgot_txt addSubview:lbl_placehoder_forgotpassword];
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
	[self updateLabel];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Other methods
-(void) updateLabel
{
	[self.lbl_send setTitle:[TSLanguageManager localizedString:@"LBL_SEND"] forState:UIControlStateNormal];
	self.lbl_fogot.text =[TSLanguageManager localizedString:@"FORGOT_PASSWORD_BUTTON"];
}
- (BOOL)prefersStatusBarHidden
{
	return YES;
}

#pragma mark - Action methods
- (IBAction)gotoLoginPageClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - webservice call
- (IBAction)submitClicked:(id)sender {
    NSString *for_email=forgot_txt.text;
    if([for_email isEqualToString:@""]){
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:[TSLanguageManager localizedString:@"MSG_ENTER_EMAIL_ID"] delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [someError show];
        [someError release];
    }
    else{
        BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
        if (isConnectionAvail) {
            GlobalVar *s_url=[GlobalVar getServiceUrl];
            //serviceURL=s_url.servieurl;
            NSString *url1=[NSString stringWithFormat:@"%@?action=forgotPassword&vEmail=", s_url.servieurl];
            NSString *url2=for_email;
            NSString *url3=[url1 stringByAppendingString:url2];
            NSURL *myURL = [NSURL URLWithString:url3];
            
            NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
            
            [NSURLConnection connectionWithRequest:myRequest delegate:self];
            
            self.spinner_cmplist = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 225, 30, 40)];
            [self.spinner_cmplist setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
            self.spinner_cmplist.color = [UIColor redColor];
            [self.view addSubview:self.spinner_cmplist];
            [self.spinner_cmplist startAnimating];
        }
        else{
            DisplayAlert(NoNetworkConnection);
        }
    }
}

#pragma mark - Textfield delegate methods
- (BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
    [forgot_txt resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
	lbl_placehoder_forgotpassword.hidden=YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([lbl_placehoder_forgotpassword.text length]==0) {
        lbl_placehoder_forgotpassword.hidden = NO;
    }
}

#pragma mark - Response Delegate methods
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.spinner_cmplist startAnimating];
    [self.spinner_cmplist removeFromSuperview];

    NSError *e = nil;
    
    NSString *json = [[NSString alloc] initWithData:self.responseData  encoding:NSUTF8StringEncoding];
    
    id responseobject = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
    id object=[responseobject valueForKey:@"message"];
    
    NSMutableString *message=[object valueForKey:@"msg"] ;
    NSString *suc_msg=[[object valueForKey:@"success"]stringValue];
    
     if([suc_msg isEqualToString:@"1"]){
         UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:message delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
         [someError show];
         [someError release];
     [self.navigationController popViewControllerAnimated:YES];
    }
     else{
         UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:message delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
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
    // inform the user
    [self.spinner_cmplist startAnimating];
    [self.spinner_cmplist removeFromSuperview];
    NSLog(@"Connection failed! Error - %@ %@",
          
          [error localizedDescription],
          
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
}

@end
