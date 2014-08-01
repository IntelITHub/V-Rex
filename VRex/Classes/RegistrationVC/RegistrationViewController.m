//
//  RegistrationViewController.m
//  MobiNesw
//   vFirstName
//vName
//  Created by Snehasis Mohapatra on 1/9/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import "RegistrationViewController.h"
#import "testViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DetailfeedViewController.h"
#import "AppDelegate.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "JSONKit.h"
#import <Social/Social.h>
#import "GlobalVar.h"
#import "TSLanguageManager.h"
#import "constant.h"

#define kOAuthConsumerKey @"ct3IXFnfUicdvFPbVGN5jg"
#define kOAuthConsumerSecret   @"AD0RAHWWaJv9gf0GZsXlNgPNMNCywkSdVvr5upDVHg"
@interface RegistrationViewController (){

}
@end

//intialise variables
NSInteger rotation = 0;
NSInteger currentrotation = 0;
NSInteger twittewCallBack = 0;
NSInteger loginType = 0;
NSInteger currentField = 0;

@implementation RegistrationViewController
@synthesize webview = webview;
@synthesize accountStore,fbToken,fbID,twID,twToken,twUsername,tempsocialId1,tempsoicialToken1,user_round_img1,regName1;
@synthesize regUsername1,regEmail1,Fname1,FUname1,FEmail1,loginType1,username_placeholder,Name_placeholder,email_placeholder,password_placeholder;
@synthesize cnf_placeholder,user_round_img,takePhotoimg,popupView,popupView_Location,signUpImg,AccptTCImg;
@synthesize DontAcceptTCImg,popupView_contain,popupView_Location_contain,Accpt_location_Img,DontAccep_location_Img,userimg;
@synthesize alert,responseData,backbtnimg,facebookloginbtnimg,twitterloginbtnimg,accountsArray,FEmail,Fname,FUname;
@synthesize facebook_imgurl,popover,serviceURL;

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
	//initialise array
	twUsername = [[NSMutableString alloc] init];
	fbToken = [[NSMutableString alloc] init];
	fbID = [[NSMutableString alloc] init];
	twID = [[NSMutableString alloc] init];
	twToken = [[NSMutableString alloc] init];
	
//    GlobalVar *obj=[GlobalVar getInstance];
    GlobalVar *s_url=[GlobalVar getServiceUrl];
    serviceURL=s_url.servieurl;
    
    //initialise Account store
    self.accountStore= [[ACAccountStore alloc] init];
    //initialise response data
    self.responseData = [NSMutableData data];
    
    if (!isiPad) {
        [self loadForIphone];
    }else{
        [self loadforPad];
    }
    
    //initialize facebook loing tab
    self.backbtnimg.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_b =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTologin:)];
	[self.backbtnimg addGestureRecognizer:tab_b];
	[tab_b release];
    
    //initialize takephoto tab
    self.takePhotoimg.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_takePoto =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OpenPhotoActionsheet:)];
	[self.takePhotoimg addGestureRecognizer:tab_takePoto];
	[tab_takePoto release];
    
    //initialize accept term and condition tab
    self.AccptTCImg.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_accepttc =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(acceptTcClicked:)];
	[self.AccptTCImg addGestureRecognizer:tab_accepttc];
	[tab_accepttc release];
    
    //initialize Do not accept term and condition tab
    self.DontAcceptTCImg.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_donot_tc =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dontoAcceptTc:)];
	[self.DontAcceptTCImg addGestureRecognizer:tab_donot_tc];
	[tab_donot_tc release];
    
    //initialize accept location popup tab
    self.Accpt_location_Img.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_acc_loc =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accept_location_Clicked:)];
	[self.Accpt_location_Img addGestureRecognizer:tab_acc_loc];
	[tab_acc_loc release];
    
    //initialize Do notaccept location tab
    self.DontAccep_location_Img.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_donot_location =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dontoAccept_location:)];
	[self.DontAccep_location_Img addGestureRecognizer:tab_donot_location];
	[tab_donot_location release];
	
    //initialize facebook tab
	self.facebookloginbtnimg.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_flogin =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(facebookLogin:)];
	[self.facebookloginbtnimg addGestureRecognizer:tab_flogin];
	[tab_flogin release];
    
    //twitter loging tab
    self.twitterloginbtnimg.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_twitter =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twitterLogin:)];
	[self.twitterloginbtnimg addGestureRecognizer:tab_twitter];
	[tab_twitter release];
    
	if([self.loginType1 isEqualToString:@"1"]){
         loginType = 1;
        
        _regName.text = self.regName1;
        _regUsername.text = self.regUsername1;
        _regEmail.text = self.regEmail1;
        _regPassword.text = @"123123";
        _regCnfpasswrod.text= @"123123";
        _tempsocialId.text = self.tempsocialId1;
        _tempsoicialToken.text = self.tempsoicialToken1;
        
        username_placeholder.hidden = YES;
        Name_placeholder.hidden=YES;
        email_placeholder.hidden=YES;
        password_placeholder.hidden=YES;
        cnf_placeholder.hidden = YES;
        
    }
    else if([self.loginType1 isEqualToString:@"2"]){
        loginType = 2;

		_tempsocialId.text =self.twID1;
		_tempsoicialToken.text =self.twToken1;
		_regName.text=self.twUsername1;
		_regUsername.text=self.twUsername1;
		
		username_placeholder.hidden = YES;
		Name_placeholder.hidden=YES;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    currentField = 0;
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *sel_language = [prefs stringForKey:@"sel_language"];
    
	if([sel_language isEqualToString:@"pt"]){
		[TSLanguageManager setSelectedLanguage:kLMPortu];
	}else{
		[TSLanguageManager setSelectedLanguage:kLMEnglish];
	}
    //call update label
	[self updateLabel];
}
- (void)viewDidAppear: (BOOL)animated {
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [_regName release];
    [_regUsername release];
    [_regEmail release];
    [_regPassword release];
    [_regCnfpasswrod release];
    [_scrollView release];
    [super dealloc];
}

