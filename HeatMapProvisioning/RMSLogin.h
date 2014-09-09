//
//  RMSLogin.h
//  HeatMapProvisioning
//
//  Created by MacBook  on 8/22/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMSLogin : UIViewController

@property (weak, nonatomic) IBOutlet UIView *loginView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *chooseModelSegCtrl;
- (IBAction)login:(id)sender;
@end
