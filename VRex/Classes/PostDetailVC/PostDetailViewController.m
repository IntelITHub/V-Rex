//
//  PostDetailViewController.m
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/31/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import "PostDetailViewController.h"
#import "GlobalVar.h"
#import "CommnetViewController.h"
#import "UserprofileViewController.h"
#import "MediaPlayer/MediaPlayer.h"
#import "AppDelegate.h"
#import "TSLanguageManager.h"
#import "constant.h"

NSMutableString *currentUrl;
@interface PostDetailViewController ()

@end

@implementation PostDetailViewController
@synthesize backbtn,player,likebtn,commentbtn,responseData,post_userphoto,postphoto,posts_id,cat_name,scrollview,fullScrollView;
@synthesize post_text,getNotiticationimg,post_textview,likebtn_red,date_post_labl;
@synthesize postuernamelbl,profileid,serviceURL,fullView,fullViewImage,fullViewBackImage;

//initialise variable
int imgdata=0;

#pragma mark - viewcontroler methods
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
	
    if (isiPad) {
        [scrollview setContentSize:CGSizeMake(200, 900)];
    }
    else{
        if (isiPhone5) {
            if (iOS7) {
                
            }
            else{
                [scrollview setFrame:CGRectMake(7, 71, 306, 480)];
            }
        }
        else{
            
            [scrollview setFrame:CGRectMake(7, 150, 306, 480)];
        }
        [scrollview setContentSize:CGSizeMake(200, 630)];

    }
    scrollview.scrollEnabled = YES;
   
    
    //call webservice
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        [self getPostDetails];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
   
    //go to public profile
    self.postuernamelbl.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_user =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPublicProfile:)];
	[self.postuernamelbl addGestureRecognizer:tap_user];
	[tap_user release];
    
    //Post user photo
    self.post_userphoto.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_userphoto =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPublicProfile:)];
	[self.post_userphoto addGestureRecognizer:tap_userphoto];
	[tap_userphoto release];
    
    //getNotification
    self.getNotiticationimg.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_noti =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getNotitificationClicked:)];
	[self.getNotiticationimg addGestureRecognizer:tap_noti];
	[tap_noti release];
	
    //Close Fullview
	self.fullViewBackImage.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_back_full_view =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeFullView:)];
	[self.fullViewBackImage addGestureRecognizer:tap_back_full_view];
	[tap_back_full_view release];
	
    //go back Post Detail
    self.backbtn.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_B =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gobackF_PostDetails:)];
	[self.backbtn addGestureRecognizer:tap_B];
	[tap_B release];
    
    //btnRed
    self.likebtn_red.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_like_red =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeBtn_RedClicked:)];
	[self.likebtn_red addGestureRecognizer:tap_like_red];
	[tap_like_red release];
    
    //btnLike
    self.likebtn.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_likebtn =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeBtnClicked:)];
	[self.likebtn addGestureRecognizer:tap_likebtn];
	[tap_likebtn release];
    
    //btnComment
    self.commentbtn.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_commnet =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentBtnClicked:)];
	[self.commentbtn addGestureRecognizer:tap_commnet];
	[tap_commnet release];
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
-(void) viewDidAppear:(BOOL)animated
{
//    scrollview.scrollEnabled = YES;
//    if (isiPad) {
//        [scrollview setContentSize:CGSizeMake(200, 900)];
//    }
//    else{
//        [scrollview setContentSize:CGSizeMake(200, 630)];
//    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Other methods
#pragma GoToPublicProfile
-(void)gotoPublicProfile:(UITapGestureRecognizer *)recognizer{
    UserprofileViewController *userprofileController = [[UserprofileViewController alloc] initWithNibName:objAppDel.userProfileView bundle:nil];
    
    userprofileController.profiletype=@"public";
    userprofileController.Pub_profileid=self.profileid;
    [self.navigationController pushViewController:userprofileController animated:YES];
}
#pragma getNotification
- (void)getNotitificationClicked:(UITapGestureRecognizer *)recognizer  {
    CommnetViewController *commnetController = [[CommnetViewController alloc] initWithNibName:objAppDel.commentView bundle:nil];
    
    commnetController.post_id=posts_id;
    [self.navigationController pushViewController:commnetController animated:YES];
}
#pragma comment button
- (void)commentBtnClicked:(UITapGestureRecognizer *)recognizer  {
    self.postsendbtn.hidden=NO;
    self.post_text.hidden=NO;
}
#pragma goBackPostDetail
- (void)gobackF_PostDetails:(UITapGestureRecognizer *)recognizer  {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma closeFullView
- (void)closeFullView:(UITapGestureRecognizer *)recognizer  {
	self.fullView.hidden=  YES;
    [player stop];
}
#pragma UpdateLabel
-(void) updateLabel
{
	self.lbl_like.text =[TSLanguageManager localizedString:@"LBL_LIKE"];
	self.lbl_comment.text =[TSLanguageManager localizedString:@"LBL_COMMENT"];
}
#pragma PlayVideo
-(void)playvideo:(UITapGestureRecognizer *)recognizer{
	NSURL *url1= [NSURL URLWithString:_tem_currentURL.text];
	
	player = [[MPMoviePlayerController alloc] initWithContentURL:url1];
	if (!isiPad) {
    	player.view.frame = CGRectMake(2, 71, 316, 300);
	}else{
	 	player.view.frame = CGRectMake(2, 108, 765, 1000);
	}
	
	[self.fullView addSubview:player.view];
	[self.view addSubview:self.fullView];
	self.fullView.hidden=  NO;
	[player play];
}
#pragma OpenImage
-(void)openImage:(UITapGestureRecognizer *)recognizer{
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
	dispatch_async(queue, ^{
		NSURL *url_img_video_thumb = [NSURL URLWithString:[NSString stringWithFormat:@"%@", _tem_currentURL.text]];
		NSData *data_video_thumb = [NSData dataWithContentsOfURL:url_img_video_thumb];
		UIImage *newIMage = [UIImage imageWithData:data_video_thumb];
		NSLog(@"Width %f ==> height %f",newIMage.size.width,newIMage.size.height);
		dispatch_sync(dispatch_get_main_queue(), ^{
			self.fullViewImage.image=[UIImage imageWithData:data_video_thumb];
		});
	});
	self.fullView.hidden=  NO;
	[self.view addSubview:self.fullView];
}
- (BOOL)prefersStatusBarHidden
{
	return YES;
}

#pragma mark - WebService methods
#pragma LikeRed button
-(void)likeBtn_RedClicked:(UITapGestureRecognizer *)reconizer{
    //alert
	self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[self.alert show];
    //activity indicator
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.center = CGPointMake(150, 100);
	[indicator startAnimating];
	[self.alert addSubview:indicator];
	
    likebtn_red.hidden=YES;
    likebtn.hidden=NO;
  
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        //    GlobalVar *obj=[GlobalVar getInstance];
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
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
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
        NSString *param5 = @"setPostUnLike";
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param5] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // set request body
        [request setHTTPBody:body];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }

    NSString *npost=self.post_like_lbl.text;
    NSInteger myInt = [npost intValue];
    myInt--;
    
    NSString *Likestring = [NSString stringWithFormat:@"%d", myInt];
    self.post_like_lbl.text=Likestring;
    
    likebtn.hidden=NO;
    likebtn_red.hidden=YES;
	
	self.lbl_like.text = [TSLanguageManager localizedString:@"LBL_LIKE"];
	self.lbl_like.textColor = [UIColor darkGrayColor];
}
#pragma Like button
- (void)likeBtnClicked:(UITapGestureRecognizer *)recognizer  {
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
        UIImage *ourImage= [UIImage imageNamed:@"sports.png"];
        NSData * imageData = UIImageJPEGRepresentation(ourImage, 1.0);
        
        NSString *urlString = serviceURL;
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
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
    
    //return and test
//    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
//    NSError *e = nil;
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
    
//    id object = [NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
//    NSMutableString *message=[object valueForKey:@"msg"];
    
    NSString *npost=self.post_like_lbl.text;
    NSInteger myInt = [npost intValue];
    myInt++;
    
    NSString *Likestring = [NSString stringWithFormat:@"%d", myInt];
    self.post_like_lbl.text=Likestring;
    likebtn.hidden=YES;
    likebtn_red.hidden=NO;
	self.lbl_like.text = [TSLanguageManager localizedString:@"LBL_LIKED"];
	self.lbl_like.textColor = [UIColor whiteColor];
}
#pragma GetPostDetail
-(void)getPostDetails{
    //alert
	self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[self.alert show];
    //activity indicator
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.center = CGPointMake(150, 100);
	[indicator startAnimating];
	[self.alert addSubview:indicator];
	
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
	self.responseData = [NSMutableData data];
 
	NSString*J_url=[NSString stringWithFormat:@"%@", serviceURL];
	NSString*J_istr=@"?action=getPostdetails&iPostId=";
    NSString*J_postid=posts_id;
    NSString*J_miidtext=@"&iMemberId=";
    NSString*J_Memid=savedMemderid;
    NSArray *myStrings = [[NSArray alloc] initWithObjects:J_url,J_istr, J_postid,J_miidtext,J_Memid, nil];
   
    NSString *joinedString = [myStrings componentsJoinedByString:@""];
    NSURL *myURL = [NSURL URLWithString:joinedString];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
    [NSURLConnection connectionWithRequest:myRequest delegate:self];
}
- (IBAction)SendPost:(id)sender {
    NSString *p_text=post_text.text;
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
        UIImage *ourImage= [UIImage imageNamed:@"sports.png"];
        NSData * imageData = UIImageJPEGRepresentation(ourImage, 1.0);
        
        NSString *urlString = [NSString stringWithFormat:@"%@", serviceURL];;
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
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
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
        [self.alert dismissWithClickedButtonIndex:0 animated:YES];
        
        NSMutableString *message=[[object valueForKey:@"message"] objectForKey:@"msg"];
        NSMutableString *success=[[object valueForKey:@"message"] objectForKey:@"success"];
        
        if([success integerValue] == 1){
            UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:message delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [someError show];
            [someError release];
            
            NSString *npost=self.post_commnet_lbl.text;
            NSInteger myInt = [npost intValue];
            myInt++;
            
            NSString *Likestring = [NSString stringWithFormat:@"%d", myInt];
            self.post_commnet_lbl.text=Likestring;
            
            self.post_commnet_lbl.hidden=YES;
            self.post_commnet_lbl.hidden=YES;
        }
        else{
            UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:message delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [someError show];
            [someError release];
        }
        [post_text resignFirstResponder];
        [scrollview setContentOffset:CGPointMake(0, 0)];
        self.postsendbtn.hidden=YES;
        self.post_text.hidden=YES;
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
}

