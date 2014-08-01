//
//  testViewController.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 1/10/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface testViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,retain) NSArray *tableData;

@end
