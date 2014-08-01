//
//  EditprofileViewController.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/23/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditprofileViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>{
    IBOutlet UITextField *E_name;
    IBOutlet UITextField *E_username;
    IBOutlet UITextField *E_userwebsite;
}
@property(nonatomic,retain)NSMutableData *responseData;
@property(retain,nonatomic)UIImage *E_userimg;
@property(nonatomic,retain)IBOutlet UIScrollView *scrollview;
@property(nonatomic,retain)IBOutlet UIImageView *backimg;
@property(nonatomic,retain)IBOutlet UIImageView *plusimg;
@property(nonatomic,retain)IBOutlet UIImageView *gotoGeneralimg;

@property(nonatomic,retain)IBOutlet UITextField *E_name;
@property(nonatomic,retain)IBOutlet UITextField *E_username;
@property(nonatomic,retain)IBOutlet UITextField *E_userwebsite;
@property(nonatomic,retain)IBOutlet UITextField *E_Desc;
@property(nonatomic,retain)IBOutlet UITextField *E_password;

@property(nonatomic,retain)IBOutlet UITextField *E_Email;
@property(nonatomic,retain)IBOutlet UITextField *E_phone;
@property(nonatomic,retain)IBOutlet UIImageView *E_userPhoto;

@property(nonatomic,retain)IBOutlet UILabel *lbl_user_info;
@property(nonatomic,retain)IBOutlet UILabel *lbl_user_private_info;

@property(nonatomic,retain)IBOutlet UIButton *lbl_Save;
@property(nonatomic,retain)IBOutlet UIButton *lbl_logout;
@property(nonatomic,retain)IBOutlet UILabel *lbl_general_setting;
@property(nonatomic,retain)UIPopoverController *popover;
@property (nonatomic,retain)UIAlertView *alert;
@property(nonatomic,retain)NSString *serviceURL;

//other methods
-(void)getProfileDetail;
//action methods
- (IBAction)logoutClicked:(id)sender;
- (IBAction)saveProfile:(id)sender;
@end
