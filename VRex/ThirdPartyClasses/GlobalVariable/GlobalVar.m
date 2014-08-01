//
//  GlobalVar.m
//  MobiNesw
//
//  Created by Snehasis Mohapatra on 2/4/14.
//  Copyright (c) 2014 Snehasis Mohapatra. All rights reserved.
//

#import "GlobalVar.h"

@implementation GlobalVar
@synthesize test,postCat;
@synthesize str,servieurl;

static GlobalVar *instance =nil;
static GlobalVar *instance_url =nil;
+(GlobalVar *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            
            instance= [GlobalVar new];
        }
    }
    return instance;
}
+(GlobalVar *)getServiceUrl
{
    @synchronized(self)
    {
        if(instance_url==nil)
        {
            
            instance_url= [GlobalVar new];
        }
    }
    return instance_url;
}

   
@end
