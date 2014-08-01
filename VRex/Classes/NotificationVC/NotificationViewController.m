//
//  NotificationViewController.m
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/21/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationTable.h"
#import "DetailfeedViewController.h"
#import "SearchViewController.h"
#import "CaputreViewController.h"
#import "UserprofileViewController.h"
#import "PostDetailViewController.h"
#import "GlobalVar.h"
#import "AppDelegate.h"
#import "constant.h"
#import "TSLanguageManager.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController
@synthesize tableData,userprofileview,searchview,caputerview,backbtn,responseData,following_img;
@synthesize me_img,following_lbl,me_lbl,serviceURL;

#pragma mark - Viewcontroller methods
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
	GlobalVar *s_url=[GlobalVar getServiceUrl];
	serviceURL=s_url.servieurl;
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
    if (isiPad) {
        
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
                [self.table setFrame:CGRectMake(0, 59, 320, 450)];
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
    
	if (!isiPad) {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            searchview=@"SearchViewController";
            caputerview=@"CaputreViewController";
            userprofileview=@"UserprofileViewController";
        }
        else
        {
            // iPhone 5 or maybe a larger iPhone ??
            searchview=@"SearchViewIphone5";
            caputerview=@"CaputreViewControllerIphone5";
            userprofileview=@"UserprofileViewControllerIphone5";        
        }
	}
    else{
        searchview=@"SearchViewControllerIpad";
        caputerview=@"CaptureViewControllerIpad";
        userprofileview=@"UserprofileViewControllerIpad";
    }
    
		  
        self.backbtn.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_B =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gobackF_Notification:)];
        [self.backbtn addGestureRecognizer:tap_B];
        [tap_B release];
        
        self.following_img.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_foll =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followingHeadClicked:)];
        [self.following_img addGestureRecognizer:tap_foll];
        [tap_foll release];
        
        self.me_img.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_me =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MeClicked:)];
        [self.me_img addGestureRecognizer:tap_me];
        [tap_me release];

        //initialise array
        tableData =  [[NSArray alloc] initWithObjects:@"testing the app",@"Art,culture,Entertaiment,movie,game", @"Famous", nil];
        self.tableData= [[NSArray alloc] initWithObjects: nil];
        self.postimgArray= [[NSArray alloc]initWithObjects: nil];
        self.datatimeArray= [[NSArray alloc]initWithObjects: nil];
        self.descriptionArray= [[NSArray alloc]initWithObjects: nil];
        //intialise response data
        self.responseData = [NSMutableData data];
       
        NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
        NSString *url1=[NSString stringWithFormat:@"%@", serviceURL];
        NSString *istr=@"?action=newsFeed&iProfilerId=";
        NSString *proflerid=savedMemderid;
        NSString *pagetext=@"&page=";
        NSString *page=@"1";
        NSString *etype=@"&eNewsFeedType=";
        NSString *etypeval=@"ME";
        NSString *memstr=@"&iMemberId=";
        NSString *memid=savedMemderid;
        
        NSArray *myStrings = [[NSArray alloc] initWithObjects:url1,istr,proflerid,pagetext,page,etype,etypeval,memstr,memid, nil];
        NSString *joinedString = [myStrings componentsJoinedByString:@""];
        NSURL *myURL = [NSURL URLWithString:joinedString];
    
        NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
        //alert
        self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
        [self.alert show];
        //activity indicator
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.center = CGPointMake(150, 100);
        [indicator startAnimating];
        [self.alert addSubview:indicator];
        [NSURLConnection connectionWithRequest:myRequest delegate:self];
}
-(void)viewWillAppear:(BOOL)animated
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

#pragma mark - Other methods
- (void)gobackF_Notification:(UITapGestureRecognizer *)recognizer  {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)gotoDetail:(UITapGestureRecognizer *)recognizer  {
	PostDetailViewController *postDetaildController = [[PostDetailViewController alloc] initWithNibName:objAppDel.postDetailView bundle:nil];
	[self.navigationController pushViewController:postDetaildController animated:YES];
}
-(void) updateLabel
{
	self.following_lbl.text = [TSLanguageManager localizedString:@"LBL_FOLLOWING"];
	self.me_lbl.text = [TSLanguageManager localizedString:@"LBL_ME"];
}
- (BOOL)prefersStatusBarHidden
{
	return YES;
}

