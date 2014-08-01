	//
	//  EditprofileViewController.m
	//  MobiNesw
	//
	//  Created by Snehasis Mohapatra on 1/23/14.
	//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
	//

#import "EditprofileViewController.h"
#import "AccountSettingViewController.h"
#import "GeneralSettingsViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "constant.h"
#import "GlobalVar.h"
#import "TSLanguageManager.h"

@interface EditprofileViewController ()

@end

NSInteger edit_rotation = 0;
NSInteger edit_currentrotation = 0;
NSInteger currentFieldEdit = 0;

@implementation EditprofileViewController
@synthesize responseData,E_userimg,scrollview,backimg,plusimg,gotoGeneralimg,E_name,E_username,E_userwebsite,E_Desc;
@synthesize E_password,E_Email,E_phone,E_userPhoto,lbl_user_info,lbl_user_private_info,lbl_Save,lbl_logout,lbl_general_setting;
@synthesize popover,alert,serviceURL;

#pragma mak - viewcontroller delegate methods
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
	
	self.lbl_general_setting.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_general =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoGeenral:)];
	[self.lbl_general_setting addGestureRecognizer:tab_general];
	[tab_general release];
	
	self.backimg.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_backf =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backFromEditProifle:)];
	[self.backimg addGestureRecognizer:tab_backf];
	[tab_backf release];
	
	self.plusimg.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_plus =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoAccountsettings:)];
	[self.plusimg addGestureRecognizer:tab_plus];
	[tab_plus release];
	
    //---- -- initialize takephoto tab------
	self.E_userPhoto.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_takePoto =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OpenPhotoActionsheet:)];
	[self.E_userPhoto addGestureRecognizer:tab_takePoto];
	[tab_takePoto release];
	
	[self getProfileDetail];
}
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    if (isiPad) {
        
    }
    else{
        if (isiPhone5) {
            
        }
        else{
            [self.scrollview setFrame:CGRectMake(0, 60, 320, 420)];
            [self.scrollview setContentSize:CGSizeMake(320, 480)];
        }
    }
    
	[self.scrollview setContentOffset:CGPointZero animated:YES];
    
    edit_rotation = 0;
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *sel_language = [prefs stringForKey:@"sel_language"];
	NSLog(@"sel_language %@",sel_language);
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
}

