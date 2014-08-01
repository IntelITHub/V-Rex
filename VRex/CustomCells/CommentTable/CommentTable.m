//
//  CommentTable.m
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 2/4/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import "CommentTable.h"

@implementation CommentTable
@synthesize post_uname,postDesc,postimg,time,deleteView,replyBtn,deleteBtn;

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