#pragma mark - Action methods
- (IBAction)gotoHomeF_notificaiton:(id)sender {
    DetailfeedViewController *DetailController = [[DetailfeedViewController alloc] initWithNibName:objAppDel.detailfeedView bundle:nil]; [self.navigationController pushViewController:DetailController animated:YES];
}
- (IBAction)gotoSearchF_notification:(id)sender {
    SearchViewController *searchController = [[SearchViewController alloc] initWithNibName:objAppDel.searchView bundle:nil]; [self.navigationController pushViewController:searchController animated:YES];
}
- (IBAction)gotoCaptureF_notification:(id)sender {
    CaputreViewController *capController = [[CaputreViewController alloc] initWithNibName:objAppDel.captureView bundle:nil]; [self.navigationController pushViewController:capController animated:YES];
}
- (IBAction)gotoUserprofile_notiticaiton:(id)sender {
    UserprofileViewController *capController = [[UserprofileViewController alloc] initWithNibName:objAppDel.userProfileView bundle:nil]; [self.navigationController pushViewController:capController animated:YES];
}

#pragma mark - WebService methods
#pragma FollowingHead
- (void)followingHeadClicked:(UITapGestureRecognizer *)recognizer  {
    following_img.image=[UIImage imageNamed:@"white_blank.png"];
    me_img.image=[UIImage imageNamed:@"red_blank.png"];
    [following_lbl setTextColor:[UIColor redColor]];
    [me_lbl setTextColor:[UIColor whiteColor]];
    
    //initalise array
    self.tableData= [[NSArray alloc]initWithObjects: nil];
    self.postimgArray= [[NSArray alloc]initWithObjects: nil];
    self.datatimeArray= [[NSArray alloc]initWithObjects: nil];
    self.descriptionArray= [[NSArray alloc]initWithObjects: nil];
    //initialise response data
    self.responseData = [NSMutableData data];
   
    //alert
	self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[self.alert show];
    //activity indicator
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.center = CGPointMake(150, 100);
	[indicator startAnimating];
	[self.alert addSubview:indicator];
    
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
        
        NSString *url1=[NSString stringWithFormat:@"%@?action=newsFeed&iProfilerId=", serviceURL];
        NSString *proflerid=savedMemderid;
        NSString *pagetext=@"&page=";
        NSString *page=@"1";
        NSString *etype=@"&eNewsFeedType=";
        NSString *etypeval=@"FOLLOWING";
        NSString *memstr=@"&iMemberId=";
        NSString *memid=savedMemderid;
        
        NSArray *myStrings = [[NSArray alloc] initWithObjects:url1,proflerid,pagetext,page,etype,etypeval,memstr,memid, nil];
        NSString *joinedString = [myStrings componentsJoinedByString:@""];
        NSURL *myURL = [NSURL URLWithString:joinedString];
        
        NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
        [NSURLConnection connectionWithRequest:myRequest delegate:self];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
}
#pragma MeClicked
- (void)MeClicked:(UITapGestureRecognizer *)recognizer  {
 
    following_img.image=[UIImage imageNamed:@"red_blank.png"];
    me_img.image=[UIImage imageNamed:@"white_blank.png"];
    [following_lbl setTextColor:[UIColor whiteColor]];
    [me_lbl setTextColor:[UIColor redColor]];
    
    //initialise array
    self.tableData= [[NSArray alloc]initWithObjects: nil];
    self.postimgArray= [[NSArray alloc]initWithObjects: nil];
    self.datatimeArray= [[NSArray alloc]initWithObjects: nil];
    self.descriptionArray= [[NSArray alloc]initWithObjects: nil];
    
	//alert
    self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[self.alert show];
    //activity indiacator
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.center = CGPointMake(150, 100);
	[indicator startAnimating];
	[self.alert addSubview:indicator];
    
    //initialise response data
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        self.responseData = [NSMutableData data];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
        
        NSString *url1=[NSString stringWithFormat:@"%@?action=newsFeed&iProfilerId=", serviceURL];
        NSString *proflerid=savedMemderid;
        NSString *pagetext=@"&page=";
        NSString *page=@"1";
        NSString *etype=@"&eNewsFeedType=";
        NSString *etypeval=@"ME";
        NSString *memstr=@"&iMemberId=";
        NSString *memid=savedMemderid;
        
        NSArray *myStrings = [[NSArray alloc] initWithObjects:url1,proflerid,pagetext,page,etype,etypeval,memstr,memid, nil];
        NSString *joinedString = [myStrings componentsJoinedByString:@""];
        NSURL *myURL = [NSURL URLWithString:joinedString];
        NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
        [NSURLConnection connectionWithRequest:myRequest delegate:self];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
}

