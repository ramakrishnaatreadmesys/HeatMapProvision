//
//  RMSStoresInfo.m
//  HeatMapProvisioning
//
//  Created by MacBook  on 8/20/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import "RMSStoresInfo.h"
#import "RMSStoreImageCell.h"
#import "popViewController.h"
#import "RMSManageStore.h"
#import "RMSStoresManagementTableViewController.h"
#import "RMSStoreSensors.h"
#import "RMSScanner.h"
#import "RMSUtil.h"
@interface RMSStoresInfo ()

@end

@implementation RMSStoresInfo

CGFloat lastScale;
CGFloat lastRotation;
CGFloat firstX;
CGFloat firstY;
bool lockScreen=false;
UIView *selectedParentView;
CGPoint previousPoint ;
RMSUtil *util ;


NSArray *selectedGatewaySensors;

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
    util=[[RMSUtil alloc]init];
    self.dbManager=[[RMSDBManager alloc]init];
    [self loadStores];
    
    //gateway view config
    [self.gatewaysView.layer setBorderColor: [[UIColor blueColor] CGColor]];
    [self.gatewaysView.layer setBorderWidth: 2.0];
    for (UIImageView *iView in self.gatewaysView.subviews) {
        iView.userInteractionEnabled=true;
    }
    [self.gatewaysView  setUserInteractionEnabled:true];
    
    //sensor view config
    [self.sensorsView.layer setBorderColor: [[UIColor blueColor] CGColor]];
    [self.sensorsView.layer setBorderWidth: 2.0];
    for (UIImageView *iView in self.sensorsView.subviews) {
        iView.userInteractionEnabled=true;
    }
    [self.sensorsView  setUserInteractionEnabled:true];
    
    self.scroolView.delegate = self;
    [self.scroolView  setUserInteractionEnabled:true];
    //   [self.scroolView setCanCancelContentTouches:YES];
    [self.scroolView.layer setBorderColor: [[UIColor blueColor] CGColor]];
    [self.scroolView.layer setBorderWidth: 2.0];
    self.scroolView.backgroundColor = [UIColor blackColor];
    self.scroolView.minimumZoomScale = 1.0  ;
    self.scroolView.maximumZoomScale = 10.0;
    self.scroolView.zoomScale = 1.0;
    self.scroolView.delegate = self;
    
    [self.storeMapImageView  setUserInteractionEnabled:true];
    //  self.storeMapImageView.center = self.scroolView.center;
    [self.storesTableView.layer setBorderColor: [[UIColor blueColor] CGColor]];
    [self.storesTableView.layer setBorderWidth: 2.0];
    
    
    // UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Lock" style:UIBarButtonItemStylePlain target:self action:@selector(LockandUnlock:)];
    // self.navigationItem.rightBarButtonItem = anotherButton;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0f, 0.0f, 293.0f, 50.0f)];
    [btn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"safewayLogo.gif"] forState:UIControlStateNormal];
   // UIBarButtonItem *eng_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
   // self.navigationItem.rightBarButtonItem = eng_btn;
    
     self.navigationItem.titleView = btn;
    
}

- (void)showStoreSensors:(id)sender {
    
    long index=((UIButton *)sender).tag;
    
    RMSStoreSensors *ManageStoreViewController =  [[RMSStoreSensors alloc] initWithNibName:@"RMSStoreSensors" bundle:nil];
    //  nextViewController.currentStore=self.currentStore;
    // [self presentModalViewController:nextViewController animated:YES];
    //    [self.parent.navigationController pushViewController:nextViewController animated:YES];
    //
    //    RMSManageStore *ManageStoreViewController =  [[RMSManageStore alloc] initWithNibName:@"RMSManageStore" bundle:nil];
    //
    if(index>=0){
        RMSStore *store=(RMSStore *) [self.storesArray objectAtIndex:index];
        ManageStoreViewController.currentStore=store;
    }
    
    self.sensosrPopupView = [[UIPopoverController alloc] initWithContentViewController:ManageStoreViewController];
    
    [self.sensosrPopupView setPopoverContentSize:CGSizeMake( ManageStoreViewController.view.frame.size.width, ManageStoreViewController.view.frame.size.height)];
    
    [self.sensosrPopupView presentPopoverFromRect:CGRectMake(10,10, 10.0,10.0)
                                          inView:((UIButton *)sender)
                        permittedArrowDirections:  UIPopoverArrowDirectionLeft |UIPopoverArrowDirectionRight
                                        animated:YES];
    
}