#pragma mark - Other methods
- (void)gotoGeenral:(UITapGestureRecognizer *)recognizer  {
	GeneralSettingsViewController *genearlController = [[GeneralSettingsViewController alloc] initWithNibName:objAppDel.generalSettingView bundle:nil]; [self.navigationController pushViewController:genearlController animated:YES];
}
- (void)gotoAccountsettings:(UITapGestureRecognizer *)recognizer  {
	AccountSettingViewController *acController = [[AccountSettingViewController alloc] initWithNibName:objAppDel.accountSettingView bundle:nil]; [self.navigationController pushViewController:acController animated:YES];
}
- (void)backFromEditProifle:(UITapGestureRecognizer *)recognizer  {
	
	[self.navigationController popViewControllerAnimated:YES];
}
-(void) updateLabel
{
	self.E_name.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[TSLanguageManager localizedString:@"LBL_NAME"]];
	self.E_Desc.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[TSLanguageManager localizedString:@"LBL_DESCRIPTION"]];
	self.E_Email.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[TSLanguageManager localizedString:@"LBL_EMAIL"]];
	self.E_password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[TSLanguageManager localizedString:@"LBL_PASSWORD"]];
	self.E_phone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[TSLanguageManager localizedString:@"LBL_PHONE"]];
	self.E_username.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[TSLanguageManager localizedString:@"LBL_USERNAME"]];
	self.E_userwebsite.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[TSLanguageManager localizedString:@"LBL_WEBSITE"]];
	
	self.lbl_user_info.text =[TSLanguageManager localizedString:@"LBL_USER_INFO"];
	self.lbl_user_private_info.text =[TSLanguageManager localizedString:@"LBL_PRIVATE_INFO"];
	
	self.lbl_general_setting.text =[TSLanguageManager localizedString:@"LBL_GENERAL_SETTING"];
	
	[self.lbl_logout setTitle:[TSLanguageManager localizedString:@"LBL_LOGOUT"] forState:UIControlStateNormal];
	[self.lbl_Save setTitle:[TSLanguageManager localizedString:@"LBL_SAVE"] forState:UIControlStateNormal];
}
- (void)nextTextField {
    if (currentFieldEdit == 0) {
        currentFieldEdit = 1;
        [self.E_name resignFirstResponder];
        [self.E_username becomeFirstResponder];
    }
    else if (currentFieldEdit == 1) {
        currentFieldEdit = 2;
        [self.E_username resignFirstResponder];
        [self.E_userwebsite becomeFirstResponder];
    }
    else if (currentFieldEdit == 2) {
        currentFieldEdit = 3;
        [self.E_userwebsite resignFirstResponder];
        [self.E_Desc becomeFirstResponder];
    }
    else if (currentFieldEdit == 3) {
        currentFieldEdit = 4;
        [self.E_Desc resignFirstResponder];
        [self.E_password becomeFirstResponder];
    }
    else if (currentFieldEdit == 4) {
        currentFieldEdit = 5;
        [self.E_password resignFirstResponder];
        [self.E_Email becomeFirstResponder];
    }
    else if (currentFieldEdit == 5) {
        currentFieldEdit = 6;
        [self.E_Email resignFirstResponder];
        [self.E_phone becomeFirstResponder];
    }
    else if (currentFieldEdit == 6) {
        currentFieldEdit = 0;
        [self.E_phone resignFirstResponder];
    }
}
-(void)previousTextField
{
    if (currentFieldEdit == 0) {
        currentFieldEdit = 0;
        [self.E_name resignFirstResponder];
    }
    else if (currentFieldEdit == 1) {
        currentFieldEdit = 0;
        [self.E_username resignFirstResponder];
        [self.E_name becomeFirstResponder];
    }
    else if (currentFieldEdit == 2) {
        currentFieldEdit = 1;
        [self.E_userwebsite resignFirstResponder];
        [self.E_username becomeFirstResponder];
    }
    else if (currentFieldEdit == 3) {
        currentFieldEdit = 2;
        [self.E_Desc resignFirstResponder];
        [self.E_userwebsite becomeFirstResponder];
    }
    else if (currentFieldEdit == 4) {
        currentFieldEdit = 3;
        [self.E_password resignFirstResponder];
        [self.E_Desc becomeFirstResponder];
    }
    else if (currentFieldEdit == 5) {
        currentFieldEdit = 4;
        [self.E_Email resignFirstResponder];
        [self.E_password becomeFirstResponder];
    }
    else if (currentFieldEdit == 6) {
        currentFieldEdit = 5;
        [self.E_phone resignFirstResponder];
        [self.E_Email becomeFirstResponder];
    }
}
-(void)resignKeyboard {
    [self.E_Desc resignFirstResponder];
	[self.E_Email resignFirstResponder];
	[self.E_name resignFirstResponder];
	[self.E_password resignFirstResponder];
	[self.E_phone resignFirstResponder];
	[self.E_username resignFirstResponder];
	[self.E_userwebsite resignFirstResponder];
}
- (BOOL)prefersStatusBarHidden
{
	return YES;
}

