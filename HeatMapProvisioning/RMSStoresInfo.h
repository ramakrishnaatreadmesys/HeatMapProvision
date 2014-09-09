//
//  RMSStoresInfo.h
//  HeatMapProvisioning
//
//  Created by MacBook  on 8/20/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMSDBManager.h"

@interface RMSStoresInfo : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate, UINavigationControllerDelegate,UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *storesTableView;
@property (weak, nonatomic) IBOutlet UITableView *gatewaysTableView;
@property (weak, nonatomic) IBOutlet UITableView *sensorsTableView;

@property (weak, nonatomic) IBOutlet UIView *gatewaysView;
@property (weak, nonatomic) IBOutlet UIView *sensorsView;

@property (nonatomic, strong) UIPopoverController *sensosrPopupView;
@property (weak, nonatomic) IBOutlet UIScrollView *scroolView;
@property (weak, nonatomic) IBOutlet UIView *GatewaysSourceView;
@property (weak, nonatomic) IBOutlet UIImageView *storeMapImageView;
@property (nonatomic, strong) UIImageView *dragObject;
@property (weak, nonatomic) IBOutlet UIButton *lockBtn;
- (IBAction)Scan:(id)sender;

@property (nonatomic, assign) CGPoint touchOffset;
//@property int nextId;
@property RMSStore *currentStore;
@property NSMutableArray *storesArray;
@property NSMutableArray *gatewaysArray;
@property NSMutableArray *sensorsArray;
@property NSMutableArray *storeSensorsArray;
@property RMSDBManager *dbManager;

- (IBAction)addStore:(id)sender;
-(void)loadSelectedStoreSensors:(RMSStore *)store;
-(void)loadStores;
@end
