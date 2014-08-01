//
//  HomepageTable.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 2/4/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomepageTable : UITableViewCell
@property(nonatomic,retain)IBOutlet UIImageView *userimg;

@property(nonatomic,retain)IBOutlet UILabel *Usernamelbl;
@property(nonatomic,retain)IBOutlet UILabel *postttl_lbl;
@property(nonatomic,retain)IBOutlet UILabel *city_lbl;
@property(nonatomic,retain)IBOutlet UILabel *date_time;
@property(nonatomic,retain)IBOutlet UILabel *like_lbl;
@property(nonatomic,retain)IBOutlet UILabel *Comment_lbl;
@property(nonatomic,retain)IBOutlet UILabel *category_lbl;

@property(nonatomic,retain)IBOutlet UILabel *lbl_like;
@property(nonatomic,retain)IBOutlet UILabel *lbl_comment;

@property(nonatomic,retain)IBOutlet UITextView *commnetTextview;
@property(nonatomic,retain)IBOutlet UIImageView *post_image;
@property(nonatomic,retain)IBOutlet UIImageView *like_img;
@property(nonatomic,retain)IBOutlet UIImageView *like_redimg;
@property(nonatomic,retain)IBOutlet UIImageView *comment_img;
@property(nonatomic,retain)IBOutlet UITextField *commonettbox;
@property(nonatomic,retain)IBOutlet UIImageView *dot_img;
@property(nonatomic,retain)IBOutlet UIImageView *sendImg;
@property(nonatomic,retain)IBOutlet UIImageView *videoIcon;
@property(nonatomic,retain)IBOutlet UIButton *btnComment;
@end