#pragma mark - TextField Delegate methods
- (BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
    [post_text resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    post_text.text = @"";
	if(textField == post_text){
        if (isiPad) {
            [scrollview setContentOffset:CGPointMake(0, 280)];
        }
        else{
            if (isiPhone5) {
                [scrollview setContentOffset:CGPointMake(0, 220)];
            }
            else{
                [scrollview setContentOffset:CGPointMake(0, 380)];
            }
        }
	}
    else
    {
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 animations:^{
    }];
}

#pragma mark - Response Delegate methods
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *e = nil;
 
    NSString *json = [[NSString alloc] initWithData:self.responseData  encoding:NSUTF8StringEncoding];
    
    id responseobject = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
    id object=[responseobject valueForKey:@"data"];
    
    NSMutableString *isPostLike=[object valueForKey:@"isPostLike"];
    NSMutableString *name=[object valueForKey:@"vName"];
    NSMutableString *post_ttl=[object valueForKey:@"tPost"];
    NSMutableString *city=[object valueForKey:@"vCity"];
    NSMutableString *tDescription=[object valueForKey:@"tDescription"];
    NSString *pfo_id=[object valueForKey:@"iMemberId"];
    
    NSMutableString *imagefile=[object valueForKey:@"vFile"];
    NSMutableString *userimagefile=[object valueForKey:@"vPicture"];
	NSMutableString *vVideothumbnail=[object valueForKey:@"vVideothumbnail"];
	NSMutableString *eFileType=[object valueForKey:@"eFiletype"];
	cat_name =[object valueForKey:@"vCategoriesName"];
    
    if([isPostLike isEqualToString:@"NO"])
    {
        likebtn.hidden=NO;
        likebtn_red.hidden=YES;
		  self.lbl_like.text = [TSLanguageManager localizedString:@"LBL_LIKE"];
		  self.lbl_like.textColor = [UIColor darkGrayColor];
    }
    else{
        likebtn_red.hidden=NO;
        likebtn.hidden=YES;
		  self.lbl_like.text = [TSLanguageManager localizedString:@"LBL_LIKED"];
		 self.lbl_like.textColor = [UIColor whiteColor];
    }
    NSString *no_post = [[object valueForKey:@"totalPostComments"] stringValue];
      NSString *no_like = [[object valueForKey:@"totalPostLikes"] stringValue];

    self.profileid=pfo_id;
    self.post_city_lbl.text=city;
    self.post_textDetals_box.text=tDescription;
	
	if([name isEqual: [NSNull null]]){
		 self.postuernamelbl.text=@"";
	}else{
		 self.postuernamelbl.text=name;
	}
    if([post_ttl isEqual: [NSNull null]]){
		self.post_ttl_lbl.text=@"";
	}else{
		self.post_ttl_lbl.text=post_ttl;
	}
    self.post_like_lbl.text=no_like;
    self.post_commnet_lbl.text=no_post;
    self.post_catgory_lbl.text=cat_name;
   
    NSURL *url_img1 = [NSURL URLWithString:userimagefile];
    NSData *data2 = [NSData dataWithContentsOfURL:url_img1];
    post_userphoto.image=[UIImage imageWithData:data2];
   
	[self.alert dismissWithClickedButtonIndex:0 animated:YES];
	if([eFileType isEqualToString:@"Image"]){
        self.videoIcon.hidden = YES;
		dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
		dispatch_async(queue, ^{
			NSURL *url_img = [NSURL URLWithString:imagefile];
			NSData *data1 = [NSData dataWithContentsOfURL:url_img];
			_tem_currentURL.text =imagefile;
			dispatch_sync(dispatch_get_main_queue(), ^{
					postphoto.image=[UIImage imageWithData:data1];
			});
		});
		postphoto.userInteractionEnabled = YES;
		UITapGestureRecognizer *tap_back_full_view =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImage:)];
		[postphoto addGestureRecognizer:tap_back_full_view];
		[tap_back_full_view release];
	}
    else{
        self.videoIcon.hidden = NO;
		dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
		dispatch_async(queue, ^{
			NSURL *url_img_video_thumb = [NSURL URLWithString:vVideothumbnail];
			NSData *data_video_thumb = [NSData dataWithContentsOfURL:url_img_video_thumb];
			_tem_currentURL.text =imagefile;
			dispatch_sync(dispatch_get_main_queue(), ^{
				postphoto.image=[UIImage imageWithData:data_video_thumb];
			});
		});
		postphoto.userInteractionEnabled = YES;
		UITapGestureRecognizer *tap_back_full_view =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playvideo:)];
		[postphoto addGestureRecognizer:tap_back_full_view];
		[tap_back_full_view release];
  
        self.videoIcon.userInteractionEnabled = YES;
		UITapGestureRecognizer *tap_back_full_view1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playvideo:)];
		[self.videoIcon addGestureRecognizer:tap_back_full_view1];
		[tap_back_full_view1 release];
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
