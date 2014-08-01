//
//  AppDelegate.m
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/9/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "constant.h"
#import "TSLanguageManager.h"
#import <AdSupport/ASIdentifierManager.h>

@implementation AppDelegate

@synthesize countryStr,stateStr,categoryStr,strDeviceId,strDeviceToken,strCurrentURl,strCurrentUploadType;
@synthesize currentProfileView,navigationController,viewname,shareRotate,registerView,loginView;
@synthesize  detailfeedView,mainView,searchView,simpleTableCellView,searchResultView,captureView,notificationView;
@synthesize  notificationTableView,userProfileView,sharePostView,editProfileView,accountSettingView,generalSettingView;
@synthesize  choosePictureView,postDetailView,homePageTableView,commentView,forgotView,userprofileTableCellView,deviceCurrentIP,MypostsView;

#pragma makr - AppDelegate methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    objAppDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //initialise variables
	currentProfileView = @"";
	countryStr = @"";
	stateStr = @"";
	categoryStr = @"";
	strDeviceId = @"";
	strDeviceToken = @"";
	strCurrentURl  = @"";
	strCurrentUploadType  = @"";
	deviceCurrentIP = @"";
	shareRotate = @"0";
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"storeimage"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //language options
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *sel_language = [prefs stringForKey:@"sel_language"];
	
	if([sel_language isEqualToString:@"pt"])
    {
		[TSLanguageManager setSelectedLanguage:kLMPortu];
	}
    else
    {
		[TSLanguageManager setSelectedLanguage:kLMEnglish];
	}
	
    //nib selection
	if (!isiPad) {
		CGSize result = [[UIScreen mainScreen] bounds].size;
		if(result.height == 480)
		 {
			// iPhone Classic
            registerView = @"RegistrationViewController";
            loginView= @"RegistrationViewController";;
            detailfeedView= @"DetailfeedViewController";;
            mainView= @"ViewController";;
            searchView= @"SearchViewController";;
            simpleTableCellView= @"SimpleTableCell";
            searchResultView= @"SearchresultViewController";;
            captureView= @"CaputreViewController";;
            notificationView= @"NotificationViewController";;
            notificationTableView= @"NotificationTable";;
            userProfileView= @"UserprofileViewController";;
            sharePostView= @"SharePostViewController";;
            editProfileView= @"EditprofileViewController";;
            accountSettingView= @"AccountSettingViewController";;
            generalSettingView= @"GeneralSettingsViewController";;
            choosePictureView= @"ChoosePictureViewController";;
            postDetailView= @"PostDetailViewController";;
            homePageTableView= @"HomepageTable";;
            commentView= @"CommnetViewController";;
            forgotView= @"ForgotViewController";
            userprofileTableCellView =@"userprofileTableCell";
            MypostsView = @"MypostsViewController";
		 }
		else
		 {
            registerView = @"RegistrationViewControllerIphone5";
            loginView= @"RegistrationViewControllerIphone5";
            detailfeedView= @"DetailfeedViewController";
            mainView= @"ViewController";
            searchView= @"SearchViewController";
            simpleTableCellView= @"SimpleTableCell";
            searchResultView= @"SearchresultViewController";
            captureView= @"CaputreViewControllerIphone5";
            notificationView= @"NotificationViewController";
            notificationTableView= @"NotificationTable";
            userProfileView= @"UserprofileViewControllerIphone5";
            sharePostView= @"SharePostViewController";
            editProfileView= @"EditprofileViewController";
            accountSettingView= @"AccountSettingViewController";
            generalSettingView= @"GeneralSettingsViewController";
            choosePictureView= @"ChoosePictureViewController";
            postDetailView= @"PostDetailViewController";
            homePageTableView= @"HomepageTable";
            commentView= @"CommnetViewController";
            forgotView= @"ForgotViewController";
            userprofileTableCellView =@"userprofileTableCell";
            MypostsView = @"MypostsViewController";
		 }
	}
    else{//iPad
		registerView = @"RegistrationViewControllerIpad";
		loginView= @"RegistrationViewControllerIpad";
		detailfeedView= @"DetailfeedViewControllerIpad";
		mainView= @"ViewControllerIpad";
		searchView= @"SearchViewControllerIpad";
		simpleTableCellView= @"SimpleTableICellpad";
		searchResultView= @"SearchResultViewControllerIpad";
		captureView= @"CaptureViewControllerIpad";
		notificationView= @"NotificationViewControllerIpad";
		notificationTableView= @"NotificationTableIpad";
		userProfileView= @"UserprofileViewControllerIpad";
		sharePostView= @"SharePostViewControllerIpad";
		editProfileView= @"EditprofileViewControllerIpad";
		accountSettingView= @"accountsettingcontrollerIpad";
		generalSettingView= @"GeneralSettingViewControllerIpad";
		choosePictureView= @"ChoosePictureViewControllerIpad";
		postDetailView= @"PostDetailViewControllerIpad";
		homePageTableView= @"HomePageTableIpad";
		commentView= @"CommnetViewControllerIpad";
		forgotView= @"ForgotViewControllerIpad";
		userprofileTableCellView =@"userprofileTableCellIpad";
        MypostsView = @"MypostsViewControllerIpad";
	}
    
    if (!isiPad) {
        viewname=@"ViewController";
    } else {
        viewname=@"ViewControllerIpad";
    }
    
    //set rootview controller
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.viewController = [[[ViewController alloc] initWithNibName:viewname bundle:Nil] autorelease];
	self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
	self.navigationController.navigationBarHidden = YES;
	self.window.rootViewController = self.navigationController;
    
    //sleep for splash screen
	sleep(2);
    //hide statusbar
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
    //notification type
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
	 (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    //check for facebook authentication
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }
    else {
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    //store device token
	objAppDel.strDeviceToken = [NSString stringWithFormat:@"%@",deviceToken];
	
    //store Adverisement Id
	NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
	objAppDel.strDeviceId = [NSString stringWithFormat:@"%@",adId];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    //get push notification data
	UIApplicationState sstate = [application applicationState];
	if (sstate == UIApplicationStateActive)
    {
        NSString *cancelTitle = @"Close";
        NSString *showTitle = @"Show";
        NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"]
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:cancelTitle
                                                  otherButtonTitles:showTitle, nil];
        [alertView show];
        [alertView release];
	}
    else
    {
        //Do stuff that you would do if the application was not active
	}
	[self addMessageFromRemoteNotification:userInfo updateUI:YES];
}