#pragma mark - Action methods
- (IBAction)SignUpClicked:(id)sender {
    popupView_contain.layer.cornerRadius = 5;
    popupView_contain.layer.masksToBounds = YES;
    
    popupView_Location_contain.layer.cornerRadius = 5;
    popupView_Location_contain.layer.masksToBounds = YES;
    
    NSString *Regname= _regName.text;
    NSString *Reguname=_regUsername.text;
    NSString *RegEmail=_regEmail.text;
    NSString *RegPwd=_regPassword.text;
    NSString *RegCnfpwd=_regCnfpasswrod.text;
    
    if(Regname == nil){
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:[TSLanguageManager localizedString:@"MSG_ENTER_NAME"] delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [someError show];
        [someError release];
    }
    else if(Reguname == nil){
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:[TSLanguageManager localizedString:@"MSG_ENTER_USERNAME"] delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [someError show];
        [someError release];
    }
    else if(RegEmail == nil){
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:[TSLanguageManager localizedString:@"MSG_ENTER_EMAIL_ID"] delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [someError show];
        [someError release];
    }else if([self validEmail:RegEmail] == NO){
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:[TSLanguageManager localizedString:@"MSG_ENTER_VALID_EMAIL_ID"] delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [someError show];
        [someError release];
    }
    else if(RegPwd == nil){
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:[TSLanguageManager localizedString:@"MSG_ENTER_PASSWORD"] delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [someError show];
        [someError release];
    }
    else if(RegCnfpwd == nil){
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:[TSLanguageManager localizedString:@"MSG_ENTER_CONFIRM_PASSWORD"] delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [someError show];
        [someError release];
    }
    else{
        if([self isPasswordValid:RegPwd] == NO){
            UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:[TSLanguageManager localizedString:@"MSG_ENTER_VALID_PASSWORD"] delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [someError show];
            [someError release];
        }
        else if(![RegCnfpwd isEqualToString:RegPwd]){
            UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:[TSLanguageManager localizedString:@"MSG_ENTER_PASSWORD_NOT_MATCHED"] delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [someError show];
            [someError release];
            
        }
        else{
		 	[self.view addSubview:popupView];
        }
    }
}
- (IBAction)OpenPhotoActionsheet:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Photo", nil];
    [actionSheet showInView:self.view];
}
- (IBAction)gotoTest:(id)sender {
    testViewController *RegController = [[testViewController alloc] initWithNibName:@"testview1" bundle:nil]; [self.navigationController pushViewController:RegController animated:YES];
}
- (IBAction)cancelPopup:(id)sender {
    [self.popupView removeFromSuperview];
}
- (IBAction)RotateClickedRight:(UITapGestureRecognizer *)recognizer {
    if(rotation == -360){
        rotation = 0;
    }
    rotation = rotation-90;
    currentrotation =rotation;
    self.user_round_img.transform = CGAffineTransformMakeRotation(rotation * M_PI / 180.0);
}
- (IBAction)RotateClicked:(id)sender {
	if(rotation == 360){
        rotation = 0;
    }
    rotation = rotation+90;
    currentrotation =rotation;
	self.user_round_img.transform = CGAffineTransformMakeRotation(rotation * M_PI / 180.0);
}

