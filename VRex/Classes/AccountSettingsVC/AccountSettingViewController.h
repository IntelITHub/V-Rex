//
//  AccountSettingViewController.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/23/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountSettingViewController : UIViewController
{
    IBOutlet UIScrollView *scrollView;
}
@property(nonatomic,retain)IBOutlet UIImageView *backimg;
@property(nonatomic,retain)IBOutlet UIImageView *plusimg;

//action methods
- (IBAction)logoutClicked:(id)sender;
@end
