//
//  RMSStoreDetailsTableViewCell.m
//  HeatMapProvisioning
//
//  Created by MacBook  on 8/14/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import "RMSStoreDetailsTableViewCell.h"
#import "RMSStoreSensors.h"
#import "RMSStoresInfo.h"
@implementation RMSStoreDetailsTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)showStoreSensors:(id)sender {
  
    RMSStoreSensors *nextViewController =  [[RMSStoreSensors alloc] initWithNibName:@"RMSStoreSensors" bundle:nil];
    nextViewController.currentStore=self.currentStore;
    // [self presentModalViewController:nextViewController animated:YES];
    [self.parent.navigationController pushViewController:nextViewController animated:YES];
  
    //nextViewController.currentStore=self.currentStore;
}
-(void)loadStore
{
    self.storeName.text=self.currentStore.storeName;
    self.storeDescLbl.text=self.currentStore.storeDesc;
    [self.storeSensorsCountBtn setTitle:self.currentStore.sensorsCount forState:UIControlStateNormal];
    [self.storeProvisionMapBtn setTitle:@"View Store Map" forState:UIControlStateNormal];
    
    [self.storeSensorsCountBtn setUserInteractionEnabled:YES];
    
//    if(!self.currentStore.HasStorePlan || self.currentStore.HasStorePlan==0)
//    {
//        [self.uploadStorePlanBtn setHidden:false];
//         [self.storeProvisionMapBtn setHidden:true];
//    }
//    else{
//        [self.uploadStorePlanBtn setHidden:true];
//        [self.storeProvisionMapBtn setHidden:false];
//    }
    
}

-(void)loadDefaults{
    self.storeName.text=@"Store Name";
    self.storeDescLbl.text=@"Description";
    [self.storeSensorsCountBtn setTitle:@"Sensores" forState:UIControlStateNormal];
  [self.storeProvisionMapBtn setTitle:@" " forState:UIControlStateNormal];
    [self.uploadStorePlanBtn setTitle:@" " forState:UIControlStateNormal];
    [self.storeSensorsCountBtn setBackgroundColor:[UIColor clearColor]];
    [self.storeSensorsCountBtn setUserInteractionEnabled:NO];
     }

- (IBAction)showStoreProvisionMap:(id)sender {
    
    RMSStoresInfo *nextViewController =  [[RMSStoresInfo alloc] initWithNibName:@"RMSStoresInfo" bundle:nil];
    nextViewController.currentStore=self.currentStore;
    // [self presentModalViewController:nextViewController animated:YES];
    [self.parent.navigationController pushViewController:nextViewController animated:YES];
}

@end
