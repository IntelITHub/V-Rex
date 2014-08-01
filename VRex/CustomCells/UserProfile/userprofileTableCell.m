//
//  userprofileTableCell.m
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/23/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import "userprofileTableCell.h"

@implementation userprofileTableCell
@synthesize post_uname;
@synthesize postDesc;
@synthesize postimg;
@synthesize time;

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
