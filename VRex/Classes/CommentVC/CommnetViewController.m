//
//  CommnetViewController.m
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 2/4/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import "CommnetViewController.h"
#import "NotificationTable.h"
#import "GlobalVar.h"
#import "AppDelegate.h"
#import "TSLanguageManager.h"
#import "constant.h"

@interface CommnetViewController ()

@end
//initialise variables
static int deleteclick=0;
static int NowiCommentId=0;
static int NowPostId=0;

@implementation CommnetViewController
@synthesize tableData,post_id,nameArray,postArray,imgArray,memberidArray,tableview1,responseData,backImg,commnetTxtbox;
@synthesize  sendbtn,post_id_homepage,Memver_id_home,Memver_like,Memver_likeArray,post_box_container,Closecmtbtn;
@synthesize serviceURL;

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
    
	self.sendbtn.hidden=NO;
	self.commnetTxtbox.hidden=NO;
	self.post_box_container.hidden=NO;
	
    [self getCommentlist];
    
    //---- -- initialize back tab------
    self.backImg.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_back =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backFromCommentlist:)];
	[self.backImg addGestureRecognizer:tab_back];
	[tab_back release];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    if (!isiPad) {
		CGSize result = [[UIScreen mainScreen] bounds].size;
		if(result.height == 480)
        {
            
        }else{
            CGRect myFrame = self.post_box_container.frame;
            myFrame.origin.y = result.height - 78;
            
            self.post_box_container.frame = myFrame;
            CGRect myFrame1 = self.commnetTxtbox.frame;
            myFrame1.origin.y = (result.height - 78)+20;
            self.commnetTxtbox.frame = myFrame1;
            CGRect myFrame2 = self.sendbtn.frame;
            myFrame2.origin.y = (result.height - 78)+20;
            self.sendbtn.frame = myFrame2;
        }
    }
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Other methods
- (void)backFromCommentlist:(UITapGestureRecognizer *)recognizer  {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)deleteComment:(UITapGestureRecognizer *)recognizer  {
	deleteclick =1;
	UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:[TSLanguageManager localizedString:@"LBL_CONFIRM"]];
	[alert setMessage:[TSLanguageManager localizedString:@"MSG_SURE_TO_DELETE_COMMENT"]];
	[alert setDelegate:self];
	[alert addButtonWithTitle:[TSLanguageManager localizedString:@"LBL_YES"]];
	[alert addButtonWithTitle:[TSLanguageManager localizedString:@"LBL_NO"]];
	[alert show];
	[alert release];
	
	NSString *iCommentId= [NSString stringWithFormat:@"%@",[self.commentIDData objectAtIndex:[recognizer.view tag]]];
	NowiCommentId =[iCommentId integerValue];
	NSString *iPostId= [NSString stringWithFormat:@"%@",[self.tableData objectAtIndex:[recognizer.view tag]]];
	NowPostId =[iPostId integerValue];
}
-(void) updateLabel
{
	[self.sendbtn setTitle:[TSLanguageManager localizedString:@"LBL_SEND"] forState:UIControlStateNormal];
	self.lbl_comment.text =[TSLanguageManager localizedString:@"LBL_COMMENTS"];
}
- (BOOL)prefersStatusBarHidden
{
	return YES;
}
- (void)replayComment:(UITapGestureRecognizer *)recognizer  {
	
}

#pragma mark - Action methods
- (IBAction)gobackF_commenlist:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)CloseCommetBox:(id)sender {
	self.sendbtn.hidden=YES;
	self.commnetTxtbox.hidden=YES;
	self.post_box_container.hidden=YES;
}

#pragma mark - Keyboard methods
- (void)keyboardWasShown:(NSNotification *)notification
{
    // Get the size of the keyboard.
	CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	const int movementDistance = -keyboardSize.height; // tweak as needed
	const float movementDuration = 0.1f; // tweak as needed
	int movement = movementDistance;
	
	[UIView beginAnimations: @"animateTextField" context: nil];
	[UIView setAnimationBeginsFromCurrentState: YES];
	[UIView setAnimationDuration: movementDuration];
    commnetTxtbox.frame = CGRectOffset(commnetTxtbox.frame, 0, movement);
    sendbtn.frame = CGRectOffset(sendbtn.frame, 0, movement);
//	self.view.frame = CGRectOffset(self.view.frame, 0, movement);
	[UIView commitAnimations];
}
- (void)keyboardWasHide:(NSNotification *)notification
{
    // Get the size of the keyboard.
	CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	const int movementDistance = keyboardSize.height; // tweak as needed
	const float movementDuration = 0.1f; // tweak as needed
	int movement = movementDistance;
	
	[UIView beginAnimations: @"animateTextField" context: nil];
	[UIView setAnimationBeginsFromCurrentState: YES];
	[UIView setAnimationDuration: movementDuration];
    commnetTxtbox.frame = CGRectOffset(commnetTxtbox.frame, 0, movement);
    sendbtn.frame = CGRectOffset(sendbtn.frame, 0, movement);
//	self.view.frame = CGRectOffset(self.view.frame, 0, movement);
	[UIView commitAnimations];
}

