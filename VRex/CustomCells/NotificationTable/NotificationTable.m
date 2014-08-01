//
//  NotificationTable.m
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/21/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import "NotificationTable.h"

@implementation NotificationTable
@synthesize titletext,userimg,post_text_lbl,userimg1,datetimelbl,deleteView,replyBtn,deleteBtn;

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
    // Configure the view for the selected state
}

@end
