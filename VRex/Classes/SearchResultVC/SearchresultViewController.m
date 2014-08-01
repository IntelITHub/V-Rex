//
//  SearchresultViewController.m
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/18/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import "SearchresultViewController.h"
#import "SimpleTableCell.h"
#import "CaputreViewController.h"
#import "DetailfeedViewController.h"
#import "PostDetailViewController.h"
#import "NotificationViewController.h"
#import "UserprofileViewController.h"
#import "CommnetViewController.h"
#import "GlobalVar.h"
#import "AppDelegate.h"
#import "TSLanguageManager.h"
#import "constant.h"

@interface SearchresultViewController ()

@end

//initialise variables
static int deleteclick=0;
int CallLocalize = 0;
static int NowPostId=0;

@implementation SearchresultViewController
@synthesize tableData = tableData;
@synthesize locationManager,back_img,searchtxtfield,searchPlacehoder,viewname,Catid,catname;
@synthesize responseData,posttableview,table_like,table_commet,table_imagurl,post_id,member_id;
@synthesize table_username,serviceURL,searched_tableData,searchedtable_like,searchedtable_username,searchedtable_commet;
@synthesize searchedtable_imagurl,searched_post_id,searched_member_id,searchedtDescription,tDescription;
@synthesize searchedCells = searchedCells;
@synthesize strCurrentString;

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
	NSString *sel_language = [prefs stringForKey:@"sel_language"];

	if([sel_language isEqualToString:@"pt"]){
		[TSLanguageManager setSelectedLanguage:kLMPortu];
	}else{
		[TSLanguageManager setSelectedLanguage:kLMEnglish];
	}
    
    if (isiPad) {
        
    }
    else{
        if (isiPhone5) {
            if (iOS7) {
                [btnHome setFrame:CGRectMake(-1 ,522 ,70 ,50)];
                [btnSearch setFrame:CGRectMake(67 ,522 ,70 ,50)];
                [btnCamera setFrame:CGRectMake(133 ,522 ,69 ,50)];
                [btnCategoty setFrame:CGRectMake(194 ,522 ,69 ,50)];
                [btnProfile setFrame:CGRectMake(255 ,522 ,69 ,50)];
            }
            else{
                [btnHome setFrame:CGRectMake(-1 ,500 ,70 ,50)];
                [btnSearch setFrame:CGRectMake(67 ,500 ,70 ,50)];
                [btnCamera setFrame:CGRectMake(133 ,500 ,69 ,50)];
                [btnCategoty setFrame:CGRectMake(194 ,500 ,69 ,50)];
                [btnProfile setFrame:CGRectMake(255 ,500 ,69 ,50)];
            }
        }
        else{
            if (iOS7) {
                [posttableview setFrame:CGRectMake(0, 59, 320, 450)];
                [btnHome setFrame:CGRectMake(-1 ,436 ,70 ,50)];
                [btnSearch setFrame:CGRectMake(67 ,436 ,70 ,50)];
                [btnCamera setFrame:CGRectMake(133 ,436 ,69 ,50)];
                [btnCategoty setFrame:CGRectMake(194 ,436 ,69 ,50)];
                [btnProfile setFrame:CGRectMake(255 ,436 ,69 ,50)];
            }
            else{
                [btnHome setFrame:CGRectMake(-1 ,414 ,70 ,50)];
                [btnSearch setFrame:CGRectMake(67 ,414 ,70 ,50)];
                [btnCamera setFrame:CGRectMake(133 ,414 ,69 ,50)];
                [btnCategoty setFrame:CGRectMake(194 ,414 ,69 ,50)];
                [btnProfile setFrame:CGRectMake(255 ,414 ,69 ,50)];
            }
        }
    }
    
    GlobalVar *s_url=[GlobalVar getServiceUrl];
    serviceURL=s_url.servieurl;
	if (!isiPad) {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            viewname=@"CaputreViewController";
        }
        else
        {
            // iPhone 5 or maybe a larger iPhone ??
            viewname=@"CaputreViewControllerIphone5";
        }
	}
	else
    {
        viewname=@"CaptureViewControllerIpad";
    }
    
    //initialise array
    self.table_like = [[NSMutableArray alloc] init];
    self.table_commet = [[NSMutableArray alloc] init];
	self.tableData = [[NSMutableArray alloc] init];
	self.table_username = [[NSMutableArray alloc] init];
	self.table_commet = [[NSMutableArray alloc] init];
	self.table_imagurl = [[NSMutableArray alloc] init];
	self.post_id = [[NSMutableArray alloc] init];
    self.member_id = [[NSMutableArray alloc] init];
   
    self.searched_tableData =[[NSMutableArray alloc] init];
	self.searchedtable_like =[[NSMutableArray alloc] init];
	self.searchedtable_username =[[NSMutableArray alloc] init];
	self.searchedtable_commet =[[NSMutableArray alloc] init];
	self.searchedtable_imagurl =[[NSMutableArray alloc] init];
	self.searched_post_id =[[NSMutableArray alloc] init];
    self.searched_member_id =[[NSMutableArray alloc] init];
	self.searchedtDescription =[[NSMutableArray alloc] init];
	self.tDescription =[[NSMutableArray alloc] init];
    
    //initialise response data
    self.responseData = [NSMutableData data];
 
    //gesture methods for search result
    self.back_img.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_B1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gobackFromSerachResult:)];
	[self.back_img addGestureRecognizer:tap_B1];
	[tap_B1 release];
	
    //call websrvice
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        [self loadPosts];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
}
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    self.strCurrentString = @"";
    searchtxtfield.text = @"";
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *sel_language = [prefs stringForKey:@"sel_language"];
	if([sel_language isEqualToString:@"pt"]){
		[TSLanguageManager setSelectedLanguage:kLMPortu];
	}else{
		[TSLanguageManager setSelectedLanguage:kLMEnglish];
	}
	[self updateLabel];
    [posttableview reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Other methods
- (void)gobackFromSerachResult:(UITapGestureRecognizer *)recognizer  {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getNotitificationClicked:(UITapGestureRecognizer *)recognizer  {
    NSLog(@"Comment List details");
	NSLog(@"%ld", (long)recognizer.view.tag);
	
	CommnetViewController *commnetController = [[CommnetViewController alloc] initWithNibName:objAppDel.commentView bundle:nil];
    commnetController.post_id=[self.searched_post_id objectAtIndex:recognizer.view.tag];
	
	[self.navigationController pushViewController:commnetController animated:YES];
}
- (void)gotoDetail:(UITapGestureRecognizer *)recognizer  {
	PostDetailViewController *postDetaildController = [[PostDetailViewController alloc] initWithNibName:objAppDel.postDetailView bundle:nil];
	postDetaildController.posts_id=[self.searched_post_id objectAtIndex:recognizer.view.tag];
	[self.navigationController pushViewController:postDetaildController animated:YES];
}
-(void) updateLabel
{
	searchtxtfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[TSLanguageManager localizedString:@"LBL_SEARCH_TEXT_WITH_HASH"]];
	[self.uppdperbtn setTitle:[TSLanguageManager localizedString:@"LBL_LATEST"] forState:UIControlStateNormal];
	[self.downbtn setTitle:[TSLanguageManager localizedString:@"LBL_MY_LOCATION"] forState:UIControlStateNormal];
}
-(void)canNotdeletePost:(UITapGestureRecognizer *)recognizer  {
    if (recognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    deleteclick =0;
    
	UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:[TSLanguageManager localizedString:@"LBL_CONFIRM"]];
	[alert setMessage:[TSLanguageManager localizedString:@"MSG_CAN_NOT_DELETE_POST"]];
	[alert setDelegate:self];
	[alert addButtonWithTitle:[TSLanguageManager localizedString:@"Ok"]];
	[alert show];
	[alert release];
}
-(void)deletePost:(UITapGestureRecognizer *)recognizer  {
    if (recognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    NSString *iPostId= [NSString stringWithFormat:@"%@",[self.post_id objectAtIndex:[recognizer.view tag]]];
	NowPostId =[iPostId integerValue];
    deleteclick =1;
    
	UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:[TSLanguageManager localizedString:@"LBL_CONFIRM"]];
	[alert setMessage:[TSLanguageManager localizedString:@"MSG_SURE_TO_DELETE_POST"]];
	[alert setDelegate:self];
	[alert addButtonWithTitle:[TSLanguageManager localizedString:@"LBL_YES"]];
	[alert addButtonWithTitle:[TSLanguageManager localizedString:@"LBL_NO"]];
	[alert show];
	[alert release];
}
- (BOOL)prefersStatusBarHidden
{
	return YES;
}

#pragma mark - Action methods
- (IBAction)cancelSearchClicked:(id)sender {
    searchtxtfield.text = @"";
    self.strCurrentString = @"";
	[self filterContentForSearchText:searchtxtfield.text
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
	[searchtxtfield resignFirstResponder];
	self.cancelSearch.hidden = YES;
}
- (IBAction)homeBtnClicked:(id)sender {
    DetailfeedViewController *DetailController = [[DetailfeedViewController alloc] initWithNibName:objAppDel.detailfeedView bundle:nil]; [self.navigationController pushViewController:DetailController animated:YES];
}
- (IBAction)home_search_resultClicked:(id)sender {
    DetailfeedViewController *DetailController = [[DetailfeedViewController alloc] initWithNibName:objAppDel.detailfeedView bundle:nil]; [self.navigationController pushViewController:DetailController animated:YES];
}
- (IBAction)Capute_SearchbtnClicked:(id)sender {
    CaputreViewController *CaptureView = [[CaputreViewController alloc] initWithNibName:objAppDel.captureView bundle:nil]; [self.navigationController pushViewController:CaptureView animated:YES];
}
- (IBAction)notificaitonClicked:(id)sender {
    NotificationViewController *notiController = [[NotificationViewController alloc] initWithNibName:objAppDel.notificationView bundle:nil]; [self.navigationController pushViewController:notiController animated:YES];
}
- (IBAction)UserProfileClicked:(id)sender {
    UserprofileViewController *userprofileController = [[UserprofileViewController alloc] initWithNibName:objAppDel.userProfileView bundle:nil]; [self.navigationController pushViewController:userprofileController animated:YES];
}
- (IBAction)myLatestClicked:(id)sender {
//	self->searchResult.hidden = NO;
	CallLocalize = 0;
    
    //initialise array
	self.table_like = [[NSMutableArray alloc] init];
	self.table_commet = [[NSMutableArray alloc] init];
    self.tableData = [[NSMutableArray alloc] init];
	self.table_username = [[NSMutableArray alloc] init];
	self.table_commet = [[NSMutableArray alloc] init];
	self.table_imagurl = [[NSMutableArray alloc] init];
	self.post_id = [[NSMutableArray alloc] init];
    self.member_id = [[NSMutableArray alloc] init];
    
    self.searched_tableData =[[NSMutableArray alloc] init];
	self.searchedtable_like =[[NSMutableArray alloc] init];
	self.searchedtable_username =[[NSMutableArray alloc] init];
	self.searchedtable_commet =[[NSMutableArray alloc] init];
	self.searchedtable_imagurl =[[NSMutableArray alloc] init];
	self.searched_post_id =[[NSMutableArray alloc] init];
    self.searched_member_id =[[NSMutableArray alloc] init];
	self.searchedtDescription =[[NSMutableArray alloc] init];
	self.tDescription =[[NSMutableArray alloc] init];
    
    //initialise response data
	self.responseData = [NSMutableData data];
    self.locationTabView.hidden = YES;
    
    //call websrvice
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        [self loadPosts];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
}
- (IBAction)myLocationClicked:(id)sender {
//	self->searchResult.hidden = NO;
    //initialise CLLocation manager
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	locationManager.distanceFilter = kCLDistanceFilterNone;
	[locationManager startUpdatingLocation];
	
    //initialise CLLocation
	CLLocation *location = [locationManager location];
    
    //initialise CLLocationCoordinate2D
	CLLocationCoordinate2D coordinate = [location coordinate];
	
	NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
	NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
	
	self.currentLong=longitude;
	self.currentLat=latitude;
	CallLocalize = 1;
	
	self.table_like = [[NSMutableArray alloc] init];
	self.table_commet = [[NSMutableArray alloc] init];
	self.tableData = [[NSMutableArray alloc] init];
	self.table_username = [[NSMutableArray alloc] init];
	self.table_commet = [[NSMutableArray alloc] init];
	self.table_imagurl = [[NSMutableArray alloc] init];
	self.post_id = [[NSMutableArray alloc] init];
    self.member_id = [[NSMutableArray alloc] init];
    
    self.searched_tableData =[[NSMutableArray alloc] init];
	self.searchedtable_like =[[NSMutableArray alloc] init];
	self.searchedtable_username =[[NSMutableArray alloc] init];
	self.searchedtable_commet =[[NSMutableArray alloc] init];
	self.searchedtable_imagurl =[[NSMutableArray alloc] init];
	self.searched_post_id =[[NSMutableArray alloc] init];
    self.searched_member_id =[[NSMutableArray alloc] init];
	self.searchedtDescription =[[NSMutableArray alloc] init];
	self.tDescription =[[NSMutableArray alloc] init];
    
    //initialise response data
	self.responseData = [NSMutableData data];
	
    self.locationTabView.hidden = YES;

    //call webservice
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        [self loadPosts];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
}
- (IBAction)PlusBtnClicked:(id)sender {
	if(self.locationTabView.hidden){
		self.locationTabView.hidden = NO;
//		self->searchResult.hidden = YES;
	}else{
		self.locationTabView.hidden = YES;
//		self->searchResult.hidden = NO;
	}
}
- (IBAction)searchButtonclicked:(id)sender
{
    /*[self filterContentForSearchText:searchtxtfield.text
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
     */
}

#pragma mark - ColorWithHex method
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

#pragma mark - WebSrvice Call
-(void)loadPosts{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
	NSString *J_url=self.serviceURL;
	NSString *J_action=@"?action=getPosts&iCategoryId=";
	NSString*J_catid=Catid;
	NSString*J_memstr=@"&iMemberId=";
	NSString*J_memid=savedMemderid;
	
	NSArray *myStrings;
	if(CallLocalize == 0){
		myStrings = [[NSArray alloc] initWithObjects:J_url,J_action,J_catid,J_memstr,J_memid, nil];
	}else{
		NSString *J_lat=@"&vLattitude=";
		NSString*J_latval=self.currentLat;
		NSString *J_long=@"&vLongitude";
		NSString*J_longval=self.currentLong;
		myStrings = [[NSArray alloc] initWithObjects:J_url,J_action,J_catid,J_lat,J_latval,J_long,J_longval, nil];
	}
	
	NSString *joinedString = [myStrings componentsJoinedByString:@""];
	NSURL *myURL = [NSURL URLWithString:joinedString];
	NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
	[NSURLConnection connectionWithRequest:myRequest delegate:self];
	
    //alert
	self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[self.alert show];
    //activity indiacator
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.center = CGPointMake(150, 100);
	[indicator startAnimating];
	[self.alert addSubview:indicator];
}
-(void)deletePostFromServer{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
	
    //alert
	self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[self.alert show];
    //activity indicator
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.center = CGPointMake(150, 100);
	[indicator startAnimating];
	[self.alert addSubview:indicator];
	[indicator release];
	
	NSString *urlString = [NSString stringWithFormat:@"%@", serviceURL];
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	NSMutableData *body = [NSMutableData data];
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
    // Another text parameter
	NSString *param = @"deletePost";
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:param] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Another text parameter
	NSString *param1 = [NSString stringWithFormat:@"%d",NowPostId];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iPostId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:param1] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Another text parameter
	NSString *param2 = savedMemderid;
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iMemberId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:param2] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
    // close form
	[body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
    // set request body
	[request setHTTPBody:body];
	
	[NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* receivedData, NSError* error)
	 {
         NSString *returnString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
         [self.alert dismissWithClickedButtonIndex:0 animated:YES];
         NSError *e = nil;
         [self.alert dismissWithClickedButtonIndex:0 animated:YES];
         
         id object = [NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
         id responseMessage=[object valueForKey:@"message"];
         
         NSMutableString *success=[responseMessage valueForKey:@"success"];
         NSMutableString *message=[responseMessage valueForKey:@"msg"];
         if([success integerValue] == 1){
             UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_ALERT"] message:message delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
             [someError show];
             [someError release];
             BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
             if (isConnectionAvail) {
                 [self loadPosts];
             }
             else{
                 DisplayAlert(NoNetworkConnection);
             }
         }
         else{
             UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_ALERT"] message:message delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
             [someError show];
             [someError release];
         }
	 }];
}

