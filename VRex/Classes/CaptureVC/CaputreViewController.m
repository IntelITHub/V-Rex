//
//  CaputreViewController.m
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/20/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import "CaputreViewController.h"
#import "DetailfeedViewController.h"
#import "SharePostViewController.h"
#import "ChoosePictureViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "TSLanguageManager.h"
#import "constant.h"
//custom camera
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AVCamPreviewView.h"

NSInteger share_rotation = 0;
NSInteger share_currentrotation = 0;

static void * CapturingStillImageContext = &CapturingStillImageContext;
static void * RecordingContext = &RecordingContext;
static void * SessionRunningAndDeviceAuthorizedContext = &SessionRunningAndDeviceAuthorizedContext;

@interface CaputreViewController ()<AVCaptureFileOutputRecordingDelegate>
@property (nonatomic, retain) IBOutlet AVCamPreviewView *movieView;//*previewView;

//custom camera
-(IBAction)btnRearFrontCameraclicked:(id)sender;
-(IBAction)btnFlashclicked:(id)sender;

// Session management.
@property (nonatomic) dispatch_queue_t sessionQueue; // Communicate with the session and other session objects on this queue.
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;

// Utilities.
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;
@property (nonatomic, getter = isDeviceAuthorized) BOOL deviceAuthorized;
@property (nonatomic, readonly, getter = isSessionRunningAndDeviceAuthorized) BOOL sessionRunningAndDeviceAuthorized;
@property (nonatomic) BOOL lockInterfaceRotation;
@property (nonatomic) id runtimeErrorHandlingObserver;
@end


@implementation CaputreViewController
@synthesize backimgbtn,next_imgbtn,viewname,cameraImg,videoImg,Image_container,GalleryImgbtn;
@synthesize captureimg,movieURL,movieController,movieView,movieScrolview,assets,slecType;
@synthesize header_galery_imgbtn;

#pragma mark - Custom Camera methods
#pragma Session
- (BOOL)isSessionRunningAndDeviceAuthorized
{
	return [[self session] isRunning] && [self isDeviceAuthorized];
}
+ (NSSet *)keyPathsForValuesAffectingSessionRunningAndDeviceAuthorized
{
	return [NSSet setWithObjects:@"session.running", @"deviceAuthorized", nil];
}
#pragma RunStillImageCapture
- (void)runStillImageCaptureAnimation
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[[[self movieView] layer] setOpacity:0.0];
		[UIView animateWithDuration:.25 animations:^{
			[[[self movieView] layer] setOpacity:1.0];
		}];
	});
}
#pragma CheckDeviceAuthorisation
- (void)checkDeviceAuthorizationStatus
{
	NSString *mediaType = AVMediaTypeVideo;
	
	[AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
		if (granted)
		{
			//Granted access to mediaType
			[self setDeviceAuthorized:YES];
		}
		else
		{
			//Not granted access to mediaType
			dispatch_async(dispatch_get_main_queue(), ^{
				[[[UIAlertView alloc] initWithTitle:@"V-Rex!"
											message:@"V-Rex doesn't have permission to use Camera, please change privacy settings"
										   delegate:self
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil] show];
				[self setDeviceAuthorized:NO];
			});
		}
	}];
}
#pragma mediaType
+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
	NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
	AVCaptureDevice *captureDevice = [devices firstObject];
	
	for (AVCaptureDevice *device in devices)
	{
		if ([device position] == position)
		{
			captureDevice = device;
			break;
		}
	}
	return captureDevice;
}
#pragma CameraInitial methods
-(void)cameraViewdidLoad
{
    //set previous gallery thumbnail
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"storeimage"];
    if (imageData.length > 0) {
        UIImage *img = [UIImage imageWithData:imageData];
        UIImageView *GalleryFrame = [[UIImageView alloc] initWithImage:img];
        GalleryFrame.frame = CGRectMake(0, 0, 55, 45);
        [self.GalleryImgbtn setImage:GalleryFrame.image];
    }
   
  
	// Create the AVCaptureSession
	AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPreset640x480;
    [self setSession:session];

    //camera width
