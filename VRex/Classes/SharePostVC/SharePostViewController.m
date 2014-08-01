//
//  SharePostViewController.m
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/23/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import "SharePostViewController.h"
#import "DetailfeedViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalVar.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import "JSONKit.h"
#import "TSLanguageManager.h"
#import "constant.h"

@interface SharePostViewController ()

@end
//initalise variables globally
int stateClick = 0;
int catClick = 0;
NSInteger currentFieldShare = 0;
NSInteger twittewCallBack2 = 0;
NSInteger fbShareOn = 0;
NSInteger TwShareOn = 0;

@implementation SharePostViewController
@synthesize pickerButton,fromButton,categoriestxt,maptext,heladinetext,posttextview,back,viewname;
@synthesize Postimgview,postimage,locationManager,spinner_cmplist,serviceURL;
@synthesize webview = webview;

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
    
	GlobalVar *s_url=[GlobalVar getServiceUrl];
	serviceURL=s_url.servieurl;
	
    [self.scrollview setContentSize:CGSizeMake(320, self.view.frame.size.height+10)];
    
    if([objAppDel.strCurrentUploadType isEqualToString:@"Video"]){
        self.videoView.hidden=NO;
        self.movieController1 = [[[MPMoviePlayerController alloc]initWithContentURL:self.shareVidURL] autorelease];
//        [self.movieController1.view setFrame: CGRectMake(0, 0, 110, 105)];
        UIImage  *thumbnail = [self.movieController1 thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        UIImageView *frameView = [[UIImageView alloc] initWithImage:thumbnail];
        frameView.frame = CGRectMake(0, 0, 110, 105);//self.videoView.frame ;
//        imgViewVideoImage.image = thumbnail;
        [self.videoView setBackgroundColor:[UIColor colorWithPatternImage:frameView.image]];
    }
    else{
        self.videoView.hidden=YES;
        self.Postimgview.image=self.postimage;
    }
    
    //call methods
    [self setpadding];
    [self tabRecog];
	
    //tap gesture
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
	[self.view addGestureRecognizer:tap];
	
    //show category
	self.categoryView.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_cat =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCategory:)];
	[self.categoryView addGestureRecognizer:tap_cat];
	[tap_cat release];
	
    //get map
	self.AddtoMapView.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_map =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getMapValue:)];
	[self.AddtoMapView addGestureRecognizer:tap_map];
	[tap_map release];
	
    //initialise array
	self.countryName = [[NSMutableArray alloc]initWithObjects: nil];
	self.countryId = [[NSMutableArray alloc]initWithObjects: nil];
	self.stateName = [[NSMutableArray alloc]initWithObjects: nil];
	self.stateId = [[NSMutableArray alloc]initWithObjects: nil];
	self.categoryName = [[NSMutableArray alloc]initWithObjects: nil];
	self.categoryId = [[NSMutableArray alloc]initWithObjects: nil];
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
    
    //call update label
	[self updateLabel];
	
	NSString *local_Latitude = [prefs stringForKey:@"local_Latitude"];
	NSString *local_Longitude = [prefs stringForKey:@"local_Longitude"];
	NSString *local_Country = [prefs stringForKey:@"local_Country"];
	NSString *local_CountryCode = [prefs stringForKey:@"local_CountryCode"];
	NSString *local_State = [prefs stringForKey:@"local_State"];
	NSString *local_City = [prefs stringForKey:@"local_City"];
   
    self.currentLat =local_Latitude;
    self.currentLong =local_Longitude;
    if(local_Country ==nil){
        self.countrytext.text=@"Country";
    }
    else
    {
        [_countrytext setText:[NSString stringWithFormat:@"%@",local_Country]];
        _countryID.text =[NSString stringWithFormat:@"%@",local_CountryCode];
    }
    if(local_City ==nil){
    
        _citytext.placeholder=@"City";
    }
    else
    {
        _citytext.text =[NSString stringWithFormat:@"%@",local_City];
    }
    
    if(local_State ==nil){
        self.statetext.text=@"State";
    }
    else
    {
        [_statetext setText:[NSString stringWithFormat:@"%@",local_State]];
        _stateID.text =[NSString stringWithFormat:@"%@",local_State];
    }
    
	if(local_Latitude==nil || local_Longitude == nil){
        maptext.placeholder=@"Add to Map";
	}
    else
    {
        _AddtoMaptext.text  =[NSString stringWithFormat:@"%@, %@",local_Latitude,local_Longitude];
    }

	NSString *share_rotation = [prefs stringForKey:@"share_rotation"];
	if([share_rotation integerValue] != 0){
		self.Postimgview.transform = CGAffineTransformMakeRotation([share_rotation integerValue] * M_PI / 180.0);
	}
}
- (void)viewDidUnload
{
	[super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
	[super dealloc];
}

#pragma mark - Action methods
-(IBAction)aMethod:(id)sender
{
	[myPickerView removeFromSuperview];
	[doneButton removeFromSuperview];
}
-(IBAction)aMethod1:(id)sender
{
	[myPickerView1 removeFromSuperview];
    [doneButton1 removeFromSuperview];
}
-(IBAction)aMethod2:(id)sender
{
	[myPickerView2 removeFromSuperview];
    [doneButton2 removeFromSuperview];
}
- (IBAction)FBchangeSwitch:(id)sender{
	if([sender isOn]){
		fbShareOn =1;
        BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
        if (isConnectionAvail) {
            [self flogin];
        }
        else{
            DisplayAlert(NoNetworkConnection);
        }
	} else{
		fbShareOn = 0;
	}
}
- (IBAction)TWchangeSwitch:(id)sender{
	if([sender isOn]){
		TwShareOn =1;
		[self twitterLogin];
	} else{
		TwShareOn =0;
	}
}
-(IBAction)checkIfCorrectLength:(id)sender{
	if (![self isAcceptableTextLength:self.posttextview.text.length]) {
        // do something to make text shorter
	}
}

#pragma mark - other methods
- (BOOL)isAcceptableTextLength:(NSUInteger)length {
	return length <= 140;
}
- (void)gobackFromSharePost:(UITapGestureRecognizer *)recognizer  {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setpadding
{
     //-------setting border radious-----------------------
    [maptext setBorderStyle:UITextBorderStyleNone];
    [maptext.layer setMasksToBounds:YES];
    [maptext.layer setCornerRadius:6.0f];
    [maptext.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [maptext.layer setBorderWidth:1.1];
    maptext.textColor=[UIColor grayColor];
    [maptext setFont:[UIFont systemFontOfSize:16]];
    
    UIView *userpaddding1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    maptext.leftView = userpaddding1;
    maptext.leftViewMode = UITextFieldViewModeAlways;
    
    //-------setting border radious-----------------------
    [categoriestxt setBorderStyle:UITextBorderStyleNone];
    [categoriestxt.layer setMasksToBounds:YES];
    [categoriestxt.layer setCornerRadius:6.0f];
    [categoriestxt.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [categoriestxt.layer setBorderWidth:1.1];
    categoriestxt.textColor=[UIColor grayColor];
    [categoriestxt setFont:[UIFont systemFontOfSize:16]];
    
    UIView *userpaddding2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    categoriestxt.leftView = userpaddding2;
    categoriestxt.leftViewMode = UITextFieldViewModeAlways;
    
    //-------setting border radious-----------------------
    [posttextview.layer setMasksToBounds:YES];
    [posttextview.layer setCornerRadius:6.0f];
    [posttextview.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [posttextview.layer setBorderWidth:1.1];
    posttextview.textColor=[UIColor grayColor];
    [posttextview setFont:[UIFont systemFontOfSize:16]];
}
-(void)twitterLogin{
	twittewCallBack2 = 0;
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        webview=[[UIWebView alloc]initWithFrame:CGRectMake(10, 40, 300,400)];
        
        NSString *url=[NSString stringWithFormat:@"%@?action=loginWithTwitter",self.serviceURL];
        NSURL *nsurl=[NSURL URLWithString:url];
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
        self.webview.delegate =(id) self;
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
-(void)closeWebview{
	self.webview.hidden = YES;
	self.close.hidden = YES;
}
-(void) updateLabel
{
    if ([self.countrytext isEqual:[NSNull null]]) {
        self.countrytext.text=@"Country";
    }
    else if ([self.statetext isEqual:[NSNull null]])
    {
        self.statetext.text=@"State";
    }
	else if ([_citytext.text isEqual:[NSNull null]])
    {
        _citytext.placeholder=@"City";
    }
    else if ([self.AddtoMaptext isEqual:[NSNull null]])
    {
        self.statetext.text=@"Add to Map";
    }
    else{
        self.heladinetext.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[TSLanguageManager localizedString:@"LBL_TITLE"]];
        self.citytext.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[TSLanguageManager localizedString:@"LBL_CITY"]];
		
        self.cattext.text =[TSLanguageManager localizedString:@"LBL_CATEGORY"];
        self.countrytext.text =[TSLanguageManager localizedString:@"LBL_COUNTRY"];
        self.statetext.text =[TSLanguageManager localizedString:@"LBL_STATE"];
        self.AddtoMaptext.text =[TSLanguageManager localizedString:@"LBL_ADD_TO_MAP"];
        self.lbl_share_on_tw.text =[TSLanguageManager localizedString:@"LBL_SHARE_ON_TW"];
        self.lbl_shareon_fb.text =[TSLanguageManager localizedString:@"LBL_SHARE_ON_FB"];
        
        [self.lbl_Share setTitle:[TSLanguageManager localizedString:@"LBL_SHARE"] forState:UIControlStateNormal];
    }
}
-(void)dismissKeyboard {
    NSLog(@"Dismis keyboard");
	[self.posttextview resignFirstResponder];
	[self.categoriestxt resignFirstResponder];
	[maptext resignFirstResponder];
	[heladinetext resignFirstResponder];
	[self.citytext resignFirstResponder];
}
- (void)nextTextField {
    if (currentFieldShare == 0) {
        currentFieldShare = 1;
        [self.heladinetext resignFirstResponder];
        [self.posttextview becomeFirstResponder];
    }else if (currentFieldShare == 1) {
        currentFieldShare = 2;
        [self.posttextview resignFirstResponder];
    }else if (currentFieldShare == 2) {
        currentFieldShare = 0;
        [self.citytext resignFirstResponder];
    }
}
-(void)previousTextField
{
    if (currentFieldShare == 0) {
        currentFieldShare = 0;
        [self.heladinetext resignFirstResponder];
    }else if (currentFieldShare == 1) {
        currentFieldShare = 0;
        [self.posttextview resignFirstResponder];
        [self.heladinetext becomeFirstResponder];
    }else if (currentFieldShare == 2) {
        currentFieldShare = 0;
        [self.citytext resignFirstResponder];
    }
}
- (BOOL)prefersStatusBarHidden
{
	return YES;
}


#pragma mark - Gesture method - Goback from share post
-(void)tabRecog
{
    self.back.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_B1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gobackFromSharePost:)];
	[self.back addGestureRecognizer:tap_B1];
	[tap_B1 release];
}

#pragma mark - webservice methods
- (IBAction)shareBtnClicked:(id)sender {
 
    NSString *cat_text=self.categoriestxt.text;
    NSString *headlinetxt=self.heladinetext.text;
    NSString *post_Details=self.posttextview.text;
    UIImage *ourImage=self.postimage;
    NSString *ftype;
   
    ftype=@"Image";
	if([objAppDel.strCurrentUploadType isEqualToString:@"Video"]){
        ftype=@"Video";
    }
	
	if(headlinetxt == nil || [headlinetxt isEqual: [NSNull null]] || [headlinetxt isEqualToString:@""]){
		
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:[TSLanguageManager localizedString:@"MSG_ENTER_HEADLINE"] delegate: self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		
		[someError show];
		[someError release];
	}
	else if(post_Details == nil || [post_Details isEqual: [NSNull null]] || [post_Details isEqualToString:@""]){
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:[TSLanguageManager localizedString:@"MSG_ENTER_DESCRIPTION"] delegate: self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		
		[someError show];
		[someError release];
		
	}else if(cat_text == nil || [cat_text isEqual: [NSNull null]] || [cat_text isEqualToString:@""]){
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:[TSLanguageManager localizedString:@"MSG_SELECT_CATEGORY"] delegate: self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		
		[someError show];
		[someError release];
		
	}else{
		NSData * imageData = UIImagePNGRepresentation(ourImage);//UIImageJPEGRepresentation(ourImage, 1.0);
		
		self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
		[self.alert show];
		UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		indicator.center = CGPointMake(150, 100);
		[indicator startAnimating];
		[self.alert addSubview:indicator];
		
        BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
        if (isConnectionAvail) {
            GlobalVar *gobal_service=[GlobalVar getServiceUrl];
            
            NSString *urlString =gobal_service.servieurl;
            NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
            [request setURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            
            NSMutableData *body = [NSMutableData data];
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
            [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            if([objAppDel.strCurrentUploadType isEqualToString:@"Video"]){
                [body appendData:[@"Content-Disposition: attachment; name=\"vFile\"; filename=\"demo.mp4\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[NSData dataWithContentsOfURL:self.shareVidURL]];
            }
            else{
                [body appendData:[@"Content-Disposition: attachment; name=\"vFile\"; filename=\"imageData.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[NSData dataWithData:imageData]];
            }
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
            
            // Text parameter1
            NSString *param1 = savedMemderid;
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iMemberId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param1] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            // Text parameter2
            NSString *param2 = headlinetxt;
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tPost\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param2] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSString *share_rotation = [prefs stringForKey:@"share_rotation"];
            NSString *param_r = share_rotation;
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"imagerotation\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param_r] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSString *param_ios = @"IOS";
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vType\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param_ios] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            // Text parameter3
            NSString *param3 = self.currentLong;
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vLongitude\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param3] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            // Text parameter4
            NSString *param4 = self.currentLat;
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vLattitude\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param4] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            // Text parameter5
            NSString *param5 = ftype;
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"eFileType\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param5] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            // Text parameter6
            NSString *param6 =post_Details;
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tComments\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param6] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            // Text parameter7
            NSString *param7 =cat_text;
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vCategoryId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param7] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            // Text parameter8
            NSString *param10 = @"setPost";
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param10] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSString *param11 = @"";
            // Text parameter9
            if([_countrytext.text isEqualToString:@"Country"]){
                param11 = @"";
            }else{
                param11 = _countryID.text;
            }
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iCountryId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param11] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            NSString *param12 = @"";
            // Text parameter10
            if([_statetext.text isEqualToString:@"State"]){
                param12 = @"";
            }else{
                param12 = _stateID.text;
            }
            
            // Text parameter11
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iStateId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param12] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            // Text parameter12
            NSString *param13 = @"";
            
            // Text parameter13
            if([_citytext.text isEqualToString:@"City"]){
                param13 = @"";
            }else{
                param13 = _citytext.text;
            }
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vCity\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param13] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSString *param14 = @"";
            
            // Another text parameter
            if(fbShareOn == 0){
                param14 = @"";
            }else{
                param14 = @"FACEBOOK";
            }
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"isShareWithFacebook\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param14] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSString *param15 = @"";
            // Another text parameter
            if(TwShareOn == 0){
                param15 = @"";
            }else{
                param15 = @"TWITTER";
            }
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"isShareWithTwitter\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param15] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vIP\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:objAppDel.deviceCurrentIP] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            // close form
            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            
