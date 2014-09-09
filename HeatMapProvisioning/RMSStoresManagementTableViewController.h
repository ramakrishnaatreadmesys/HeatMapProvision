//
//  RMSStoresManagementTableViewController.h
//  HeatMapProvisioning
//
//  Created by MacBook  on 8/14/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMSDBManager.h"
@interface RMSStoresManagementTableViewController : UITableViewController
@property NSString *OrgId;
@property (nonatomic, strong) UIPopoverController *userDataPopover;
@property RMSDBManager *dbManager;
-(void)loadStors;
@end