#pragma mark - ActionSheet methods
- (void)OpenPhotoActionsheet:(UITapGestureRecognizer *)recognizer  {
	UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Photo", nil];
	[actionSheet showInView:self.view];
}
#pragma ActionSheet Delegate method
//---------when action sheet btn clicked-----------------------
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
			}
            else {
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
- (IBAction)RotateClickedRight:(UITapGestureRecognizer *)recognizer {
    if(edit_rotation == -360){
        edit_rotation = 0;
    }
    edit_rotation = edit_rotation-90;
    edit_currentrotation =edit_rotation;
	self.E_userPhoto.transform = CGAffineTransformMakeRotation(edit_rotation * M_PI / 180.0);
}
- (IBAction)RotateClicked:(id)sender {
    if(edit_rotation == 360){
        edit_rotation = 0;
    }
	edit_rotation = edit_rotation+90;
    edit_currentrotation =edit_rotation;
	self.E_userPhoto.transform = CGAffineTransformMakeRotation(edit_rotation * M_PI / 180.0);
}
- (IBAction)logoutClicked:(id)sender {
    self.responseData = [NSMutableData data];
    GlobalVar *s_url=[GlobalVar getServiceUrl];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
    NSString *url=[NSString stringWithFormat:@"%@?action=userLogout&iMemberId=%@&vIP=%@", s_url.servieurl,savedMemderid,objAppDel.deviceCurrentIP];
    NSLog(@"Logout API %@",url);
    NSURL *myURL = [NSURL URLWithString:url];
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
    
    [NSURLConnection connectionWithRequest:myRequest delegate:self];
}

#pragma mark - WebService Call
#pragma getProfileDetail
-(void)getProfileDetail{
	self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[self.alert show];
	
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
                 
                 //                NSString *iMemberId=[responseDatas valueForKey:@"iMemberId"];
                 NSString *vPicture=[responseDatas valueForKey:@"vPicture"];
                 if ([vPicture isEqual:[NSNull null]] ) {
                     self.E_userPhoto.image = nil;
                 }
                 else{
                     dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                     dispatch_async(queue, ^{
                         NSURL *url_img = [NSURL URLWithString:vPicture];
                         NSLog(@"IMAGE URL %@",url_img);
                         NSData *data = [NSData dataWithContentsOfURL:url_img];
                         
                         dispatch_sync(dispatch_get_main_queue(), ^{
                             self.E_userPhoto.image=[UIImage imageWithData:data];
                         });
                     });
                 }
                 
                 NSString *vName=[responseDatas valueForKey:@"vName"];
                 if ([vName isEqual:[NSNull null]] ) {
                     self.E_name.placeholder = @"Name";
                 }
                 else{
                     self.E_name.text =[NSString stringWithFormat:@"%@", vName];
                 }
                 
                 NSString *vUsername=[responseDatas valueForKey:@"vUsername"];
                 if ([vUsername isEqual:[NSNull null]] ) {
                     self.E_username.text =@"Username";
                 }
                 else{
                     self.E_username.text =[NSString stringWithFormat:@"%@", vUsername];
                 }
                 
                 NSString *vURL=[responseDatas valueForKey:@"vURL"];
                 if ([vURL isEqual:[NSNull null]] ) {
                     self.E_userwebsite.placeholder = @"Website";
                 }
                 else{
                     self.E_userwebsite.text =[NSString stringWithFormat:@"%@", vURL];
                 }
                 
                 NSString *tDescription=[responseDatas valueForKey:@"tDescription"];
                 if ([tDescription isEqual:[NSNull null]] ) {
                     self.E_Desc.placeholder = @"Description";
                 }
                 else{
                     self.E_Desc.text =[NSString stringWithFormat:@"%@", tDescription];
                 }
                 
                 NSString *vEmail=[responseDatas valueForKey:@"vEmail"];
                 if ([vEmail isEqual:[NSNull null]] ) {
                     self.E_Email.placeholder = @"Email";
                 }
                 else{
                     self.E_Email.text =[NSString stringWithFormat:@"%@", vEmail];
                 }
                 
                 NSString *vPhone=[responseDatas valueForKey:@"vPhone"];
                 if ([vPhone isEqual:[NSNull null]] ) {
                     self.E_phone.placeholder = @"Phone";
                 }
                 else{
                     self.E_phone.text =[NSString stringWithFormat:@"%@", vPhone];
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
#pragma saveProfile
- (void)saveProfile:(id)sender  {
   //alert
	self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[self.alert show];
	
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.center = CGPointMake(150, 100);
	[indicator startAnimating];
	[self.alert addSubview:indicator];
	[indicator release];
	
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        UIImage *ourImage=self.E_userPhoto.image;//self.userimg;
        NSData * imageData = UIImageJPEGRepresentation(ourImage, 1.0);
        NSString *urlString = [NSString stringWithFormat:@"%@?action=setProfileDetails", serviceURL];
        
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
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
        
        NSString *param1 = savedMemderid;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iMemberId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param1] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param2 = [NSString stringWithFormat:@"%@", self.E_username.text];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vUsername\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param2] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *param3 = [NSString stringWithFormat:@"%@", self.E_name.text];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vName\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param3] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *paramemail = [NSString stringWithFormat:@"%@", self.E_Email.text];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vEmail\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:paramemail] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param5 = [NSString stringWithFormat:@"%@", self.E_userwebsite.text];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vURL\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param5] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param6 = @"IOS";
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vType\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param6] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param7 = [NSString stringWithFormat:@"%ld", (long)edit_currentrotation];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"imagerotation\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param7] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param8 = [NSString stringWithFormat:@"%@", self.E_phone.text];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vPhone\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param8] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *param9 =  [NSString stringWithFormat:@"%@", self.E_Desc.text];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tDescription\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param9] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *param_p = [NSString stringWithFormat:@"%@", self.E_password.text];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vPassword\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param_p] dataUsingEncoding:NSUTF8StringEncoding]];
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
            // [self.alert dismissWithClickedButtonIndex:0 animated:YES];
             
             id object = [NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
             id responseMessage=[object valueForKey:@"message"];
             
             NSMutableString *message=[responseMessage valueForKey:@"msg"];
             if([message isEqualToString:@"Register succesfully"]){
                 id responseDatas=[object valueForKey:@"data"];
                 
                 NSMutableString *iMemberId=[responseDatas valueForKey:@"iMemberId"];
                 
                 NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                 [prefs setObject:iMemberId forKey:@"local_Memberid"];
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

#pragma mark - ImagePickervontroller delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
	self.E_userPhoto.image=chosenImage;
	[picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Response Delegate methods
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//	NSError *e = nil;
	
//	NSString *json = [[NSString alloc] initWithData:self.responseData  encoding:NSUTF8StringEncoding];
	
//	id responseobject = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
//	id object=[responseobject valueForKey:@"message"];
	
//	NSMutableString *message=[object valueForKey:@"msg"] ;
//	NSString *suc_msg=[[object valueForKey:@"success"]stringValue];
	
	[[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"local_Memberid"];
	[[NSUserDefaults standardUserDefaults]synchronize];
	
	ViewController *viewController = [[ViewController alloc] initWithNibName:objAppDel.mainView bundle:nil]; [self.navigationController pushViewController:viewController animated:YES];
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

#pragma mark - Textfield Delegate methods
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
     if(textField == self.E_name){
      currentFieldEdit = 0;
     }
     if(textField == self.E_username){
      currentFieldEdit = 1;
     }
     if(textField == self.E_userwebsite){
      currentFieldEdit = 2;
     }
     if(textField == self.E_Desc){
      currentFieldEdit = 3;
     }
     if(textField == self.E_password){
      currentFieldEdit = 4;
     }
     if(textField == self.E_Email){
      currentFieldEdit = 5;
     }
     if(textField == self.E_phone){
      currentFieldEdit = 6;
     }
}
- (BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
	[self.E_Desc resignFirstResponder];
	[self.E_Email resignFirstResponder];
	[self.E_name resignFirstResponder];
	[self.E_password resignFirstResponder];
	[self.E_phone resignFirstResponder];
	
	[self.E_username resignFirstResponder];
	[self.E_userwebsite resignFirstResponder];
	
	return YES;
}
@end
