//
//  GlobalVar.h
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 2/4/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalVar : NSObject{
NSString *str;
    NSString *servieurl;
}
@property(nonatomic,retain)NSString *test;
@property(nonatomic,retain)NSString *str;
@property(nonatomic,retain)NSString *servieurl;
@property(nonatomic,retain)NSString *postCat;
+(GlobalVar*)getInstance;
+(GlobalVar*)getServiceUrl;
@end
