//
//  RegistrationViewController.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/9/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
 
@interface RegistrationViewController : UIViewController<UITextFieldDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIWebViewDelegate>{
    
    IBOutlet UITextField     *tweetTextField;
	NSMutableString *fbToken;
	NSMutableString *fbID;
	NSMutableString *twID;
	NSMutableString *twToken;
	NSMutableString *twUsername;
}
@property (retain, nonatomic) IBOutlet UITextField *regName;
@property (retain, nonatomic) IBOutlet UITextField *regUsername;

@property (retain, nonatomic) IBOutlet UITextField *tempsocialId;
@property (retain, nonatomic) IBOutlet UITextField *tempsoicialToken;

@property (retain, nonatomic) IBOutlet UITextField *regEmail;
@property (retain, nonatomic) IBOutlet UITextField *regPassword;
@property (retain, nonatomic) IBOutlet UITextField *regCnfpasswrod;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property(retain,nonatomic)IBOutlet UILabel *Name_placeholder;
@property(retain,nonatomic)IBOutlet UILabel *username_placeholder;
@property(retain,nonatomic)IBOutlet UILabel *email_placeholder;
@property(retain,nonatomic)IBOutlet UILabel *password_placeholder;
@property(retain,nonatomic)IBOutlet UILabel *cnf_placeholder;
@property(retain,nonatomic)IBOutlet UIImageView *user_round_img;
@property(retain,nonatomic)IBOutlet UIImageView *takePhotoimg;
@property(retain,nonatomic)IBOutlet UIView *popupView;
@property(retain,nonatomic)IBOutlet UIView *popupView_contain;
@property(retain,nonatomic)IBOutlet UIView *popupView_Location;
@property(retain,nonatomic)IBOutlet UIView *popupView_Location_contain;
@property(retain,nonatomic)IBOutlet UIImageView *signUpImg;
@property(retain,nonatomic)IBOutlet UIImageView *AccptTCImg;
@property(retain,nonatomic)IBOutlet UIImageView *DontAcceptTCImg;
@property(nonatomic,retain)NSMutableData *responseData;
@property(retain,nonatomic)IBOutlet UIImageView *Accpt_location_Img;
@property(retain,nonatomic)IBOutlet UIImageView *DontAccep_location_Img;
@property(retain,nonatomic)UIImage *userimg;
@property (nonatomic,retain)UIAlertView *alert;
@property(nonatomic,retain)IBOutlet UIImageView *backbtnimg;
@property(nonatomic,retain)IBOutlet UIImageView *facebookloginbtnimg;
@property(nonatomic,retain)IBOutlet UIImageView *twitterloginbtnimg;
@property(nonatomic,retain)NSString *Fname;
@property(nonatomic,retain)NSString *FUname;
@property(nonatomic,retain)NSString *FEmail;
@property(nonatomic,retain)NSArray *accountsArray ;
@property(nonatomic,retain)NSString *facebook_imgurl;
@property(nonatomic,retain)UIPopoverController *popover;
@property(nonatomic,retain)NSString *serviceURL;
@property (strong, nonatomic) UIWindow *	window;
@property (strong, nonatomic) UIWebView *	webview;
@property (strong, nonatomic) UIButton *	close;

@property(nonatomic,retain)NSMutableString *fbToken;
@property(nonatomic,retain)NSMutableString *fbID;
@property(nonatomic,retain)NSMutableString *twID;
@property(nonatomic,retain)NSMutableString *twToken;
@property(nonatomic,retain)NSMutableString *twUsername;

@property(nonatomic,retain)IBOutlet UILabel *lbl_register;
@property(nonatomic,retain)IBOutlet UIButton *lbl_take_a_picture;
@property(nonatomic,retain)IBOutlet UIButton *lbl_signup;
@property(nonatomic,retain)IBOutlet UILabel *lbl_or_signup_using;

@property(nonatomic,retain)IBOutlet UILabel *lbl_terms_header;
@property(nonatomic,retain)IBOutlet UILabel *lbl_terms_title;
@property(nonatomic,retain)IBOutlet UITextView *lbl_terms_desc;
@property(nonatomic,retain)IBOutlet UILabel *lbl_terms_accept;
@property(nonatomic,retain)IBOutlet UILabel *lbl_terms_do_not_accept;

@property(nonatomic,retain)IBOutlet UILabel *lbl_geo_header;
@property(nonatomic,retain)IBOutlet UITextView *lbl_geo_desc;
@property(nonatomic,retain)IBOutlet UILabel *lbl_geo_accept;
@property(nonatomic,retain)IBOutlet UILabel *lbl_geo_do_not_accept;

@property(nonatomic,retain)NSString *tempsocialId1;
@property(nonatomic,retain)NSString *tempsoicialToken1;
@property(nonatomic,retain)NSString *user_round_img1;
@property(nonatomic,retain)NSString *regName1;
@property(nonatomic,retain)NSString *regUsername1;
@property(nonatomic,retain)NSString *regEmail1;
@property(nonatomic,retain)NSString *Fname1;
@property(nonatomic,retain)NSString *FUname1;
@property(nonatomic,retain)NSString *FEmail1;
@property(nonatomic,retain)NSString *loginType1;

@property(nonatomic,retain)NSString *twID1;
@property(nonatomic,retain)NSString *twToken1;
@property(nonatomic,retain)NSString *twUsername1;

@property (nonatomic,retain) ACAccountStore *accountStore;

//other methods
-(void)loadForIphone;
-(void)loadforPad;
-(void)flogin;
-(void)fbookRegister;

//action methods
- (IBAction)gotoTest:(id)sender;
- (IBAction)cancelPopup:(id)sender;
- (IBAction)RotateClicked:(id)sender;

@end
