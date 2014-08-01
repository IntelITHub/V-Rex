//
//  UserprofileViewController.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/23/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserprofileViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    IBOutlet UIButton *btnHome,*btnSearch,*btnCamera,*btnCategory,*btnProfile;
}
@property(nonatomic,retain) NSArray *tableData;
@property(nonatomic,retain)NSString *captuerview;
@property(nonatomic,retain)NSString *searchView;
@property(nonatomic,retain)IBOutlet UIImageView *coverPhotoimg;
@property(nonatomic,retain)IBOutlet UIImageView *editProfileimg;
@property(nonatomic,retain)IBOutlet UIImageView *editfollow;
@property(nonatomic,retain)IBOutlet UIImageView *editfollowing;
@property(nonatomic,retain)IBOutlet UIImageView *backbtn;
@property(nonatomic,retain)IBOutlet UIImageView *settingimg;

@property(nonatomic,retain)IBOutlet UILabel *usernamelbl;
@property(nonatomic,retain)IBOutlet UILabel *Describtionlbl;
@property(nonatomic,retain)IBOutlet UILabel *Describtionlbl2;
@property(nonatomic,retain)IBOutlet UILabel *followerslbl;
@property(nonatomic,retain)IBOutlet UILabel *followingslbl;
@property(nonatomic,retain)IBOutlet UILabel *postlbl;
@property(nonatomic,retain)IBOutlet UIImageView *ueserProfileimg;
@property(nonatomic,retain)NSString *profiletype;
@property(nonatomic,retain)NSString *Pub_profileid;
@property(nonatomic,retain)IBOutlet UITableView *table;
@property(nonatomic,retain)NSArray *postimgArray;
@property(nonatomic,retain)NSArray *datatimeArray;
@property(nonatomic,retain)NSArray *descriptionArray;
@property(nonatomic,retain)NSArray *postId;
@property(nonatomic,retain)NSString *serviceURL;
@property(nonatomic,retain)UIPopoverController *popover;
@property (nonatomic,retain)UIAlertView *alert;

@property(nonatomic,retain)IBOutlet UILabel *lbl_following;
@property(nonatomic,retain)IBOutlet UILabel *lbl_followed;
@property(nonatomic,retain)IBOutlet UILabel *lbl_posts;
@property(nonatomic,retain)IBOutlet UILabel *lbl_edit_profile_btn;
@property(nonatomic,retain)IBOutlet UILabel *lbl_follow_btn;
@property(nonatomic,retain)IBOutlet UILabel *lbl_following_btn;
@property(nonatomic,retain)IBOutlet UIButton *lbl_change_cover;

//other methods
-(void)getProfileData;
-(void)getPublicProfileData;

//action methods
- (IBAction)home_footerClicked:(id)sender;
- (IBAction)search_footerClicked:(id)sender;
- (IBAction)caputer_footerClicked:(id)sender;
- (IBAction)notification_footerClicked:(id)sender;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height;

@end
