//
//  RMSDBManager.h
//  HeatMapProvisioning
//
//  Created by MacBook  on 8/20/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMSStore.h"
#import "RMSSensor.h"
#import <sqlite3.h>

@interface RMSDBManager : NSObject
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *contactDB;

-(void)createDatabase;
-(NSMutableArray *)loadStors:(NSString *)OrgId;
-(NSMutableArray *)loadSensors:(NSString *)storeId;

-(NSMutableArray *)loadSensorsByType:(NSString *)storeId forDeviceType:(NSString *)deviceType;;
-(bool)SaveStore:(RMSStore *)currentStore forOrg:(NSString *)OrgId;
-(bool)SaveSensor:(RMSSensor *)currentSensor;
-(NSMutableArray *)loadSensorsByGateway:(NSString *)GatewayId;
-(bool)SaveSensorLocation:(RMSSensor *)currentSensor;
@end
