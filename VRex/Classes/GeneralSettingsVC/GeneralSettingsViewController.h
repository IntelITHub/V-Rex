//
//  GeneralSettingsViewController.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/24/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralSettingsViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate>{
	UIPickerView *myPickerView;
	UIButton *doneButton ;
	NSMutableArray *array_from;
    
    IBOutlet UIScrollView *scrollView;
}
@property(nonatomic,retain)NSMutableData *responseData;
@property(nonatomic,retain)IBOutlet UIImageView *backbtn;
@property(nonatomic,retain) IBOutlet NSMutableArray *languageName;
@property(nonatomic,retain) IBOutlet NSMutableArray *languageId;

@property(nonatomic,retain) IBOutlet UILabel *lbl_setting;
@property(nonatomic,retain) IBOutlet UILabel *lbl_save_setting;
@property(nonatomic,retain) IBOutlet UILabel *lbl_camera_set;
@property(nonatomic,retain) IBOutlet UILabel *lbl_language;
@property(nonatomic,retain) IBOutlet UILabel *lbl_selected_language;
@property(nonatomic,retain) IBOutlet UITextField *selected_language;
@property(nonatomic,retain) IBOutlet UISwitch *camera_switch;
@property(nonatomic,retain)UIAlertView *alert;
@property(nonatomic,retain) IBOutlet UIImageView *choose_language;

@end
