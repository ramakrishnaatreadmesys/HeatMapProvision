//
//  RMSManageStore.h
//  HeatMapProvisioning
//
//  Created by MacBook  on 8/21/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMSStore.h"
#import "RMSDBManager.h"
#import "RMSStoresInfo.h"

@interface RMSManageStore : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property RMSStore *currentStore;
//@property NSString *storeId;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UIButton *showCameraBtn;
@property (weak, nonatomic) IBOutlet UITextField *storeNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *storeDescTxt;
@property RMSDBManager *dbManager;
@property RMSStoresInfo *parent;



- (IBAction)showCamera:(id)sender;
- (IBAction)showGallery:(id)sender;
- (IBAction)SavePhoto:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) NSMutableArray *capturedImages;
@end