#pragma mark - Webservice Call
-(void)getCommentlist{
    //alert
    self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[self.alert show];
    
    //initialise array
	self.responseData = [NSMutableData data];
	self.tableData = [[NSMutableArray alloc]initWithObjects: nil];
	self.nameArray=[[NSMutableArray alloc]initWithObjects: nil];
	self.memberidArray=[[NSMutableArray alloc]initWithObjects: nil];
	self.commentIDData=[[NSMutableArray alloc]initWithObjects: nil];
    self.DatelabelArray=[[NSMutableArray alloc]initWithObjects: nil];
	self.imgArray=[[NSMutableArray alloc]initWithObjects: nil];
	self.postArray=[[NSMutableArray alloc]initWithObjects: nil];
    self.DatelabelArray=[[NSMutableArray alloc]initWithObjects: nil];
 
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        UIImage *ourImage= [UIImage imageNamed:@"sports.png"];
        NSData * imageData = UIImageJPEGRepresentation(ourImage, 1.0);

        GlobalVar *s_url=[GlobalVar getServiceUrl];
        serviceURL=s_url.servieurl;
        
        NSString *urlString = s_url.servieurl;
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
        self.post_id_homepage = post_id;
        NSString *param1 = post_id;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iPostId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param1] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param5 = @"getComments";
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param5] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
        
        NSString *param6 = savedMemderid;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iMemberId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param6] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // set request body
        [request setHTTPBody:body];
        
        //return and test
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSError *e = nil;
        [self.alert dismissWithClickedButtonIndex:0 animated:YES];
        
        id object = [NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
        id response_Data=[object valueForKey:@"data"];
        id response_message=[object valueForKey:@"message"];
        NSString *msg = [response_message valueForKey:@"msg"];
        NSString *succ = [response_message valueForKey:@"success"];
        if([succ integerValue] == 1){
            for (NSDictionary *dic in response_Data){
                NSString *tComments = (NSString*) [dic valueForKey:@"tComments"];
                NSString *vName = (NSString*) [dic valueForKey:@"vUsername"];
                NSString *iPostId = (NSString*) [dic valueForKey:@"iPostId"];
                NSString *vPicture = (NSString*) [dic valueForKey:@"vPicture"];
                NSString *iCommentId = (NSString*) [dic valueForKey:@"iCommentId"];
                NSString *iMemberId = (NSString*) [dic valueForKey:@"iMemberId"];
                NSString *dCreatedDate = (NSString*) [dic valueForKey:@"dCreatedDate"];
                
                [self.DatelabelArray addObject:dCreatedDate];
                [self.postArray addObject:tComments];
                [self.nameArray addObject:vName];
                [self.imgArray addObject:vPicture];
                [self.tableData addObject:iPostId];
                [self.commentIDData addObject:iCommentId];
                [self.memberidArray addObject:iMemberId];
            }
            [self.tableview1 setHidden:NO];
            [self.tableview1 reloadData];
        }
        else{
            [self.tableview1 setHidden:YES];
            UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:msg delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [someError show];
            [someError release];
        }
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
}
-(void)deleteCommentsFromServer{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
	
	self.alert= [[[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"LOADING_PLASE_WAIT"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[self.alert show];
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.center = CGPointMake(150, 100);
	[indicator startAnimating];
	[self.alert addSubview:indicator];
	[indicator release];
	
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        NSString *urlString = [NSString stringWithFormat:@"%@", serviceURL];
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSMutableData *body = [NSMutableData data];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        // Another text parameter
        NSString *param1 = [NSString stringWithFormat:@"%d", NowiCommentId];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iCommentId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param1] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param2 = savedMemderid;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iMemberId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param2] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param3 = [NSString stringWithFormat:@"%d", NowPostId];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"iPostId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:param3] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Another text parameter
        NSString *param5 = @"deleteComment";
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
                 [self getCommentlist];
             }
             else{
                 UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_ALERT"] message:message delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 [someError show];
                 [someError release];
             }
         }];
    }
    else{
        DisplayAlert(NoNetworkConnection);
    }
}
- (IBAction)sendpost_home:(id)sender {
	NSString *p_text=commnetTxtbox.text;
    commnetTxtbox.text = @"";
    commnetTxtbox.placeholder = @"Comment";
    [commnetTxtbox resignFirstResponder];
    
    //posts_id
    BOOL isConnectionAvail = [objAppDel isconnectedToNetwork];
    if (isConnectionAvail) {
        GlobalVar *s_url=[GlobalVar getServiceUrl];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
        
        UIImage *ourImage= [UIImage imageNamed:@"sports.png"];
        NSData * imageData = UIImageJPEGRepresentation(ourImage, 1.0);
        
        NSString *urlString = [NSString stringWithFormat:@"%@", s_url.servieurl];
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
        //    id response_Data=[object valueForKey:@"data"];
        id response_message=[object valueForKey:@"message"];
        NSString *msg = [response_message valueForKey:@"msg"];
        NSString *succ = [response_message valueForKey:@"success"];
        
        //"You are logged in"
        if([succ integerValue] == 1){
            [self getCommentlist];
            [tableview1 reloadData];
        }
        else{
            UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:msg delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
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
    NSError *e = nil;

    NSString *json = [[NSString alloc] initWithData:self.responseData  encoding:NSUTF8StringEncoding];
    
    id object = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
    NSMutableString *message=[object valueForKey:@"msg"];
	NSMutableString *success=[object valueForKey:@"success"];

    if([success integerValue] ==1){
       
    }
    else{
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle:[TSLanguageManager localizedString:@"MSG_VIDEOBLOG"] message:message delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [someError show];
        [someError release];
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

#pragma mark - Tableview delegate methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"NotificationTable";
    
    NotificationTable *cell = (NotificationTable *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:objAppDel.notificationTableView owner:self options:nil];
    cell = [nib objectAtIndex:0];
    if (cell == nil)
    {
      //  NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotificationTable" owner:self options:nil];
       // cell = [nib objectAtIndex:0];
    }
    
    cell.titletext.text = [NSString stringWithFormat:@"@%@",[self.nameArray objectAtIndex:indexPath.row]];
    cell.post_text_lbl.text=[self.postArray objectAtIndex:indexPath.row];
    cell.userimg1.hidden=YES;
   
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
	NSString *commentUserId =[self.memberidArray objectAtIndex:indexPath.row];
	
    if([commentUserId isEqualToString:savedMemderid]){
		cell.deleteBtn.hidden = NO;
	}
    else{
		cell.deleteBtn.hidden = YES;
	}
 
    cell.datetimelbl.text =[self.DatelabelArray objectAtIndex:indexPath.row];
	cell.deleteView.tag = 5;
	
	cell.replyBtn.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_reply =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replayComment:)];
	[cell.replyBtn addGestureRecognizer:tab_reply];
	cell.replyBtn.tag = indexPath.row;
	[tab_reply release];
	
	cell.deleteBtn.userInteractionEnabled = YES;
	UITapGestureRecognizer *tab_delete =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteComment:)];
	[cell.deleteBtn addGestureRecognizer:tab_delete];
	cell.deleteBtn.tag = indexPath.row;
	[tab_delete release];
	
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
	dispatch_async(queue, ^{
		NSURL *url_img = [NSURL URLWithString:[self.imgArray objectAtIndex: indexPath.row]];
		NSData *data1 = [NSData dataWithContentsOfURL:url_img];
		
		dispatch_sync(dispatch_get_main_queue(), ^{
			cell.userimg.image=[UIImage imageWithData:data1];
		});
	});
	
    [tableView setSeparatorColor:[UIColor clearColor]];
    cell.userInteractionEnabled = YES;
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return [self.postArray count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
   
	UIView *sdeleteView = (UIImageView *)[selectedCell viewWithTag:5];
	
	if(sdeleteView.hidden){
		sdeleteView.hidden = NO;
        [self.view bringSubviewToFront:sdeleteView];
	}
    else{
		sdeleteView.hidden = YES;
	}
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *savedMemderid = [prefs stringForKey:@"local_Memberid"];
	NSString *commentUserId =[self.memberidArray objectAtIndex:indexPath.row];
	
    if([commentUserId isEqualToString:savedMemderid]){
    }
    else{
        //alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"V-Rex" message:@"You are not authorised user to delete other's comment." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82;
}

#pragma mark - alertview delegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(deleteclick == 1){
		if (buttonIndex == 0){
			deleteclick =0;
			[self deleteCommentsFromServer];
		}else if (buttonIndex == 1){
			deleteclick =0;
		}
	}
}

#pragma mark - TextField delegate methods
- (BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
	[commnetTxtbox resignFirstResponder];
	return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	[self animateTextField:textField up:NO];
}
-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
	/*
	const int movementDistance = -130; // tweak as needed
	const float movementDuration = 0.3f; // tweak as needed
	
	int movement = (up ? movementDistance : -movementDistance);
	
	[UIView beginAnimations: @"animateTextField" context: nil];
	[UIView setAnimationBeginsFromCurrentState: YES];
	[UIView setAnimationDuration: movementDuration];
	self.view.frame = CGRectOffset(self.view.frame, 0, movement);
	[UIView commitAnimations];
	 */
}

@end
