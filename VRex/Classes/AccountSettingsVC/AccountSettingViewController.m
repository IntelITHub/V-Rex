//
//  AccountSettingViewController.m
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/23/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "TSLanguageManager.h"
#import "constant.h"

@interface AccountSettingViewController ()

@end

@implementation AccountSettingViewController
@synthesize backimg;

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
    if (isiPad) {
        
    }
    else{
        if (isiPhone5) {
            
        }
        else{
            [scrollView setFrame:CGRectMake(0, 150, 320, 420)];
        }
    }
    
    self.backimg.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap_B =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goback:)];
	[self.backimg addGestureRecognizer:tap_B];
	[tap_B release];
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
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Other methods
- (void)goback:(UITapGestureRecognizer *)recognizer  {
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)prefersStatusBarHidden
{
	return YES;
}

#pragma mark - Action methods
- (IBAction)logoutClicked:(id)sender {
	[[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"local_Memberid"];
	ViewController *viewController = [[ViewController alloc] initWithNibName:objAppDel.mainView bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
