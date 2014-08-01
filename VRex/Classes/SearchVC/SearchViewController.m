//
//  SearchViewController.m
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/17/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import "SearchViewController.h"
#import "DetailfeedViewController.h"
#import "SearchresultViewController.h"
#import "CaputreViewController.h"
#import "NotificationViewController.h"
#import "UserprofileViewController.h"
#import "AsyncImageView.h"
#import "GlobalVar.h"
#import "AppDelegate.h"
#import "TSLanguageManager.h"
#import "constant.h"
#import "SimpleTableCell.h"
#import "PostDetailViewController.h"
#import "CommnetViewController.h"

#define webUrlSubCategory @"http://54.191.200.49/videoblog_web/service?action=getAllPost"
@interface SearchViewController ()
@end

static int deleteclickSearch=0;
int CallLocalizeSearch = 0;
static int NowPostIdSearch=0;

static long totalcategory = 0;
static long currentlyDisplayingcategory = 1;

@implementation SearchViewController
@synthesize searchtxtfield,searchPlacehoder,categoryname,categoryIcon,viewname,userprofileview,responseData,CategoryImgurlArray;
@synthesize CategoryNameArray,tableView1,CatagoryIdArray,backImg,alert,serviceURL;
@synthesize strCurrentString,Catid;
@synthesize currentLat,currentLong;

int customTableCellHeight;
int celltextsize;

#pragma mark - viewcontroller methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GlobalVar *s_url=[GlobalVar getServiceUrl];
    serviceURL=s_url.servieurl;
    strKey = @"";
    
    //initialise array for category
    table_like = [[NSMutableArray alloc] init];
    table_commet = [[NSMutableArray alloc] init];
	tableData = [[NSMutableArray alloc] init];
	table_username = [[NSMutableArray alloc] init];
	table_commet = [[NSMutableArray alloc] init];
	table_imagurl = [[NSMutableArray alloc] init];
	post_id = [[NSMutableArray alloc] init];
    member_id = [[NSMutableArray alloc] init];
    
    searched_tableData =[[NSMutableArray alloc] init];
	searchedtable_like =[[NSMutableArray alloc] init];
	searchedtable_username =[[NSMutableArray alloc] init];
	searchedtable_commet =[[NSMutableArray alloc] init];
	searchedtable_imagurl =[[NSMutableArray alloc] init];
	searched_post_id =[[NSMutableArray alloc] init];
    searched_member_id =[[NSMutableArray alloc] init];
	searchedtDescription =[[NSMutableArray alloc] init];
	tDescription =[[NSMutableArray alloc] init];
    
    //intialise array for subcategory
    self.searched_categoryIcon = [[NSMutableArray alloc] init];
    self.searched_categoryname = [[NSMutableArray alloc] init];
	self.searched_CatagoryIdArray = [[NSMutableArray alloc] init];
	
	self.categoryname = [[NSMutableArray alloc] init];
    self.categoryIcon = [[NSMutableArray alloc] init];
	self.CatagoryIdArray = [[NSMutableArray alloc] init];
    
    if (isiPad) {
        
    }
    else{
        if (isiPhone5) {
            if (iOS7) {
                [btnHome setFrame:CGRectMake(-1 ,519 ,70 ,50)];//522
                [btnSearch setFrame:CGRectMake(67 ,519 ,70 ,50)];
                [btnCamera setFrame:CGRectMake(133 ,519 ,69 ,50)];
                [btnCategory setFrame:CGRectMake(194 ,519 ,69 ,50)];
                [btnProfile setFrame:CGRectMake(255 ,519 ,69 ,50)];
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
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
	
    if (!isiPad) {
        customTableCellHeight=40;
        celltextsize=16;
        if(result.height == 480)
        {
            // iPhone Classic
            viewname=@"CaputreViewController";
            userprofileview=@"UserprofileViewController";
        }
        else
        {
            // iPhone 5 or maybe a larger iPhone ??
            viewname=@"CaputreViewControllerIphone5";
            userprofileview=@"UserprofileViewControllerIphone5";
        }
    }
    else{
        customTableCellHeight=80;
        celltextsize=23;
        viewname=@"CaptureViewControllerIpad";
        userprofileview=@"UserprofileViewControllerIpad";
    }
    self.responseData = [NSMutableData data];
    
    //go back to search
    self.backImg.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_Bimg =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gobackF_Search:)];
	[self.backImg addGestureRecognizer:tap_Bimg];
	[tap_Bimg release];

    //call webservice-------------------------------------------
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
        
        NSString *J_url=self.serviceURL;
        NSString*J_catid=@"/service?action=getCategories&iMemberId=";
        NSString*J_memid=savedMemderid;
        
        NSArray *myStrings = [[NSArray alloc] initWithObjects:J_url, J_catid,J_memid, nil];
        NSString *joinedString = [myStrings componentsJoinedByString:@""];
        
        NSURL *myURL = [NSURL URLWithString:joinedString];
        
        
        NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
        [NSURLConnection connectionWithRequest:myRequest delegate:self];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }//---------------------------------------------------------

    //alert
    self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
    [self.alert show];
    //activity indicator
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = CGPointMake(150, 100);
    [indicator startAnimating];
    [self.alert addSubview:indicator];
}
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    self.strCurrentString = @"";
    searchtxtfield.text = @"";
    intSearchBar = 0;
    
	self.cachedCatImages = [[NSMutableDictionary alloc] init];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *sel_language = [prefs stringForKey:@"sel_language"];
    
	if([sel_language isEqualToString:@"pt"]){
		[TSLanguageManager setSelectedLanguage:kLMPortu];
	}else{
		[TSLanguageManager setSelectedLanguage:kLMEnglish];
	}
    
    //call update label method
	[self updateLabel];
    [tableView1 reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)viewDidAppear:(BOOL)animated
{
    currentlyDisplayingcategory=0;
}

