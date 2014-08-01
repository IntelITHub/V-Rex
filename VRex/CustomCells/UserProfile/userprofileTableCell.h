//
//  userprofileTableCell.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/23/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface userprofileTableCell : UITableViewCell
@property(nonatomic,retain)IBOutlet UIImageView *postimg;
@property(nonatomic,retain)IBOutlet UILabel *post_uname;
@property(nonatomic,retain)IBOutlet UILabel *postDesc;
@property(nonatomic,retain)IBOutlet UILabel *time;
@end