-(void)loadStores
{
     self.storesArray=[self.dbManager loadStors:[util GetOrgId]];
    //Loading firstStoreDetails by default
    if(self.storesArray!=nil && self.storesArray.count>0){
        if(self.currentStore==nil)
        self.currentStore=(RMSStore *)[self.storesArray objectAtIndex:0];
        [self loadSelectedStoreSensors : self.currentStore];
    }
    [self.storesTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.storesArray=[self.dbManager loadStors: [util GetOrgId]];
    [self.storesTableView reloadData];
    
    // self.title=@"Safe Way Store Information";
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.toolbarHidden = NO;
    self.navigationController.navigationBar.backgroundColor= [UIColor colorWithRed:57.0/255.0 green:158.0/255 blue:209.0/255 alpha:1.0];
    self.navigationController.toolbar.backgroundColor= [UIColor colorWithRed:57.0/255.0 green:158.0/255 blue:209.0/255 alpha:1.0];
    
    [self changeViewsByOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;
    
}
//- (IBAction)LockandUnlock:(id)sender {
//
//}

-(IBAction)LockandUnlock:(id)sender
{
    if( [self.lockBtn.titleLabel.text isEqualToString: @"Lock"])
    {
        lockScreen=true;
        [self.lockBtn setTitle: @"UnLock" forState: UIControlStateNormal];
    }
    else{
        lockScreen=false;
        [self.lockBtn setTitle: @"Lock" forState: UIControlStateNormal];
    }
    
    for (UIImageView *iView in self.gatewaysView.subviews) {
        iView.userInteractionEnabled=!lockScreen;
    }
    
    for (UIImageView *iView in self.sensorsView.subviews) {
        iView.userInteractionEnabled=!lockScreen;
    }
    
  //  UIImage *tempimg=[UIImage imageNamed:@"imgSensor.png"];
    for (UIImageView *iView in self.storeMapImageView.subviews) {
      //  if ([iView.image isEqual:tempimg] )
        iView.userInteractionEnabled=!lockScreen;
        }
    
    self.scroolView.userInteractionEnabled=!lockScreen;
    self.gatewaysView.userInteractionEnabled=!lockScreen;
    self.sensorsView.userInteractionEnabled=!lockScreen;
}


-(void)move:(id)sender {
    
    UIPanGestureRecognizer   *recognizer=(UIPanGestureRecognizer*)sender;
    
    if (recognizer.state==UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateEnded){
        UIView *superview = recognizer.view.superview;
        CGSize superviewSize = superview.bounds.size;
        CGSize thisSize = recognizer.view.frame.size;
        CGPoint translation = [recognizer translationInView:self.storeMapImageView];
        
        CGPoint center = CGPointMake(recognizer.view.center.x + translation.x,
                                     recognizer.view.center.y + translation.y);
        
        CGPoint resetTranslation = CGPointMake(translation.x, translation.y);
        
        if(center.x - thisSize.width/2 < 0)
            center.x = thisSize.width/2;
        else if (center.x + thisSize.width/2 > superviewSize.width)
            center.x = superviewSize.width-thisSize.width/2;
        else
            resetTranslation.x = 0; //Only reset the horizontal translation if the view *did* translate horizontally
        
        if(center.y - thisSize.height/2 < 0)
            center.y = thisSize.height/2;
        else if(center.y + thisSize.height/2 > superviewSize.height)
            center.y = superviewSize.height-thisSize.height/2;
        else
            resetTranslation.y = 0; //Only reset the vertical translation if the view *did* translate vertically
        
        recognizer.view.center = center;
        RMSSensor *sensor=[[RMSSensor alloc]init];
        
        sensor.sensorID=[NSString stringWithFormat:@"%ld", (long)((UIImageView *)recognizer.view).tag];
        
        if (recognizer.state == UIGestureRecognizerStateEnded){
            
            sensor.sensor_X_axis=[NSString stringWithFormat:@"%f", center.x ];
            sensor.sensor_Y_axis=[NSString stringWithFormat:@"%f", center.y];
            [self.dbManager SaveSensorLocation:sensor];
         //   NSLog(@"Location updated on save (%f,%f)",center.x,center.y);
        }
        
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.storeMapImageView];
        
    }
}

-(void)changeViewsByOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:0.5];
    
    CGRect scrollViewframe = self.scroolView.frame;
    CGRect GatewaysSourceViewframe = self.GatewaysSourceView.frame;
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    { // portrait
        scrollViewframe.origin.x = 32.0f;
        scrollViewframe.origin.y =115.0f;
        
        GatewaysSourceViewframe.origin.x = 100.0f;
        GatewaysSourceViewframe.origin.y =69.0f;
        self.storesTableView.hidden=true;
        
    }else
    {// landscape
        scrollViewframe.origin.x = 188.0f;
        scrollViewframe.origin.y =115.0f;
        
        GatewaysSourceViewframe.origin.x = 278.0f;
        GatewaysSourceViewframe.origin.y =69.0f;
        self.storesTableView.hidden=false;
    }
    self.scroolView.frame = scrollViewframe;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self changeViewsByOrientation:toInterfaceOrientation];
}