#pragma mark - Other methods
#pragma Load nib for iPad
-(void)loadforPad{

    user_round_img.layer.cornerRadius = 44.0;
    user_round_img.layer.masksToBounds = YES;
    user_round_img.layer.borderColor = [UIColor clearColor].CGColor;
    user_round_img.layer.borderWidth = 3.0;
    CGRect frame = user_round_img.frame;
    frame.size.width = 80;//100;
    frame.size.height = 80;//100;
    user_round_img.frame = frame;
    
    UIView *userpaddding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    
    [_regName setBorderStyle:UITextBorderStyleNone];
    [_regName.layer setMasksToBounds:YES];
    [_regName.layer setCornerRadius:6.0f];
    [_regName.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [_regName.layer setBorderWidth:1.2];
    _regName.leftView = userpaddding;
    _regName.leftViewMode = UITextFieldViewModeAlways;
     _regName.textColor=[UIColor grayColor];
    [_regName setFont:[UIFont systemFontOfSize:23]];
    
    [_regUsername setBorderStyle:UITextBorderStyleNone];
    [_regUsername.layer setMasksToBounds:YES];
    [_regUsername.layer setCornerRadius:6.0f];
    [_regUsername.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [_regUsername.layer setBorderWidth:1.2];
    _regUsername.leftView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    _regUsername.leftViewMode = UITextFieldViewModeAlways;
    _regUsername.textColor=[UIColor grayColor];
    [_regUsername setFont:[UIFont systemFontOfSize:23]];
    
    [_regEmail setBorderStyle:UITextBorderStyleNone];
    [_regEmail.layer setMasksToBounds:YES];
    [_regEmail.layer setCornerRadius:6.0f];
    [_regEmail.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [_regEmail.layer setBorderWidth:1.2];
    _regEmail.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    _regEmail.leftViewMode = UITextFieldViewModeAlways;
    _regEmail.textColor=[UIColor grayColor];
    [_regEmail setFont:[UIFont systemFontOfSize:23]];
    
    [_regPassword setBorderStyle:UITextBorderStyleNone];
    [_regPassword.layer setMasksToBounds:YES];
    [_regPassword.layer setCornerRadius:6.0f];
    [_regPassword.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [_regPassword.layer setBorderWidth:1.2];
    _regPassword.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    _regPassword.leftViewMode = UITextFieldViewModeAlways;
    _regPassword.textColor=[UIColor grayColor];
    [_regPassword setFont:[UIFont systemFontOfSize:23]];
    
    [_regCnfpasswrod setBorderStyle:UITextBorderStyleNone];
    [_regCnfpasswrod.layer setMasksToBounds:YES];
    [_regCnfpasswrod.layer setCornerRadius:6.0f];
    [_regCnfpasswrod.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [_regCnfpasswrod.layer setBorderWidth:1.2];
    _regCnfpasswrod.leftView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    _regCnfpasswrod.leftViewMode = UITextFieldViewModeAlways;
    _regCnfpasswrod.textColor=[UIColor grayColor];
    [_regCnfpasswrod setFont:[UIFont systemFontOfSize:23]];
    
    //-------------------placehoder for username-------------------------------
    Name_placeholder = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0,_regName.frame.size.width - 7.0, 60.0)];
    [Name_placeholder setText:[TSLanguageManager localizedString:@"LBL_YOUR_NAME"]];
    [Name_placeholder setBackgroundColor:[UIColor clearColor]];
    [Name_placeholder setTextColor:[UIColor lightGrayColor]];
    [Name_placeholder setFont:[UIFont systemFontOfSize:23]];
    _regName.delegate = self;
    [_regName addSubview:Name_placeholder];
    
    username_placeholder= [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0,_regUsername.frame.size.width - 7.0, 60.0)];
	
    [username_placeholder setText:[TSLanguageManager localizedString:@"LBL_USERNAME"]];
    [username_placeholder setBackgroundColor:[UIColor clearColor]];
    [username_placeholder setTextColor:[UIColor lightGrayColor]];
      [username_placeholder setFont:[UIFont systemFontOfSize:23]];
    _regUsername.delegate = self;
    [_regUsername addSubview:username_placeholder];
    
    email_placeholder = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0,_regEmail.frame.size.width - 7.0, 60.0)];
	
    [email_placeholder setText:[TSLanguageManager localizedString:@"LBL_EMAIL"]];
    [email_placeholder setBackgroundColor:[UIColor clearColor]];
    [email_placeholder setTextColor:[UIColor lightGrayColor]];
    [email_placeholder setFont:[UIFont systemFontOfSize:23]];
    _regEmail.delegate = self;
    [_regEmail addSubview:email_placeholder];
    
    password_placeholder = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0,_regPassword.frame.size.width - 7.0, 60.0)];
	
    [password_placeholder setText:[TSLanguageManager localizedString:@"LBL_PASSWORD"]];
    [password_placeholder setBackgroundColor:[UIColor clearColor]];
    [password_placeholder setTextColor:[UIColor lightGrayColor]];
      [password_placeholder setFont:[UIFont systemFontOfSize:23]];
    _regPassword.delegate = self;
    [_regPassword addSubview:password_placeholder];
    
    cnf_placeholder = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0,_regCnfpasswrod.frame.size.width - 7.0, 60.0)];
		
    [cnf_placeholder setText:[TSLanguageManager localizedString:@"LBL_REPEAT_PASSWORD"]];
    [cnf_placeholder setBackgroundColor:[UIColor clearColor]];
    [cnf_placeholder setTextColor:[UIColor lightGrayColor]];
      [cnf_placeholder setFont:[UIFont systemFontOfSize:23]];
    _regCnfpasswrod.delegate = self;
    [_regCnfpasswrod addSubview:cnf_placeholder];
}
#pragma LoadiPhone
-(void)loadForIphone{
    user_round_img.layer.cornerRadius = 44.0;
    user_round_img.layer.masksToBounds = YES;
    user_round_img.layer.borderColor = [UIColor clearColor].CGColor;
    user_round_img.layer.borderWidth = 3.0;
    CGRect frame = user_round_img.frame;
    frame.size.width = 80;//100;
    frame.size.height = 80;//100;
    user_round_img.frame = frame;
    
    UIView *userpaddding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    
    [_regName setBorderStyle:UITextBorderStyleNone];
    [_regName.layer setMasksToBounds:YES];
    [_regName.layer setCornerRadius:6.0f];
    [_regName.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [_regName.layer setBorderWidth:1.2];
    _regName.leftView = userpaddding;
    _regName.leftViewMode = UITextFieldViewModeAlways;
    
    [_regUsername setBorderStyle:UITextBorderStyleNone];
    [_regUsername.layer setMasksToBounds:YES];
    [_regUsername.layer setCornerRadius:6.0f];
    [_regUsername.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [_regUsername.layer setBorderWidth:1.2];
    _regUsername.leftView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    _regUsername.leftViewMode = UITextFieldViewModeAlways;
    
    [_regEmail setBorderStyle:UITextBorderStyleNone];
    [_regEmail.layer setMasksToBounds:YES];
    [_regEmail.layer setCornerRadius:6.0f];
    [_regEmail.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [_regEmail.layer setBorderWidth:1.2];
    _regEmail.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    _regEmail.leftViewMode = UITextFieldViewModeAlways;
    
    [_regPassword setBorderStyle:UITextBorderStyleNone];
    [_regPassword.layer setMasksToBounds:YES];
    [_regPassword.layer setCornerRadius:6.0f];
    [_regPassword.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [_regPassword.layer setBorderWidth:1.2];
    _regPassword.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    _regPassword.leftViewMode = UITextFieldViewModeAlways;
    
    [_regCnfpasswrod setBorderStyle:UITextBorderStyleNone];
    [_regCnfpasswrod.layer setMasksToBounds:YES];
    [_regCnfpasswrod.layer setCornerRadius:6.0f];
    [_regCnfpasswrod.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [_regCnfpasswrod.layer setBorderWidth:1.2];
    _regCnfpasswrod.leftView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    _regCnfpasswrod.leftViewMode = UITextFieldViewModeAlways;
    
    //-------------------placehoder for username-------------------------------
    Name_placeholder = [[UILabel alloc] initWithFrame:CGRectMake(7.0, 0.0,_regName.frame.size.width - 7.0, 28.0)];
    [Name_placeholder setText:[TSLanguageManager localizedString:@"LBL_YOUR_NAME"]];
    [Name_placeholder setBackgroundColor:[UIColor clearColor]];
    [Name_placeholder setTextColor:[UIColor lightGrayColor]];
    _regName.delegate = self;
    [_regName addSubview:Name_placeholder];
    
    username_placeholder= [[UILabel alloc] initWithFrame:CGRectMake(7.0, 0.0,_regUsername.frame.size.width - 7.0, 28.0)];
    [username_placeholder setText:[TSLanguageManager localizedString:@"LBL_USERNAME"]];
    [username_placeholder setBackgroundColor:[UIColor clearColor]];
    [username_placeholder setTextColor:[UIColor lightGrayColor]];
    _regUsername.delegate = self;
    [_regUsername addSubview:username_placeholder];
    
    email_placeholder = [[UILabel alloc] initWithFrame:CGRectMake(7.0, 0.0,_regEmail.frame.size.width - 7.0, 28.0)];
    [email_placeholder setText:[TSLanguageManager localizedString:@"LBL_EMAIL"]];
    [email_placeholder setBackgroundColor:[UIColor clearColor]];
    [email_placeholder setTextColor:[UIColor lightGrayColor]];
    _regEmail.delegate = self;
    [_regEmail addSubview:email_placeholder];
    
    password_placeholder = [[UILabel alloc] initWithFrame:CGRectMake(7.0, 0.0,_regPassword.frame.size.width - 7.0, 28.0)];
    [password_placeholder setText:[TSLanguageManager localizedString:@"LBL_PASSWORD"]];
    [password_placeholder setBackgroundColor:[UIColor clearColor]];
    [password_placeholder setTextColor:[UIColor lightGrayColor]];
    _regPassword.delegate = self;
    [_regPassword addSubview:password_placeholder];
    
    cnf_placeholder = [[UILabel alloc] initWithFrame:CGRectMake(7.0, 0.0,_regCnfpasswrod.frame.size.width - 7.0, 28.0)];
    [cnf_placeholder setText:[TSLanguageManager localizedString:@"LBL_REPEAT_PASSWORD"]];
    [cnf_placeholder setBackgroundColor:[UIColor clearColor]];
    [cnf_placeholder setTextColor:[UIColor lightGrayColor]];
    _regCnfpasswrod.delegate = self;
    [_regCnfpasswrod addSubview:cnf_placeholder];
}
-(void)closeWebview{
	self.webview.hidden = YES;
	self.close.hidden = YES;
}
- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController
            isAvailableForServiceType:SLServiceTypeTwitter];
}
#pragma gesture
- (void)backTologin:(UITapGestureRecognizer *)recognizer  {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)accept_location_Clicked:(UITapGestureRecognizer *)recognizer  {
    [self.popupView removeFromSuperview];
    DetailfeedViewController *DetailController = [[DetailfeedViewController alloc] initWithNibName:objAppDel.detailfeedView bundle:nil]; [self.navigationController pushViewController:DetailController animated:YES];
}
- (void)dontoAccept_location:(UITapGestureRecognizer *)recognizer  {
    [self.popupView removeFromSuperview];
    DetailfeedViewController *DetailController = [[DetailfeedViewController alloc] initWithNibName:objAppDel.detailfeedView bundle:nil]; [self.navigationController pushViewController:DetailController animated:YES];
}
- (void)acceptTcClicked:(UITapGestureRecognizer *)recognizer  {
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        [self submitRegister];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
}
- (void)dontoAcceptTc:(UITapGestureRecognizer *)recognizer  {
    [self.popupView removeFromSuperview];
}
-(void)putText
{
    
}
-(void) updateLabel
{
	[Name_placeholder setText:[TSLanguageManager localizedString:@"LBL_YOUR_NAME"]];
	[username_placeholder setText:[TSLanguageManager localizedString:@"LBL_USERNAME"]];
	[email_placeholder setText:[TSLanguageManager localizedString:@"LBL_EMAIL"]];
	[password_placeholder setText:[TSLanguageManager localizedString:@"LBL_PASSWORD"]];
	[cnf_placeholder setText:[TSLanguageManager localizedString:@"LBL_REPEAT_PASSWORD"]];
	
	self.lbl_register.text =[TSLanguageManager localizedString:@"LBL_REGISTER"];
	self.lbl_or_signup_using.text =[TSLanguageManager localizedString:@"LBL_OR_SIGNUP_USING"];
	self.lbl_terms_header.text =[TSLanguageManager localizedString:@"LBL_TERMS_HEADER"];
	self.lbl_terms_title.text =[TSLanguageManager localizedString:@"LBL_TERMS_TITLE"];
	self.lbl_terms_accept.text =[TSLanguageManager localizedString:@"LBL_ACCEPT"];
	self.lbl_terms_do_not_accept.text =[TSLanguageManager localizedString:@"LBL_DO_NOT_ACCEPT"];
	self.lbl_geo_header.text =[TSLanguageManager localizedString:@"LBL_GEO_HEADER"];
	self.lbl_geo_accept.text =[TSLanguageManager localizedString:@"LBL_ACCEPT"];
	self.lbl_geo_do_not_accept.text =[TSLanguageManager localizedString:@"LBL_DO_NOT_ACCEPT"];
	
	[self.lbl_take_a_picture setTitle:[TSLanguageManager localizedString:@"LBL_TAKE_A_PICTURE"] forState:UIControlStateNormal];
	[self.lbl_signup setTitle:[TSLanguageManager localizedString:@"LBL_SIGNUP"] forState:UIControlStateNormal];
	self.lbl_terms_desc.text =[TSLanguageManager localizedString:@"LBL_TERMS_TEXT"];
	self.lbl_geo_desc.text =[TSLanguageManager localizedString:@"LBL_GEO_DESC"];
}
- (BOOL)prefersStatusBarHidden
{
	return YES;
}
- (void)nextTextField {
    if (currentField == 0) {
        NSLog(@" Coming here ?");
        currentField = 1;
        [_regName resignFirstResponder];
        [_regUsername becomeFirstResponder];
    }
    else if (currentField == 1) {
        currentField = 2;
        [_regUsername resignFirstResponder];
        [_regEmail becomeFirstResponder];
    }
    else if (currentField == 2) {
        currentField = 3;
        [_regEmail resignFirstResponder];
        [_regPassword becomeFirstResponder];
    }
    else if (currentField == 3) {
        currentField = 4;
        [_regPassword resignFirstResponder];
        [_regCnfpasswrod becomeFirstResponder];
    }
    else if (currentField == 4) {
        currentField = 0;
        [_regCnfpasswrod resignFirstResponder];
    }
}
-(void)previousTextField
{
    if (currentField == 0) {
        currentField = 0;
        [_regName resignFirstResponder];
    }
    else if (currentField == 1) {
        currentField = 0;
        [_regUsername resignFirstResponder];
        [_regName becomeFirstResponder];
    }
    else if (currentField == 2) {
        currentField = 1;
        [_regEmail resignFirstResponder];
        [_regUsername becomeFirstResponder];
    }
    else if (currentField == 3) {
        currentField = 2;
        [_regPassword resignFirstResponder];
        [_regEmail becomeFirstResponder];
    }
    else if (currentField == 4) {
        currentField = 3;
        [_regCnfpasswrod resignFirstResponder];
        [_regPassword becomeFirstResponder];
    }
}
-(void)resignKeyboard {
    [_regName resignFirstResponder];
    [_regUsername resignFirstResponder];
    [_regEmail resignFirstResponder];
    [_regCnfpasswrod resignFirstResponder];
    [_regPassword resignFirstResponder];
}

#pragma mark - Email Validation
- (BOOL) validEmail:(NSString*) emailString {
	
	if([emailString length]==0){
		return NO;
	}
	NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
	NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
	
	NSLog(@"%i", regExMatches);
	if (regExMatches == 0) {
		return NO;
	}
    else {
		return YES;
	}
}

#pragma mark - PassWord Validation
-(BOOL) isPasswordValid:(NSString *)pwd {
	if ( [pwd length]<6 || [pwd length]>32 ) return NO;  // too long or too short
	NSRange rang;
	rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
	if ( !rang.length ) return NO;  // no letter
	rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
	if ( !rang.length )  return NO;  // no number;
	return YES;
}

#pragma mark - FaceBook  methods
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
                               switch (state) {
                                   case FBSessionStateOpen:
                                       [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                                           if (error) {
                                           }
                                           else
                                           {
                                               NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
                                               
                                               [self.alert dismissWithClickedButtonIndex:0 animated:YES];
                                               //     http://graph.facebook.com/67563683055/picture?type=square
                                               //bravo.ojha
                                            
                                               _tempsocialId.text =user.id;
                                               _tempsoicialToken.text =fbAccessToken;
                                               
                                               NSString*f_murl=@"http://graph.facebook.com/";
                                               NSString*f_uname=user.username;
                                               NSString*f_last=@"/picture?type=square";
                                               NSArray *myStrings = [[NSArray alloc] initWithObjects:f_murl, f_uname,f_last, nil];
                                               
                                               NSString *joinedString = [myStrings componentsJoinedByString:@""];
                                               
                                               NSURL *url_img = [NSURL URLWithString:joinedString];
                                               NSData *data1 = [NSData dataWithContentsOfURL:url_img];
                                               
                                               self.user_round_img.image = [UIImage imageWithData:data1];
                                               _regName.text=user.first_name;
                                               _regUsername.text=user.username;
                                               _regEmail.text=[user objectForKey:@"email"];
                                               
                                               username_placeholder.hidden = YES;
                                               Name_placeholder.hidden=YES;
                                               email_placeholder.hidden=YES;
                                               
                                               Fname=user.first_name;
                                               FUname=user.username;
                                               FEmail=[user objectForKey:@"email"];
                                               facebook_imgurl=joinedString;
                                               NSLog(@"username-->%@",facebook_imgurl);
                                               loginType = 1;
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

#pragma mark - Twitter methods
#pragma cacheTwitterAuthData
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
    NSUserDefaults          *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: data forKey: @"authData"];
    [defaults synchronize];
}
- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}
#pragma mark - Twitter Login
-(void)twitterLogin:(UITapGestureRecognizer *)recognizer{
	twittewCallBack = 0;
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        webview=[[UIWebView alloc]initWithFrame:CGRectMake(10, 40, 300,400)];
        
       // http://54.191.5.223/videoblog_web/service
        NSString *url=[NSString stringWithFormat:@"http://54.191.200.49/videoblog_web/service?action=loginWithTwitter"];
        
        NSURL *nsurl=[NSURL URLWithString:url];
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
        self.webview.delegate = self;
        [webview loadRequest:nsrequest];
        
        self.close = [[UIButton alloc] initWithFrame:CGRectMake(280,20, 40, 40)];
        UIImage *buttonImage5 = [UIImage imageNamed:@"close.png"];
        [self.close setImage:buttonImage5 forState:UIControlStateNormal];
        [self.close addTarget:self
                       action:@selector(closeWebview)
             forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:webview];
        [self.view addSubview:self.close];
        [self.window makeKeyAndVisible];
        [webview release];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
}

#pragma mark - Webview delegate methods
-(void)webViewHistoryDidChange:(NSNotification *)notification {
	NSLog(@"URL CHANGED");
}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
	if(twittewCallBack == 1){
		NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('pre')[0].innerHTML"];
		NSDictionary *myDictionary = [html objectFromJSONString];
		NSLog(@"Content %@", myDictionary);
		
		id responseMessage=[myDictionary valueForKey:@"data"];
		
		NSMutableString *vUsername=[[NSMutableString alloc] init];
		vUsername = [responseMessage valueForKey:@"vUsername"];
		
		NSMutableString *tTwitterToken= [[NSMutableString alloc] init];
		tTwitterToken = [responseMessage valueForKey:@"tTwitterToken"];
		NSMutableString *vTwitterId=[[NSMutableString alloc] init];
		vTwitterId = [responseMessage valueForKey:@"vTwitterId"];
		
        loginType = 2;
		_regName.text=vUsername;
		_regUsername.text=vUsername;
		_tempsocialId.text =vTwitterId;
		_tempsoicialToken.text =tTwitterToken;
		twToken =tTwitterToken;
		twUsername =vUsername;
        twID =vTwitterId;
		
		username_placeholder.hidden = YES;
		Name_placeholder.hidden=YES;
		
		self.webview.hidden = YES;
		self.close.hidden = YES;
	}
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
	NSString *URLString = [[request URL] absoluteString];
	if ([URLString rangeOfString:@"action=callBackTwitter"].location != NSNotFound) {
		if ([URLString rangeOfString:@"oauth_token="].location == NSNotFound) {
		}
        else {
			twittewCallBack = 1;
		}
	}
	return YES;
}

#pragma mark - Call WebService
//--------------------------Term and condtion accept cliekd-------------------------------------------------
-(void)submitRegister{
    //alert
    self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[self.alert show];
    //activity indicator
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.center = CGPointMake(150, 100);
	[indicator startAnimating];
	[self.alert addSubview:indicator];
	[indicator release];
	
	NSString *Regname= _regName.text;
	NSString *Reguname=_regUsername.text;
	NSString *RegEmail=_regEmail.text;
	NSString *RegPwd=_regPassword.text;
	
	UIImage *ourImage=self.user_round_img.image;//self.userimg;
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
	[body appendData:[@"Content-Disposition: attachment; name=\"vPicture\"; filename=\"demo.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
 // Text parameter1
	NSString *param1 = Regname;
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vName\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:param1] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
 // Another text parameter
	NSString *param2 = Reguname;
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vUsername\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:param2] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
 // Another text parameter
	NSString *param3 = RegEmail;
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vEmail\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:param3] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
 // Another text parameter
	NSString *param4 = RegPwd;
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vPassword\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:param4] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
 // Another text parameter
	NSString *param5 = @"userRegistration";
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:param5] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
 // Another text parameter
	NSString *param6 = @"IOS";
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vType\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:param6] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
 // Another text parameter
	NSString *param7 = [NSString stringWithFormat:@"%ld", (long)currentrotation];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"imagerotation\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:param7] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	if(loginType == 0){
		NSString *param44 = @"REGISTER";
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"eLoginType\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithString:param44] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	if(loginType == 1){
		NSString *param44 = @"FACEBOOK";
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"eLoginType\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithString:param44] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  
		
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tFacebookToken\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithString:_tempsoicialToken.text] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
		

		[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vFacebookId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithString:_tempsocialId.text] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	}
	if(loginType == 2){
		
		NSString *param44 = @"TWITTER";
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"eLoginType\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithString:param44] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  
		
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tTwitterToken\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithString:_tempsoicialToken.text] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
		
  
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vTwitterId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithString:_tempsocialId.text] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vDeviceid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:objAppDel.strDeviceId] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vDevicename\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:Reguname] dataUsingEncoding:NSUTF8StringEncoding]];
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
   
       NSString *returnString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
       [self.alert dismissWithClickedButtonIndex:0 animated:YES];
       NSError *e = nil;
       [self.alert dismissWithClickedButtonIndex:0 animated:YES];
       
       id object = [NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
       id responseMessage=[object valueForKey:@"message"];
   
       NSMutableString *message=[responseMessage valueForKey:@"msg"];
       NSMutableString *success=[responseMessage valueForKey:@"success"];
       
         if([success integerValue] == 1){
             id responseDatas=[object valueForKey:@"data"];
             NSMutableString *iMemberId=[responseDatas valueForKey:@"iMemberId"];
             NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
             // saving an NSString
             [prefs setObject:iMemberId forKey:@"local_Memberid"];
             [self.view addSubview:popupView_Location];
         }
         else{
             UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_ALERT"] message:message delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
             [someError show];
             [someError release];
         }
     }];
}
#pragma FaceBookRegistration
-(void)fbookRegister{
    //alert
    self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
    [self.alert show];
    //activity indiacator
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = CGPointMake(150, 100);
    [indicator startAnimating];
    [self.alert addSubview:indicator];
    [indicator release];
    
    NSString *Regname= Fname;
    NSString *Reguname=FUname;
    NSString *RegEmail=FEmail;
    NSString *RegPwd=@"password";
    NSString *f_imgurl=facebook_imgurl;
    
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        UIImage *ourImage=self.userimg;
        NSData * imageData = UIImageJPEGRepresentation(ourImage, 1.0);
        // NSString *urlString = @"http://192.168.1.41/php/videoblog/webservice";
        NSString *urlString = [NSString stringWithFormat:@"%@", serviceURL];//@"http://184.107.213.34/~techiest/php/videoblog/webservice";
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
        NSString *param1 = Regname;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vName\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param1] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param2 = Reguname;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vUsername\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param2] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param3 = RegEmail;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vEmail\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param3] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param4 = RegPwd;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vPassword\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param4] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param5 = @"userRegistration";
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param5] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param6 = f_imgurl;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"imgurl\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param6] dataUsingEncoding:NSUTF8StringEncoding]];
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
        NSMutableString *message=[object valueForKey:@"msg"];
        NSMutableString *success=[object valueForKey:@"success"];
        
        if([success integerValue] == 1){
            [self.view addSubview:popupView_Location];
        }
        else{
            UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_ALERT"] message:message delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [someError show];
            [someError release];
        }
        [self.alert dismissWithClickedButtonIndex:0 animated:YES];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
}

