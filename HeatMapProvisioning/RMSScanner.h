//
//  RMSScanner.h
//  HeatMapProvisioning
//
//  Created by MacBook  on 9/5/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;
#import "RMSDBManager.h"
#import "RMSStoresInfo.h"

@interface RMSScanner : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
@property (strong, nonatomic) NSMutableArray * allowedBarcodeTypes;

- (IBAction)startScanning:(id)sender;
 
- (IBAction)clear:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblSerialNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblMacAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnScan;
@property RMSDBManager *dbManager;
@property (nonatomic, strong) NSString *deviceType;
@property (nonatomic) RMSStoresInfo *parent1;
@property RMSStore *currentStore;
@end