//    AVCaptureVideoPreviewLayer *avLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
//    CGRect bounds=self.view.layer.bounds;//movieView.layer.bounds;
//    avLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    avLayer.bounds=bounds;
//    avLayer.position=CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    //
   
	// Setup the preview view
	[[self movieView] setSession:session];
	
	// Check for device authorization
	[self checkDeviceAuthorizationStatus];
	
	dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
	[self setSessionQueue:sessionQueue];
	
	dispatch_async(sessionQueue, ^{
		[self setBackgroundRecordingID:UIBackgroundTaskInvalid];
		
		NSError *error = nil;
		
		AVCaptureDevice *videoDevice = [CaputreViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
		AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
		
		if (error)
		{
			NSLog(@"%@", error);
		}
		
		if ([session canAddInput:videoDeviceInput])
		{
			[session addInput:videoDeviceInput];
			[self setVideoDeviceInput:videoDeviceInput];
            
			dispatch_async(dispatch_get_main_queue(), ^{
				// Why are we dispatching this to the main queue?
				// Because AVCaptureVideoPreviewLayer is the backing layer for AVCamPreviewView and UIView can only be manipulated on main thread.
				// Note: As an exception to the above rule, it is not necessary to serialize video orientation changes on the AVCaptureVideoPreviewLayer’s connection with other session manipulation.
                
				[[(AVCaptureVideoPreviewLayer *)[[self movieView] layer] connection] setVideoOrientation:(AVCaptureVideoOrientation)[self interfaceOrientation]];
			});
		}
		
		AVCaptureDevice *audioDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
		AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
		
		if (error)
		{
			NSLog(@"%@", error);
		}
		
		if ([session canAddInput:audioDeviceInput])
		{
			[session addInput:audioDeviceInput];
		}
		
		AVCaptureMovieFileOutput *movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
		if ([session canAddOutput:movieFileOutput])
		{
			[session addOutput:movieFileOutput];
			AVCaptureConnection *connection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
			if ([connection isVideoStabilizationSupported])
				[connection setEnablesVideoStabilizationWhenAvailable:YES];
			[self setMovieFileOutput:movieFileOutput];
		}
		
		AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
		if ([session canAddOutput:stillImageOutput])
		{
			[stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
			[session addOutput:stillImageOutput];
			[self setStillImageOutput:stillImageOutput];
		}
	});
}
+ (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device
{
	if ([device hasFlash] && [device isFlashModeSupported:flashMode])
	{
		NSError *error = nil;
		if ([device lockForConfiguration:&error])
		{
			[device setFlashMode:flashMode];
			[device unlockForConfiguration];
		}
		else
		{
			NSLog(@"%@", error);
		}
	}
}
-(void)cameraViewwillAppear
{
    lblFlashOnOff.text = @"Off";
    [btnClose setHidden:YES];
    [imgViewRedBullet setHidden:YES];
    [cameraImg setUserInteractionEnabled:YES];
    [videoImg setUserInteractionEnabled: YES];
    
	dispatch_async([self sessionQueue], ^{
		[self addObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:SessionRunningAndDeviceAuthorizedContext];
		[self addObserver:self forKeyPath:@"stillImageOutput.capturingStillImage" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:CapturingStillImageContext];
		[self addObserver:self forKeyPath:@"movieFileOutput.recording" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:RecordingContext];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
		
		__weak CaputreViewController *weakSelf = self;
		[self setRuntimeErrorHandlingObserver:[[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureSessionRuntimeErrorNotification object:[self session] queue:nil usingBlock:^(NSNotification *note) {
			CaputreViewController *strongSelf = weakSelf;
			dispatch_async([strongSelf sessionQueue], ^{
				// Manually restarting the session since it must have been stopped due to an error.
				[[strongSelf session] startRunning];
			});
		}]];
		[[self session] startRunning];
	});
}
#pragma Orientation
- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAll;
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[[(AVCaptureVideoPreviewLayer *)[[self movieView] layer] connection] setVideoOrientation:(AVCaptureVideoOrientation)toInterfaceOrientation];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (context == CapturingStillImageContext)
	{
		BOOL isCapturingStillImage = [change[NSKeyValueChangeNewKey] boolValue];
		
		if (isCapturingStillImage)
		{
			[self runStillImageCaptureAnimation];
		}
	}
	else if (context == RecordingContext)
	{
		BOOL isRecording = [change[NSKeyValueChangeNewKey] boolValue];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			if (isRecording)
			{
//				[[self cameraButton] setEnabled:NO];
//				[[self recordButton] setTitle:NSLocalizedString(@"Stop", @"Recording button stop title") forState:UIControlStateNormal];
//				[[self recordButton] setEnabled:YES];
			}
			else
			{
//				[[self cameraButton] setEnabled:YES];
//				[[self recordButton] setTitle:NSLocalizedString(@"Record", @"Recording button record title") forState:UIControlStateNormal];
//				[[self recordButton] setEnabled:YES];
			}
		});
	}
	else if (context == SessionRunningAndDeviceAuthorizedContext)
	{
		BOOL isRunning = [change[NSKeyValueChangeNewKey] boolValue];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			if (isRunning)
			{
//				[[self cameraButton] setEnabled:YES];
//				[[self recordButton] setEnabled:YES];
//				[[self stillButton] setEnabled:YES];
			}
			else
			{
//				[[self cameraButton] setEnabled:NO];
//				[[self recordButton] setEnabled:NO];
//				[[self stillButton] setEnabled:NO];
			}
		});
	}
	else
	{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}
