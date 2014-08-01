//
//  NotificationViewController.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/21/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIButton *btnHome,*btnCategory,*btnSearch,*btnCamera,*btnProfile;
}
@property(nonatomic,retain) NSArray *tableData;
@property(nonatomic,retain)NSString *userprofileview;
@property(nonatomic,retain)NSString *searchview;
@property(nonatomic,retain)NSString *caputerview;
@property(nonatomic,retain)IBOutlet UIImageView *backbtn;
@property(nonatomic,retain)NSMutableData *responseData;
@property(nonatomic,retain)NSArray *postimgArray;
@property(nonatomic,retain)NSArray *datatimeArray;
@property(nonatomic,retain)NSArray *descriptionArray;
@property(nonatomic,retain)NSArray *postId;
@property(nonatomic,retain)UIAlertView *alert;
@property(nonatomic,retain)IBOutlet UITableView *table;

@property(nonatomic,retain)IBOutlet UIImageView *following_img;
@property(nonatomic,retain)IBOutlet UIImageView *me_img;
@property(nonatomic,retain)IBOutlet UILabel *following_lbl;
@property(nonatomic,retain)IBOutlet UILabel *me_lbl;
@property(nonatomic,retain)NSString *serviceURL;

//action methods
- (IBAction)gotoHomeF_notificaiton:(id)sender;
- (IBAction)gotoSearchF_notification:(id)sender;
- (IBAction)gotoCaptureF_notification:(id)sender;
- (IBAction)gotoUserprofile_notiticaiton:(id)sender;
@end
