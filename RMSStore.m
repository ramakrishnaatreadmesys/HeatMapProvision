//
//  RMSStore.m
//  HeatMapProvisioning
//
//  Created by MacBook  on 8/14/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import "RMSStore.h"

@implementation RMSStore

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        
        self.orgId = dictionary[@"orgId"];
        self.storeId = dictionary[@"storeId"];
        self.storeName = dictionary[@"storeName"];
         self.storeDesc = dictionary[@"storeDesc"];
        self.sensorsCount = dictionary[@"sensorsCount"];
        
    }
    return self;
}
@end