#pragma mark - Webservice method
-(void)SubCategoryWS
{
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        strKey = @"subcategory";
        self.responseData = [NSMutableData data];
        
        NSString* webStringURL = [webUrlSubCategory stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* url = [NSURL URLWithString:webStringURL];
        
        NSURLRequest *myRequest = [NSURLRequest requestWithURL:url];
        
        [NSURLConnection connectionWithRequest:myRequest delegate:self];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
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
	NSString *param1 = [NSString stringWithFormat:@"%d",NowPostIdSearch];
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
-(void)loadPosts{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
	NSString *J_url=self.serviceURL;
	NSString *J_action=@"?action=getPosts&iCategoryId=";
	NSString*J_catid=Catid;
	NSString*J_memstr=@"&iMemberId=";
	NSString*J_memid=savedMemderid;
	
	NSArray *myStrings;
	if(CallLocalizeSearch == 0){
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

#pragma mark - Other methods
- (void)gobackF_Search:(UITapGestureRecognizer *)recognizer  {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadForIphone{
    searchPlacehoder = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0,searchtxtfield.frame.size.width - 10.0, 40.0)];
    [searchPlacehoder setText:@"Search usernames or hastags...."];
    [searchPlacehoder setBackgroundColor:[UIColor clearColor]];
    [searchPlacehoder setTextColor:[UIColor lightGrayColor]];
    searchtxtfield.delegate = self;
    [searchtxtfield setTextColor:[UIColor lightGrayColor]];
    [searchtxtfield addSubview:searchPlacehoder];
}
-(void)loadForIpad{
    searchPlacehoder = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0,searchtxtfield.frame.size.width - 20.0, 60.0)];
    [searchPlacehoder setText:@"Search usernames or hastags...."];
    [searchPlacehoder setBackgroundColor:[UIColor clearColor]];
    [searchPlacehoder setTextColor:[UIColor lightGrayColor]];
    [searchPlacehoder setFont:[UIFont systemFontOfSize:22]];
    searchtxtfield.delegate = self;
    [searchtxtfield setTextColor:[UIColor lightGrayColor]];
    [searchtxtfield setFont:[UIFont systemFontOfSize:22]];
    [searchtxtfield addSubview:searchPlacehoder];
}
-(void) updateLabel
{
	self.lbl_category.text = [TSLanguageManager localizedString:@"LBL_CATEGORY"];
	searchtxtfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[TSLanguageManager localizedString:@"LBL_SEARCH_TEXT_WITH_HASH"]];
}
- (BOOL)prefersStatusBarHidden
{
	return YES;
}

