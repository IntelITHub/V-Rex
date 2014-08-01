//
//  SimpleTableCell.m
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/18/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import "SimpleTableCell.h"

@implementation SimpleTableCell
@synthesize nameLabel;
@synthesize thumbnailImageView;
@synthesize prepTimeLabel;
@synthesize categor_yname;
@synthesize likelbl;
@synthesize commnetlbl;
@synthesize listClickView;
@synthesize commentListClick;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
