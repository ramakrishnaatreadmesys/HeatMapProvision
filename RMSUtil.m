//
//  RMSUtil.m
//  HeatMapProvisioning
//
//  Created by MacBook  on 9/8/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import "RMSUtil.h"
#import "RMSAppDelegate.h"
@implementation RMSUtil

-(NSString *)GetOrgId
{
    RMSAppDelegate *appDelegate = (RMSAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"Org Id : %@", [appDelegate OrgId]);
  return [appDelegate OrgId];
}

@end
