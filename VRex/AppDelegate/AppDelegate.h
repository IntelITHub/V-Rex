//
//  AppDelegate.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/9/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)NSString *viewname;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (nonatomic, retain) NSString *countryStr;

@property (nonatomic, retain) NSString *stateStr;
@property (nonatomic, retain) NSString *categoryStr;
@property (nonatomic, retain) NSString *strDeviceId;
@property (nonatomic, retain) NSString *strDeviceToken;
@property (nonatomic, retain) NSString *strCurrentUploadType;
@property (nonatomic, retain) NSString *strCurrentURl;
	
@property(nonatomic,retain)NSString *registerView;
@property(nonatomic,retain)NSString *loginView;
@property(nonatomic,retain)NSString *detailfeedView;
@property(nonatomic,retain)NSString *mainView;
@property(nonatomic,retain)NSString *searchView;
@property(nonatomic,retain)NSString *simpleTableCellView;
@property(nonatomic,retain)NSString *searchResultView;
@property(nonatomic,retain)NSString *captureView;
@property(nonatomic,retain)NSString *notificationView;
@property(nonatomic,retain)NSString *notificationTableView;
@property(nonatomic,retain)NSString *userProfileView;
@property(nonatomic,retain)NSString *sharePostView;
@property(nonatomic,retain)NSString *editProfileView;
@property(nonatomic,retain)NSString *accountSettingView;
@property(nonatomic,retain)NSString *generalSettingView;
@property(nonatomic,retain)NSString *choosePictureView;
@property(nonatomic,retain)NSString *postDetailView;
@property(nonatomic,retain)NSString *homePageTableView;
@property(nonatomic,retain)NSString *commentView;
@property(nonatomic,retain)NSString *forgotView;
@property(nonatomic,retain)NSString *userprofileTableCellView;
@property(nonatomic,retain)NSString *deviceCurrentIP;
@property(nonatomic,retain)NSString *shareRotate;
@property(nonatomic,retain)NSString *MypostsView;
@property(nonatomic,retain)NSString *currentProfileView;

//- (void)getTwitterAccountOnCompletion:(void(^)(ACAccount *))completionHandler;

//other methods
- (BOOL) isconnectedToNetwork;
- (CGSize) resizeOfFrameForFill:(CGSize)srcSize forBoundingSize:(CGSize)boundingSize;
- (UIImage*)imageWithImage: (UIImage *) sourceImage scaledToWidth: (float) i_width;

@end