//            NSString* json_string = [[NSString alloc] initWithData:body encoding:NSASCIIStringEncoding];
//            NSLog(@"json_string :%@",json_string);
            // set request body
            [request setHTTPBody:body];
            
            //return and test
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse* response, NSData* receivedData, NSError* error)
             {
                 
                 
                 [self.alert dismissWithClickedButtonIndex:0 animated:YES];
                 
                 NSString *returnString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
                 
                 NSError *e = nil;
                 id object = [NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
                 id responseMessage=[object valueForKey:@"message"];
                 
                 NSString *success =[responseMessage valueForKey:@"success"];
                 NSString *msg =[responseMessage valueForKey:@"msg"];
                 if([success integerValue] == 1){
                     //                        NSMutableString *message=[responseMessage valueForKey:@"msg"];
                     DetailfeedViewController *DetailController = [[DetailfeedViewController alloc] initWithNibName:objAppDel.detailfeedView bundle:nil]; [self.navigationController pushViewController:DetailController animated:YES];
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
}

#pragma mark - LocationData methods
#pragma ShowCountry
-(void)showCountry:(UITapGestureRecognizer *)recognizer
{
	[self dismissKeyboard];
	self.countryName = [[NSMutableArray alloc]
							  initWithObjects: nil];
	self.countryId = [[NSMutableArray alloc]
							initWithObjects: nil];
	
	stateClick = 0;
	catClick = 0;
	int i=0;
    NSString *selectedCategory = @"0";
    
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        NSString *countryData = objAppDel.countryStr;;
        NSError *e = nil;
        id object = [NSJSONSerialization JSONObjectWithData:[countryData dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
        id response_Data=[object valueForKey:@"data"];
        
        for (NSDictionary *dic in response_Data){
            // Now you have dictionary get value for key
            NSString *vCountry = (NSString*) [dic valueForKey:@"vCountry"];
            NSString *iCountryId = (NSString*) [dic valueForKey:@"iCountryId"];
            
            [self.countryName addObject:vCountry];
            [self.countryId addObject:iCountryId];
            
            if([vCountry isEqualToString:_countrytext.text]){
                selectedCategory = [NSString stringWithFormat:@"%d",i];
            }
            i++;
        }
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }

        
        array_from=self.countryName;

        CGSize result = [[UIScreen mainScreen] bounds].size;
        myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, result.height-200, result.width, 310)];
        
        [self.view addSubview:myPickerView];
        myPickerView.delegate = self;
     
        [myPickerView selectRow:[selectedCategory integerValue] inComponent:0 animated:YES];
        [myPickerView setBackgroundColor:[UIColor grayColor]];
        myPickerView.showsSelectionIndicator = YES;
        doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton setBackgroundColor:[UIColor blackColor]];
        doneButton.frame = CGRectMake(result.width-70,result.height-240,  70, 40.0);
        [doneButton addTarget:self
						action:@selector(aMethod:)
		  forControlEvents:UIControlEventTouchDown];
	
        [self.view addSubview:doneButton];
}
#pragma ShowState
-(void)showState:(UITapGestureRecognizer *)recognizer
{
	[self dismissKeyboard];
	self.stateName = [[NSMutableArray alloc]
							initWithObjects: nil];
	self.stateId = [[NSMutableArray alloc]
						 initWithObjects: nil];
	
	stateClick = 1;
	catClick = 0;
	
	NSString *stateData = objAppDel.stateStr;;
	
	NSError *e = nil;
	id object = [NSJSONSerialization JSONObjectWithData:[stateData dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
	
	id response_Data=[object valueForKey:@"data"];
	int i=0;
    
    NSString *selectedCategory = @"0";
	for (NSDictionary *dic in response_Data){
		NSString *vCountry = (NSString*) [dic valueForKey:@"vState"];
		NSString *iCountryId = (NSString*) [dic valueForKey:@"iStateId"];
        NSString *iStateCountryId = (NSString*) [dic valueForKey:@"vCountry"];
        
        if([_countrytext.text isEqualToString:@""] || _countrytext.text == NULL){
                [self.stateName addObject:vCountry];
                [self.stateId addObject:iCountryId];
            
                if([vCountry isEqualToString:_statetext.text]){
                    selectedCategory = [NSString stringWithFormat:@"%d",i];
                }
                i++;
        }else{
            if([_countrytext.text isEqualToString:iStateCountryId]){
                [self.stateName addObject:vCountry];
                [self.stateId addObject:iCountryId];
                
                if([vCountry isEqualToString:_statetext.text]){
                    selectedCategory = [NSString stringWithFormat:@"%d",i];
                }
                i++;
            }
        }
	}
	
	array_from=self.stateName;
	CGSize result = [[UIScreen mainScreen] bounds].size;
	myPickerView1 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, result.height-200, result.width, 310)];
	[self.view addSubview:myPickerView1];
	myPickerView1.delegate = self;
    [myPickerView1 selectRow:[selectedCategory integerValue] inComponent:0 animated:YES];
	[myPickerView1 setBackgroundColor:[UIColor grayColor]];
	myPickerView1.showsSelectionIndicator = YES;
    
	doneButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
	[doneButton1 setTitle:@"Done" forState:UIControlStateNormal];
	[doneButton1 setBackgroundColor:[UIColor blackColor]];
	doneButton1.frame = CGRectMake(result.width-70,result.height-240,  70, 40.0);
	[doneButton1 addTarget:self
						action:@selector(aMethod1:)
		  forControlEvents:UIControlEventTouchDown];
	[self.view addSubview:doneButton1];
}
#pragma Get map value
-(void)getMapValue:(UITapGestureRecognizer *)recognizer
{
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	locationManager.distanceFilter = kCLDistanceFilterNone;
	[locationManager startUpdatingLocation];
	
	CLLocation *location = [locationManager location];
	
	CLLocationCoordinate2D coordinate = [location coordinate];
	
	NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
	NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
	self.currentLat =latitude;
	self.currentLong =longitude;
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:latitude forKey:@"local_Latitude"];
	[prefs setObject:longitude forKey:@"local_Longitude"];
	
	CLGeocoder *geocoder = [[CLGeocoder alloc] init];
	[geocoder reverseGeocodeLocation: location completionHandler:
	 ^(NSArray *placemarks, NSError *error) {
		 
        //Get nearby address
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
        //String to hold address
         NSString *locatedAtState = placemark.administrativeArea;
         NSString *locatedAtcountry = placemark.country;
         NSString *locatedAtcity = placemark.locality;
         NSString *locatedAtisocountry = placemark.ISOcountryCode;
		 
		 [prefs setObject:locatedAtcountry forKey:@"local_Country"];
		 [prefs setObject:locatedAtisocountry forKey:@"local_CountryCode"];
		 [prefs setObject:locatedAtState forKey:@"local_State"];
		 [prefs setObject:locatedAtcity forKey:@"local_City"];
		 
		 [_countrytext setText:[NSString stringWithFormat:@"%@",locatedAtcountry]];
		 _countryID.text =[NSString stringWithFormat:@"%@",locatedAtisocountry];
         if (locatedAtcity == nil) {
             _citytext.text =@"City";
         }
         else
         {
             _citytext.text =[NSString stringWithFormat:@"%@",locatedAtcity];
         }
		 [_statetext setText:[NSString stringWithFormat:@"%@",locatedAtState]];
		 _stateID.text =[NSString stringWithFormat:@"%@",locatedAtState];
	}];
	[self.AddtoMaptext setText:[NSString stringWithFormat:@"%@, %@",latitude,longitude]];
}
#pragma ShowCategory
-(void)showCategory:(UITapGestureRecognizer *)recognizer
{
	[self dismissKeyboard];
	self.categoryName = [[NSMutableArray alloc]initWithObjects: nil];
	self.categoryId = [[NSMutableArray alloc]initWithObjects: nil];
	
	catClick = 1;
	stateClick = 2;
	
	NSString *stateData = objAppDel.categoryStr;
	
	NSError *e = nil;
	id object = [NSJSONSerialization JSONObjectWithData:[stateData dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
	id response_Data=[object valueForKey:@"data"];
    int i = 0;
    NSString *selectedCategory = @"0";
    for (NSDictionary *dic in response_Data){
        NSString *vCategory = (NSString*) [dic valueForKey:@"vCategory"];
        NSString *iCategoryId = (NSString*) [dic valueForKey:@"iCategoryId"];
            
        [self.categoryName addObject:vCategory];
        [self.categoryId addObject:iCategoryId];
        if([iCategoryId isEqualToString:categoriestxt.text]){
            selectedCategory = [NSString stringWithFormat:@"%d",i];
        }
        i++;
	}
	
	array_from=self.categoryName;
	stateClick = 1;
	CGSize result = [[UIScreen mainScreen] bounds].size;
	
	myPickerView2 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, result.height-200, result.width, 310)];
	[self.view addSubview:myPickerView2];
	myPickerView2.delegate = self;
 
     [myPickerView2 selectRow:[selectedCategory integerValue] inComponent:0 animated:YES];
     [myPickerView2 setBackgroundColor:[UIColor grayColor]];
     myPickerView2.showsSelectionIndicator = YES;
    
     doneButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
     [doneButton2 setTitle:@"Done" forState:UIControlStateNormal];
     [doneButton2 setBackgroundColor:[UIColor blackColor]];
     doneButton2.frame = CGRectMake(result.width-70,result.height-240,  70, 40.0);
	 [doneButton2 addTarget:self
						action:@selector(aMethod2:)
		  forControlEvents:UIControlEventTouchDown];
	
	[self.view addSubview:doneButton2];
}

