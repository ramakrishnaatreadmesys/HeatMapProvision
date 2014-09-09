//
//  RMSStoreDetailsTableViewCell.h
//  HeatMapProvisioning
//
//  Created by MacBook  on 8/14/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMSStore.h"
#import "RMSStoresManagementTableViewController.h"
#import "RMSDBManager.h"
@interface RMSStoreDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *storeDescLbl;
@property (weak, nonatomic) IBOutlet UIButton *storeSensorsCountBtn;
- (IBAction)showStoreSensors:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *storeProvisionMapBtn;
@property (weak, nonatomic) RMSStore  *currentStore;
@property (nonatomic) RMSStoresManagementTableViewController *parent;
@property (weak, nonatomic) IBOutlet UIButton *uploadStorePlanBtn;
 
-(void)loadDefaults;
-(void)loadStore;
@end
