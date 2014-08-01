    //
//  DetailfeedViewController.m
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/16/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import "DetailfeedViewController.h"
#import "SearchViewController.h"
#import "CaputreViewController.h"
#import "NotificationViewController.h"
#import "UserprofileViewController.h"
#import "PostDetailViewController.h"
#import "GlobalVar.h"
#import "HomepageTable.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "CommnetViewController.h"
#import "AppDelegate.h"
#import "TSLanguageManager.h"
#import "constant.h"

//initialise variables
int var=0;
int imgdata1=0;
int scrollconst=0;
int no_of_commt=0;
int pageid=1;
int tagno=0;
static long totalPost = 0;
static long currentlyDisplayingPost = 1;

@interface DetailfeedViewController ()

@end

@implementation DetailfeedViewController
@synthesize scrollview,viewname,capture_view,userprofile_view,comment_view,notification_view,likeimgbtn,tableData,tableView1;
@synthesize Upper_view,responseData,ProfileimgArray,userimgArray,eFileTypeArray,userArray,CategoriesNameArray,postCountArray;
@synthesize likecountArray,DescArray,tPostArray,DatetimeArray,memveridArray,postidArray,citydArray,islikeArray,mainimg,leftDownimg,lelfuppderimg,rightdownimg;
@synthesize rightupperimg,line_img,locationManager,downbtn,uppdperbtn,longi,lati,alert,commnetTxtbox,sendbtn,post_id_homepage,Memver_id_home,Memver_like;
@synthesize Memver_likeArray;
@synthesize post_box_container,Closecmtbtn,serviceURL,player;

