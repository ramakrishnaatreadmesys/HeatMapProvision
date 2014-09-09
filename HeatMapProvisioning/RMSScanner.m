//
//  RMSScanner.m
//  HeatMapProvisioning
//
//  Created by MacBook  on 9/5/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import "RMSScanner.h"
#import "Barcode.h"
#import "RMSSensor.h"
#import "RMSUtil.h"
@interface RMSScanner ()
@property (strong, nonatomic) NSMutableArray * foundBarcodes;
@property (weak, nonatomic) IBOutlet UIView *previewView;

//@property (strong, nonatomic) SettingsViewController * settingsVC;

@end

@implementation RMSScanner
AVCaptureSession *_captureSession;
AVCaptureDevice *_videoDevice;
AVCaptureDeviceInput *_videoInput;
AVCaptureVideoPreviewLayer *_previewLayer;
BOOL _running;
AVCaptureMetadataOutput *_metadataOutput;
NSString *serialNumber;
NSString *MACAddress;
 int ScanAction;

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
    
    [self setupCaptureSession];
    _previewLayer.frame = _previewView.bounds;
    [_previewView.layer addSublayer:_previewLayer];
    self.foundBarcodes = [[NSMutableArray alloc] init];
    
    // listen for going into the background and stop the session
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillEnterForeground:)
     name:UIApplicationWillEnterForegroundNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationDidEnterBackground:)
     name:UIApplicationDidEnterBackgroundNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    // set default allowed barcode types, remove types via setings menu if you don't want them to be able to be scanned
    self.allowedBarcodeTypes = [NSMutableArray new];
