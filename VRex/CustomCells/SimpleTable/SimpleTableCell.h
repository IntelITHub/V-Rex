//
//  SimpleTableCell.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/18/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableCell : UITableViewCell
@property (nonatomic,retain) IBOutlet UILabel *nameLabel;
@property (nonatomic,retain) IBOutlet UILabel *prepTimeLabel;
@property (nonatomic,retain) IBOutlet UILabel *categor_yname;
@property (nonatomic,retain) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic,retain) IBOutlet UILabel *likelbl;
@property (nonatomic,retain) IBOutlet UILabel *commnetlbl;
@property (nonatomic,retain) IBOutlet UIView *listClickView;
@property (nonatomic,retain) IBOutlet UIImageView *commentListClick;
@end
