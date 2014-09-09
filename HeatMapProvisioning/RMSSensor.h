//
//  RMSSensor.h
//  HeatMapProvisioning
//
//  Created by MacBook  on 8/15/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMSSensor : NSObject

@property NSString *sensorID;
@property NSString *sensorSerialNumber;
@property NSString *sensorMACAddress;
@property NSString *sensorDesc;
@property NSString *sensor_X_axis;
@property NSString *sensor_Y_axis;
@property NSString *storeId;
@property NSString *deviceType;
@property NSString *GatewayId;
@end
