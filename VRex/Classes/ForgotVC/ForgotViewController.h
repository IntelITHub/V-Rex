//
//  ForgotViewController.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 2/10/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIScrollView *scrollVW;
}
@property(nonatomic,retain)IBOutlet UITextField *forgot_txt;
@property(nonatomic,retain)NSMutableData *responseData;
@property (nonatomic, retain)IBOutlet UIActivityIndicatorView *spinner_cmplist;

@property (nonatomic, retain)IBOutlet UIButton *lbl_send;
@property (nonatomic, retain)IBOutlet UILabel *lbl_fogot;

@property(nonatomic,retain) UILabel *lbl_placehoder_forgotpassword;

//action methods
- (IBAction)gotoLoginPageClicked:(id)sender;
- (IBAction)submitClicked:(id)sender;

@end