#pragma mark - PickerView Delegate methods
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [array_from count];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if(catClick == 1){
		[_cattext setText:[NSString stringWithFormat:@"%@",[array_from objectAtIndex:[pickerView selectedRowInComponent:0]]]];
		categoriestxt.text =[NSString stringWithFormat:@"%@",[self.categoryId objectAtIndex:[pickerView selectedRowInComponent:0]]];
	}else{
		if(stateClick == 0){
			[_countrytext setText:[NSString stringWithFormat:@"%@",[array_from objectAtIndex:[pickerView selectedRowInComponent:0]]]];
			_countryID.text =[NSString stringWithFormat:@"%@",[self.countryId objectAtIndex:[pickerView selectedRowInComponent:0]]];
		}else if (stateClick == 1){
			[_statetext setText:[NSString stringWithFormat:@"%@",[array_from objectAtIndex:[pickerView selectedRowInComponent:0]]]];
			_stateID.text =[NSString stringWithFormat:@"%@",[self.stateId objectAtIndex:[pickerView selectedRowInComponent:0]]];
		}
	}
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [array_from objectAtIndex:row];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	CGFloat componentWidth = 0.0;
	CGSize result = [[UIScreen mainScreen] bounds].size;
	componentWidth = result.width;
 
	return componentWidth;
}

