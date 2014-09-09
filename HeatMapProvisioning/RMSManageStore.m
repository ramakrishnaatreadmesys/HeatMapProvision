//
//  RMSManageStore.m
//  HeatMapProvisioning
//
//  Created by MacBook  on 8/21/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import "RMSManageStore.h"

@interface RMSManageStore ()

@end

@implementation RMSManageStore
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

      self.dbManager=[[RMSDBManager alloc]init];
    
    self.capturedImages = [[NSMutableArray alloc] init];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.showCameraBtn.hidden=true;
    }
    
    if(self.currentStore!=nil )
    {
        self.storeNameTxt.text=self.currentStore.storeName;
       self.storeDescTxt.text= self.currentStore.storeDesc;
        
         UIImage *img=[UIImage imageWithData:self.currentStore.storePlanImgData];[ self.storeImageView setImage:img];
        
        self.currentStore.storePlanImgData=[NSData dataWithData:UIImagePNGRepresentation(self.storeImageView.image)];
    }
    
  [self hidestatusbar ];
}


- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
   [self hidestatusbar ];
    if (self.storeImageView.isAnimating)
    {
        [self.storeImageView stopAnimating];
    }
    
    if (self.capturedImages.count > 0)
    {
        [self.capturedImages removeAllObjects];
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    imagePickerController.preferredContentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        /*
         The user wants to use the camera interface. Set up our custom overlay view for the camera.
         */
        //imagePickerController.showsCameraControls = NO;
        
        /*
         Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
         */
        //  [[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil];
        //self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
        //imagePickerController.cameraOverlayView = self.overlayView;
        //self.overlayView = nil;
    }
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}


- (void)finishAndUpdate
{
    [self dismissViewControllerAnimated:YES completion:NULL];
  
    [self hidestatusbar ];
    if ([self.capturedImages count] > 0)
    {
        if ([self.capturedImages count] == 1)
        {
            // Camera took a single picture.
            [self.storeImageView setImage:[self.capturedImages objectAtIndex:0]];
        }
        else
        {
            // Camera took multiple pictures; use the list of images for animation.
            self.storeImageView.animationImages = self.capturedImages;
            self.storeImageView.animationDuration = 5.0;    // Show each captured photo for 5 seconds.
            self.storeImageView.animationRepeatCount = 0;   // Animate forever (show all photos).
            [self.storeImageView startAnimating];
        }
        
        // To be ready to start again, clear the captured images array.
        [self.capturedImages removeAllObjects];
    }
    
    self.imagePickerController = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
   [self hidestatusbar ];
}

- (void)viewWillDisappear:(BOOL)animated {
    
   [self hidestatusbar ];

}

- (IBAction)SavePhoto:(id)sender {
   
   // if(self.currentStore==nil || self.currentStore==NULL)
    //self.currentStore=[RMSStore init];
    RMSStore *store=[RMSStore alloc];
    
    store.storeId=self.currentStore.storeId;
    store.storeName=self.storeNameTxt.text;
    store.storeDesc=self.storeDescTxt.text;
    store.storePlanImgData=[NSData dataWithData:UIImagePNGRepresentation(self.storeImageView.image)];
   
    [self.dbManager SaveStore:store forOrg:@"1"];
    
    [self.parent.sensosrPopupView dismissPopoverAnimated:YES];
    [self.parent loadStores];
    
 //   [self.navigationController popViewControllerAnimated:TRUE];
    }

- (IBAction)showCamera:(id)sender {
   [self hidestatusbar ];
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)showGallery:(id)sender {
    [self hidestatusbar ];
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
   [self hidestatusbar ];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self.capturedImages addObject:image];
    
//    if ([self.cameraTimer isValid])
//    {
//        return;
//    }
    
    [self finishAndUpdate];
}

-(void)hidestatusbar
{
    //  [self.navigationController.navigationBar setHidden :TRUE];
    
//    
//    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//        
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    }
    
  //  _defaultImage = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    
   // [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
   // [self setNeedsStatusBarAppearanceUpdate];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self hidestatusbar ];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
