//
//  RMSAppDelegate.m
//  HeatMapProvisioning
//
//  Created by MacBook  on 8/13/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import "RMSAppDelegate.h"
#import "RMSStoresManagementTableViewController.H"
#import "RMSStoresInfo.h"
#import "RMSLogin.h"
#import "RMSDBManager.h"
@implementation RMSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[self class] Generalstyle];
    self.dbManager=[[RMSDBManager alloc]init];
    [self.dbManager createDatabase];
    self.OrgId=@"1";
    RMSLogin *rootController = [[RMSLogin alloc] initWithNibName:@"RMSLogin" bundle:nil];
    
    UINavigationController *navigationController = [[UINavigationController       alloc]initWithRootViewController:rootController];
   
    self.window.rootViewController = navigationController;
    return YES;
}

+ (void)Generalstyle {
    
        
    // load the background image safewayLogo.gif
  //  UIImage *imageNavBar = [UIImage imageNamed:@"safewayLogo.gif"];
    
    // set the image as stretchable and set into navbar globally
//    imageNavBar = [imageNavBar stretchableImageWithLeftCapWidth:0 topCapHeight:0];
 //   [[UINavigationBar appearance] setBackgroundImage:imageNavBar forBarMetrics:UIBarMetricsDefault];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