#pragma webview delegate methods
-(void)webViewDidFinishLoad:(UIWebView *)webView {
	NSLog(@"finish %ld",(long)twittewCallBack2);
	if(twittewCallBack2 == 1){
        
		NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('pre')[0].innerHTML"];
		NSDictionary *myDictionary = [html objectFromJSONString];
		
		id responseMessage=[myDictionary valueForKey:@"data"];
//		NSMutableString *vUsername=[responseMessage valueForKey:@"vUsername"];
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
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
			
            // Another text parameter
            NSString *param_men = savedMemderid;
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iMemberId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param_men] dataUsingEncoding:NSUTF8StringEncoding]];
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
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tDeviceToken\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:objAppDel.strDeviceToken] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vIP\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:objAppDel.deviceCurrentIP] dataUsingEncoding:NSUTF8StringEncoding]];
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
            NSString *messagestr=[messageData valueForKey:@"msg"];
            
            if([message integerValue] == 1){
                [self.alert dismissWithClickedButtonIndex:0 animated:YES];
                self.webview.hidden = YES;
                self.close.hidden = YES;
            }
            else{
                [self.alert dismissWithClickedButtonIndex:0 animated:YES];
                self.webview.hidden = YES;
                self.close.hidden = YES;
                UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_ALERT"] message:messagestr delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [someError show];
                [someError release];
            }
        }
        else{
            DisplayAlert(NoNetworkConnection);
        }
	}
}
#pragma start loading
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSString *URLString = [[request URL] absoluteString];
	if ([URLString rangeOfString:@"action=callBackTwitter"].location != NSNotFound) {
		if ([URLString rangeOfString:@"oauth_token="].location == NSNotFound) {
		} else {
			twittewCallBack2 = 1;
		}
	}
	return YES;
}

