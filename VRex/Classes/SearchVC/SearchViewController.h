//
//  SearchViewController.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/17/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UITextFieldDelegate,UISearchDisplayDelegate,UIGestureRecognizerDelegate>
{
    IBOutlet UITableView *tableView1;
    NSString *strSearch;
    IBOutlet UISearchBar *searchCatcategoryname;
    IBOutlet UIButton *btnHome,*btnSearch,*btnCamera,*btnCategory,*btnProfile;
    
    NSMutableArray *mutArrSubCategory;
    NSString *strKey;
    NSMutableArray *table_username,*tableData,*table_like,*table_imagurl,*post_id,*member_id,*table_commet,*tDescription;
    NSMutableArray *searchedtable_username,*searched_tableData,*searchedtable_like,*searchedtable_imagurl,*searched_post_id,*searched_member_id,*searchedtable_commet,*searchedtDescription;
    
    int intSearchBar;
}
@property(nonatomic, copy) UISearchBar *searchCatcategorynameBar;
@property(nonatomic,retain)IBOutlet UITextField *searchtxtfield;
@property(nonatomic,retain)IBOutlet UILabel *searchPlacehoder;
@property(nonatomic,retain)IBOutlet UILabel *lbl_category;
@property(nonatomic,retain)NSMutableArray *categoryname;

@property(nonatomic,retain)NSMutableArray *searched_categoryIcon;
@property(nonatomic,retain)NSMutableArray *searched_categoryname;
@property(nonatomic,retain)NSMutableArray *searched_CatagoryIdArray;

@property(nonatomic, copy) NSArray *filteredPersons;
@property(nonatomic, copy) NSString *currentSearchString;
@property(nonatomic,retain)NSMutableArray *categoryIcon;
@property(nonatomic,retain)NSMutableArray *aryCategory;

@property(nonatomic,retain)NSString *viewname;
@property(nonatomic,retain)NSString *userprofileview;
@property(nonatomic,retain)NSMutableData *responseData;
@property(nonatomic,retain)NSArray *CategoryNameArray;
@property(nonatomic,retain)NSArray *CategoryImgurlArray;
@property(nonatomic,retain)NSMutableArray *CatagoryIdArray;
@property(nonatomic,retain)IBOutlet UIImageView *backImg;
@property(nonatomic,retain)IBOutlet UIButton *cancelSearch;
@property (nonatomic,retain)UIAlertView *alert;

@property(nonatomic,retain)IBOutlet UITableView *tableView1;
@property(nonatomic,retain)NSString *serviceURL;
@property (strong ,nonatomic) NSMutableDictionary *cachedCatImages;

@property (nonatomic,retain)NSString *strCurrentString;
@property(nonatomic,retain)NSString *Catid;

@property(nonatomic,retain)NSString *currentLat;
@property(nonatomic,retain)NSString *currentLong;

//other methods
-(void)loadForIphone;
-(void)loadForIpad;

//action methods
- (IBAction)homeBtnClicked:(id)sender;
- (IBAction)CapturebtnClicked:(id)sender;
- (IBAction)notificationbtnClicked:(id)sender;
- (IBAction)userprofilebtnClicked:(id)sender;
- (IBAction)searchButtonclicked:(id)sender;

@end