#pragma mark - viewcontroller delegate methods
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
    if (isiPad) {
        if (iOS7) {
        }
        else{
           
        }
    }
    else{
        if (isiPhone5) {
            if (iOS7) {
                [btnHome setFrame:CGRectMake(-1 ,522 ,70 ,50)];
                [btnSearch setFrame:CGRectMake(67 ,522 ,70 ,50)];
                [btnCamera setFrame:CGRectMake(133 ,522 ,69 ,50)];
                [btnCategory setFrame:CGRectMake(194 ,522 ,69 ,50)];
                [btnProfile setFrame:CGRectMake(255 ,522 ,69 ,50)];
            }
            else{
                [btnHome setFrame:CGRectMake(-1 ,500 ,70 ,50)];
                [btnSearch setFrame:CGRectMake(67 ,500 ,70 ,50)];
                [btnCamera setFrame:CGRectMake(133 ,500 ,69 ,50)];
                [btnCategory setFrame:CGRectMake(194 ,500 ,69 ,50)];
                [btnProfile setFrame:CGRectMake(255 ,500 ,69 ,50)];
            }
        }
        else{
            if (iOS7) {
                [tableView1 setFrame:CGRectMake(0, 59, 320, 374)];
                [btnHome setFrame:CGRectMake(-1 ,436 ,70 ,50)];
                [btnSearch setFrame:CGRectMake(67 ,436 ,70 ,50)];
                [btnCamera setFrame:CGRectMake(133 ,436 ,69 ,50)];
                [btnCategory setFrame:CGRectMake(194 ,436 ,69 ,50)];
                [btnProfile setFrame:CGRectMake(255 ,436 ,69 ,50)];
            }
            else{
                [btnHome setFrame:CGRectMake(-1 ,414 ,70 ,50)];
                [btnSearch setFrame:CGRectMake(67 ,414 ,70 ,50)];
                [btnCamera setFrame:CGRectMake(133 ,414 ,69 ,50)];
                [btnCategory setFrame:CGRectMake(194 ,414 ,69 ,50)];
                [btnProfile setFrame:CGRectMake(255 ,414 ,69 ,50)];
            }
        }
    }
    
	//initialise location manager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    //initialise location
    CLLocation *location = [locationManager location];
    
    // Configure the new event with information from the location
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    self.longi=longitude;
    self.lati=latitude;
	
	self.likeimgbtn.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_likeimgtab =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeImgClicked:)];
	[self.likeimgbtn addGestureRecognizer:tab_likeimgtab];
	[tab_likeimgtab release];
    
    self.fullViewBackImage.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_back_full_view =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeFullView:)];
	[self.fullViewBackImage addGestureRecognizer:tap_back_full_view];
	[tap_back_full_view release];
}
-(void)viewWillAppear:(BOOL)animated{
	self.cachedMainImages = [[NSMutableDictionary alloc] init];
	self.cachedUserImages = [[NSMutableDictionary alloc] init];
	
	GlobalVar *s_url=[GlobalVar getServiceUrl];
	serviceURL=s_url.servieurl;
	
	totalPost = 0;
	currentlyDisplayingPost = 1;
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
	NSString *sel_language = [prefs stringForKey:@"sel_language"];

	if([sel_language isEqualToString:@"pt"]){
		[TSLanguageManager setSelectedLanguage:kLMPortu];
	}else{
		[TSLanguageManager setSelectedLanguage:kLMEnglish];
	}
	[self updateLabel];
	
	self.Memver_id_home=savedMemderid;
	self.Memver_like=@"NO";
   
    //initialise array
	self.Memver_likeArray=[[NSMutableArray alloc]initWithObjects: nil];
	self.tableData = [[NSMutableArray alloc]initWithObjects: nil];
	self.ProfileimgArray = [[NSMutableArray alloc]initWithObjects: nil];
	self.userimgArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.eFileTypeArray = [[NSMutableArray alloc]initWithObjects: nil];
	self.userArray = [[NSMutableArray alloc]initWithObjects: nil];
	self.CategoriesNameArray = [[NSMutableArray alloc]initWithObjects: nil];
	self.postCountArray = [[NSMutableArray alloc]initWithObjects: nil];
	self.likecountArray = [[NSMutableArray alloc]initWithObjects: nil];
	self.DescArray = [[NSMutableArray alloc]initWithObjects: nil];
	self.tPostArray = [[NSMutableArray alloc]initWithObjects: nil];
	self.DatetimeArray = [[NSMutableArray alloc]initWithObjects: nil];
	self.memveridArray = [[NSMutableArray alloc]initWithObjects: nil];
	self.postidArray = [[NSMutableArray alloc]initWithObjects: nil];
	self.citydArray = [[NSMutableArray alloc]initWithObjects: nil];
	self.islikeArray = [[NSMutableArray alloc]initWithObjects: nil];
	
    pageid = 1;
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        [self getPageData];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
   
	rightupperimg.hidden=YES;
	rightdownimg.hidden=YES;
	line_img.hidden=YES;
	lelfuppderimg.hidden=YES;
	leftDownimg.hidden=YES;
	mainimg.hidden=YES;
	uppdperbtn.hidden=YES;
	downbtn.hidden=YES;
}
-(void) viewDidAppear:(BOOL)animated
{
    scrollview.scrollEnabled = YES;
    if (isiPad) {
        [scrollview setContentSize:CGSizeMake(760, 900)];
    }
    else{
        [scrollview setContentSize:CGSizeMake(320, 900)];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload
{
	[super viewDidUnload];
	[self.Memver_likeArray release];
	[self.tableData release];
	[self.ProfileimgArray release];
	[self.userimgArray release];
	[self.userArray release];
	[self.CategoriesNameArray release];
	[self.postCountArray release];
	[self.likecountArray release];
	[self.DescArray release];
	[self.tPostArray release];
	[self.DatetimeArray release];
	[self.memveridArray release];
	[self.postidArray release];
	[self.citydArray release];
	[self.islikeArray release];
}


#pragma mark - Other methods
- (void)closeFullView:(UITapGestureRecognizer *)recognizer  {
	self.fullView.hidden=  YES;
    
}
-(void)goToProfile:(UITapGestureRecognizer *)recognizer{
	UserprofileViewController *userprofileController = [[UserprofileViewController alloc] initWithNibName:objAppDel.userProfileView bundle:nil];
    NSString *m_id=[self.memveridArray objectAtIndex:((UIImageView *) recognizer.view).tag];
    NSLog(@"Member ID-->%@",m_id);
    userprofileController.profiletype=@"public";
    userprofileController.Pub_profileid=m_id;
    [self.navigationController pushViewController:userprofileController animated:YES];
}
-(void)GotoCommnetlist:(UITapGestureRecognizer *)recognizer{
    self.post_id_homepage=[self.postidArray objectAtIndex:((UIImageView *) recognizer.view).tag];
    CommnetViewController *commnetController = [[CommnetViewController alloc] initWithNibName:objAppDel.commentView bundle:nil];
    commnetController.post_id=self.post_id_homepage;
    [self.navigationController pushViewController:commnetController animated:YES];
}
-(void)UserGotoProile:(UITapGestureRecognizer *)recognizer{
    UserprofileViewController *userprofileController = [[UserprofileViewController alloc] initWithNibName:objAppDel.userProfileView bundle:nil];
    NSString *m_id=[self.memveridArray objectAtIndex:((UILabel *) recognizer.view).tag];
    NSLog(@"UserGotoProile memid-->%@",m_id);
    userprofileController.profiletype=@"public";
    userprofileController.Pub_profileid=m_id;
    [self.navigationController pushViewController:userprofileController animated:YES];
}
-(void)CommentPost:(UITapGestureRecognizer *)recognizer{
    no_of_commt=0;
    tagno=((UIImageView *) recognizer.view).tag;
    self.post_id_homepage=[self.postidArray objectAtIndex:((UIImageView *) recognizer.view).tag];
    no_of_commt=[[self.postCountArray objectAtIndex:((UIImageView *) recognizer.view).tag] intValue] ;
    no_of_commt++;
    
    self.sendbtn.hidden=NO;
    self.commnetTxtbox.hidden=NO;
    self.post_box_container.hidden=NO;
    self.Closecmtbtn.hidden=NO;
}
-(void)openImage:(UITapGestureRecognizer *)recognizer{
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
	dispatch_async(queue, ^{
		NSURL *url_img_video_thumb = [NSURL URLWithString:[NSString stringWithFormat:@"%@", url_img1]];
		NSData *data_video_thumb = [NSData dataWithContentsOfURL:url_img_video_thumb];
		UIImage *newIMage = [UIImage imageWithData:data_video_thumb];
		NSLog(@"Width %f ==> height %f",newIMage.size.width,newIMage.size.height);
		dispatch_sync(dispatch_get_main_queue(), ^{
            self.fullViewImage.image = nil;
			self.fullViewImage.image=[UIImage imageWithData:data_video_thumb];
		});
	});
	// height of image
    self.player.view.hidden = YES;
	self.fullView.hidden=  NO;
    [self.view removeConstraints:self.fullView.constraints];
	[self.view addSubview:self.fullView];
}
-(void)playvideo:(UITapGestureRecognizer *)recognizer{
	NSURL *url= url_img;
    
	self.player = [[MPMoviePlayerController alloc] initWithContentURL:url];
	if (!isiPad) {
    	self.player.view.frame = CGRectMake(2, 71, 316, 300);
	}else{
	 	self.player.view.frame = CGRectMake(2, 108, 765, 1000);
	}
	
	[self.fullView addSubview:self.player.view];
	[self.view addSubview:self.fullView];
	self.fullView.hidden =  YES;
	[self.player play];
}
+ (NSMutableURLRequest *)imageRequestWithURL:(NSURL *)url {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	request.cachePolicy = NSURLRequestReturnCacheDataElseLoad; // this will make sure the request always returns the cached image
	request.HTTPShouldHandleCookies = NO;
	request.HTTPShouldUsePipelining = YES;
	[request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
	
	return request;
}
-(void)goToPostDetail:(UITapGestureRecognizer *)recognizer{
	self.post_id_homepage=[self.postidArray objectAtIndex:((UIImageView *) recognizer.view).tag];
	
	PostDetailViewController *postDetaildController = [[PostDetailViewController alloc] initWithNibName:objAppDel.postDetailView bundle:nil];
	postDetaildController.posts_id=self.post_id_homepage;
    //postDetaildController.cat_name=self.catname;
	[self.navigationController pushViewController:postDetaildController animated:YES];
}
-(void) updateLabel
{
	[self.uppdperbtn setTitle:[TSLanguageManager localizedString:@"LBL_LATEST"] forState:UIControlStateNormal];
	[self.downbtn setTitle:[TSLanguageManager localizedString:@"LBL_MY_LOCATION"] forState:UIControlStateNormal];
}
- (BOOL)prefersStatusBarHidden
{
	return YES;
}

#pragma mark - Action methods
- (IBAction)latestbtnClicked:(id)sender {
	rightupperimg.hidden=YES;
	rightdownimg.hidden=YES;
	line_img.hidden=YES;
	lelfuppderimg.hidden=YES;
	leftDownimg.hidden=YES;
	mainimg.hidden=YES;
	uppdperbtn.hidden=YES;
	downbtn.hidden=YES;
    pageid=1;
    totalPost = 0;
    currentlyDisplayingPost = 1;
    
    //initalise array
    self.tableData = [[NSMutableArray alloc]initWithObjects: nil];
    self.ProfileimgArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.userimgArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.eFileTypeArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.userArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.CategoriesNameArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.postCountArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.likecountArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.DescArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.tPostArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.DatetimeArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.memveridArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.postidArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.citydArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.islikeArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.responseData = [NSMutableData data];
    
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        [self getPageData];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
   totalPost = 0;
   currentlyDisplayingPost = 1;
}
- (IBAction)CloseCommetBox:(id)sender {
    self.sendbtn.hidden=YES;
    self.commnetTxtbox.hidden=YES;
    self.post_box_container.hidden=YES;
    self.Closecmtbtn.hidden=YES;
}
- (IBAction)searchFooterbtnClicked:(id)sender {
    SearchViewController *searchController = [[SearchViewController alloc] initWithNibName:objAppDel.searchView bundle:nil]; [self.navigationController pushViewController:searchController animated:YES];
}
- (IBAction)CaptureFooterbtnClicked:(id)sender {
    CaputreViewController *captureController = [[CaputreViewController alloc] initWithNibName:objAppDel.captureView bundle:nil]; [self.navigationController pushViewController:captureController animated:YES];
}
- (IBAction)NotificationFooterbtnClicked:(id)sender {
    NotificationViewController *notificationController = [[NotificationViewController alloc] initWithNibName:objAppDel.notificationView bundle:nil]; [self.navigationController pushViewController:notificationController animated:YES];
}
- (IBAction)userprofileFooterbtnClicked:(id)sender {
    UserprofileViewController *userprofileController = [[UserprofileViewController alloc] initWithNibName:objAppDel.userProfileView bundle:nil];
    [self.navigationController pushViewController:userprofileController animated:YES];
}
- (IBAction)PlusBtnClicked:(id)sender {
    if(rightupperimg.hidden){
        rightupperimg.hidden=NO;
        rightdownimg.hidden=NO;
        line_img.hidden=NO;
        lelfuppderimg.hidden=NO;
        leftDownimg.hidden=NO;
        mainimg.hidden=NO;
        uppdperbtn.hidden=NO;
        downbtn.hidden=NO;
    }
    else{
        rightupperimg.hidden=YES;
        rightdownimg.hidden=YES;
        line_img.hidden=YES;
        lelfuppderimg.hidden=YES;
        leftDownimg.hidden=YES;
        mainimg.hidden=YES;
        uppdperbtn.hidden=YES;
        downbtn.hidden=YES;
    }
}

#pragma mark - Webservoce Call
-(void)getPageData{
    self.responseData = [NSMutableData data];
    
    NSString* myNewString = [NSString stringWithFormat:@"%i", pageid];
    NSString *page1=myNewString;
    NSString*J_url=[NSString stringWithFormat:@"%@?action=homePageLatestPost&iMemberId=", serviceURL];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
    NSString*Memberid=savedMemderid;
    NSString*pagetext=@"&page=";
    NSString*page=page1;
    NSArray *myStrings = [[NSArray alloc] initWithObjects:J_url, Memberid,pagetext,page, nil];
    
    //alert
    self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
    [self.alert show];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = CGPointMake(150, 100);
    [indicator startAnimating];
    [self.alert addSubview:indicator];
    
    NSString *joinedString = [myStrings componentsJoinedByString:@""];
    NSURL *myURL = [NSURL URLWithString:joinedString];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
    [NSURLConnection connectionWithRequest:myRequest delegate:self];
}
-(void)likeCliked:(UITapGestureRecognizer *)recognizer{
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        NSString *posts_id=[self.postidArray objectAtIndex:((UIImageView *) recognizer.view).tag];
        NSString *like=[self.islikeArray objectAtIndex:((UIImageView *) recognizer.view).tag];
        if([like isEqualToString:@"NO"]){
            int idssss=[[self.likecountArray objectAtIndex:((UIImageView *) recognizer.view).tag] intValue] ;
            
            idssss++;
            NSString *urlString = [NSString stringWithFormat:@"%@", serviceURL];
            NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
            [request setURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            
            NSMutableData *body = [NSMutableData data];
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
            [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
            
            // Text parameter1
            NSString *param1 = savedMemderid;
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iMemberId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param1] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            // Another text parameter
            NSString *param2 = posts_id;
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iPostId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param2] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            // Another text parameter
            NSString *param5 = @"setPostLike";
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param5] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            // close form
            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // set request body
            [request setHTTPBody:body];
            
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse* response, NSData* receivedData, NSError* error)
             {
                 if(error){
                     UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:[TSLanguageManager localizedString:@"LABEL_SOMETHING_WRONG"] delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                     [someError show];
                     [someError release];
                 }
                 else{
                     //                 NSString *returnString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
                     [self.alert dismissWithClickedButtonIndex:0 animated:YES];
                     [self.alert dismissWithClickedButtonIndex:0 animated:YES];
                     
                     ((UIImageView *) recognizer.view).image= [UIImage imageNamed:@"liket_btn.png"];
                     [islikeArray replaceObjectAtIndex:((UIImageView *) recognizer.view).tag withObject:@"YES"];
                     [likecountArray replaceObjectAtIndex:((UIImageView *) recognizer.view).tag withObject:[NSNumber numberWithInt:idssss]];
                     [self.tableView1 reloadData];
                 }//"You are logged in"
             }];
            
        }
        else{
            int idssss=[[self.likecountArray objectAtIndex:((UIImageView *) recognizer.view).tag] intValue] ;
            idssss--;
            
            NSString *urlString = [NSString stringWithFormat:@"%@", serviceURL];
            NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
            [request setURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            
            NSMutableData *body = [NSMutableData data];
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
            [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
            
            // Text parameter1
            NSString *param1 =self.Memver_id_home;
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iMemberId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param1] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            // Another text parameter
            NSString *param2 = posts_id;
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iPostId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param2] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            // Another text parameter
            NSString *param5 = @"setPostUnLike";
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param5] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            // close form
            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // set request body
            [request setHTTPBody:body];
            
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse* response, NSData* receivedData, NSError* error)
             {
                 if(error){
                     UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:[TSLanguageManager localizedString:@"LABEL_SOMETHING_WRONG"] delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                     [someError show];
                     [someError release];
                 }
                 else{
                     //                 NSString *returnString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
                     [self.alert dismissWithClickedButtonIndex:0 animated:YES];
                     [self.alert dismissWithClickedButtonIndex:0 animated:YES];
                     
                     [islikeArray replaceObjectAtIndex:((UIImageView *) recognizer.view).tag withObject:@"NO"];
                     [likecountArray replaceObjectAtIndex:((UIImageView *) recognizer.view).tag withObject:[NSNumber numberWithInt:idssss]];
                     [self.tableView1 reloadData];
                     
                     ((UIImageView *) recognizer.view).image= [UIImage imageNamed:@"like_btn_normal.png"];
                 }
                 //"You are logged in"
             }];
        }
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
}
- (IBAction)myLocationClicked:(id)sender {
	rightupperimg.hidden=YES;
	rightdownimg.hidden=YES;
	line_img.hidden=YES;
	lelfuppderimg.hidden=YES;
	leftDownimg.hidden=YES;
	mainimg.hidden=YES;
	uppdperbtn.hidden=YES;
	downbtn.hidden=YES;
	
    self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
    [self.alert show];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = CGPointMake(150, 100);
    [indicator startAnimating];
    [self.alert addSubview:indicator];
    
    pageid=1;
    totalPost = 0;
    currentlyDisplayingPost = 1;
    
    //intialise array
    self.tableData = [[NSMutableArray alloc]initWithObjects: nil];
    self.ProfileimgArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.userimgArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.eFileTypeArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.userArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.CategoriesNameArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.postCountArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.likecountArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.DescArray = [[NSMutableArray alloc] initWithObjects: nil];
    self.tPostArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.DatetimeArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.memveridArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.postidArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.citydArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.islikeArray = [[NSMutableArray alloc]initWithObjects: nil];
    self.responseData = [NSMutableData data];
	
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        NSString *page1=@"1";
        NSString*J_url= [NSString stringWithFormat:@"%@?action=homePageLatestPost&iMemberId=", serviceURL];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
        
        NSString*Memberid=savedMemderid;
        NSString*pagetext=@"&page=";
        NSString*page=page1;
        NSString *lat=@"&vLattitude=";
        NSString *lat_ori=self.lati;
        NSString *longid=@"&vLongitude=";
        NSString *longi_ori=self.longi;
        NSArray *myStrings = [[NSArray alloc] initWithObjects:J_url, Memberid,pagetext,page,lat,lat_ori,longid,longi_ori, nil];
        
        NSString *joinedString = [myStrings componentsJoinedByString:@""];
        NSLog(@"url-->%@",joinedString);
        NSURL *myURL = [NSURL URLWithString:joinedString];
        NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
        [NSURLConnection connectionWithRequest:myRequest delegate:self];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
}
- (IBAction)sendpost_home:(id)sender {
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        NSString *p_text=commnetTxtbox.text;
        //posts_id
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
        
        UIImage *ourImage= [UIImage imageNamed:@"sports.png"];
        NSData * imageData = UIImageJPEGRepresentation(ourImage, 1.0);
        
        NSString *urlString = [NSString stringWithFormat:@"%@", serviceURL];
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSMutableData *body = [NSMutableData data];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: attachment; name=\"userfile\"; filename=\"demo.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Text parameter1
        NSString *param1 = savedMemderid;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iMemberId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param1] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param2 = self.post_id_homepage;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iPostId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param2] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param3 = p_text;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tComments\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param3] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param5 = @"setComments";
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param5] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // set request body
        [request setHTTPBody:body];
        
        //return and test
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSError *e = nil;
        
        id object = [NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
        
        NSMutableString *message=[object valueForKey:@"msg"];
        NSMutableString *success=[object valueForKey:@"success"];
        //"You are logged in"
        if([success integerValue] == 1){
            UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:message delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [postCountArray replaceObjectAtIndex:tagno withObject:[NSNumber numberWithInt:no_of_commt]];
            [self.tableView1 reloadData];
            [someError show];
            [someError release];
            
            self.sendbtn.hidden=YES;
            self.commnetTxtbox.hidden=YES;
            self.post_box_container.hidden=YES;
            self.Closecmtbtn.hidden=YES;
        }
        else{
            UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:message delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [someError show];
            [someError release];
        }
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
}

