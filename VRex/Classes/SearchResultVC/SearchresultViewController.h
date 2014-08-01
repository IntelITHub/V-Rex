//
//  SearchresultViewController.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/18/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SearchresultViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate,UITextFieldDelegate,UISearchDisplayDelegate>
{
    IBOutlet UISearchBar *searchResult;
	NSMutableArray *searchedCells;
    
    IBOutlet UIButton *btnHome,*btnSearch,*btnCamera,*btnCategoty,*btnProfile;
}
@property(nonatomic, copy) NSArray *filtered;
@property(nonatomic,retain) NSMutableArray *tableData;
@property(nonatomic,retain) NSMutableArray *table_like;
@property(nonatomic,retain) NSMutableArray *table_username;
@property(nonatomic,retain) NSMutableArray *table_commet;
@property(nonatomic,retain) NSMutableArray *table_imagurl;
@property(nonatomic,retain) NSMutableArray *post_id;
@property(nonatomic,retain) NSMutableArray *member_id;

@property(nonatomic,retain)IBOutlet UIImageView *back_img;
@property(nonatomic,retain)IBOutlet UITextField *searchtxtfield;
@property(nonatomic,retain)IBOutlet UILabel *searchPlacehoder;
@property(nonatomic,retain)NSString *viewname;
@property(nonatomic,retain)NSString *Catid;
@property(nonatomic,retain)NSString *catname;
@property(nonatomic,retain)NSMutableData *responseData;
@property(nonatomic,retain)IBOutlet UITableView *posttableview;
@property (nonatomic,retain)UIAlertView *alert;
@property(nonatomic,retain)NSString *serviceURL;
@property(nonatomic,retain)IBOutlet UIView *locationTabView;
@property(nonatomic, retain) CLLocationManager *locationManager;

@property(nonatomic,retain)NSMutableArray *searchedCells;
@property(nonatomic,retain) NSMutableArray *searched_tableData;
@property(nonatomic,retain) NSMutableArray *searchedtable_like;
@property(nonatomic,retain) NSMutableArray *searchedtable_username;
@property(nonatomic,retain) NSMutableArray *searchedtable_commet;
@property(nonatomic,retain) NSMutableArray *searchedtable_imagurl;
@property(nonatomic,retain) NSMutableArray *searched_post_id;
@property(nonatomic,retain) NSMutableArray *searched_member_id;

@property(nonatomic,retain) NSMutableArray *searchedtDescription;
@property(nonatomic,retain) NSMutableArray *tDescription;
@property(nonatomic,retain)IBOutlet UIButton *cancelSearch;
@property(nonatomic,retain)IBOutlet UIButton *uppdperbtn;
@property(nonatomic,retain)IBOutlet UIButton *downbtn;

@property(nonatomic,retain)NSString *currentLat;
@property(nonatomic,retain)NSString *currentLong;

@property (nonatomic,retain)NSString *strCurrentString;

//action methods
- (IBAction)home_search_resultClicked:(id)sender;
- (IBAction)Capute_SearchbtnClicked:(id)sender;
- (IBAction)homeBtnClicked:(id)sender;
- (IBAction)notificaitonClicked:(id)sender;
- (IBAction)UserProfileClicked:(id)sender;
- (IBAction)searchButtonclicked:(id)sender;
@end
