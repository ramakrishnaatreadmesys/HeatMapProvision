//
//  RMSSensorDetailsCell.h
//  HeatMapProvisioning
//
//  Created by MacBook  on 8/15/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMSStore.h"
#import "RMSSensor.h"
@interface RMSSensorDetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sensorNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *sensorDescLbl;
@property (weak, nonatomic) IBOutlet UILabel *sensorMACAddressLbl;
@property (weak, nonatomic) IBOutlet UIImageView *sensorImg;
@property (weak, nonatomic) IBOutlet UILabel *SensorPositionLbl;
@property  RMSStore *currentStore;
@property  RMSSensor *currentSensor;
-(void)loadStore;
-(void)loadSensor;
-(void)loadDefaults;
@end