#pragma mark - Response Delegate methods
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[self.alert dismissWithClickedButtonIndex:0 animated:YES];
    NSError *e = nil;
    
    NSString *json = [[NSString alloc] initWithData:self.responseData  encoding:NSUTF8StringEncoding];
    
    id object = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];

    NSMutableArray *campain_images = [[NSMutableArray alloc] init];
    campain_images=[object valueForKey:@"posts"];

    id response_Data=[object valueForKey:@"data"];
	id responseMessage=[object valueForKey:@"message"];
     
//	NSMutableString *message=[responseMessage valueForKey:@"msg"];
	NSMutableString *success=[responseMessage valueForKey:@"success"];
   
//	NSInteger lastcount=[self.userArray count];
	
	if([success integerValue] == 1){
		for (NSDictionary *dic in response_Data){
			if ([dic valueForKey:@"success"] != nil) {
			}else{
				NSString *username = (NSString*) [dic valueForKey:@"vUsername"];
				NSString *IProfileimgArray = (NSString*) [dic valueForKey:@"vPicture"];
                NSString *IeFileTypeArray = (NSString*) [dic valueForKey:@"eFileType"];
                NSString *IuserimgArray=@"";
               
                if([IeFileTypeArray isEqualToString:@"Image"]){
                 IuserimgArray = (NSString*) [dic valueForKey:@"vFile"];
                }else{
                 IuserimgArray = (NSString*) [dic valueForKey:@"vVideothumbnail"];
                }
    
                NSString *ICategoriesNameArray = (NSString*) [dic valueForKey:@"vCategoriesName"];
				NSString *IpostCountArray = (NSString*) [dic valueForKey:@"totalPostComments"];
				NSString *IlikecountArray = (NSString*) [dic valueForKey:@"totalPostLikes"];
				NSString *IDescArray = (NSString*) [dic valueForKey:@"tDescription"];
				NSString *ItPostArray = (NSString*) [dic valueForKey:@"tPost"];
				NSString *IDatetimeArray = (NSString*) [dic valueForKey:@"dCreatedDate"];
				NSString *ImemveridArray = (NSString*) [dic valueForKey:@"iMemberId"];
				NSString *IpostidArray = (NSString*) [dic valueForKey:@"iPostId"];
				NSString *IcitydArray = (NSString*) [dic valueForKey:@"vCity"];
				NSString *IislkeArray = (NSString*) [dic valueForKey:@"isPostLike"];
				
				[self.userArray addObject:username];
				[self.ProfileimgArray addObject:IProfileimgArray];
				[self.userimgArray addObject:IuserimgArray];
                [self.eFileTypeArray addObject:IeFileTypeArray];
    
				[self.CategoriesNameArray addObject:ICategoriesNameArray];
				[self.postCountArray addObject:IpostCountArray];
				[self.likecountArray addObject:IlikecountArray];
				
				[self.DescArray addObject:IDescArray];
				[self.tPostArray addObject:ItPostArray];
				[self.DatetimeArray addObject:IDatetimeArray];
				[self.CategoriesNameArray addObject:ICategoriesNameArray];
				[self.memveridArray addObject:ImemveridArray];
				[self.postidArray addObject:IpostidArray];
				[self.citydArray addObject:IcitydArray];
				[self.islikeArray addObject:IislkeArray];
			}
		}
		if(citydArray){
         scrollconst=1;
		}
		else{
			scrollconst=5;
		}
		
		self.tableData=self.userArray;
		totalPost = [self.tableData count];
		if(pageid > 1){
			self.editing = YES;
			[self.tableView1 reloadData];
		}
        else{
			self.editing = YES;
			[self.tableView1 reloadData];
		}
	}
    else{
		totalPost = 0;
		currentlyDisplayingPost =1;
		[self.tableView1 reloadData];
	}
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [self.responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // inform the user
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [someError show];
    [someError release];
    NSLog(@"Connection failed! Error - %@ %@",
          
          [error localizedDescription],
          
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

#pragma mark - TableView Delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isiPad) {
        if (isiPhone5) {
            return 570;
        }
    	return 513;//450;
    }else{
	 	return 842;//690;
    }
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return totalPost;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *simpleTableIdentifier = @"HomepageTable";
        
        HomepageTable *cell = (HomepageTable *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:objAppDel.homePageTableView owner:self options:nil];
        cell = [nib objectAtIndex:0];
        if (cell == nil) {
            cell = [[HomepageTable alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        NSString *nocount = [[likecountArray objectAtIndex:indexPath.row] stringValue];
        
        cell.like_lbl.text = nocount;
        NSString *no_post = [[postCountArray objectAtIndex:indexPath.row] stringValue];
        cell.Comment_lbl.text = no_post;
    
        cell.Usernamelbl.text = [NSString stringWithFormat:@"@%@", [tableData objectAtIndex:indexPath.row]];
        cell.postttl_lbl.text = [tPostArray objectAtIndex:indexPath.row];
        cell.city_lbl.text = [citydArray objectAtIndex:indexPath.row];
        cell.date_time.text = [DatetimeArray objectAtIndex:indexPath.row];
        cell.city_lbl.text = [citydArray objectAtIndex:indexPath.row];
        cell.category_lbl.text = [CategoriesNameArray objectAtIndex:indexPath.row];
        cell.commnetTextview.text = [DescArray objectAtIndex:indexPath.row];
        
         if([[islikeArray objectAtIndex:indexPath.row] isEqualToString:@"NO"]){
             cell.like_img.image= [UIImage imageNamed:@"like_btn.png"];
             cell.lbl_like.text = [TSLanguageManager localizedString:@"LBL_LIKE"];
             cell.lbl_like.textColor = [UIColor darkGrayColor];
         }
         else{
             cell.like_img.image=[UIImage imageNamed:@"red_like_btn.png"];
             cell.lbl_like.text = [TSLanguageManager localizedString:@"LBL_LIKED"];
             cell.lbl_like.textColor = [UIColor whiteColor];
         }
			
		cell.lbl_comment.text = [TSLanguageManager localizedString:@"LBL_COMMENT"];
        
        cell.like_img.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeCliked:)];
        [cell.like_img addGestureRecognizer:tap2];
         cell.like_img.tag = indexPath.row;
        [tap2 release];
    
        cell.userimg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap3 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToProfile:)];
        [cell.userimg addGestureRecognizer:tap3];
        cell.userimg.tag = indexPath.row;
            [tap3 release];
        
        cell.Usernamelbl.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap4 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UserGotoProile:)];
        [cell.Usernamelbl addGestureRecognizer:tap4];
        cell.Usernamelbl.tag = indexPath.row;
                   [tap4 release];
        
        cell.comment_img.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap5 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GotoCommnetlist:)];
        [cell.comment_img addGestureRecognizer:tap5];
          cell.comment_img.tag = indexPath.row;
        [tap5 release];
        
        cell.dot_img.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap6 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GotoCommnetlist:)];
        [cell.dot_img addGestureRecognizer:tap6];
        cell.dot_img.tag = indexPath.row;
        [tap6 release];
		
        cell.post_image.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_back_full_view =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImage:)];
        [cell.post_image addGestureRecognizer:tap_back_full_view];
         cell.post_image.tag = indexPath.row;
        [tap_back_full_view release];
 
         cell.videoIcon.userInteractionEnabled = YES;
         UITapGestureRecognizer *tappostdetail1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToPostDetail:)];
         [cell.videoIcon addGestureRecognizer:tappostdetail1];
         cell.videoIcon.tag = indexPath.row;
         [tappostdetail1 release];
    
        NSString *identifier = [NSString stringWithFormat:@"Cell%d" ,
                                        indexPath.row];
        if([self.cachedMainImages objectForKey:identifier] != nil){
            cell.post_image.image= [self.cachedMainImages valueForKey:identifier];
        }
        else{
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{

                url_img1 = [NSURL URLWithString:@"http://54.191.200.49/videoblog_web/uploads/member/.jpg"];
                if([self.userimgArray count] > 0){
                    url_img1 = [NSURL URLWithString:[self.userimgArray objectAtIndex: indexPath.row]];
                }
                
                data1 = [NSData dataWithContentsOfURL:url_img1];
                UIImage *img=nil;
                img =  [[UIImage alloc] initWithData:data1];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if ([tableView indexPathForCell:cell].row == indexPath.row) {
                        [self.cachedMainImages setValue:img forKey:identifier];
                        //[img release];
                        cell.post_image.image=[UIImage imageWithData:data1];
                        //[data1 release];
                    }
                });
            });
        }
	
        if([self.cachedUserImages objectForKey:identifier] != nil){
            cell.userimg.image= [self.cachedUserImages valueForKey:identifier];
        }
        else{
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                url_img = [NSURL URLWithString:@"http://54.191.200.49/videoblog_web/uploads/member/.jpg"];
                if([self.ProfileimgArray count] > 0){
                    url_img = [NSURL URLWithString:[self.ProfileimgArray objectAtIndex: indexPath.row]];
                }
                NSData *data = [NSData dataWithContentsOfURL:url_img];
                UIImage *img = nil;
                img = [[UIImage alloc] initWithData:data];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if ([tableView indexPathForCell:cell].row == indexPath.row) {
                        [self.cachedUserImages setValue:img forKey:identifier];
                       // [img release];
                        cell.userimg.image=[UIImage imageWithData:data];
                        //  [data release];
                    }
                });
            });
        }
	NSLog(@"%@",[self.eFileTypeArray objectAtIndex: indexPath.row]);
        if([[self.eFileTypeArray objectAtIndex: indexPath.row] isEqualToString:@"Video"])
        {
            cell.videoIcon.hidden = NO;
            cell.post_image.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap_back_full_view =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playvideo:)];
            [cell.post_image addGestureRecognizer:tap_back_full_view];
            [tap_back_full_view release];
        }
        else
        {
            cell.post_image.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap_back_full_view =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImage:)];
            [cell.post_image addGestureRecognizer:tap_back_full_view];
            cell.post_image.tag=indexPath.row;
            [tap_back_full_view release];
            cell.videoIcon.hidden = YES;
        }
        return cell;
}

