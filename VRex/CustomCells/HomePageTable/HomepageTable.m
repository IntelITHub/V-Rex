//
//  HomepageTable.m
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 2/4/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import "HomepageTable.h"

@implementation HomepageTable
@synthesize userimg,Usernamelbl,postttl_lbl,city_lbl,date_time,like_lbl,Comment_lbl,category_lbl,like_redimg,commonettbox,sendImg,dot_img,btnComment;

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
- (void)likeImgClicked:(UITapGestureRecognizer *)recognizer  {

}
@end
