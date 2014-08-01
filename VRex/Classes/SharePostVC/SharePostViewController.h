//
//  SharePostViewController.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/23/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SharePostViewController : UIViewController <UITextFieldDelegate,UIPickerViewDelegate,CLLocationManagerDelegate,UIWebViewDelegate>{
    
	UIButton *pickerButton;
	UIPickerView *myPickerView;
 	UIPickerView *myPickerView1;
 	UIPickerView *myPickerView2;
	NSMutableArray *array_from;
	UILabel *fromButton;
	UIButton *doneButton;
    UIButton *doneButton1;
    UIButton *doneButton2;
	UIButton *backButton ;
}
@property(nonatomic,retain)NSString *currentLat;
@property(nonatomic,retain)NSString *currentLong;

@property(retain,nonatomic)MPMoviePlayerController *movieController1;
@property(nonatomic,retain) NSURL *shareVidURL;
@property(nonatomic,retain)NSString *imgselected;
@property(nonatomic,retain)IBOutlet UIView *videoView;

@property(nonatomic,retain)IBOutlet UIScrollView *scrollview;
@property(retain,nonatomic)IBOutlet UILabel *who_when_placholder;
@property(nonatomic,retain)IBOutlet UIImageView *back;
@property(nonatomic,retain)IBOutlet UIImageView *Postimgview;
@property(nonatomic,retain)UIImage *postimage;
@property(nonatomic,retain)IBOutlet UITextField *heladinetext;
@property(nonatomic,retain)IBOutlet UITextField *categoriestxt;
@property(nonatomic,retain)IBOutlet UITextField *maptext;
@property(nonatomic,retain)IBOutlet UITextView *posttextview;
@property(nonatomic,retain)NSString *viewname;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain)IBOutlet UIActivityIndicatorView *spinner_cmplist;

@property(nonatomic,retain)IBOutlet UITextField *countryID;
@property(nonatomic,retain)IBOutlet UITextField *stateID;

@property(nonatomic,retain)IBOutlet UIView *countryView;
@property(nonatomic,retain)IBOutlet UILabel *countrytext;

@property(nonatomic,retain)IBOutlet UIView *stateView;
@property(nonatomic,retain)IBOutlet UILabel *statetext;

@property(nonatomic,retain)IBOutlet UIView *categoryView;
@property(nonatomic,retain)IBOutlet UILabel *cattext;

@property(nonatomic,retain)IBOutlet UITextField *citytext;

@property(nonatomic,retain)IBOutlet UIPickerView *countryPView;
@property(nonatomic,retain)IBOutlet UIPickerView *statePView;

@property(nonatomic,retain) IBOutlet UIButton *pickerButton;
@property(nonatomic,retain) IBOutlet UILabel *fromButton;

@property(nonatomic,retain) IBOutlet NSMutableArray *countryName;
@property(nonatomic,retain) IBOutlet NSMutableArray *countryId;

@property(nonatomic,retain) IBOutlet NSMutableArray *stateId;
@property(nonatomic,retain) IBOutlet NSMutableArray *stateName;

@property(nonatomic,retain) IBOutlet NSMutableArray *categoryId;
@property(nonatomic,retain) IBOutlet NSMutableArray *categoryName;

@property(nonatomic,retain)IBOutlet UIView *AddtoMapView;
@property(nonatomic,retain)IBOutlet UILabel *AddtoMaptext;

@property(nonatomic,retain)IBOutlet UILabel *lbl_shareon_fb;
@property(nonatomic,retain)IBOutlet UILabel *lbl_share_on_tw;
@property(nonatomic,retain)IBOutlet UIButton *lbl_Share;

@property (nonatomic,retain)UIAlertView *alert;
@property (strong, nonatomic) UIWindow *	window;
@property (strong, nonatomic) UIWebView *webview;
@property (strong, nonatomic) UIButton *close;
@property(nonatomic,retain)NSString *serviceURL;

//other methods
-(void)setpadding;
-(void)tabRecog;

//action mehtods
- (IBAction)shareBtnClicked:(id)sender;

@end
