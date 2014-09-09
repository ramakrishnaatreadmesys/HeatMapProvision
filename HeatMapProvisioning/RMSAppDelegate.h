//
//  RMSAppDelegate.h
//  HeatMapProvisioning
//
//  Created by MacBook  on 8/13/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMSDBManager.h"
@interface RMSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property RMSDBManager *dbManager;
@property (nonatomic, retain) NSString *OrgId;
+ (void) Generalstyle;
@end
