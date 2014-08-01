//
//  GeneralSettingsViewController.m
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/24/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import "GeneralSettingsViewController.h"
#import "AppDelegate.h"
#import "TSLanguageManager.h"
#import "GlobalVar.h"
#import "constant.h"

@interface GeneralSettingsViewController ()

@end
//initialise variable
NSInteger cameraON = 0;

@implementation GeneralSettingsViewController
@synthesize backbtn;

#pragma mark - view controller methods
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
    if (isiPad) {
        
    }
    else{
        if (isiPhone5) {
            
        }
        else{
            [scrollView setFrame:CGRectMake(0, 150, 320, 420)];
        }
    }
    
    self.backbtn.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_B =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gobackF_General:)];
	[self.backbtn addGestureRecognizer:tap_B];
	[tap_B release];
	
	self.choose_language.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_language =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLanguage:)];
	[self.choose_language addGestureRecognizer:tap_language];
	[tap_language release];
	
	self.lbl_save_setting.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_save =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveSettings:)];
	[self.lbl_save_setting addGestureRecognizer:tap_save];
	[tap_save release];
}
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	self.languageName = [[NSMutableArray alloc] initWithObjects: nil];
	self.languageId = [[NSMutableArray alloc] initWithObjects: nil];
	
	array_from= [[NSMutableArray alloc] initWithObjects: nil];
	NSMutableArray *items =[[NSMutableArray alloc]initWithObjects:@"",[TSLanguageManager localizedString:@"SELECT_LANG_POP_ENG_BTN"],[TSLanguageManager localizedString:@"SELECT_LANG_POP_POR_BTN"],nil];
	NSMutableArray *items1 =[[NSMutableArray alloc]initWithObjects:@"en",@"en",@"pt",nil];
	self.languageName =items;
	self.languageId =items1;
	
	NSString *sel_language = [prefs stringForKey:@"sel_language"];
	NSString *set_direct_camera = [prefs stringForKey:@"set_direct_camera"];
	
	if([set_direct_camera isEqualToString:@"ON"]){
		self.camera_switch.on = YES;
	}
	if([sel_language isEqualToString:@"pt"]){
		self.lbl_selected_language.text =[TSLanguageManager localizedString:@"SELECT_LANG_POP_POR_BTN"];
		[self.selected_language setText:[NSString stringWithFormat:@"%@",@"pt"]];
		[TSLanguageManager setSelectedLanguage:kLMPortu];
	}else{
		self.lbl_selected_language.text =[TSLanguageManager localizedString:@"SELECT_LANG_POP_ENG_BTN"];
		[self.selected_language setText:[NSString stringWithFormat:@"%@",@"en"]];
		[TSLanguageManager setSelectedLanguage:kLMEnglish];
	}
    //call update label
	[self updateLabel];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Other methods
- (void)gobackF_General:(UITapGestureRecognizer *)recognizer  {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showLanguage:(UITapGestureRecognizer *)recognizer
{
	array_from=self.languageName;
	CGSize result = [[UIScreen mainScreen] bounds].size;
	
	myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, result.height-200, result.width, 200)];
	[self.view addSubview:myPickerView];
	myPickerView.delegate = self;
     if([self.selected_language.text isEqualToString:@"en"]){
         [myPickerView selectRow:1 inComponent:0 animated:YES];
     }else{
         [myPickerView selectRow:2 inComponent:0 animated:YES];
     }
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
-(void) updateLabel
{
	self.lbl_camera_set.text =[TSLanguageManager localizedString:@"LBL_SET_CAMERA"];
	self.lbl_language.text =[TSLanguageManager localizedString:@"LBL_LANGUAGE"];
	self.lbl_save_setting.text =[TSLanguageManager localizedString:@"LBL_SAVE_SETTING"];
	self.lbl_setting.text =[TSLanguageManager localizedString:@"LBL_SETTING"];
}
- (BOOL)prefersStatusBarHidden
{
	return YES;
}

