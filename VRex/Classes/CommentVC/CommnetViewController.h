//
//  CommnetViewController.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 2/4/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommnetViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,retain) NSMutableArray *commentIDData;
@property(nonatomic,retain) NSMutableArray *tableData;
@property(nonatomic,retain)NSString *post_id;
@property(nonatomic,retain)NSMutableArray *DatelabelArray;
@property(nonatomic,retain)NSMutableArray *postArray;
@property(nonatomic,retain)NSMutableArray *nameArray;
@property(nonatomic,retain)NSMutableArray *imgArray;
@property(nonatomic,retain)NSMutableArray *memberidArray;
@property(nonatomic,retain)IBOutlet UITableView *tableview1;
@property(nonatomic,retain)NSMutableData *responseData;
@property(nonatomic,retain)IBOutlet UIImageView *backImg;

@property(nonatomic,retain)IBOutlet UIButton *sendbtn;
@property(nonatomic,retain)IBOutlet UITextField *commnetTxtbox;
@property(nonatomic,retain)NSString *post_id_homepage;
@property(nonatomic,retain)NSString *Memver_id_home;
@property(nonatomic,retain)NSString *Memver_like;
@property(nonatomic,retain)NSArray *Memver_likeArray;
@property(nonatomic,retain)IBOutlet UIImageView *post_box_container;
@property(nonatomic,retain)IBOutlet UILabel *lbl_comment;
@property(nonatomic,retain)NSString *serviceURL;
@property(nonatomic,retain)UIAlertView *alert;
@property(nonatomic,retain)IBOutlet UIButton *Closecmtbtn;

//other methods
-(void)getCommentlist;

//action methods
- (IBAction)gobackF_commenlist:(id)sender;
- (IBAction)sendpost_home:(id)sender;
- (IBAction)CloseCommetBox:(id)sender;

@end
