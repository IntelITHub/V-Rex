//
//  ViewController.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/9/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>

@interface ViewController : UIViewController<UITextFieldDelegate,UIWebViewDelegate>
{
        IBOutlet UITextField *userTxtview;
        IBOutlet UITextField *pwdTextview;
        IBOutlet UIScrollView *scrollView;
        IBOutlet  UILabel *lbl_placehoder_user;
        IBOutlet  UILabel *lbl_placehoder_pwd;
        IBOutlet UIImageView *loginimg;
        IBOutlet UIImageView *registrationimg;
}

@property(nonatomic,retain)NSUserDefaults *standardDefaults;
@property(nonatomic,retain)NSMutableData *responseData;
@property(nonatomic,retain)NSString *viewname;
@property(nonatomic,retain)IBOutlet UIImageView *loginimg;
@property(nonatomic,retain)IBOutlet UIImageView *registrationimg;
@property(nonatomic,retain)IBOutlet  UILabel *lbl_placehoder_pwd;
@property(nonatomic,retain) UILabel *lbl_placehoder_user;
@property(nonatomic,retain)IBOutlet UITextField *pwdTextview;
@property(nonatomic,retain)IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain)IBOutlet UITextField *userTxtview;
@property (nonatomic,retain)UIAlertView *alert;
@property(nonatomic,retain)NSString *Detailfeedpage;
@property(nonatomic,retain) UIActivityIndicatorView *indicator1;
@property(nonatomic,retain)NSString *serviceURL;
@property(nonatomic,retain)IBOutlet UISwitch *remembermeSwitch;
@property(nonatomic,retain)NSString *loc_mid;
@property(nonatomic,retain)IBOutlet UIImageView *facebookloginbtnimg;
@property(nonatomic,retain)IBOutlet UIImageView *twitterloginbtnimg;
@property(nonatomic,retain)NSString *facebook_imgurl;

@property (strong, nonatomic)IBOutlet UIView *selectLang_view;
@property (strong, nonatomic)IBOutlet UILabel *selectLang_header;
@property (strong, nonatomic)IBOutlet UILabel *selectLang_Desc;
@property (strong, nonatomic)IBOutlet UIButton *selectLang_btn_english;
@property (strong, nonatomic)IBOutlet UIButton *selectLang_btn_portu;

@property (strong, nonatomic)IBOutlet UIButton *btn_login;
@property (strong, nonatomic)IBOutlet UIButton *btn_register;
@property (strong, nonatomic)IBOutlet UILabel *label_login;
@property (strong, nonatomic)IBOutlet UILabel *label_remember_me;
@property (strong, nonatomic)IBOutlet UILabel *label_or_login_with;

@property (strong, nonatomic) UIWindow *	window;
@property (strong, nonatomic) UIWebView *webview;
@property (strong, nonatomic) UIButton *close;
@property (strong, nonatomic)IBOutlet UIButton *forgotpassword;

//other method
//-(void)loadmethodIpad;
-(void)loadmethodIphone;
//action methods
- (IBAction)forgotPasswordClicked:(id)sender;

@end

/*
 //-------------------placehoder for username-------------------------------
 lbl_placehoder_user = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0,userTxtview.frame.size.width - 20.0, 70.0)];
 [lbl_placehoder_user setText:@"Email Or UserName"];
 [lbl_placehoder_user setBackgroundColor:[UIColor clearColor]];
 [lbl_placehoder_user setTextColor:[UIColor lightGrayColor]];
 [lbl_placehoder_user setFont:[UIFont systemFontOfSize:23]];
 userTxtview.delegate = self;
*/