#pragma mark - Action methods
- (IBAction)cancelSearchClicked:(id)sender {
    searchtxtfield.text = @"";
    self.strCurrentString = @"";
    self.cancelSearch.hidden = YES;
    intSearchBar = 0;
    [tableView1 reloadData];
	NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchtxtfield.text];
	
	self.filteredPersons = [categoryname filteredArrayUsingPredicate:resultPredicate];
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
- (IBAction)CapturebtnClicked:(id)sender {
    NSLog(@"vname");
    CaputreViewController *DetailController = [[CaputreViewController alloc] initWithNibName:objAppDel.captureView bundle:nil]; [self.navigationController pushViewController:DetailController animated:YES];
}
- (IBAction)notificationbtnClicked:(id)sender {
    NotificationViewController *notiController = [[NotificationViewController alloc] initWithNibName:objAppDel.notificationView bundle:nil]; [self.navigationController pushViewController:notiController animated:YES];
}
- (IBAction)userprofilebtnClicked:(id)sender {
    UserprofileViewController *UProfileController = [[UserprofileViewController alloc] initWithNibName:objAppDel.userProfileView bundle:nil]; [self.navigationController pushViewController:UProfileController animated:YES];
}
- (IBAction)searchButtonclicked:(id)sender
{
   /* NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchtxtfield.text];
	self.filteredPersons = [categoryname filteredArrayUsingPredicate:resultPredicate];
	[self filterContentForSearchText:searchtxtfield.text
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];*/
}

