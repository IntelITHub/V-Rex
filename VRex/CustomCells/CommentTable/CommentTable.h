//
//  CommentTable.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 2/4/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTable : UITableViewCell
@property(nonatomic,retain)IBOutlet UIImageView *postimg;
@property(nonatomic,retain)IBOutlet UILabel *post_uname;
@property(nonatomic,retain)IBOutlet UITextView *postDesc;
@property(nonatomic,retain)IBOutlet UILabel *time;
@property(nonatomic,retain)IBOutlet UIView *deleteView;
@property(nonatomic,retain)IBOutlet UIButton *replyBtn;
@property(nonatomic,retain)IBOutlet UIButton *deleteBtn;

@end