- (void)addMessageFromRemoteNotification:(NSDictionary*)userInfo updateUI:(BOOL)updateUI
{
	NSString* alertValue = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
	NSMutableArray* parts = [NSMutableArray arrayWithArray:[alertValue componentsSeparatedByString:@": "]];
	[parts removeObjectAtIndex:0];
}
- (void)dealloc
{
    [_window release];
    [_viewController release];
    [viewname release];
    [super dealloc];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - OperUrl
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
        return [FBSession.activeSession handleOpenURL:url];
}

#pragma makr - Othe methods
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;

        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
    }
}

// Show the user the logged-out UI
- (void)userLoggedOut
{
    NSLog(@"log out");
}

// Show the user the logged-in UI
- (void)userLoggedIn
{
    NSLog(@"log in");
}

// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}

#pragma mark - Reachability methods
#pragma mark - Network Reachability methods
- (BOOL) isconnectedToNetwork {
    BOOL isInternet;
    Reachability* reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable) { isInternet =NO;}
    else if (remoteHostStatus == ReachableViaWWAN) {isInternet = TRUE;}
    else { isInternet = TRUE;}
    return isInternet;
}

#pragma mark - Resize Image
#pragma  mark - Image Resize
- (CGSize) resizeOfFrameForFill:(CGSize)srcSize forBoundingSize:(CGSize)boundingSize{
    //    CGSize boundingSize = CGSizeMake(1024, 748);
    CGFloat wRatio = boundingSize.width / srcSize.width;
    CGFloat hRatio = boundingSize.height / srcSize.height;
    CGSize dstSize;
    
    if (wRatio > hRatio) {
        dstSize = CGSizeMake(boundingSize.width, floorf(srcSize.height * wRatio));
    } else {
        dstSize = CGSizeMake(floorf(srcSize.width * hRatio), boundingSize.height);
    }
    
    return dstSize;
}
- (UIImage*)imageWithImage: (UIImage *) sourceImage scaledToWidth: (float) i_width {
    
    CGSize size = [self resizeOfFrameForFill:sourceImage.size forBoundingSize:CGSizeMake(i_width, i_width)];
    
    UIGraphicsBeginImageContext(size);
    [sourceImage drawInRect:CGRectMake(0, 0, size.width,size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
