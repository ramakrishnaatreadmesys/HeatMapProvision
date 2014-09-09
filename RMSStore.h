//
//  RMSStore.h
//  HeatMapProvisioning
//
//  Created by MacBook  on 8/14/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMSStore : NSObject

@property NSString *storeName;
@property NSString *storeDesc;
@property NSString * storeId;
@property NSString * orgId;
@property NSString * sensorsCount;
@property NSData* storePlanImgData;
@property int HasStorePlan;
@end