#pragma mark - TableView Delegate methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    NotificationTable *cell = (NotificationTable *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:objAppDel.notificationTableView owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titletext.text = [NSString stringWithFormat:@"@%@", [tableData objectAtIndex:indexPath.row]];
       cell.datetimelbl.text=[self.datatimeArray objectAtIndex:indexPath.row];
    cell.titletext.text=[NSString stringWithFormat:@"@%@", [tableData objectAtIndex:indexPath.row]];
    cell.post_text_lbl.text=[self.descriptionArray objectAtIndex:indexPath.row];
    NSLog(@"stslfadsfadsf-->%@",[self.tableData objectAtIndex:indexPath.row]);
   
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
	dispatch_async(queue, ^{
		NSURL *url_img = [NSURL URLWithString:[self.postimgArray objectAtIndex: indexPath.row]];
		NSData *data1 = [NSData dataWithContentsOfURL:url_img];
		dispatch_sync(dispatch_get_main_queue(), ^{
			cell.userimg.image=[UIImage imageWithData:data1];
		});
	});
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	PostDetailViewController *postDetaildController = [[PostDetailViewController alloc] initWithNibName:objAppDel.postDetailView bundle:nil];
	postDetaildController.posts_id=[self.postId objectAtIndex:[indexPath row]];
	[self.navigationController pushViewController:postDetaildController animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - Response Delegate methods
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *e = nil;
    
    NSString *json = [[NSString alloc] initWithData:self.responseData  encoding:NSUTF8StringEncoding];
    id responseobject = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
    id object=[responseobject valueForKey:@"message"];
    id ob2=[responseobject valueForKey:@"data"];
   
	[self.alert dismissWithClickedButtonIndex:0 animated:YES];
	
    NSMutableString *message=[object valueForKey:@"msg"] ;
    NSString *suc_msg=[[object valueForKey:@"success"]stringValue];
   
    if([suc_msg isEqualToString:@"1"]){
         if([ob2 isEqual: [NSNull null]]){
             //alert
              UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:@"No Record found" delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
              [someError show];
              [someError release];
              [self.table reloadData];
         }
         else{
              NSMutableArray *IDatetime=[ob2 valueForKey:@"dCreatedDate"];
              NSMutableArray *IDescription=[ob2 valueForKey:@"tDescription"];
              NSMutableArray *IUsername=[ob2 valueForKey:@"vUsername"];
              NSMutableArray *image_url=[ob2 valueForKey:@"vFile"];
              NSMutableArray *spostId=[ob2 valueForKey:@"iPostId"];
 
              self.tableData=IUsername;
              self.postimgArray=image_url;
              self.datatimeArray=IDatetime;
              self.descriptionArray=IDescription;
              self.postId=spostId;
              [self.table reloadData];
         }
    }
    else{
        [self.table setHidden:YES];
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:message delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [someError show];
        [someError release];
        [self.table reloadData];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [self.responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed! Error - %@ %@",
          
          [error localizedDescription],
          
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

@end
