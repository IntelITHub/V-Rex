//
//  constant.h
//  AidFramework
//
//  Created by Intel IT Hub on 07/05/14.
//  Copyright (c) 2014 Intel IT Hub. All rights reserved.
//

#ifndef AidFramework_constant_h
#define AidFramework_constant_h


//conditions
#define isiPad  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?TRUE:FALSE
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
#define iOS7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7)?TRUE:FALSE

//Alerts
#define DisplayAlert(msg) { UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; ;}

#define NoNetworkConnection @"No network connection."
#define NoDataFound @"No data found."

#endif