#pragma mark - Filter content for search text
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	[self.searched_categoryIcon removeAllObjects];
	[self.searched_categoryname removeAllObjects];
	[self.searched_CatagoryIdArray removeAllObjects];
    
    [searched_tableData removeAllObjects];
	[searchedtable_like removeAllObjects];
	[searchedtable_username removeAllObjects];
	[searchedtable_commet removeAllObjects];
	[searchedtable_imagurl removeAllObjects];
	[searched_post_id removeAllObjects];
    [searched_member_id removeAllObjects];
	[searchedtDescription removeAllObjects];
	
   
   //----------------------------------------------------------------
    NSString *newStr = nil;
	NSString *originalSearched =searchText;
    if (originalSearched.length > 0) {
        newStr = [originalSearched substringWithRange:NSMakeRange(0, 1)];
    }
    
    //Search for categories Filter,Travel etc.
	if([originalSearched isEqualToString:@""]){
        intSearchBar = 0;
        NSPredicate *resultPredicate = [NSPredicate
                                        predicateWithFormat:@"SELF contains[cd] %@",
                                        searchText];
        NSLog(@"%@",[NSMutableArray arrayWithArray: [self.categoryname filteredArrayUsingPredicate:resultPredicate]]) ;
        
		for(NSUInteger s = 0; s < [self.CatagoryIdArray count]; ++s){
			NSIndexPath *idxPath = [NSIndexPath indexPathForRow:s inSection:0];
			[self.searched_categoryIcon addObject:[self.categoryIcon objectAtIndex:idxPath.row]];
			[self.searched_categoryname addObject:[self.categoryname objectAtIndex:idxPath.row]];
			[self.searched_CatagoryIdArray addObject:[self.CatagoryIdArray objectAtIndex:idxPath.row]];
		}
	}
    else if ([newStr isEqualToString:@"@"] || [newStr isEqualToString:@"#"]){
        intSearchBar = 1;
      
//		NSString *newStr = [originalSearched substringWithRange:NSMakeRange(0, 1)];
		for(NSUInteger s = 0; s < [tableData count]; ++s){
			NSIndexPath *idxPath = [NSIndexPath indexPathForRow:s inSection:0];
            
			if ([newStr isEqualToString:@"@"]) {
				searchText = [originalSearched substringFromIndex:1];
				if([searchText isEqualToString:@""]){
					for(NSUInteger s = 0; s < [tableData count]; ++s){
                        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:s inSection:0];
                        [searchedtable_username addObject:[table_username objectAtIndex:idxPath.row]];
                        [searched_tableData addObject:[tableData objectAtIndex:idxPath.row]];
                        [searchedtable_like addObject:[table_like objectAtIndex:idxPath.row]];
                        [searchedtable_commet addObject:[table_commet objectAtIndex:idxPath.row]];
                        [searchedtable_imagurl addObject:[table_imagurl objectAtIndex:idxPath.row]];
                        [searched_post_id addObject:[post_id objectAtIndex:idxPath.row]];
                        [searched_member_id addObject:[member_id objectAtIndex:idxPath.row]];
                        [searchedtDescription addObject:[tDescription objectAtIndex:idxPath.row]];
                    }
				}
                else{
					if([table_username objectAtIndex:idxPath.row] != (id)[NSNull null]){

                    
						NSRange range = [[table_username objectAtIndex:idxPath.row] rangeOfString:searchText options:NSCaseInsensitiveSearch];
						if (range.length > 0) { //if the substring match
							[searchedtable_username addObject:[table_username objectAtIndex:idxPath.row]];
							[searched_tableData addObject:[tableData objectAtIndex:idxPath.row]];
							[searchedtable_like addObject:[table_like objectAtIndex:idxPath.row]];
							[searchedtable_commet addObject:[table_commet objectAtIndex:idxPath.row]];
							[searchedtable_imagurl addObject:[table_imagurl objectAtIndex:idxPath.row]];
							[searched_post_id addObject:[post_id objectAtIndex:idxPath.row]];
                            [searched_member_id addObject:[member_id objectAtIndex:idxPath.row]];
							[searchedtDescription addObject:[tDescription objectAtIndex:idxPath.row]];
						}
					}
				}
			}
            else if([newStr isEqualToString:@"#"]){
				searchText = [originalSearched substringFromIndex:1];
				if([searchText isEqualToString:@""]){
					for(NSUInteger s = 0; s < [tableData count]; ++s){
                        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:s inSection:0];
                        [searchedtable_username addObject:[table_username objectAtIndex:idxPath.row]];
                        [searched_tableData addObject:[tableData objectAtIndex:idxPath.row]];
                        [searchedtable_like addObject:[table_like objectAtIndex:idxPath.row]];
                        [searchedtable_commet addObject:[table_commet objectAtIndex:idxPath.row]];
                        [searchedtable_imagurl addObject:[table_imagurl objectAtIndex:idxPath.row]];
                        [searched_post_id addObject:[post_id objectAtIndex:idxPath.row]];
                        [searched_member_id addObject:[member_id objectAtIndex:idxPath.row]];
                        [searchedtDescription addObject:[tDescription objectAtIndex:idxPath.row]];
                    }
				}
                else{
					if([table_username objectAtIndex:idxPath.row] != (id)[NSNull null]){
						NSRange range = [[tDescription objectAtIndex:idxPath.row] rangeOfString:searchText options:NSCaseInsensitiveSearch];
						if (range.length > 0) { //if the substring match
							[searchedtable_username addObject:[table_username objectAtIndex:idxPath.row]];
							[searched_tableData addObject:[tableData objectAtIndex:idxPath.row]];
							[searchedtable_like addObject:[table_like objectAtIndex:idxPath.row]];
							[searchedtable_commet addObject:[table_commet objectAtIndex:idxPath.row]];
							[searchedtable_imagurl addObject:[table_imagurl objectAtIndex:idxPath.row]];
							[searched_post_id addObject:[post_id objectAtIndex:idxPath.row]];
                            [searched_member_id addObject:[member_id objectAtIndex:idxPath.row]];
							[searchedtDescription addObject:[tDescription objectAtIndex:idxPath.row]];
						}
					}
				}
			}
            else{
				NSRange range = [[tableData objectAtIndex:idxPath.row] rangeOfString:originalSearched options:NSCaseInsensitiveSearch];
				if (range.length > 0) { //if the substring match
					[searchedtable_username addObject:[table_username objectAtIndex:idxPath.row]];
					[searched_tableData addObject:[tableData objectAtIndex:idxPath.row]];
					[searchedtable_like addObject:[table_like objectAtIndex:idxPath.row]];
					[searchedtable_commet addObject:[table_commet objectAtIndex:idxPath.row]];
					[searchedtable_imagurl addObject:[table_imagurl objectAtIndex:idxPath.row]];
					[searched_post_id addObject:[post_id objectAtIndex:idxPath.row]];
                    [searched_member_id addObject:[member_id objectAtIndex:idxPath.row]];
					[searchedtDescription addObject:[tDescription objectAtIndex:idxPath.row]];
				}
			}
		}
	}
    else{
            //		NSString *newStr = [originalSearched substringWithRange:NSMakeRange(0, 1)];
            for(NSUInteger s = 0; s < [self.CatagoryIdArray count]; ++s){
                NSIndexPath *idxPath = [NSIndexPath indexPathForRow:s inSection:0];
                if([self.categoryname objectAtIndex:idxPath.row] != (id)[NSNull null]){
                    NSRange range = [[self.categoryname objectAtIndex:idxPath.row] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (range.length > 0) { //if the substring match
                        [self.searched_categoryIcon addObject:[self.categoryIcon objectAtIndex:idxPath.row]];
                        [self.searched_categoryname addObject:[self.categoryname objectAtIndex:idxPath.row]];
                        [self.searched_CatagoryIdArray addObject:[self.CatagoryIdArray objectAtIndex:idxPath.row]];
                    }
                }
            }
    }
	[self.tableView1 reloadData];
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

	/*NSPredicate *resultPredicate = [NSPredicate
											  predicateWithFormat:@"SELF contains[cd] %@",
											  searchtxtfield.text];
	self.filteredPersons = [categoryname filteredArrayUsingPredicate:resultPredicate];
	[self filterContentForSearchText:searchtxtfield.text
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
         intSearchBar = 0;
         [tableView1 reloadData];
     }
     else{
         if (string) {
             
             NSPredicate *resultPredicate = [NSPredicate
                                             predicateWithFormat:@"SELF contains[cd] %@",
                                             searchtxtfield.text];
             self.filteredPersons = [categoryname filteredArrayUsingPredicate:resultPredicate];
             
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
             //
             [self filterContentForSearchText:self.strCurrentString/*string*/
                                        scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                               objectAtIndex:[self.searchDisplayController.searchBar
                                                              selectedScopeButtonIndex]]];
         }
         [tableView1 reloadData];
     }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    searchPlacehoder.hidden = YES;
    self.cancelSearch.hidden = NO;
}

