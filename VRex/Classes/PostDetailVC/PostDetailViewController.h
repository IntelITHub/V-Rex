//
//  PostDetailViewController.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/31/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaPlayer/MediaPlayer.h"

@interface PostDetailViewController : UIViewController<UITextFieldDelegate>
@property(nonatomic,retain)IBOutlet UIView *fullView;
@property(nonatomic,retain)IBOutlet UIImageView *fullViewImage;
@property(nonatomic,retain)IBOutlet UIImageView *fullViewBackImage;
@property(nonatomic,retain)IBOutlet UITextField *tem_currentURL;

@property(nonatomic,retain)IBOutlet UIButton *postsendbtn;
@property(nonatomic,retain)IBOutlet UITextView *post_textview;
@property(nonatomic,retain)IBOutlet UIScrollView *scrollview;
@property(nonatomic,retain)IBOutlet UIImageView *backbtn;
@property(nonatomic,retain)IBOutlet UIImageView *likebtn;
@property(nonatomic,retain)IBOutlet UIImageView *likebtn_red;
@property(nonatomic,retain)IBOutlet UIImageView *commentbtn;
@property(nonatomic,retain)NSMutableData *responseData;
@property(nonatomic,retain)IBOutlet UIImageView *post_userphoto;
@property(nonatomic,retain)IBOutlet UIImageView *postphoto;

@property(nonatomic,retain)IBOutlet UILabel *date_post_labl;
@property(nonatomic,retain)IBOutlet UILabel *postuernamelbl;
@property(nonatomic,retain)IBOutlet UILabel *post_ttl_lbl;
@property(nonatomic,retain)IBOutlet UILabel *post_city_lbl;
@property(nonatomic,retain)IBOutlet UILabel *post_like_lbl;
@property(nonatomic,retain)IBOutlet UILabel *post_commnet_lbl;
@property(nonatomic,retain)IBOutlet UITextView *post_textDetals_box;
@property(nonatomic,retain)IBOutlet UILabel *post_catgory_lbl;
@property(nonatomic,retain)NSString *posts_id;
@property(nonatomic,retain)NSString *cat_name;
@property(nonatomic,retain)IBOutlet UITextField *post_text;

@property(nonatomic,retain)IBOutlet UIScrollView *fullScrollView;

@property(nonatomic,retain)MPMoviePlayerController *player;
@property (nonatomic,retain)UIAlertView *alert;
@property(nonatomic,retain)IBOutlet UILabel *lbl_like;
@property(nonatomic,retain)IBOutlet UILabel *lbl_comment;
@property(nonatomic,retain)IBOutlet UIImageView *getNotiticationimg;
@property(nonatomic,retain)IBOutlet UIImageView *videoIcon;
@property(nonatomic,retain)NSString *profileid;
@property(nonatomic,retain)NSString *serviceURL;

//other methods
-(void)getPostDetails;

//action methods
- (IBAction)SendPost:(id)sender;

@end
