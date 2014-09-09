//
//  RMSStoreImageCell.m
//  HeatMapProvisioning
//
//  Created by MacBook  on 8/20/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import "RMSStoreImageCell.h"
#import "RMSManageStore.h"
@implementation RMSStoreImageCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)Bind
{
  //   self.containerView.backgroundColor = [UIColor blackColor];
    
    [self.storeNameBtn setTitle:[NSString stringWithFormat:@"%@ (%@)",  self.currentStore.storeName,self.currentStore.sensorsCount] forState:UIControlStateNormal];
      
    //// Start of optimisation - for iamges to load dynamically in cell with delay , make sure you call this function in performSelectorinBackground./////
    
    //Setting nil if any for safety
    self.storePlanImageView.image = nil;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    dispatch_async(queue, ^{
      UIImage *img=[UIImage imageWithData:self.currentStore.storePlanImgData]; // Load from file or Bundle as you want
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            //Set the image to image view not, wither cell.imageview or [cell add subviw:imageview later ]
            [ self.storePlanImageView setImage:img];
            [ self.storePlanImageView setNeedsLayout];
        });
    });
    
    //// End of optimisation/////
    
}

- (IBAction)editStore:(id)sender {
    RMSManageStore *ManageStoreViewController =  [[RMSManageStore alloc] initWithNibName:@"RMSManageStore" bundle:nil];
    
    ManageStoreViewController.parent=self.parent;
     ManageStoreViewController.currentStore=self.currentStore;
    
   self.popoverController = [[UIPopoverController alloc] initWithContentViewController:ManageStoreViewController];
    
    [self.popoverController setPopoverContentSize:CGSizeMake( ManageStoreViewController.view.frame.size.width, ManageStoreViewController.view.frame.size.height)];
    
    [self.popoverController presentPopoverFromRect:CGRectMake(10,10, 10.0,10.0)
                                          inView:self
                        permittedArrowDirections:  UIPopoverArrowDirectionLeft |UIPopoverArrowDirectionRight
                                        animated:YES];
}
@end
