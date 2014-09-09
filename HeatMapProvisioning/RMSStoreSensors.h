//
//  RMSStoreSensors.h
//  HeatMapProvisioning
//
//  Created by MacBook  on 8/15/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMSStore.h"
#import "RMSSensor.h"
#import "RMSDBManager.h"
@interface RMSStoreSensors : UITableViewController
@property  RMSStore *currentStore;
@property RMSDBManager *dbManager;
@end
