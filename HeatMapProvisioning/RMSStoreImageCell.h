//
//  RMSStoreImageCell.h
//  HeatMapProvisioning
//
//  Created by MacBook  on 8/20/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMSStore.h"
#import "RMSManageStore.h"
@interface RMSStoreImageCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UILabel *storeNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *storePlanImageView;
@property RMSStore *currentStore;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property(nonatomic) RMSStoresInfo *parent;
-(void)Bind;
- (IBAction)editStore:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *editStoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *storeNameBtn;
@end