- (void)handleSingleTap:(UIGestureRecognizer *)tapRecognizer {
    
    bool isGatewaySelectedAlready=false;
    UIImageView *view = (UIImageView *)tapRecognizer.view;
    if(CGColorEqualToColor([view.layer borderColor], [[UIColor redColor] CGColor]))
    {
        isGatewaySelectedAlready=true;
    }
    
    for (UIImageView *iView in self.storeMapImageView.subviews) {
        [iView.layer setBorderColor: [[UIColor clearColor] CGColor]];
    }
    
    //CGPoint locationimg = [tapRecognizer locationInView: self.storeMapImageView];
    if(!isGatewaySelectedAlready){
        [view.layer setBorderColor: [[UIColor redColor] CGColor]];
        [view.layer setBorderWidth: 2.0];
        
        selectedGatewaySensors=[self.dbManager loadSensorsByGateway:[NSString stringWithFormat:@"%ld",(long)view.tag]];
        
        for(int i=0;i<selectedGatewaySensors.count;i++)
        {
            RMSSensor *sensor=[selectedGatewaySensors objectAtIndex:i];
            
            UIView *thisView = (UIView*)[self.storeMapImageView viewWithTag:
                                         [sensor.sensorID intValue] ];
            
            if(thisView!=nil){
                [thisView.layer setBorderColor: [[UIColor redColor] CGColor]];
                [thisView.layer setBorderWidth: 2.0];
            }
        }
    }
}