#pragma mark - Tableview delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.strCurrentString.length > 0)///if ([searchtxtfield.text length] > 0)
    {
        return [searched_tableData count];
    }
    else
    {
        return [searched_tableData count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    SimpleTableCell *cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:objAppDel.simpleTableCellView owner:self options:nil];
        cell = (SimpleTableCell *)[nib objectAtIndex:0];
    }
    UIView* bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    bgview.opaque = YES;
    bgview.backgroundColor = [self colorWithHexString:@"E9E9E9"];
    if (self.strCurrentString.length > 0)///if ([searchtxtfield.text length] > 0)
    {
        cell.nameLabel.text = [searched_tableData objectAtIndex:indexPath.row];
    }
    else
    {
        cell.nameLabel.text = [searched_tableData objectAtIndex:indexPath.row];
    }
    cell.prepTimeLabel.text =[NSString stringWithFormat:@"@%@", [self.searchedtable_username objectAtIndex:indexPath.row]];
    cell.categor_yname.text=self.catname;
    NSString *nocount = [self.searchedtable_like objectAtIndex:indexPath.row];
    
    cell.likelbl.text = nocount;
    NSString *no_post = [self.searchedtable_commet objectAtIndex:indexPath.row];
    cell.commnetlbl.text = no_post;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSURL *url_img = [NSURL URLWithString:[self.searchedtable_imagurl objectAtIndex: indexPath.row]];
        NSData *data1 = [NSData dataWithContentsOfURL:url_img];
       
        dispatch_sync(dispatch_get_main_queue(), ^{
			  cell.thumbnailImageView.image=[UIImage imageWithData:data1];
        });
    });

    [tableView setSeparatorColor:[UIColor clearColor]];
    if (indexPath.row % 2) {
        
    }
    else{
        [cell setBackgroundView:bgview];
    }
   
	cell.listClickView.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_B1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoDetail:)];
	cell.listClickView.tag =indexPath.row;
	[cell.listClickView addGestureRecognizer:tap_B1];
	[tap_B1 release];
 
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
	NSString *postmemId =[self.member_id objectAtIndex:indexPath.row];
    if([postmemId isEqualToString:savedMemderid]){
		UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(deletePost:)];
        lpgr.minimumPressDuration = .5; //seconds
        lpgr.delegate = self;
        [cell.listClickView addGestureRecognizer:lpgr];
	}
    else{
		UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(canNotdeletePost:)];
        lpgr.minimumPressDuration = .5; //seconds
        lpgr.delegate = self;
        [cell.listClickView addGestureRecognizer:lpgr];
	}
	cell.commentListClick.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_B2 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getNotitificationClicked:)];
	cell.commentListClick.tag =indexPath.row;
	[cell.commentListClick addGestureRecognizer:tap_B2];
	[tap_B2 release];
	
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (!isiPad) {
		
		CGSize result = [[UIScreen mainScreen] bounds].size;
		if(result.height == 480)
        {
            return 100;
        }
		else
        {
			return 105;
        }
	}
	else
    {
		return 203;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostDetailViewController *postDetaildController = [[PostDetailViewController alloc] initWithNibName:objAppDel.postDetailView bundle:nil];
	postDetaildController.posts_id=[self.searched_post_id objectAtIndex:[indexPath row]];
	postDetaildController.cat_name=self.catname;
}
-(BOOL)isRowSearchedOnTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
	return ([searchedCells containsObject:indexPath]) ? YES : NO;
}