#pragma MakeDevice Configuration
- (void)subjectAreaDidChange:(NSNotification *)notification
{
	CGPoint devicePoint = CGPointMake(.5, .5);
	[self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:NO];
}
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange
{
	dispatch_async([self sessionQueue], ^{
		AVCaptureDevice *device = [[self videoDeviceInput] device];
		NSError *error = nil;
		if ([device lockForConfiguration:&error])
		{
			if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode])
			{
				[device setFocusMode:focusMode];
				[device setFocusPointOfInterest:point];
			}
			if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode])
			{
				[device setExposureMode:exposureMode];
				[device setExposurePointOfInterest:point];
			}
			[device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
			[device unlockForConfiguration];
		}
		else
		{
			NSLog(@"%@", error);
		}
	});
}

#pragma mark File Output Delegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
	if (error)
		NSLog(@"%@", error);
	
	[self setLockInterfaceRotation:NO];
	
	// Note the backgroundRecordingID for use in the ALAssetsLibrary completion handler to end the background task associated with this recording. This allows a new recording to be started, associated with a new UIBackgroundTaskIdentifier, once the movie file output's -isRecording is back to NO — which happens sometime after this method returns.
	UIBackgroundTaskIdentifier backgroundRecordingID = [self backgroundRecordingID];
	[self setBackgroundRecordingID:UIBackgroundTaskInvalid];
	
    //
    //info[UIImagePickerControllerMediaURL];
    MPMoviePlayerController *player = [[[MPMoviePlayerController alloc] initWithContentURL:outputFileURL]autorelease];
    UIImage  *thumbnail = [player thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    UIImageView *frameView = [[UIImageView alloc] initWithImage:thumbnail];
    frameView.frame = CGRectMake(0, 0, 316, 250);
//    [Image_container setImage:frameView.image];change
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(thumbnail) forKey:@"storeimage"];
    
    //change
    UIImageView *GalleryFrame = [[UIImageView alloc] initWithImage:thumbnail];
    GalleryFrame.frame = CGRectMake(0, 0, 55, 45);
    [self.GalleryImgbtn setImage:GalleryFrame.image];