//tuch events start

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!lockScreen)
    {
        if ([touches count] == 1) {
            
            UITouch *touch = [touches anyObject];
            selectedParentView=  touch.view.superview;
            
            if(selectedParentView==self.gatewaysView)
            {
                //clears previous selection
                self.dragObject=nil;
                
                CGPoint touchPoint = [[touches anyObject] locationInView:self.gatewaysView];
                
                for (UIImageView *iView in self.gatewaysView.subviews) {
                    [iView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
                }
                
                for (UIImageView *iView in self.gatewaysView.subviews) {
                    
                    if (touchPoint.x > iView.frame.origin.x &&
                        touchPoint.x < (iView.frame.origin.x + iView.frame.size.width) &&
                        touchPoint.y > iView.frame.origin.y &&
                        touchPoint.y < (iView.frame.origin.y + iView.frame.size.height))
                    {
                        
                        self.dragObject = iView;
                        // self.dragObject.tag=self.nextId++;
                        
                        [iView.layer setBorderColor: [[UIColor blueColor] CGColor]];
                        [iView.layer setBorderWidth: 2.0];
                        self.touchOffset = CGPointMake(touchPoint.x - iView.frame.origin.x,
                                                       touchPoint.y - iView.frame.origin.y);
                        
                        
                    }
                }
            }
            else if(selectedParentView==self.sensorsView)
            {
                
                //clears previous selection
                self.dragObject=nil;
                
                CGPoint touchPoint = [[touches anyObject] locationInView:self.sensorsView];
                
                for (UIImageView *iView in self.sensorsView.subviews) {
                    [iView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
                }
                
                for (UIImageView *iView in self.sensorsView.subviews) {
                    
                    if (touchPoint.x > iView.frame.origin.x &&
                        touchPoint.x < (iView.frame.origin.x + iView.frame.size.width) &&
                        touchPoint.y > iView.frame.origin.y &&
                        touchPoint.y < (iView.frame.origin.y + iView.frame.size.height))
                    {
                        
                        self.dragObject = iView;
                        // self.dragObject.tag=self.nextId++;
                        
                        [iView.layer setBorderColor: [[UIColor blueColor] CGColor]];
                        [iView.layer setBorderWidth: 2.0];
                        self.touchOffset = CGPointMake(touchPoint.x - iView.frame.origin.x,
                                                       touchPoint.y - iView.frame.origin.y);
                        
                        
                    }
                }
                
            }
            
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!lockScreen)
    {
        //   // UIView *dragView = [[touches anyObject] view];
        //    //CGPoint newCenter = [[touches anyObject] locationInView:dragView.superview];
        //
        //
        //   CGPoint touchPoint = [[touches anyObject] locationInView:self.dragObject];
        ////    // here I use the superview, but I also want to use the ScrollView
        ////
        //    CGRect newDragObjectFrame = CGRectMake(touchPoint.x - self.touchOffset.x,
        //                                           touchPoint.y - self.touchOffset.y,
        //                                           self.dragObject.frame.size.width,
        //                                           self.dragObject.frame.size.height);
        //    self.dragObject.frame = newDragObjectFrame;
        ////
        ////
        //    [UIView beginAnimations:nil context:NULL];
        //    [UIView setAnimationDuration:.35];
        //    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        //    [self.dragObject setCenter:CGPointMake(newDragObjectFrame.origin.x, newDragObjectFrame.origin.y)];
        //    [UIView commitAnimations];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!lockScreen)
    {
        if( self.dragObject!=nil){
            
            CGPoint nowPoint = [touches.anyObject locationInView:self.storeMapImageView];
            
            CGRect rect = self.storeMapImageView.frame;
            
            if(CGRectContainsPoint(rect, nowPoint))
            {
                UIImageView *starImgView = [[UIImageView alloc] initWithFrame:CGRectMake(nowPoint.x, nowPoint.y, 30, 30)]; //create ImageView
                [starImgView setUserInteractionEnabled:true];
                
                
                if(selectedParentView==self.gatewaysView)
                {
                    starImgView.image = [UIImage imageNamed:@"imgGateway.png"];
                }
                else if(selectedParentView==self.sensorsView)
                {
                    starImgView.image = [UIImage imageNamed:@"imgSensor.png"];
                    
                }
                
                //Pan Gesture
                UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
                [panRecognizer setMinimumNumberOfTouches:1];
                [panRecognizer setMaximumNumberOfTouches:1];
                //[panRecognizer setDelegate:self];
                [starImgView  addGestureRecognizer:panRecognizer];
                
                //after zoom the image , if want gateways or sensors should be dragged, put the following line
                [self.scroolView.panGestureRecognizer requireGestureRecognizerToFail:panRecognizer];
                
                popViewController *testViewController =  [[popViewController alloc] initWithNibName:@"popViewController" bundle:nil];
                testViewController.parent1=self;
                testViewController.currentStore=self.currentStore;
                testViewController.x_axis=nowPoint.x;
                testViewController.y_axis=nowPoint.y;
                testViewController.deviceType=(selectedParentView==self.gatewaysView)?@"1":@"2";
                
                self.sensosrPopupView = [[UIPopoverController alloc] initWithContentViewController:testViewController];
                self.sensosrPopupView.delegate=self;
                [self.sensosrPopupView setPopoverContentSize:CGSizeMake( testViewController.view.frame.size.width, testViewController.view.frame.size.height)];
                
                [self.sensosrPopupView presentPopoverFromRect:CGRectMake(nowPoint.x, nowPoint.y, 10.0,10.0)
                                                      inView:self.storeMapImageView
                                    permittedArrowDirections:  UIPopoverArrowDirectionLeft |UIPopoverArrowDirectionRight
                                                    animated:YES];
                
                [self.storeMapImageView addSubview:starImgView];
            }
            self.dragObject = nil;
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesCancelled:touches withEvent:event];
}

//tuch events end


-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // return which subview we want to zoom
    return self.storeMapImageView;
}

-(void)loadSelectedStoreSensors:(RMSStore *)store
{
    //Clear already added sensors
    [self.storeMapImageView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    UIImage *img=[UIImage imageWithData:store.storePlanImgData];
    [self.storeMapImageView setImage:img];
     self.scroolView.zoomScale = 1.0;
    
    //   self.storeMapImageView.center = self.scroolView.center;
    self.storeSensorsArray=[self.dbManager loadSensors:store.storeId];
    
    for(int i=0; i<self.storeSensorsArray.count;i++)
    {
        RMSSensor *nextSensor=(RMSSensor *)[self.storeSensorsArray objectAtIndex:i];
        
        UIImageView *starImgView = [[UIImageView alloc] initWithFrame:CGRectMake([nextSensor.sensor_X_axis floatValue]-15,[ nextSensor.sensor_Y_axis floatValue]-15, 30, 30)]; //create ImageView
     
        
        [starImgView setUserInteractionEnabled:true];
        starImgView.tag=[ nextSensor.sensorID intValue];
        
        if([nextSensor.deviceType isEqualToString:@"1"])
        {
            starImgView.image = [UIImage imageNamed:@"imgGateway.png"];
            
            //Tap Gesture
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [singleTap setNumberOfTapsRequired:2];
            [starImgView addGestureRecognizer:singleTap];
        }
        else
        {
            starImgView.image = [UIImage imageNamed:@"imgSensor.png"];
        }
        
        
        //Pan Gesture
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        [panRecognizer setMinimumNumberOfTouches:1];
        [panRecognizer setMaximumNumberOfTouches:1];
        //[panRecognizer setDelegate:self];
        [starImgView  addGestureRecognizer:panRecognizer];
        
        //after zoom the image , if want gateways or sencors should be dragged, put the following line
        [self.scroolView.panGestureRecognizer requireGestureRecognizerToFail:panRecognizer];
        
        [self.storeMapImageView addSubview:starImgView];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.storesTableView)
        return self.storesArray.count;
    else  if(tableView==self.gatewaysTableView)
        return self.gatewaysArray.count;
    else  if(tableView==self.sensorsTableView)
        return self.sensorsArray.count;
    else return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.storesTableView)
        return 140;
    else  if(tableView==self.gatewaysTableView)
        return 50;
    else  if(tableView==self.sensorsTableView)
        return 50;
    else return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.storesTableView)
    {
        RMSStoreImageCell *cell = (RMSStoreImageCell *)[tableView dequeueReusableCellWithIdentifier:@"StoreImageCell"];
        
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RMSStoreImageCell" owner:self options:nil];
            for (id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell =  (RMSStoreImageCell *) currentObject;
                    break;
                }
            }
        }
       // [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
       
        [cell.editStoreBtn addTarget:self action:@selector(editStore:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.storeNameBtn addTarget:self action:@selector(showStoreSensors:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.currentStore=(RMSStore *)[self.storesArray objectAtIndex:indexPath.row];
          cell.storeNameBtn.tag=indexPath.row;
        cell.editStoreBtn.tag=indexPath.row;
        cell.parent=self;
        [cell Bind];
        
        if(  [self.currentStore.storeId isEqualToString: cell.currentStore.storeId])
        {
            [self.storesTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:
          UITableViewScrollPositionNone];
            
            [self.storesTableView.delegate tableView:self.storesTableView didSelectRowAtIndexPath:indexPath];
            

           // [ cell setSelected:true];
        }
        return cell;
    }
    else if(tableView==self.gatewaysTableView)
    {
        
        RMSStoreImageCell *cell = (RMSStoreImageCell *)[tableView dequeueReusableCellWithIdentifier:@"StoreImageCell"];
        
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RMSStoreImageCell" owner:self options:nil];
            for (id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell =  (RMSStoreImageCell *) currentObject;
                    break;
                }
            }
        }
       // [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        if(  [self.currentStore.storeId isEqualToString: cell.currentStore.storeId])
        {
            [ cell setSelected:true];
        }
        return cell;
    }
    else if(tableView==self.sensorsTableView)
    {
        
        RMSStoreImageCell *cell = (RMSStoreImageCell *)[tableView dequeueReusableCellWithIdentifier:@"StoreImageCell"];
        
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RMSStoreImageCell" owner:self options:nil];
            for (id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell =  (RMSStoreImageCell *) currentObject;
                    break;
                }
            }
        }
        //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        if(  [self.currentStore.storeId isEqualToString: cell.currentStore.storeId])
        {
            [ cell setSelected:true];
        }
        return cell;
    }
    else return nil;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    self.currentStore=(RMSStore *)[self.storesArray objectAtIndex:indexPath.row];
    [self loadSelectedStoreSensors :self.currentStore];
    
}
- (IBAction)showStorsInList:(id)sender {
    
    RMSStoresManagementTableViewController *nextViewController =  [[RMSStoresManagementTableViewController alloc] initWithNibName:@"RMSStoresManagementTableViewController" bundle:nil];
    
    [self.navigationController pushViewController:nextViewController animated:YES];
    
}