#pragma mark - Tableview Delegate methods
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int aIntRowCount = 0;
    if (intSearchBar == 0) {//searches categories like travel,famous,entertainment etc
        if (self.strCurrentString.length > 0)//if ([searchtxtfield.text length] > 0)
        {
            aIntRowCount = [self.searched_categoryname count];
        }
        else {
            aIntRowCount = [self.categoryname count];;
        }
    }
    else{//searches for subCategories
        if (self.strCurrentString.length > 0)///if ([searchtxtfield.text length] > 0)
        {
            return [searched_tableData count];
        }
        else{
            return [searched_tableData count];
        }
    }
    return aIntRowCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (intSearchBar == 0){//load category cells
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell =[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1
                                         reuseIdentifier:simpleTableIdentifier]autorelease];
        }
        //    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        //    NSString *trimmed = [searchtxtfield.text stringByTrimmingCharactersInSet:whitespace];
        if (self.strCurrentString.length > 0) //if ([trimmed length] > 0)
        {
            cell.textLabel.text = [self.searched_categoryname objectAtIndex:indexPath.row];
            cell.textLabel.textColor=[UIColor grayColor];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            
            if (indexPath.row % 2) {
                
                UIView* bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
                bgview.opaque = YES;
                bgview.backgroundColor = [self colorWithHexString:@"E9E9E9"];
                cell.textLabel.backgroundColor = [self colorWithHexString:@"E9E9E9"];
                cell.contentView.backgroundColor = [self colorWithHexString:@"E9E9E9"];
                [cell.textLabel setFont:[UIFont systemFontOfSize:celltextsize]];
                [cell setBackgroundView:bgview];
            } else {
                [cell.textLabel setFont:[UIFont systemFontOfSize:celltextsize]];
            }
            
            NSString *identifier = [NSString stringWithFormat:@"Cell%@" ,
                                    [self.categoryIcon objectAtIndex: indexPath.row]];
            
            if([self.cachedCatImages objectForKey:identifier] != nil){
                cell.imageView.image= [self.cachedCatImages valueForKey:identifier];
            }
            else{
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue, ^{
                    NSURL *url6 = [NSURL URLWithString:[self.searched_categoryIcon objectAtIndex: indexPath.row]];
                    NSData *data1 = [NSData dataWithContentsOfURL:url6];
                    UIImage *img = nil;
                    img = [[UIImage alloc] initWithData:data1];
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self.cachedCatImages setValue:img forKey:identifier];
                        [img release];
                        cell.imageView.image=[UIImage imageWithData:data1];
//                        [data1 release];
                        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sr_arrow1.png"]] autorelease];
                    });
                });
            }
            [tableView setBackgroundView: nil];
        }
        else
        {
            cell.textLabel.text = [self.categoryname objectAtIndex:indexPath.row];
            cell.textLabel.textColor=[UIColor grayColor];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            
            if (indexPath.row % 2) {
                UIView* bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
                bgview.opaque = YES;
                bgview.backgroundColor = [self colorWithHexString:@"E9E9E9"];
                cell.textLabel.backgroundColor = [self colorWithHexString:@"E9E9E9"];
                cell.contentView.backgroundColor = [self colorWithHexString:@"E9E9E9"];
                
                [cell.textLabel setFont:[UIFont systemFontOfSize:celltextsize]];
                [cell setBackgroundView:bgview];
            } else {
                [cell.textLabel setFont:[UIFont systemFontOfSize:celltextsize]];
            }
            
            NSString *identifier = [NSString stringWithFormat:@"Cell%@" ,
									[self.categoryIcon objectAtIndex: indexPath.row]];
            
            if([self.cachedCatImages objectForKey:identifier] != nil){
                cell.imageView.image= [self.cachedCatImages valueForKey:identifier];
            }
            else{
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue, ^{
                    NSURL *url6 = [NSURL URLWithString:[self.categoryIcon objectAtIndex: indexPath.row]];
                    NSData *data1 = [NSData dataWithContentsOfURL:url6];
                    
                    UIImage *img = nil;
                    img = [[UIImage alloc] initWithData:data1];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self.cachedCatImages setValue:img forKey:identifier];
                        [img release];
                        cell.imageView.image=[UIImage imageWithData:data1];
//                        [data1 release];
                        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sr_arrow1.png"]] autorelease];
                    });
                });
            }
            [tableView setBackgroundView: nil];
        }
        
        return cell;
    }//--------------------------------------------------------------------------
    else{//load sub-category cells
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
        cell.prepTimeLabel.text =[NSString stringWithFormat:@"@%@", [searchedtable_username objectAtIndex:indexPath.row]];
//        cell.categor_yname.text=[self.categoryname objectAtIndex:[indexPath row]];//self.catname;-----
        NSString *nocount = [searchedtable_like objectAtIndex:indexPath.row];
        
        cell.likelbl.text = nocount;
        NSString *no_post = [searchedtable_commet objectAtIndex:indexPath.row];
        cell.commnetlbl.text = no_post;
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSURL *url_img = [NSURL URLWithString:[searchedtable_imagurl objectAtIndex: indexPath.row]];
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
        UITapGestureRecognizer *tap_B1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoDetailsubCat:)];
        cell.listClickView.tag =indexPath.row;
        [cell.listClickView addGestureRecognizer:tap_B1];
        [tap_B1 release];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
        NSString *postmemId =[member_id objectAtIndex:indexPath.row];
        if([postmemId isEqualToString:savedMemderid]){
            UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(deletePostsubCat:)];
            lpgr.minimumPressDuration = .5; //seconds
            lpgr.delegate = self;
            [cell.listClickView addGestureRecognizer:lpgr];
        }
        else{
            UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(canNotdeletePostSubCat:)];
            lpgr.minimumPressDuration = .5; //seconds
            lpgr.delegate = self;
            [cell.listClickView addGestureRecognizer:lpgr];
        }
        cell.commentListClick.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_B2 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getNotitificationClickedSubCat:)];
        cell.commentListClick.tag =indexPath.row;
        [cell.commentListClick addGestureRecognizer:tap_B2];
        [tap_B2 release];
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (intSearchBar == 0){//search category
        NSString *nameLength= [self.CatagoryIdArray objectAtIndex: [indexPath row]];
        
        SearchresultViewController *searchController = [[SearchresultViewController alloc] initWithNibName:objAppDel.searchResultView bundle:nil];
        searchController.Catid=nameLength;
        searchController.catname=[self.categoryname objectAtIndex:[indexPath row]];
        [self.navigationController pushViewController:searchController animated:YES];
    }
    else{//search subcategory
        PostDetailViewController *postDetaildController = [[PostDetailViewController alloc] initWithNibName:objAppDel.postDetailView bundle:nil];
        postDetaildController.posts_id=[searched_post_id objectAtIndex:[indexPath row]];
        postDetaildController.cat_name=[self.categoryname objectAtIndex:[indexPath row]];//self.catname;
    }
}
-(float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    float floatHeight = 0.0;
    if (intSearchBar == 0) {
        floatHeight =  0.01f;
    }
    return floatHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (intSearchBar == 0) {
        return [[UIView new] autorelease];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (intSearchBar == 0) {//search category
        return customTableCellHeight;
    }
    else{//search subcategory
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
}

#pragma mark - SubCategory methods
- (void)gotoDetailsubCat:(UITapGestureRecognizer *)recognizer  {
	PostDetailViewController *postDetaildController = [[PostDetailViewController alloc] initWithNibName:objAppDel.postDetailView bundle:nil];
	postDetaildController.posts_id=[searched_post_id objectAtIndex:recognizer.view.tag];
	[self.navigationController pushViewController:postDetaildController animated:YES];
}
-(void)deletePostsubCat:(UITapGestureRecognizer *)recognizer  {
    if (recognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    NSString *iPostId= [NSString stringWithFormat:@"%@",[post_id objectAtIndex:[recognizer.view tag]]];
	NowPostIdSearch =[iPostId integerValue];
    deleteclickSearch =1;
    
	UIAlertView *alertVW = [[UIAlertView alloc] init];
	[alertVW setTitle:[TSLanguageManager localizedString:@"LBL_CONFIRM"]];
	[alertVW setMessage:[TSLanguageManager localizedString:@"MSG_SURE_TO_DELETE_POST"]];
	[alertVW setDelegate:self];
	[alertVW addButtonWithTitle:[TSLanguageManager localizedString:@"LBL_YES"]];
	[alertVW addButtonWithTitle:[TSLanguageManager localizedString:@"LBL_NO"]];
	[alertVW show];
	[alertVW release];
}
-(void)canNotdeletePostSubCat:(UITapGestureRecognizer *)recognizer  {
    if (recognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    deleteclickSearch =0;
    
	UIAlertView *alertVW = [[UIAlertView alloc] init];
	[alertVW setTitle:[TSLanguageManager localizedString:@"LBL_CONFIRM"]];
	[alertVW setMessage:[TSLanguageManager localizedString:@"MSG_CAN_NOT_DELETE_POST"]];
	[alertVW setDelegate:self];
	[alertVW addButtonWithTitle:[TSLanguageManager localizedString:@"Ok"]];
	[alertVW show];
	[alertVW release];
}
- (void)getNotitificationClickedSubCat:(UITapGestureRecognizer *)recognizer  {
    NSLog(@"Comment List details");
	NSLog(@"%ld", (long)recognizer.view.tag);
	
	CommnetViewController *commnetController = [[CommnetViewController alloc] initWithNibName:objAppDel.commentView bundle:nil];
    commnetController.post_id=[searched_post_id objectAtIndex:recognizer.view.tag];
	
	[self.navigationController pushViewController:commnetController animated:YES];
}

#pragma mark - AlertView Delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(deleteclickSearch == 1){
		if (buttonIndex == 0){
			deleteclickSearch =0;
            BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
            if (isConnectionAvail) {
                [self deletePostFromServer];
            }
            else{
                DisplayAlert(NoNetworkConnection);
            }
		}else if (buttonIndex == 1){
			deleteclickSearch =0;
		}
	}
}

#pragma mark - SearchdisplayController Delegate methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    return YES;
}
/*
 {
 [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
 
 return YES;
 }
 */

#pragma mark - Response Delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [self.responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *e = nil;
    
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
    
    NSString *json = [[NSString alloc] initWithData:self.responseData  encoding:NSUTF8StringEncoding];
    
    id object1 = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
    id object =[object1 valueForKey:@"data"];
    id mes=[object1 valueForKey:@"message"];
    
    NSString *messs=[[mes valueForKey:@"success"] stringValue];
   
    if([messs isEqualToString:@"1"]){
        int i = 0;
        if ([strKey isEqualToString:@""]) {
            NSMutableArray *iCategoryId=[object valueForKey:@"iCategoryId"];
            NSMutableArray *icon_url=[object valueForKey:@"vImage"];
            NSMutableArray *categoryname1=[object valueForKey:@"vCategory"];
            
            self.categoryIcon=icon_url;
            self.categoryname=categoryname1;
            self.CatagoryIdArray=iCategoryId;
            
            totalcategory = [self.categoryname count];
            
            //call webservice
            [self SubCategoryWS];
            
            //alert
            self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
            [self.alert show];
            //activity indicator
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            indicator.center = CGPointMake(150, 100);
            [indicator startAnimating];
            [self.alert addSubview:indicator];
        }
        else if ([strKey isEqualToString:@"subcategory"]) {
            for (NSDictionary *dic in object){
                NSString *iMemberId=[NSString stringWithFormat:@"%@", [dic valueForKey:@"iMemberId"]];
                NSString *postId=[NSString stringWithFormat:@"%@", [dic valueForKey:@"iPostId"]];
                NSString *imageurl=[NSString stringWithFormat:@"%@", [dic valueForKey:@"vVideothumbnail"]];
                NSString *post_ttl=[NSString stringWithFormat:@"%@", [dic valueForKey:@"tPost"]];
                NSString *tab_username=[NSString stringWithFormat:@"%@", [dic valueForKey:@"vUsername"]];
                NSString *tlikes=[NSString stringWithFormat:@"%@", [dic valueForKey:@"totalPostLikes"]];
                NSString *tcommentds=[NSString stringWithFormat:@"%@", [dic valueForKey:@"totalPostComments"]];
                NSString *stDescription=[NSString stringWithFormat:@"%@", [dic valueForKey:@"tDescription"]];
                
                [table_username insertObject:tab_username atIndex:i];
                [tableData insertObject:post_ttl atIndex:i];
                [table_like insertObject:tlikes atIndex:i];
                [table_imagurl insertObject:imageurl atIndex:i];
                [post_id insertObject:postId atIndex:i];
                [member_id insertObject:iMemberId atIndex:i];
                [table_commet insertObject:tcommentds atIndex:i];
                [tDescription insertObject:stDescription atIndex:i];
                
                [searchedtable_username insertObject:tab_username atIndex:i];
                [searched_tableData insertObject:post_ttl atIndex:i];
                [searchedtable_like insertObject:tlikes atIndex:i];
                [searchedtable_imagurl insertObject:imageurl atIndex:i];
                [searched_post_id insertObject:postId atIndex:i];
                [searched_member_id insertObject:iMemberId atIndex:i];
                [searchedtable_commet insertObject:tcommentds atIndex:i];
                [searchedtDescription insertObject:stDescription atIndex:i];
                i++;
            }
        }
        [self.tableView1 reloadData];
    }
}

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
@end
