//
//  ChoosePictureViewController.m
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/31/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import "ChoosePictureViewController.h"
#import "SharePostViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "TSLanguageManager.h"
#import "constant.h"

@interface ChoosePictureViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

//initialise variables
NSInteger showimage = 0;
NSInteger share_rotation_n = 0;//90;
NSInteger share_currentrotation_n = 0;

@implementation ChoosePictureViewController
@synthesize backbtn,nextkbtn,viewname,chooseimg,ChoosedImgview,toglebtmView,Toglebtn_photo,Toglebtn_video;
@synthesize myScrollView1;
@synthesize image;
@synthesize btn_imageBackground;
@synthesize vidURL;
@synthesize videoView;
@synthesize movieController1;

#pragma mark - viewcontroller methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([self.imgselected isEqualToString:@"vid"]){
		 showimage = 1;
         self.videoView.hidden=NO;
		 Toglebtn_photo.hidden=NO;
		 Toglebtn_video.hidden=YES;
		 self.lbl_Photos.textColor = [UIColor redColor];
		 self.lbl_Videos.textColor = [UIColor whiteColor];
		 
         self.movieController1= [[MPMoviePlayerController alloc] init];
         [self.movieController1 setContentURL: self.vidURL];
//         if (!isiPad) {
        [self.movieController1.view setFrame:CGRectMake(0, 0, 280, 264)]; //CGRectMake(0, 0, self.videoView.frame.size.width, self.videoView.frame.size.height)];
//         }
//         else{
//            [self.movieController1.view setFrame: CGRectMake(0, 0, self.videoView.frame.size.width, self.videoView.frame.size.height)];
//         }
        [self.videoView addSubview:self.movieController1.view];//videoView
        [self.movieController1 prepareToPlay];
        [self.movieController1 play];
        
        /*
         self.movieController= [[MPMoviePlayerController alloc] init];
         [self.movieController setContentURL: self.movieURL];
         [self.movieController.view setFrame: CGRectMake(0, 0, 295, 210)];
         [self.movieView addSubview:self.movieController.view];
         //[self.movieController play];
         [self.movieController play];
         */
    }
    else{
         self.videoView.hidden=YES;
		 Toglebtn_photo.hidden=YES;
		 Toglebtn_video.hidden=NO;
		 self.lbl_Photos.textColor = [UIColor whiteColor];
		 self.lbl_Videos.textColor = [UIColor redColor];
		 
         UIImage *imageRotation=[[NSUserDefaults standardUserDefaults] objectForKey:@"Rotation"];
		 if(chooseimg){
			 ChoosedImgview.image=self.chooseimg;
		 }
		 else{
		 }
         if (imageRotation==NULL) {
         }
         else
         {
            self.ChoosedImgview.transform = CGAffineTransformMakeScale(-1, 1);
         }
        NSString *share_rotation = [prefs stringForKey:@"share_rotation"];
		 if([share_rotation integerValue] != 0){
		 	self.ChoosedImgview.transform = CGAffineTransformMakeRotation([share_rotation integerValue] * M_PI / 180.0);
		 }
    }

    self.backbtn.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_B =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gobackF_Choosepicture:)];
	[self.backbtn addGestureRecognizer:tap_B];
	[tap_B release];
    
    self.nextkbtn.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_next =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextBtnClicked:)];
	[self.nextkbtn addGestureRecognizer:tap_next];
	[tap_next release];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *sel_language = [prefs stringForKey:@"sel_language"];

	if([sel_language isEqualToString:@"pt"]){
		[TSLanguageManager setSelectedLanguage:kLMPortu];
	}else{
		[TSLanguageManager setSelectedLanguage:kLMEnglish];
	}
	[self updateLabel];
}
- (void)viewWillDisappear:(BOOL)animated
{
	[self->assetsArray release];
	[self->imageThumbnailArray release];
	[self->imageOriginalArray release];
//	[self->chooseimg release];
	[self->_imgselected release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)viewDidAppear:(BOOL)animated
{
}

#pragma mark - Action mehtods
-(IBAction)btnRotateLeftClicked:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if(share_rotation_n == 360){
        share_rotation_n = 0;
    }
    share_rotation_n = share_rotation_n+90;
    share_currentrotation_n =share_rotation_n;
	[prefs setObject:[NSString stringWithFormat:@"%ld", (long)share_currentrotation_n] forKey:@"share_rotation"];
	self.ChoosedImgview.transform = CGAffineTransformMakeRotation(share_rotation_n * M_PI / 180.0);
}
-(IBAction)btnRotateRightClicked:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if(share_rotation_n == -360){
        share_rotation_n = 0;
    }
    share_rotation_n = share_rotation_n-90;
    share_currentrotation_n =share_rotation_n;
	[prefs setObject:[NSString stringWithFormat:@"%ld", (long)share_currentrotation_n] forKey:@"share_rotation"];
	self.ChoosedImgview.transform = CGAffineTransformMakeRotation(share_rotation_n * M_PI / 180.0);
}
-(void)buttonImagePressed:(id)sender
{
	if(showimage == 1){
		self.imgselected = @"vid";
		self.vidURL =[imageOriginalArray objectAtIndex:[sender tag]];
		self.videoView.hidden=NO;
		
		self.movieController1= [[MPMoviePlayerController alloc] init];
		[self.movieController1 setContentURL: self.vidURL];
		if (!isiPad) {
			
			[self.movieController1.view setFrame: CGRectMake(0, 0, self.videoView.frame.size.width, self.videoView.frame.size.height-30)];
		}else{
		 	[self.movieController1.view setFrame: CGRectMake(0, 0, self.videoView.frame.size.width, self.videoView.frame.size.height-30)];
		}
		[self.videoView addSubview:self.movieController1.view];
		[self.movieController1 play];
		objAppDel.strCurrentUploadType = [NSString stringWithFormat:@"Video"];
		objAppDel.strCurrentURl = [NSString stringWithFormat:@"%@",self.vidURL];
	}else{
		self.imgselected = @"image";
		self.vidURL =[NSURL URLWithString:@""];
		self.videoView.hidden=YES;
		ChoosedImgview.image=[imageOriginalArray objectAtIndex:[sender tag]];
		objAppDel.strCurrentUploadType = [NSString stringWithFormat:@"Image"];
		objAppDel.strCurrentURl = [NSString stringWithFormat:@"%@",ChoosedImgview.image];
	}
}
- (IBAction)btnImageClicked:(id)sender
{
    if ([[arr_isImagesChecked objectAtIndex:[sender tag]] intValue]) {
        //image selected so deselect it
        [sender setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [arr_isImagesChecked replaceObjectAtIndex:[sender tag] withObject:[NSNumber numberWithUnsignedInteger:0]];
    }else{
        //image not selected so select it by adding checked image onto the UIbutton
        [sender setImage:[UIImage imageNamed:@"small_check_aerrow.png"] forState:UIControlStateNormal];
        [arr_isImagesChecked replaceObjectAtIndex:[sender tag] withObject:[NSNumber numberWithUnsignedInteger:1]];
    }
}
- (IBAction)RotateClicked:(UITapGestureRecognizer *)recognizer {
	share_currentrotation_n =share_rotation_n;
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:[NSString stringWithFormat:@"%ld", (long)share_currentrotation_n] forKey:@"share_rotation"];
	self.ChoosedImgview.transform = CGAffineTransformMakeRotation(share_rotation_n * M_PI / 180.0);
	share_rotation_n = share_rotation_n+90;
}