#pragma mark - Action methods
-(IBAction)aMethod:(id)sender
{
	[myPickerView removeFromSuperview];
	[doneButton removeFromSuperview];
}
- (IBAction)FBchangeSwitch:(id)sender{
	if([sender isOn]){
		cameraON =1;
	} else{
		cameraON = 0;
	}
}

#pragma  mark - PickerView delegate mathods
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return 3;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if([[self.languageId objectAtIndex:[pickerView selectedRowInComponent:0]] isEqualToString:@""]){
	
	}
    else{
		[self.selected_language setText:[NSString stringWithFormat:@"%@",[self.languageId objectAtIndex:[pickerView selectedRowInComponent:0]]]];
		self.lbl_selected_language.text = [NSString stringWithFormat:@"%@",[self.languageName   objectAtIndex:[pickerView selectedRowInComponent:0]]];
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


#pragma mark - Response Delegate methods
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//	NSError *e = nil;
	
//	NSString *json = [[NSString alloc] initWithData:self.responseData  encoding:NSUTF8StringEncoding];
	
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
//	id responseobject = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
//	id object=[responseobject valueForKey:@"message"];
	
//	NSMutableString *message=[object valueForKey:@"msg"] ;
//	NSString *suc_msg=[[object valueForKey:@"success"]stringValue];
	
	if([self.selected_language.text isEqualToString:@"en"]){
		NSString *selectedLanguage = @"en";
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		[prefs setObject:selectedLanguage forKey:@"sel_language"];
		[prefs synchronize];
		[TSLanguageManager setSelectedLanguage:kLMEnglish];
		self.lbl_selected_language.text = [TSLanguageManager localizedString:@"SELECT_LANG_POP_ENG_BTN"];
		
        //call update label
		[self updateLabel];
	}else{
		NSString *selectedLanguage = @"pt";
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		[prefs setObject:selectedLanguage forKey:@"sel_language"];
		[prefs synchronize];
		[TSLanguageManager setSelectedLanguage:kLMPortu];
        //call update label
		[self updateLabel];
		self.lbl_selected_language.text = [TSLanguageManager localizedString:@"SELECT_LANG_POP_POR_BTN"];
	}
	NSMutableArray *items =[[NSMutableArray alloc]initWithObjects:@"",[TSLanguageManager localizedString:@"SELECT_LANG_POP_ENG_BTN"],[TSLanguageManager localizedString:@"SELECT_LANG_POP_POR_BTN"],nil];
	self.languageName =items;
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	[self.responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[self.responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[error localizedDescription],
	[[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey];
}

#pragma mark - Webserice Call
-(void)saveSettings:(UITapGestureRecognizer *)recognizer{
    //alert
	self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[self.alert show];
    //activity indicator
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.center = CGPointMake(150, 100);
	[indicator startAnimating];
	[self.alert addSubview:indicator];
	
	NSString *Cammode = @"OFF";
	if(cameraON == 1){
		Cammode = @"ON";
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		[prefs setObject:@"ON" forKey:@"set_direct_camera"];
		[prefs synchronize];
	}else{
		Cammode = @"OFF";
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		[prefs setObject:@"OFF" forKey:@"set_direct_camera"];
		[prefs synchronize];
	}
	
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        self.responseData = [NSMutableData data];
		
        GlobalVar *s_url=[GlobalVar getServiceUrl];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
        
        NSString *url=[NSString stringWithFormat:@"%@?action=setMemberSettings&iMemberId=%@&iLangId=%@&eCameraMode=%@", s_url.servieurl,savedMemderid,self.selected_language.text,Cammode];
        NSLog(@"Save Language API %@",url);
        NSURL *myURL = [NSURL URLWithString:url];
        
        NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
        
        [NSURLConnection connectionWithRequest:myRequest delegate:self];

    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
}

@end
