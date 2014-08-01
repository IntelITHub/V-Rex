//
//  ChoosePictureViewController.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/31/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface ChoosePictureViewController : UIViewController <UIScrollViewDelegate,UISplitViewControllerDelegate>{
  
    UIScrollView *myScrollView;
    UIImageView *image;
    NSMutableArray *arr_Images;
    NSMutableArray *arr_isImagesChecked;
    
    UIButton *btn_imageBackground;
    ALAssetsLibrary *assetsLibrary;
    NSMutableArray *groups;
    ALAssetsGroup *assetsGroup;
    
    UIScrollView *myScrollView1;
    UIActivityIndicatorView *activityIndicator;
    NSMutableArray *assetsArray;
    NSMutableArray *imageThumbnailArray;
    NSMutableArray *imageOriginalArray;
    
    UIButton *buttonImage;
    
    IBOutlet UIButton *btnRorateLeft;
    IBOutlet UIButton *btnRotateRight;
}
@property(retain,nonatomic)MPMoviePlayerController *movieController1;
@property(nonatomic,retain)IBOutlet UIView *videoView;
@property(nonatomic,retain) NSURL*vidURL;
@property(nonatomic,retain)NSString *imgselected;
@property(nonatomic,retain)IBOutlet UIImageView *backbtn;
@property(nonatomic,retain)IBOutlet UIImageView *nextkbtn;
@property(nonatomic,retain)IBOutlet UIImageView *ChoosedImgview;
@property(nonatomic,retain)NSString *viewname;
@property(retain,nonatomic)UIImage *chooseimg;
@property(retain,nonatomic)IBOutlet UIView *toglebtmView;
@property(retain,nonatomic)IBOutlet UIImageView *Toglebtn_photo;
@property(retain,nonatomic)IBOutlet UIImageView *Toglebtn_video;
@property (retain, nonatomic) id detailItem;
@property (nonatomic,retain)IBOutlet UIScrollView *myScrollView1;
@property (nonatomic,retain) UIImageView *image;
@property (nonatomic,retain) UIButton *btn_imageBackground;
@property (retain, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property(nonatomic,retain)IBOutlet UILabel *lbl_next;
@property(nonatomic,retain)IBOutlet UILabel *lbl_photo_videos;
@property(nonatomic,retain)IBOutlet UILabel *lbl_Photos;
@property(nonatomic,retain)IBOutlet UILabel *lbl_Videos;
@property(nonatomic,retain)IBOutlet UILabel *lbl_Photos1;
@property(nonatomic,retain)IBOutlet UILabel *lbl_Videos1;

//action methods
-(IBAction)btnImageClicked:(id)sender;
-(IBAction)btnRotateLeftClicked:(id)sender;
-(IBAction)btnRotateRightClicked:(id)sender;
@end