- (void) popoverControllerDidDismissPopover:(UIPopoverController *) popoverController {
    //do stuff here...
     [self loadSelectedStoreSensors : self.currentStore];
}

- (IBAction)editStore:(id)sender {
    UIButton *editbtn=(UIButton *)sender;
    
    RMSManageStore *ManageStoreViewController =  [[RMSManageStore alloc] initWithNibName:@"RMSManageStore" bundle:nil];
    
    ManageStoreViewController.parent=self;
    ManageStoreViewController.currentStore=(RMSStore *)[self.storesArray objectAtIndex:editbtn.tag];
    
    self.sensosrPopupView = [[UIPopoverController alloc] initWithContentViewController:ManageStoreViewController];
    self.sensosrPopupView.delegate=self;
    [self.sensosrPopupView setPopoverContentSize:CGSizeMake( ManageStoreViewController.view.frame.size.width, ManageStoreViewController.view.frame.size.height)];
    
    [self.sensosrPopupView presentPopoverFromRect:CGRectMake(10,10, 10.0,10.0)
                                          inView:(UIButton *)sender
                        permittedArrowDirections:  UIPopoverArrowDirectionLeft |UIPopoverArrowDirectionRight
                                        animated:YES];
}

- (IBAction)addStore:(id)sender {
    
    RMSManageStore *ManageStoreViewController =  [[RMSManageStore alloc] initWithNibName:@"RMSManageStore" bundle:nil];
    
    //  ManageStoreViewController.currentStore=self.currentStore;
    ManageStoreViewController.parent=self;
    
    self.sensosrPopupView = [[UIPopoverController alloc] initWithContentViewController:ManageStoreViewController];
    self.sensosrPopupView.delegate=self;
    [self.sensosrPopupView setPopoverContentSize:CGSizeMake( ManageStoreViewController.view.frame.size.width, ManageStoreViewController.view.frame.size.height)];
    
    [self.sensosrPopupView presentPopoverFromRect:CGRectMake(10,10, 10.0,10.0)
                                          inView:(UIButton *)sender
                        permittedArrowDirections:  UIPopoverArrowDirectionLeft |UIPopoverArrowDirectionRight
                                        animated:YES];
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView  {
    //handle subviews  not to zoom
    for(UIView *view in self.storeMapImageView.subviews){
    [view setTransform:CGAffineTransformMakeScale(1/scrollView.zoomScale, 1/scrollView.zoomScale)];
    }
}

- (IBAction)Scan:(id)sender {
    
    long index=((UIButton *)sender).tag;
    
    RMSScanner *ManageStoreViewController =  [[RMSScanner alloc] initWithNibName:@"RMSScanner" bundle:nil];
    
    if(index>=0){
        RMSStore *store=(RMSStore *) [self.storesArray objectAtIndex:index];
        ManageStoreViewController.currentStore=store;
    }
    ManageStoreViewController.parent1=self;
    
    self.sensosrPopupView = [[UIPopoverController alloc] initWithContentViewController:ManageStoreViewController];
    
    [self.sensosrPopupView setPopoverContentSize:CGSizeMake( ManageStoreViewController.view.frame.size.width, ManageStoreViewController.view.frame.size.height)];
    
    [self.sensosrPopupView presentPopoverFromRect:CGRectMake(10,10, 10.0,10.0)
                                           inView:((UIButton *)sender)
                         permittedArrowDirections:  UIPopoverArrowDirectionLeft |UIPopoverArrowDirectionRight
                                         animated:YES];

    
}
@end