#pragma mark - Search Delegate methods
#pragma FilterContentFor Search
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	[self.searched_tableData removeAllObjects];
	[self.searchedtable_like removeAllObjects];
	[self.searchedtable_username removeAllObjects];
	[self.searchedtable_commet removeAllObjects];
	[self.searchedtable_imagurl removeAllObjects];
	[self.searched_post_id removeAllObjects];
    [self.searched_member_id removeAllObjects];
	[self.searchedtDescription removeAllObjects];
	
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    NSLog(@"%@",[NSMutableArray arrayWithArray: [self.searched_tableData filteredArrayUsingPredicate:resultPredicate]]) ;
   
	NSString *originalSearched =searchText;
	if([originalSearched isEqualToString:@""]){
		for(NSUInteger s = 0; s < [tableData count]; ++s){
			NSIndexPath *idxPath = [NSIndexPath indexPathForRow:s inSection:0];
			[self.searchedtable_username addObject:[table_username objectAtIndex:idxPath.row]];
			[self.searched_tableData addObject:[tableData objectAtIndex:idxPath.row]];
			[self.searchedtable_like addObject:[table_like objectAtIndex:idxPath.row]];
			[self.searchedtable_commet addObject:[table_commet objectAtIndex:idxPath.row]];
			[self.searchedtable_imagurl addObject:[table_imagurl objectAtIndex:idxPath.row]];
			[self.searched_post_id addObject:[post_id objectAtIndex:idxPath.row]];
            [self.searched_member_id addObject:[member_id objectAtIndex:idxPath.row]];
			[self.searchedtDescription addObject:[tDescription objectAtIndex:idxPath.row]];
		}
	}
    else{
		NSString *newStr = [originalSearched substringWithRange:NSMakeRange(0, 1)];
		for(NSUInteger s = 0; s < [tableData count]; ++s){
			NSIndexPath *idxPath = [NSIndexPath indexPathForRow:s inSection:0];
			if ([newStr isEqualToString:@"@"]) {
				searchText = [originalSearched substringFromIndex:1];
				if([searchText isEqualToString:@""]){
					for(NSUInteger s = 0; s < [tableData count]; ++s){
                        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:s inSection:0];
                        [self.searchedtable_username addObject:[table_username objectAtIndex:idxPath.row]];
                        [self.searched_tableData addObject:[tableData objectAtIndex:idxPath.row]];
                        [self.searchedtable_like addObject:[table_like objectAtIndex:idxPath.row]];
                        [self.searchedtable_commet addObject:[table_commet objectAtIndex:idxPath.row]];
                        [self.searchedtable_imagurl addObject:[table_imagurl objectAtIndex:idxPath.row]];
                        [self.searched_post_id addObject:[post_id objectAtIndex:idxPath.row]];
                        [self.searched_member_id addObject:[member_id objectAtIndex:idxPath.row]];
                        [self.searchedtDescription addObject:[tDescription objectAtIndex:idxPath.row]];
                    }
				}
                else{
					if([self.table_username objectAtIndex:idxPath.row] != (id)[NSNull null]){
						NSRange range = [[self.table_username objectAtIndex:idxPath.row] rangeOfString:searchText options:NSCaseInsensitiveSearch];
						if (range.length > 0) { //if the substring match
							[self.searchedtable_username addObject:[table_username objectAtIndex:idxPath.row]];
							[self.searched_tableData addObject:[tableData objectAtIndex:idxPath.row]];
							[self.searchedtable_like addObject:[table_like objectAtIndex:idxPath.row]];
							[self.searchedtable_commet addObject:[table_commet objectAtIndex:idxPath.row]];
							[self.searchedtable_imagurl addObject:[table_imagurl objectAtIndex:idxPath.row]];
							[self.searched_post_id addObject:[post_id objectAtIndex:idxPath.row]];
                            [self.searched_member_id addObject:[member_id objectAtIndex:idxPath.row]];
							[self.searchedtDescription addObject:[tDescription objectAtIndex:idxPath.row]];
						}
					}
				}
			}
            else if([newStr isEqualToString:@"#"]){
				searchText = [originalSearched substringFromIndex:1];
				if([searchText isEqualToString:@""]){
					for(NSUInteger s = 0; s < [tableData count]; ++s){
                        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:s inSection:0];
                        [self.searchedtable_username addObject:[table_username objectAtIndex:idxPath.row]];
                        [self.searched_tableData addObject:[tableData objectAtIndex:idxPath.row]];
                        [self.searchedtable_like addObject:[table_like objectAtIndex:idxPath.row]];
                        [self.searchedtable_commet addObject:[table_commet objectAtIndex:idxPath.row]];
                        [self.searchedtable_imagurl addObject:[table_imagurl objectAtIndex:idxPath.row]];
                        [self.searched_post_id addObject:[post_id objectAtIndex:idxPath.row]];
                        [self.searched_member_id addObject:[member_id objectAtIndex:idxPath.row]];
                        [self.searchedtDescription addObject:[tDescription objectAtIndex:idxPath.row]];
                    }
				}
                else{
					if([self.table_username objectAtIndex:idxPath.row] != (id)[NSNull null]){
						NSRange range = [[self.tDescription objectAtIndex:idxPath.row] rangeOfString:searchText options:NSCaseInsensitiveSearch];
						if (range.length > 0) { //if the substring match
							[self.searchedtable_username addObject:[table_username objectAtIndex:idxPath.row]];
							[self.searched_tableData addObject:[tableData objectAtIndex:idxPath.row]];
							[self.searchedtable_like addObject:[table_like objectAtIndex:idxPath.row]];
							[self.searchedtable_commet addObject:[table_commet objectAtIndex:idxPath.row]];
							[self.searchedtable_imagurl addObject:[table_imagurl objectAtIndex:idxPath.row]];
							[self.searched_post_id addObject:[post_id objectAtIndex:idxPath.row]];
                            [self.searched_member_id addObject:[member_id objectAtIndex:idxPath.row]];
							[self.searchedtDescription addObject:[tDescription objectAtIndex:idxPath.row]];
						}
					}
				}
			}
            else{
				NSRange range = [[tableData objectAtIndex:idxPath.row] rangeOfString:originalSearched options:NSCaseInsensitiveSearch];
				if (range.length > 0) { //if the substring match
					[self.searchedtable_username addObject:[table_username objectAtIndex:idxPath.row]];
					[self.searched_tableData addObject:[tableData objectAtIndex:idxPath.row]];
					[self.searchedtable_like addObject:[table_like objectAtIndex:idxPath.row]];
					[self.searchedtable_commet addObject:[table_commet objectAtIndex:idxPath.row]];
					[self.searchedtable_imagurl addObject:[table_imagurl objectAtIndex:idxPath.row]];
					[self.searched_post_id addObject:[post_id objectAtIndex:idxPath.row]];
                    [self.searched_member_id addObject:[member_id objectAtIndex:idxPath.row]];
					[self.searchedtDescription addObject:[tDescription objectAtIndex:idxPath.row]];
				}
			}
		}
	}
	[self.posttableview reloadData];
}
#pragma searchDisplayController
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