//    [Image_container setHidden:NO];
    [btnClose setHidden:NO];
    [cameraImg setUserInteractionEnabled:NO];
    [videoImg setUserInteractionEnabled: NO];
    [imgViewRedBullet setHidden:YES];
    [[self movieFileOutput] stopRecording];
    [[self session] stopRunning];
    
    //store video at document directory
    NSData *videoData = [[NSData dataWithContentsOfURL:outputFileURL] retain];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //delete file from document directory
    NSString *tempPath = [documentsDirectory stringByAppendingFormat:@"/movie.mov"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:tempPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath: tempPath error: &error];

    }
    
//    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Default Album"];
//    
//    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
//        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSString *videopath= [[[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/movie.mov",documentsDirectory]] autorelease];
    
    BOOL success = [videoData writeToFile:videopath atomically:NO];
    if (success) {
        //take video from document directory
         NSURL *vedioURL;
         
         NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
         NSLog(@"files array %@", filePathsArray);
         
         NSString *fullpath;
         
         for ( NSString *apath in filePathsArray )
         {
             fullpath = [documentsDirectory stringByAppendingPathComponent:apath];
             vedioURL =[NSURL fileURLWithPath:fullpath];
         }
         NSLog(@"vurl %@",vedioURL);
        self.movieURL= vedioURL;

//         MPMoviePlayerViewController *videoPlayerView = [[MPMoviePlayerViewController alloc] initWithContentURL:vedioURL];
//         [self presentMoviePlayerViewControllerAnimated:videoPlayerView];
//         [videoPlayerView.moviePlayer play];
        
    }
    
    //save video in library
	[[[ALAssetsLibrary alloc] init] writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
		if (error)
			NSLog(@"%@", error);
		//remove video from temp folder
		[[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
		
		if (backgroundRecordingID != UIBackgroundTaskInvalid)
			[[UIApplication sharedApplication] endBackgroundTask:backgroundRecordingID];
	}];
}

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
    share_rotation = 0;
    [self cameraViewdidLoad];
    
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:[NSString stringWithFormat:@"%ld", (long)share_currentrotation] forKey:@"share_rotation"];
	
    self.header_galery_imgbtn.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_headergallery =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HeadeGalleryClicked:)];
	[self.header_galery_imgbtn addGestureRecognizer:tab_headergallery];
	[tab_headergallery release];
    
    //---- -- initialize video tab------
    self.GalleryImgbtn.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_gallery =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GalleryimgClicked:)];
	[self.GalleryImgbtn addGestureRecognizer:tab_gallery];
	[tab_gallery release];
    
    //---- -- initialize video tab------
    self.videoImg.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_video =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(VideoImgClicked:)];
	[self.videoImg addGestureRecognizer:tab_video];
	[tab_video release];
    
    //---- -- initialize next tab------
    self.cameraImg.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_cam =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CameraImgClicked:)];
	[self.cameraImg addGestureRecognizer:tab_cam];
	[tab_cam release];
    
    //---- -- initialize next tab------
    self.next_imgbtn.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_next =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NextTabclicked:)];
	[self.next_imgbtn addGestureRecognizer:tab_next];
	[tab_next release];
    
    //---- -- initialize back tab------
    self.backimgbtn.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_backf =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backFromCaputre:)];
	[self.backimgbtn addGestureRecognizer:tab_backf];
	[tab_backf release];
    
    //---- -- initialize rotation tab------
    self.imageRotation.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_rotation =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(RotateClicked:)];
	[self.imageRotation addGestureRecognizer:tab_rotation];
	[tab_rotation release];
    
    self.imageRotation1.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_rotation1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(RotateClickedRight:)];
	[self.imageRotation1 addGestureRecognizer:tab_rotation1];
	[tab_rotation1 release];
}
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [self cameraViewwillAppear];
    
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *sel_language = [prefs stringForKey:@"sel_language"];
	NSLog(@"sel_language %@",sel_language);
	if([sel_language isEqualToString:@"pt"]){
		[TSLanguageManager setSelectedLanguage:kLMPortu];
	}else{
		[TSLanguageManager setSelectedLanguage:kLMEnglish];
	}
	[self updateLabel];
}
- (void)viewDidDisappear:(BOOL)animated
{
	dispatch_async([self sessionQueue], ^{
		[[self session] stopRunning];
		
		[[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
		[[NSNotificationCenter defaultCenter] removeObserver:[self runtimeErrorHandlingObserver]];
		
		[self removeObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" context:SessionRunningAndDeviceAuthorizedContext];
		[self removeObserver:self forKeyPath:@"stillImageOutput.capturingStillImage" context:CapturingStillImageContext];
		[self removeObserver:self forKeyPath:@"movieFileOutput.recording" context:RecordingContext];
	});
}
- (BOOL)shouldAutorotate
{
	// Disable autorotation of the interface when recording is in progress.
	return ![self lockInterfaceRotation];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Other methods
-(void)imageRotation:(UITapGestureRecognizer *)recognizer
{
    self.movieView.transform = CGAffineTransformMakeScale(-1, 1);
    UIImage *image=self.Image_container.image;
    [[NSUserDefaults standardUserDefaults] setObject:image forKey:@"Rotation"];
}
-(void)test{
    NSTimer *timer;
    timer = [[NSTimer scheduledTimerWithTimeInterval:10000 target:self selector:@selector(thisMethodGetsFiredOnceEveryThirtySeconds:) userInfo:nil repeats:YES] retain];
    [timer fire];
}
-(void)GalleryimgClicked:(UITapGestureRecognizer *)recognizer  {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}
- (void)NextTabclicked:(UITapGestureRecognizer *)recognizer  {
    ChoosePictureViewController *choosephotoController = [[ChoosePictureViewController alloc] initWithNibName:objAppDel.choosePictureView bundle:nil];
   
	if(self.movieURL){
		objAppDel.strCurrentUploadType = [NSString stringWithFormat:@"Video"];
		objAppDel.strCurrentURl = [NSString stringWithFormat:@"%@",self.movieURL];
	}
    else{
		objAppDel.strCurrentUploadType = [NSString stringWithFormat:@"Image"];
		objAppDel.strCurrentURl = [NSString stringWithFormat:@"%@",self.captureimg];
	}
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"storeimage"];
    choosephotoController.chooseimg=[UIImage imageWithData:imageData];//self.captureimg;
    choosephotoController.imgselected=self.slecType;
    choosephotoController.vidURL=self.movieURL;
    [self.navigationController pushViewController:choosephotoController animated:YES];
}
- (void)CameraImgClicked:(UITapGestureRecognizer *)recognizer  {
     //self.movieScrolview.hidden=YES;
    
      self.slecType=@"cam";
   
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_ALERT"]
                                                              message:[TSLanguageManager localizedString:@"MSG_DEVICE_HAS_NO_CAMERA"]
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
    }
    else{
           /* UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];*/
        dispatch_async([self sessionQueue], ^{
            // Update the orientation on the still image output video connection before capturing.
            [[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[[(AVCaptureVideoPreviewLayer *)[[self movieView] layer] connection] videoOrientation]];
            
            // Flash set to Auto for Still Capture
//            [CaputreViewController setFlashMode:AVCaptureFlashModeOn forDevice:[[self videoDeviceInput] device]];
            
            // Capture a still image.
            [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                
                if (imageDataSampleBuffer)
                {
                    NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                    UIImage *image = [[UIImage alloc] initWithData:imageData];
//                    self.Image_container.image = image;
                    
                    //change
                    UIImageView *GalleryFrame = [[UIImageView alloc] initWithImage:image];
                    GalleryFrame.frame = CGRectMake(0, 0, 55, 45);
                    [self.GalleryImgbtn setImage:GalleryFrame.image];
//                    [Image_container setHidden:NO];
                    [btnClose setHidden:NO];
                    [cameraImg setUserInteractionEnabled:NO];
                    [videoImg setUserInteractionEnabled:NO];
                    [[self session] stopRunning];
                    
//                    self.captureimg=image;
                    [[NSUserDefaults standardUserDefaults] setObject:UIImageJPEGRepresentation(image, 1.0) forKey:@"storeimage"];
                    [[[ALAssetsLibrary alloc] init] writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:nil];
                }
            }];
        });
       }
}
- (void)playVideo {
    self.movieController= [[MPMoviePlayerController alloc] init];
    [self.movieController setContentURL: self.movieURL];
    if (isiPad) {
        
    }
    else{
        if (isiPhone5) {
            [self.movieController.view setFrame: CGRectMake(0, 0, 280, 310)];
        }
        else
        {
            [self.movieController.view setFrame: CGRectMake(0, 0, 250, 250)];
        }
    }
    
    [self.movieView addSubview:self.movieController.view];
    [self.movieController play];
}
- (void) thisMethodGetsFiredOnceEveryThirtySeconds:(id)sender {
    NSLog(@"fired!");
}
- (void)VideoImgClicked:(UITapGestureRecognizer *)recognizer  {
    self.slecType=@"vid";
	[imgViewRedBullet setHidden:NO];
    [btnClose setHidden:YES];
	dispatch_async([self sessionQueue], ^{
		if (![[self movieFileOutput] isRecording])
		{
			[self setLockInterfaceRotation:YES];
			
			if ([[UIDevice currentDevice] isMultitaskingSupported])
			{
				[self setBackgroundRecordingID:[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil]];
			}
			
			// Update the orientation on the movie file output video connection before starting recording.
			[[[self movieFileOutput] connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[[(AVCaptureVideoPreviewLayer *)[[self movieView] layer] connection] videoOrientation]];
			
			// Turning OFF flash for video recording
            lblFlashOnOff.text = @"Off";
			[CaputreViewController setFlashMode:AVCaptureFlashModeOff forDevice:[[self videoDeviceInput] device]];
			
			// Start recording to a temporary file.
			NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[@"movie" stringByAppendingPathExtension:@"mov"]];
            
			[[self movieFileOutput] startRecordingToOutputFileURL:[NSURL fileURLWithPath:outputFilePath] recordingDelegate:self];
		}
		else
		{
			[[self movieFileOutput] stopRecording];
		}
	});
}
-(void)HeadeGalleryClicked:(UITapGestureRecognizer *)recognizer{
}
- (void)timeOutTriggered{
    [self  playVideo];
}
- (void)backFromCaputre:(UITapGestureRecognizer *)recognizer  {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *set_direct_camera = [prefs stringForKey:@"set_direct_camera"];
	NSLog(@"set_direct_camera %@",set_direct_camera);
	if([set_direct_camera isEqualToString:@"ON"]){
		DetailfeedViewController *DetailController = [[DetailfeedViewController alloc] initWithNibName:objAppDel.detailfeedView bundle:nil];
		[self.navigationController pushViewController:DetailController animated:YES];
	}else{
		[self.navigationController popViewControllerAnimated:YES];
	}
}
-(void) updateLabel
{
	self.lbl_next.text = [TSLanguageManager localizedString:@"LBL_NEXT"];
}
- (BOOL)prefersStatusBarHidden
{
	return YES;
}

#pragma mark - Action methods
//change
-(IBAction)btnCloseClicked:(id)sender
{
    self.Image_container.hidden = YES;
    [movieView setHidden:NO];
    [cameraImg setUserInteractionEnabled:YES];
    [videoImg setUserInteractionEnabled: YES];
    [Image_container setHidden:YES];
    [btnClose setHidden:YES];
    [[self session] startRunning];
}
//
- (IBAction)RotateClickedRight:(UITapGestureRecognizer *)recognizer {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	if(share_rotation == -360){
        share_rotation = 0;
    }
    share_rotation = share_rotation-90;
    share_currentrotation =share_rotation;
	[prefs setObject:[NSString stringWithFormat:@"%ld", (long)share_currentrotation] forKey:@"share_rotation"];
	self.movieView.transform = CGAffineTransformMakeRotation(share_rotation * M_PI / 180.0);
}
- (IBAction)RotateClicked:(UITapGestureRecognizer *)recognizer {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	if(share_rotation == 360){
        share_rotation = 0;
    }
    share_rotation = share_rotation+90;
    share_currentrotation =share_rotation;
	[prefs setObject:[NSString stringWithFormat:@"%ld", (long)share_currentrotation] forKey:@"share_rotation"];
	self.movieView.transform = CGAffineTransformMakeRotation(share_rotation * M_PI / 180.0);
}
#pragma custom camera
-(IBAction)btnRearFrontCameraclicked:(id)sender
{
	dispatch_async([self sessionQueue], ^{
		AVCaptureDevice *currentVideoDevice = [[self videoDeviceInput] device];
		AVCaptureDevicePosition preferredPosition = AVCaptureDevicePositionUnspecified;
		AVCaptureDevicePosition currentPosition = [currentVideoDevice position];
		
		switch (currentPosition)
		{
			case AVCaptureDevicePositionUnspecified:
				preferredPosition = AVCaptureDevicePositionBack;
				break;
			case AVCaptureDevicePositionBack:
				preferredPosition = AVCaptureDevicePositionFront;
				break;
			case AVCaptureDevicePositionFront:
				preferredPosition = AVCaptureDevicePositionBack;
				break;
		}
		
		AVCaptureDevice *videoDevice = [CaputreViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:preferredPosition];
		AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
		
		[[self session] beginConfiguration];
		
		[[self session] removeInput:[self videoDeviceInput]];
		if ([[self session] canAddInput:videoDeviceInput])
		{
			[[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:currentVideoDevice];
			
//			[CaputreViewController setFlashMode:AVCaptureFlashModeOn forDevice:videoDevice];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:videoDevice];
			
			[[self session] addInput:videoDeviceInput];
			[self setVideoDeviceInput:videoDeviceInput];
		}
		else
		{
			[[self session] addInput:[self videoDeviceInput]];
		}
		
		[[self session] commitConfiguration];
		
		dispatch_async(dispatch_get_main_queue(), ^{

		});
	});
}
-(IBAction)btnFlashclicked:(id)sender
{
//    AVCaptureDevice *videoDevice = [CaputreViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
//    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
    //videoDeviceInput.device;//

    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (device.flashMode == AVCaptureFlashModeOff)//AVCaptureTorchModeOff
    {
         lblFlashOnOff.text = @"On";
         [CaputreViewController setFlashMode:AVCaptureFlashModeOn forDevice:[[self videoDeviceInput] device]];
    }
    else
    {
         lblFlashOnOff.text = @"Off";
         [CaputreViewController setFlashMode:AVCaptureFlashModeOff forDevice:[[self videoDeviceInput] device]];
    }
}

#pragma mark - ImagePickerController delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [cameraImg setUserInteractionEnabled:NO];
    [videoImg setUserInteractionEnabled:NO];
    self.movieURL= info[UIImagePickerControllerMediaURL];
    if(self.movieURL){
//         self.movieView.hidden = YES;
//         self.Image_container.hidden = NO;
        
        MPMoviePlayerController *player = [[[MPMoviePlayerController alloc] initWithContentURL:self.movieURL]autorelease];
        UIImage  *thumbnail = [player thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        UIImageView *frameView = [[UIImageView alloc] initWithImage:thumbnail];
        frameView.frame = CGRectMake(0, 0, 316, 250);//movieView.frame ;
//        imgViewVideoImage.image = thumbnail;
        //        player = nil;
        [Image_container setImage:frameView.image];
//        [movieView addSubview:frameView];
        
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(thumbnail) forKey:@"storeimage"];
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }
    else{
        
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        self.Image_container.image = chosenImage;
        self.captureimg=chosenImage;
    
//        self.movieView.hidden = YES;
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(chosenImage) forKey:@"storeimage"];
        
        [picker dismissViewControllerAnimated:YES completion:NULL];
        //when select from gallery
        //change
        [[self session] stopRunning];
        [movieView setHidden:YES];
        self.Image_container.hidden = NO;
        [btnClose setHidden:NO];
        [cameraImg setUserInteractionEnabled:YES];
        [videoImg setUserInteractionEnabled: YES];
        //
    }
}

@end