#pragma mark - Other methods
#pragma Load ScrollView
-(void)loadScrollView
{
    float horizontal = 8.0;
    float vertical = 8.0;
	[myScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for(int i=0; i<[imageThumbnailArray count]; i++)
    {
        if (!isiPad) {
            if((i%4) == 0 && i!=0)
            {
                horizontal = 8.0;
                vertical = vertical + 70.0 + 8.0;
            }
        }else{
            if((i%9) == 0 && i!=0)
            {
                horizontal = 8.0;
                vertical = vertical + 70.0 + 8.0;
            }
        }
        buttonImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonImage setFrame:CGRectMake(horizontal, vertical, 70.0, 70.0)];
        [buttonImage setTag:i];
        [buttonImage setImage:[imageThumbnailArray objectAtIndex:i] forState:UIControlStateNormal];
        btn_imageBackground=[UIButton buttonWithType:UIButtonTypeCustom] ;
        btn_imageBackground.frame=CGRectMake(horizontal, vertical, 60, 60);
        [btn_imageBackground addTarget:self action:@selector(btnImageClicked:) forControlEvents:UIControlEventTouchUpInside];
        [buttonImage addTarget:self action:@selector(buttonImagePressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn_imageBackground addTarget:self action:@selector(btnImageClicked:) forControlEvents:UIControlEventTouchUpInside];
        [myScrollView addSubview:buttonImage];
        horizontal = horizontal + 70.0 + 8.0;
    }
    CGSize result = [[UIScreen mainScreen] bounds].size;
	if(result.height > 480){
	}else{
	}
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
}
#pragma Video
-(void)showImageVideo{
    assetsArray = [[NSMutableArray alloc]init];
    assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsArray removeAllObjects];
	[imageThumbnailArray removeAllObjects];
	[imageOriginalArray removeAllObjects];
	
    groups = [[NSMutableArray alloc] init];
    [groups removeAllObjects];
	
	ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
		if (group) {
			[groups addObject:group];
		} else {
			[self displayImages];
		}
	};
	ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
		NSString *errorMessage = nil;
		switch ([error code]) {
			case ALAssetsLibraryAccessUserDeniedError:
			case ALAssetsLibraryAccessGloballyDeniedError:
				errorMessage = @"The user has declined access to it.";
				break;
			default:
				errorMessage = @"Reason unknown.";
				break;
		}
	};
	[assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:listGroupBlock failureBlock:failureBlock];
}
#pragma Image
-(void)displayImages
{
    [assetsArray removeAllObjects];
	[imageThumbnailArray removeAllObjects];
	[imageOriginalArray removeAllObjects];
    for (int i = 0 ; i< [groups count]; i++) {
        assetsGroup = [groups objectAtIndex:i];
        ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                [assetsArray addObject:result];
            }
        };