#pragma mark - TextField Delegate methods
- (BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
//    self.strCurrentString = @"";
	[searchtxtfield resignFirstResponder];
	return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [searchtxtfield resignFirstResponder];
/*	[self filterContentForSearchText:searchtxtfield.text
										scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
												 objectAtIndex:[self.searchDisplayController.searchBar
																	 selectedScopeButtonIndex]]];*/
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    if (range.location == 0 && range.length == 1){
        searchtxtfield.text = @"";
        self.strCurrentString = @"";
        self.cancelSearch.hidden = YES;
        [posttableview reloadData];
    }
    else{
        if (string) {

            NSString *strTextField;
            
            NSLog(@"%d %d",range.length,range.location);
            if (range.length == 0)
            {
                strTextField = [NSString stringWithFormat:@"%@",string];
            }
            else
            {
                int index = [self.strCurrentString length]-1;
                strTextField = [self.strCurrentString substringToIndex:index];
                self.strCurrentString = @"";
            }
            
            self.strCurrentString = [self.strCurrentString stringByAppendingFormat:@"%@",strTextField];
            
            [self filterContentForSearchText:self.strCurrentString/*searchtxtfield.text*/
                                       scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                              objectAtIndex:[self.searchDisplayController.searchBar
                                                             selectedScopeButtonIndex]]];

        }
        [posttableview reloadData];
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    searchPlacehoder.hidden = YES;
   self.cancelSearch.hidden = NO;
}