#pragma mark - ActionSheet Delegate methods
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
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                UIPopoverController *popover1 = [[UIPopoverController alloc] initWithContentViewController:picker];
                [popover1 presentPopoverFromRect:self.view.bounds inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                self.popover = popover1;
            } else {
                [self presentViewController:picker animated:YES completion:nil];
            }
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

#pragma mark - ImagePickerController delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.user_round_img.image = chosenImage;
    self.userimg=chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
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

- (BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
     [_regName resignFirstResponder];
     [_regUsername resignFirstResponder];
     [_regEmail resignFirstResponder];
     [_regCnfpasswrod resignFirstResponder];
     [_regPassword resignFirstResponder];
     
     return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
     if(textField == _regName){
      currentField = 0;
     }
     if(textField == _regUsername){
      currentField = 1;
     }
     if(textField == _regEmail){
      currentField = 2;
     }
     if(textField == _regPassword){
      currentField = 3;
     }
     if(textField == _regCnfpasswrod){
      currentField = 4;
     }
 
	if(textField == _regCnfpasswrod){
		[_scrollView setContentOffset:CGPointMake(0, 80)];
        cnf_placeholder.hidden = YES;
	}
	else if(textField==_regPassword){
        [_scrollView setContentOffset:CGPointMake(0, 80)];
        password_placeholder.hidden = YES;
    }
    else if(textField==_regEmail){
        [_scrollView setContentOffset:CGPointMake(0,60)];
        email_placeholder.hidden = YES;
    }
    else if(textField==_regUsername){
        username_placeholder.hidden = YES;
    }
    else if(textField==_regName){
        Name_placeholder.hidden = YES;
    }
	else
    {
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
     if ([_regCnfpasswrod.text length]==0) {
      cnf_placeholder.hidden = NO;
     }
     if ([_regPassword.text length]==0) {
      password_placeholder.hidden = NO;
     }
     if ([_regEmail.text length]==0) {
      email_placeholder.hidden = NO;
     }
     if ([_regUsername.text length]==0) {
      username_placeholder.hidden = NO;
     }
     if ([_regName.text length]==0) {
      Name_placeholder.hidden = NO;
     }
     [UIView animateWithDuration:0.25 animations:^{
      [_scrollView setContentSize:CGSizeMake(320, 480)];
      [_scrollView setContentOffset:CGPointMake(0, 0)];
     }];
}
@end