//        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
       // [assetsGroup setAssetsFilter:onlyPhotosFilter];
      //  allVideos
        [assetsGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];
    }
    //Seprate the thumbnail and original images [assetsArray count]
	int totcount = 0;
	if([assetsArray count] > 20){
		totcount=10;
	}else{
		totcount=[assetsArray count];
	}
    for(int i=0;i<totcount; i++)
    {
        ALAsset *asset = [assetsArray objectAtIndex:i];
	
        if(showimage == 0){
            if([[asset valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]){
                CGImageRef thumbnailImageRef = [asset thumbnail];
                UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
                [imageThumbnailArray addObject:thumbnail];
                
                ALAssetRepresentation *representation = [asset defaultRepresentation];
                CGImageRef originalImage = [representation fullResolutionImage];
                UIImage *original = [UIImage imageWithCGImage:originalImage];
                [imageOriginalArray addObject:original];
            }
        }
        else{
            if([[asset valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypeVideo"]){
                CGImageRef thumbnailImageRef = [asset thumbnail];
                UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
                [imageThumbnailArray addObject:thumbnail];
                
                ALAssetRepresentation *representation = [asset defaultRepresentation];
//                CGImageRef originalImage = [representation fullResolutionImage];
                NSURL *original = representation.url;
                [imageOriginalArray addObject:original];
            }
        }
    }
    [self loadScrollView];
}
#pragma setDetailItem
- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}
#pragma ConfigureView
- (void)configureView
{
    // Update the user interface for the detail item.
    self.myScrollView1.backgroundColor=[UIColor redColor];
    int x=10,y=10;
    
    for (int i=0; i<[arr_Images count]; i++) {
        if (x > 300) {
            x=10;
            y=y+60;
            
            image =[[UIImageView alloc]initWithImage:[UIImage imageNamed:[arr_Images objectAtIndex:i]]];
            image.frame=CGRectMake(x, y, 60, 60);
            
            btn_imageBackground=[UIButton buttonWithType:UIButtonTypeCustom] ;
            btn_imageBackground.frame=CGRectMake(x, y, 60, 60);
            [btn_imageBackground addTarget:self action:@selector(btnImageClicked:) forControlEvents:UIControlEventTouchUpInside];
            x=x+60;
        }
        else {
            image =[[UIImageView alloc]initWithImage:[UIImage imageNamed:[arr_Images objectAtIndex:i]]];
            image.frame=CGRectMake(x, y, 60, 60);
            
            btn_imageBackground=[UIButton buttonWithType:UIButtonTypeCustom] ;
            btn_imageBackground.frame=CGRectMake(x, y, 60, 60);
            [btn_imageBackground addTarget:self action:@selector(btnImageClicked:) forControlEvents:UIControlEventTouchUpInside];
            x=x+60;
        }
        image.tag=i;
        btn_imageBackground.tag=i;
        [self.myScrollView1 addSubview:image];
        [self.myScrollView1 addSubview:btn_imageBackground];
        [self.view addSubview:myScrollView1];
    }
}
- (void)toglePhotoClicked:(UITapGestureRecognizer *)recognizer  {
    Toglebtn_photo.hidden=YES;
    Toglebtn_video.hidden=NO;
    self.lbl_Photos.textColor = [UIColor whiteColor];
    self.lbl_Videos.textColor = [UIColor redColor];
	showimage = 0;
	[self showImageVideo];
}
- (void)togleVideoClicked:(UITapGestureRecognizer *)recognizer  {
    Toglebtn_photo.hidden=NO;
    Toglebtn_video.hidden=YES;
	self.lbl_Photos.textColor = [UIColor redColor];
	self.lbl_Videos.textColor = [UIColor whiteColor];
	showimage = 1;
	[self showImageVideo];
}
- (void)gobackF_Choosepicture:(UITapGestureRecognizer *)recognizer  {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)nextBtnClicked:(UITapGestureRecognizer *)recognizer  {
    SharePostViewController *shareController = [[SharePostViewController alloc] initWithNibName:objAppDel.sharePostView bundle:nil];
    shareController.postimage=self.ChoosedImgview.image;
    shareController.shareVidURL=self.vidURL;
    [self.navigationController pushViewController:shareController animated:YES];
}
-(void) updateLabel
{
	self.lbl_next.text =[TSLanguageManager localizedString:@"LBL_NEXT"];
	self.lbl_photo_videos.text =[TSLanguageManager localizedString:@"LBL_PHOTOS_VIDEOS"];
	self.lbl_Photos.text =[TSLanguageManager localizedString:@"LBL_PHOTOS"];
	self.lbl_Videos.text =[TSLanguageManager localizedString:@"LBL_VIDEOS"];
}
- (BOOL)prefersStatusBarHidden
{
	return YES;
}
@end