//    [self.allowedBarcodeTypes addObject:@"org.iso.QRCode"];
//    [self.allowedBarcodeTypes addObject:@"org.iso.PDF417"];
//    [self.allowedBarcodeTypes addObject:@"org.gs1.UPC-E"];
//    [self.allowedBarcodeTypes addObject:@"org.iso.Aztec"];
//    [self.allowedBarcodeTypes addObject:@"org.iso.Code39"];
//    [self.allowedBarcodeTypes addObject:@"org.iso.Code39Mod43"];
//    [self.allowedBarcodeTypes addObject:@"org.gs1.EAN-13"];
//    [self.allowedBarcodeTypes addObject:@"org.gs1.EAN-8"];
//    [self.allowedBarcodeTypes addObject:@"com.intermec.Code93"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Code128"];
 [self cleardata];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
     [self cleardata];
    [self reset];
    [self startRunning];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     [self cleardata];
    [self stopRunning];
    _captureSession=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) orientationChanged
{
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (deviceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        [_previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
    
    else if (deviceOrientation == UIInterfaceOrientationPortrait)
        [_previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
    else if (deviceOrientation == UIInterfaceOrientationLandscapeLeft)
        [_previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
    
    else
        [_previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
}

#pragma mark - AV capture methods

- (void)setupCaptureSession {
    // 1
    if (_captureSession) return;
    // 2
    _videoDevice = [AVCaptureDevice
                    defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!_videoDevice) {
        NSLog(@"No video camera on this device!");
        return;
    }
    // 3
    _captureSession = [[AVCaptureSession alloc] init];
    // 4
    _videoInput = [[AVCaptureDeviceInput alloc]
                   initWithDevice:_videoDevice error:nil];
    // 5
    if ([_captureSession canAddInput:_videoInput]) {
        [_captureSession addInput:_videoInput];
    }
    // 6
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc]
                     initWithSession:_captureSession];
    _previewLayer.videoGravity =
    AVLayerVideoGravityResizeAspectFill;
    
    // capture and process the metadata
    _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    dispatch_queue_t metadataQueue =
    dispatch_queue_create("com.1337labz.featurebuild.metadata", 0);
    [_metadataOutput setMetadataObjectsDelegate:self
                                          queue:metadataQueue];
    if ([_captureSession canAddOutput:_metadataOutput]) {
        [_captureSession addOutput:_metadataOutput];
    }
    
}

- (void)startRunning {
  
    if (_running)
        [_captureSession stopRunning];
    
    if(ScanAction==0)
    {
        [_captureSession startRunning];
        [self.btnScan setTitle:@"Scan" forState:UIControlStateNormal];
        ScanAction=1;
    }else if(ScanAction==1)
    {
          //  [_captureSession stopRunning];
        
        _metadataOutput.metadataObjectTypes =
        _metadataOutput.availableMetadataObjectTypes;
         [_captureSession startRunning];
        [self.btnScan setHidden:YES];
    }
    
   // if (_running) return;
    //[_captureSession startRunning];
   // _metadataOutput.metadataObjectTypes =
   // _metadataOutput.availableMetadataObjectTypes;
    _running = YES;
}
- (void)stopRunning {
    if (!_running) return;
    _metadataOutput.metadataObjectTypes =nil;
    [_captureSession stopRunning];
  
    _running = NO;
}

//  handle going foreground/background
- (void)applicationWillEnterForeground:(NSNotification*)note {
    [self startRunning];
}
- (void)applicationDidEnterBackground:(NSNotification*)note {
    [self stopRunning];
}

//#pragma mark - Button action functions
//- (IBAction)settingsButtonPressed:(id)sender {
//    [self performSegueWithIdentifier:@"toSettings" sender:self];
//}
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"toSettings"]) {
//        self.settingsVC = (SettingsViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"SettingsViewController"];
//        self.settingsVC = segue.destinationViewController;
//        self.settingsVC.delegate = self;
//    }
//}


#pragma mark - Delegate functions

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    NSLog(@"count : %lu ",(unsigned long)[metadataObjects count]);
    
    [metadataObjects
     enumerateObjectsUsingBlock:^(AVMetadataObject *obj,
                                  NSUInteger idx,
                                  BOOL *stop)
     {
         if ([obj isKindOfClass:
              [AVMetadataMachineReadableCodeObject class]])
         {
             // 3
             AVMetadataMachineReadableCodeObject *code =
             (AVMetadataMachineReadableCodeObject*)
             [_previewLayer transformedMetadataObjectForMetadataObject:obj];
             // 4
             Barcode * barcode = [Barcode processMetadataObject:code];
             
             NSLog(@"index : %lu bar code : %@",(unsigned long)idx,barcode.getBarcodeData);
             
             for(NSString * str in self.allowedBarcodeTypes){
                 if([barcode.getBarcodeType isEqualToString:str]){
                     [self validBarcodeFound:barcode];
                     return;
                 }
             }
         }
     }];
}

- (void) validBarcodeFound:(Barcode *)barcode{
    [self stopRunning];
   
    if(serialNumber==nil||[serialNumber isEqualToString:@""])
    {
          serialNumber=barcode.getBarcodeData;
    }else{
         MACAddress=barcode.getBarcodeData;
    }
    
    [self.foundBarcodes addObject:barcode];
    [self showBarcodeAlert:barcode];
}
- (void) showBarcodeAlert:(Barcode *)barcode{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Code to do in background processing
        NSString * alertMessage = @"You found a barcode with type ";
        alertMessage = [alertMessage stringByAppendingString:[barcode getBarcodeType]];
        //        alertMessage = [alertMessage stringByAppendingString:@" and data "];
        //        alertMessage = [alertMessage stringByAppendingString:[barcode getBarcodeData]];
        alertMessage = [alertMessage stringByAppendingString:@"\n\nBarcode added to array of "];
        alertMessage = [alertMessage stringByAppendingString:[NSString stringWithFormat:@"%lu",(unsigned long)[self.foundBarcodes count]-1]];
        alertMessage = [alertMessage stringByAppendingString:@" previously found barcodes."];
        
      //  UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Barcode Found!" message:alertMessage delegate:self cancelButtonTitle:@"Done"  otherButtonTitles:@"Scan again",nil];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Code to update the UI/send notifications based on the results of the background processing
           // [message show];
             [self binddata ];
            
            [self reset];
           
        });
    });
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if(buttonIndex == 0){
//        //Code for Done button
//        // TODO: Create a finished view
//    }
//    if(buttonIndex == 1){
//        //Code for Scan more button
//        [self startRunning];
//    }
//}

//- (void) settingsChanged:(NSMutableArray *)allowedTypes{
//    for(NSObject * obj in allowedTypes){
//        NSLog(@"%@",obj);
//    }
//    if(allowedTypes){
//        self.allowedBarcodeTypes = [NSMutableArray arrayWithArray:allowedTypes];
//    }
//}

- (IBAction)startScanning:(id)sender {
     [self startRunning];
  //  [self startScan];
}

- (IBAction)clear:(id)sender {
    [self cleardata];
}
-(void) cleardata
{
    serialNumber=@"";
    MACAddress=@"";
    [self binddata ];
}
-(void)binddata
{
    [self.lblSerialNumber setText:serialNumber];
    [self.lblMacAddress setText:MACAddress];
}

-(void)reset
{
    ScanAction=0;
    [self.btnScan setTitle:@"Start" forState:UIControlStateNormal];
 //   _metadataOutput.metadataObjectTypes =nil;
     [self.btnScan setHidden:NO];
}

- (IBAction)SaveSensor:(id)sender {
    
    RMSSensor *sensor=[[RMSSensor alloc]init];
    
    sensor.storeId=self.currentStore.storeId;
//    if([self.deviceType isEqual:@"1"])
//    {
//        sensor.GatewayId=nil;
//        
//    }else{
//        sensor.GatewayId=selectedGatewayId;
//    }
    
    sensor.sensorSerialNumber=self.lblSerialNumber.text;
    sensor.sensorMACAddress=self.lblMacAddress.text;
    sensor.sensorDesc=@"";
    sensor.sensor_X_axis=[NSString stringWithFormat:@"%d",  50];
    sensor.sensor_Y_axis=[NSString stringWithFormat:@"%d",  50];
    sensor.deviceType= @"1";
    
    if([self.dbManager  SaveSensor:sensor])
    {
//        self.Statuslbl.text = @"Sensor added";
//        self.sensorNametxt.text = @"";
//        self.sensorDesctxt.text = @"";
//        
        [self.parent1.sensosrPopupView dismissPopoverAnimated:YES];
        [self.parent1 loadSelectedStoreSensors :self.currentStore];
        
    }
    else{
      //  self.Statuslbl.text = @"Failed to add Sensor";
        
    }
}

@end

