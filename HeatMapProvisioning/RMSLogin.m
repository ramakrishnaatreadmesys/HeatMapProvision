//
//  RMSLogin.m
//  HeatMapProvisioning
//
//  Created by MacBook  on 8/22/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import "RMSLogin.h"
#import "RMSStoresInfo.h"
#import "RMSStoresManagementTableViewController.h"
@interface RMSLogin ()

@end

@implementation RMSLogin
 UIImage *_defaultImage;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

   self.loginView .backgroundColor = [UIColor whiteColor];
    self.loginView .layer.cornerRadius = 15.f;
    self.loginView .layer.borderColor = [UIColor blackColor].CGColor;
    self.loginView .layer.borderWidth = 2.f;
}

- (void)viewWillAppear:(BOOL)animated {
//    _defaultImage = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
//    
//   [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    
//    // load the background image navbar.png
//    UIImage *imageNavBar = [UIImage imageNamed:@"safewayLogo.gif"];
//    
//    // set the image as stretchable and set into navbar globally
//    imageNavBar = [imageNavBar stretchableImageWithLeftCapWidth:0 topCapHeight:0];
//      [self.navigationController.navigationBar  setBackgroundImage: imageNavBar forBarMetrics:UIBarMetricsDefault ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)login:(id)sender {
    
//    if(  self.chooseModelSegCtrl.selectedSegmentIndex==1)
//    {
        RMSStoresInfo *nextViewController = [[RMSStoresInfo alloc] initWithNibName:@"RMSStoresInfo" bundle:nil];
        [self.navigationController pushViewController:nextViewController animated:YES];
//    }
//    else {
//        RMSStoresManagementTableViewController  *nextViewController = [[RMSStoresManagementTableViewController alloc] initWithNibName:@"RMSStoresManagementTableViewController" bundle:nil];
//        [self.navigationController pushViewController:nextViewController animated:YES];
//    }
}
@end