#pragma mark - Response Delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [self.responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
     [self.alert dismissWithClickedButtonIndex:0 animated:YES];
     NSLog(@"Connection failed! Error - %@ %@",
          
          [error localizedDescription],
          
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
     [self.alert dismissWithClickedButtonIndex:0 animated:YES];
     NSError *e = nil;
    
     NSString *json = [[NSString alloc] initWithData:self.responseData  encoding:NSUTF8StringEncoding];
    
     id responseobject = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
     id object=[responseobject valueForKey:@"data"];
     id responseMessage=[responseobject valueForKey:@"message"];
     NSString *succ =[responseMessage valueForKey:@"success"];
     NSString *msg =[responseMessage valueForKey:@"msg"];
     if([succ integerValue] == 1){
        int i = 0;
        for (NSDictionary *dic in object){
            NSString *iMemberId=[NSString stringWithFormat:@"%@", [dic valueForKey:@"iMemberId"]];
            NSString *postId=[NSString stringWithFormat:@"%@", [dic valueForKey:@"iPostId"]];
            NSString *imageurl=[NSString stringWithFormat:@"%@", [dic valueForKey:@"vVideothumbnail"]];
            NSString *post_ttl=[NSString stringWithFormat:@"%@", [dic valueForKey:@"tPost"]];
            NSString *tab_username=[NSString stringWithFormat:@"%@", [dic valueForKey:@"vUsername"]];
            NSString *tlikes=[NSString stringWithFormat:@"%@", [dic valueForKey:@"totalPostLikes"]];
            NSString *tcommentds=[NSString stringWithFormat:@"%@", [dic valueForKey:@"totalPostComments"]];
            NSString *stDescription=[NSString stringWithFormat:@"%@", [dic valueForKey:@"tDescription"]];
            
            [self.table_username insertObject:tab_username atIndex:i];
            [self.tableData insertObject:post_ttl atIndex:i];
            [self.table_like insertObject:tlikes atIndex:i];
            [self.table_imagurl insertObject:imageurl atIndex:i];
            [self.post_id insertObject:postId atIndex:i];
            [self.member_id insertObject:iMemberId atIndex:i];
            [self.table_commet insertObject:tcommentds atIndex:i];
            [self.tDescription insertObject:stDescription atIndex:i];
            
            [self.searchedtable_username insertObject:tab_username atIndex:i];
            [self.searched_tableData insertObject:post_ttl atIndex:i];
            [self.searchedtable_like insertObject:tlikes atIndex:i];
            [self.searchedtable_imagurl insertObject:imageurl atIndex:i];
            [self.searched_post_id insertObject:postId atIndex:i];
            [self.searched_member_id insertObject:iMemberId atIndex:i];
            [self.searchedtable_commet insertObject:tcommentds atIndex:i];
            [self.searchedtDescription insertObject:stDescription atIndex:i];
            i++;
        }
        [self.posttableview reloadData];
    }
     else{
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:msg delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [someError show];
        [someError release];
        [self.posttableview reloadData];
    }
}

#pragma mark - AlertView Delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(deleteclick == 1){
		if (buttonIndex == 0){
			deleteclick =0;
            BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
            if (isConnectionAvail) {
                [self deletePostFromServer];
            }
            else{
                DisplayAlert(NoNetworkConnection);
            }
		}else if (buttonIndex == 1){
			deleteclick =0;
		}
	}
}

@end