#pragma mark - Textfield Delegate methods
- (BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
    [commnetTxtbox resignFirstResponder];
    CGRect destination = self.commnetTxtbox.frame;
    CGRect destination1 = self.sendbtn.frame;
    CGRect destination3 = self.post_box_container.frame;
    CGRect destination4 = self.Closecmtbtn.frame;
    
    destination.origin.y= 340;
    destination1.origin.y= 340;
    destination3.origin.y= 320;
    destination4.origin.y= 320;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.commnetTxtbox.frame =destination;
        self.sendbtn.frame =destination1;
        self.post_box_container.frame =destination3;
        self.Closecmtbtn.frame =destination4;
    }];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"testing");
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect destination = self.commnetTxtbox.frame;
    CGRect destination1 = self.sendbtn.frame;
    CGRect destination2 = self.post_box_container.frame;
    CGRect destination3 = self.Closecmtbtn.frame;
 
    destination.origin.y= 180;
    destination1.origin.y= 180;
    destination2.origin.y= 160;
    destination3.origin.y= 160;
    
    [UIView animateWithDuration:0.25 animations:^{
            self.commnetTxtbox.frame =destination;
            self.sendbtn.frame =destination1;
            self.post_box_container.frame =destination2;
            self.Closecmtbtn.frame =destination3;
    }];
}

#pragma mark - ScrollView Delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView_
{
    CGFloat actualPosition = scrollView_.contentOffset.y;
    CGFloat contentHeight = scrollView_.contentSize.height - (300);
    if (actualPosition >= contentHeight) {
        if(scrollconst==1){
            scrollconst=0;
            pageid=pageid+1;
            BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
            if (isConnectionAvail) {
                [self getPageData];
            }
            else{
                DisplayAlert(NoNetworkConnection);
            }
        }
    }
}

@end
