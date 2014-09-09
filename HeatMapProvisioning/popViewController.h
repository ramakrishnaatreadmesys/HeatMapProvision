//
//  popViewController.h
//  ReadMeProvisioning
//
//  Created by MacBook  on 8/7/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMSStore.h"
#import "DropDownView.h"
#import "RMSDBManager.h"
#import "RMSStoresInfo.h"

@interface popViewController : UIViewController<DropDownViewDelegate>

@property (nonatomic, strong) id delegate;
@property (weak, nonatomic) IBOutlet UITextField *sensorNametxt;
@property (weak, nonatomic) IBOutlet UITextField *sensorMacAddress;
@property (weak, nonatomic) IBOutlet UITextField *sensorDesctxt;
@property (weak, nonatomic) IBOutlet UIButton *gatewayBtn;
@property (weak, nonatomic) IBOutlet UIView *gatewayInputView;
@property (weak, nonatomic) IBOutlet UILabel *gatewayTitleLbl;
@property (weak, nonatomic) IBOutlet UIView *addsensorView;

@property (nonatomic) int x_axis;
@property (nonatomic) int y_axis;
@property (nonatomic, strong) NSString *deviceType;
@property (nonatomic) RMSStoresInfo *parent1;
@property (nonatomic, strong) UIPopoverController *parentPopPopover;
@property RMSStore *currentStore;
- (IBAction)BindGateways:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *Statuslbl;
@property (weak, nonatomic) IBOutlet UIButton *dismissPopOver;
- (IBAction)dismissPopUp:(id)sender;
@property RMSDBManager *dbManager;

@end
