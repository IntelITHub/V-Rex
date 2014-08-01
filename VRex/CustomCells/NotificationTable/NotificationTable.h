//
//  NotificationTable.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/21/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTable : UITableViewCell
@property(nonatomic,retain)IBOutlet UILabel *titletext;
@property(nonatomic,retain)IBOutlet UIImageView *userimg;
@property(nonatomic,retain)IBOutlet UIImageView *userimg1;
@property(nonatomic,retain)IBOutlet UITextView *post_text_lbl;
@property(nonatomic,retain)IBOutlet UILabel *datetimelbl;
@property(nonatomic,retain)IBOutlet UIView *deleteView;
@property(nonatomic,retain)IBOutlet UIButton *replyBtn;
@property(nonatomic,retain)IBOutlet UIButton *deleteBtn;

@end
