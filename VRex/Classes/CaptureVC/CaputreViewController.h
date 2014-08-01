//
//  CaputreViewController.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/20/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface CaputreViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIImageView *imgViewVideoImage;
    IBOutlet UIImageView *imgViewRedBullet;
    IBOutlet UIButton *btnClose;
    IBOutlet UILabel *lblFlashOnOff;
}
@property(nonatomic,retain)IBOutlet UIImageView *imageRotation;
@property(nonatomic,retain)IBOutlet UIImageView *imageRotation1;
@property(nonatomic,retain)IBOutlet UIImageView *backimgbtn;
@property(nonatomic,retain)IBOutlet UIImageView *header_galery_imgbtn;
@property(nonatomic,retain)IBOutlet UIImageView *next_imgbtn;
@property(nonatomic,retain)IBOutlet UIImageView *cameraImg;
@property(nonatomic,retain)IBOutlet UIImageView *videoImg;
@property(nonatomic,retain)IBOutlet UIImageView *GalleryImgbtn;
@property(retain,nonatomic)UIImage *captureimg;
@property(nonatomic,retain)NSString *viewname;
@property(nonatomic,retain)IBOutlet UIImageView *Image_container;
@property(copy, nonatomic) NSURL*movieURL;
@property(retain,nonatomic)MPMoviePlayerController *movieController;
//@property(retain,nonatomic)IBOutlet UIView *movieView;
@property(retain,nonatomic)IBOutlet UIScrollView *movieScrolview;
@property(retain,nonatomic)NSMutableArray *assets;
@property(retain,nonatomic)NSString *slecType;
@property(retain,nonatomic)IBOutlet UILabel *lbl_next;

//other methods
-(void)playVideo;
-(void)test;

-(IBAction)btnCloseClicked:(id)sender;

@end
