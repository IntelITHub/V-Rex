//
//  DetailfeedViewController.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/16/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//255-38-55

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MediaPlayer/MediaPlayer.h"
@interface DetailfeedViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,CLLocationManagerDelegate>
{
    NSURL *url_img1;
    NSURL *url_img;
    NSData *data1;
    IBOutlet UIButton *btnHome,*btnSearch,*btnCamera,*btnCategory,*btnProfile;
    
}
@property(nonatomic,retain)NSMutableData *responseData;
@property(retain,nonatomic)IBOutlet UIScrollView *scrollview;
@property(retain,nonatomic)IBOutlet UIView *Upper_view;
@property(retain,nonatomic)NSString *viewname;
@property(retain,nonatomic)NSString *capture_view;
@property(retain,nonatomic)NSString *userprofile_view;
@property(retain,nonatomic)NSString *comment_view;
@property(retain,nonatomic)NSString *notification_view;

@property(retain,nonatomic)IBOutlet  UIImageView *likeimgbtn;
@property(nonatomic,retain) NSMutableArray *tableData;
@property(nonatomic,retain)IBOutlet UITableView *tableView1;

@property(nonatomic,retain)NSMutableArray *ProfileimgArray;
@property(nonatomic,retain)NSMutableArray *userimgArray;
@property(nonatomic,retain)NSMutableArray *userArray;
@property(nonatomic,retain)NSMutableArray *CategoriesNameArray;
@property(nonatomic,retain)NSMutableArray *postCountArray;
@property(nonatomic,retain)NSMutableArray *likecountArray;
@property(nonatomic,retain)NSMutableArray *DescArray;
@property(nonatomic,retain)NSMutableArray *tPostArray;
@property(nonatomic,retain)NSMutableArray *DatetimeArray;
@property(nonatomic,retain)NSMutableArray *memveridArray;
@property(nonatomic,retain)NSMutableArray *postidArray;
@property(nonatomic,retain)NSMutableArray *citydArray;
@property(nonatomic,retain)NSMutableArray *islikeArray;
@property(nonatomic,retain)NSMutableArray *eFileTypeArray;

@property(nonatomic,retain)IBOutlet UIImageView *mainimg;
@property(nonatomic,retain)IBOutlet UIImageView *lelfuppderimg;
@property(nonatomic,retain)IBOutlet UIImageView *leftDownimg;
@property(nonatomic,retain)IBOutlet UIImageView *rightupperimg;
@property(nonatomic,retain)IBOutlet UIImageView *rightdownimg;
@property(nonatomic,retain)IBOutlet UIImageView *line_img;

@property(nonatomic,retain)IBOutlet UIButton *uppdperbtn;
@property(nonatomic,retain)IBOutlet UIButton *downbtn;
@property(nonatomic,retain)NSString *longi;
@property(nonatomic,retain)NSString *lati;
@property(nonatomic,retain)UIAlertView *alert;
@property(nonatomic, retain) CLLocationManager *locationManager;

@property(nonatomic,retain)IBOutlet UIButton *sendbtn;
@property(nonatomic,retain)IBOutlet UITextField *commnetTxtbox;
@property(nonatomic,retain)NSString *post_id_homepage;
@property(nonatomic,retain)NSString *Memver_id_home;
@property(nonatomic,retain)NSString *Memver_like;
@property(nonatomic,retain)NSArray *Memver_likeArray;
@property(nonatomic,retain)IBOutlet UIImageView *post_box_container;
@property(nonatomic,retain)IBOutlet UIButton *Closecmtbtn;
@property(nonatomic,retain)NSString *serviceURL;
@property (strong ,nonatomic) NSMutableDictionary *cachedMainImages;
@property (strong ,nonatomic) NSMutableDictionary *cachedUserImages;

@property (strong ,nonatomic) IBOutlet UIView *fullView;
@property (strong ,nonatomic) IBOutlet UIImageView *fullViewImage;
@property (strong ,nonatomic) IBOutlet UIImageView *fullViewBackImage;
@property(nonatomic,retain)MPMoviePlayerController *player;

//Action methods
- (IBAction)searchFooterbtnClicked:(id)sender;
- (IBAction)CaptureFooterbtnClicked:(id)sender;
- (IBAction)NotificationFooterbtnClicked:(id)sender;
- (IBAction)userprofileFooterbtnClicked:(id)sender;
- (IBAction)PlusBtnClicked:(id)sender;
- (IBAction)latestbtnClicked:(id)sender;
- (IBAction)myLocationClicked:(id)sender;
- (IBAction)sendpost_home:(id)sender;
- (IBAction)CloseCommetBox:(id)sender;

//other methods
-(void)getPageData;
-(void)openImage:(UITapGestureRecognizer *)recognizer;
-(void)playvideo:(UITapGestureRecognizer *)recognizer;

@end