#pragma mark - FB Authentication and Session method
-(void)flogin
{
	[FBSession openActiveSessionWithReadPermissions:@[@"email",@"user_location",@"user_birthday",@"user_hometown"]allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
												
        switch (state) {
            case FBSessionStateOpen:
              [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                    if (error) {
                        NSLog(@"error:%@",error);
                    }
                    else
                    {
                        NSArray *permissions = [NSArray arrayWithObjects:@"publish_actions", nil];
          
                        [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES
                                           completionHandler:^(FBSession *session, FBSessionState state, NSError *error)
                        {
                                               
                             switch (state) {
                             case FBSessionStateOpen:
                                  [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
                                     {
                                       if (error) {
                                       }
                                       else
                                       {
                                            NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
                                            
                                            NSString*f_murl=@"http://graph.facebook.com/";
                                            NSString*f_uname=user.username;
                                            NSString*f_last=@"/picture?type=square";
                                            NSArray *myStrings = [[NSArray alloc] initWithObjects:f_murl, f_uname,f_last, nil];
                                            
                                            NSString *joinedString = [myStrings componentsJoinedByString:@""];
                                            
                                            NSURL *url_img = [NSURL URLWithString:joinedString];
                                            NSData *data1 = [NSData dataWithContentsOfURL:url_img];
                                           
                                            self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
                                            [self.alert show];
                                            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                                            indicator.center = CGPointMake(150, 100);
                                            [indicator startAnimating];
                                            [self.alert addSubview:indicator];
                                            [indicator release];
                                                            
                                            UIImage *ourImage=[UIImage imageWithData:data1];
                                            NSData * imageData = UIImageJPEGRepresentation(ourImage, 1.0);
                                            // NSString *urlString = @"http://192.168.1.41/php/videoblog/webservice";
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
                                            
                                            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                                            NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
                                           
                                           // Text parameter1
                                            NSString *param1 = savedMemderid;
                                            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                                            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iMemberId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                                            [body appendData:[[NSString stringWithString:param1] dataUsingEncoding:NSUTF8StringEncoding]];
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
                                            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tDeviceToken\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                                            [body appendData:[[NSString stringWithString:objAppDel.strDeviceToken] dataUsingEncoding:NSUTF8StringEncoding]];
                                            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                                            
                                            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                                            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vIP\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                                            [body appendData:[[NSString stringWithString:objAppDel.deviceCurrentIP] dataUsingEncoding:NSUTF8StringEncoding]];
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
                                            
                                            if([message integerValue] == 1){
//                                                id responseDatas=[object valueForKey:@"data"];
                                            }
                                            else{
                                           
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

#pragma mark - Textview Delegate methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {
	return [self isAcceptableTextLength:posttextview.text.length + string.length - range.length];
}
-(BOOL)textViewShouldBeginEditing: (UITextView *)textView
{
     CGSize result = [[UIScreen mainScreen] bounds].size;
     UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, result.width, 50)];
     
     keyboardToolBar.barStyle = UIBarStyleDefault;
     [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                 [[UIBarButtonItem alloc]initWithTitle:[TSLanguageManager localizedString:@"LBL_PREV"] style:UIBarButtonItemStyleBordered target:self action:@selector(previousTextField)],
                                 
                                 [[UIBarButtonItem alloc] initWithTitle:[TSLanguageManager localizedString:@"LBL_NEXT"] style:UIBarButtonItemStyleBordered target:self action:@selector(nextTextField)],
                                 [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                 nil]];
     textView.inputAccessoryView = keyboardToolBar;
      return true;
}
-(void)textViewDidBeginEditing:(UITextView *)textField
{
    if(textField==self.posttextview){
        currentFieldShare = 1;
		self.who_when_placholder.hidden = YES;
	}
}
-(void)textViewDidEndEditing:(UITextView *)textField
{
	if ([self.posttextview.text length]==0) {
		self.who_when_placholder.hidden = NO;
	}
	[[self view] endEditing:YES];
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
     [self.categoriestxt resignFirstResponder];
     [maptext resignFirstResponder];
     [heladinetext resignFirstResponder];
     [self.citytext resignFirstResponder];
        if(textField == self.citytext){
            currentFieldShare = 2;
//            self.scrollview.frame=CGRectMake(self.scrollview.frame.origin.x, self.scrollview.frame.origin.y, self.scrollview.frame.size.width, self.scrollview.frame.size.height);
        }
     return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
     if(textField == self.heladinetext){
      currentFieldShare = 0;
     }else if(textField == self.citytext){
         currentFieldShare = 2;
         if (isiPad) {
             
         }
         else{
             if (isiPhone5) {
                 [self.scrollview setContentOffset:CGPointMake(0, 140) animated:YES];
             }
             else{
                 [self.scrollview setContentOffset:CGPointMake(0, 230) animated:YES];
             }
         }
     }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.citytext){
        if (isiPad) {
            
        }
        else{
            if (isiPhone5) {
                [self.scrollview setContentOffset:CGPointMake(0, 63) animated:YES];
            }
            else{
                [self.scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        }
        
    }
}

@end
