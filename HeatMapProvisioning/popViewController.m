//
//  popViewController.m
//  ReadMeProvisioning
//
//  Created by MacBook  on 8/7/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import "popViewController.h"

@interface popViewController ()

@end

@implementation popViewController

NSArray *gatewaysData;
DropDownView *dropDownView;
NSString *selectedGatewayId;


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
    
    if([self.deviceType isEqual:@"1"])
    {
        [self.gatewayBtn setHidden:true];
        [self.gatewayTitleLbl setHidden:true];
    }
    else{
        
        gatewaysData =[self.dbManager loadSensorsByType:self.currentStore.storeId forDeviceType:@"1"];
        
        NSMutableArray *gatewayNamesArray=[[NSMutableArray alloc]init];
        
        for (RMSSensor *sensor in gatewaysData)
        {
            [ gatewayNamesArray addObject:sensor.sensorSerialNumber];
        }
        
        if(gatewaysData.count>0)
        {
            [self.gatewayBtn setTitle:((RMSSensor *)[gatewaysData objectAtIndex:0]).sensorSerialNumber forState:UIControlStateNormal];
           
            selectedGatewayId=((RMSSensor *)[gatewaysData objectAtIndex:0]).sensorID;
            
            dropDownView = [[DropDownView alloc] initWithArrayData:gatewayNamesArray cellHeight:30 heightTableView:200 paddingTop:-8 paddingLeft:-5 paddingRight:-10 refView:self.gatewayBtn animation:BLENDIN openAnimationDuration:0.5 closeAnimationDuration:0.5]; 	dropDownView.delegate = self;
            
            [self.view addSubview:dropDownView.view];
            
        }
        [self.gatewayBtn setHidden:false];
        [self.gatewayTitleLbl setHidden:false];
    }
    
    
    self.addsensorView .backgroundColor = [UIColor whiteColor];
    self.addsensorView .layer.cornerRadius = 15.f;
    self.addsensorView .layer.borderColor = [UIColor blackColor].CGColor;
    self.addsensorView .layer.borderWidth = 2.f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)SaveSensor:(id)sender {
    
    RMSSensor *sensor=[[RMSSensor alloc]init];
   
    sensor.storeId=self.currentStore.storeId;
    if([self.deviceType isEqual:@"1"])
    {
        sensor.GatewayId=nil;
        
    }else{
        sensor.GatewayId=selectedGatewayId;
    }

    sensor.sensorSerialNumber=self.sensorNametxt.text;
    sensor.sensorMACAddress=self.sensorMacAddress.text;
    sensor.sensorDesc=self.sensorDesctxt.text;
    sensor.sensor_X_axis=[NSString stringWithFormat:@"%d",  self.x_axis];
    sensor.sensor_Y_axis=[NSString stringWithFormat:@"%d",  self.y_axis];
    sensor.deviceType= self.deviceType;
    
    if([self.dbManager  SaveSensor:sensor])
    {
        self.Statuslbl.text = @"Sensor added";
        self.sensorNametxt.text = @"";
        self.sensorDesctxt.text = @"";
        
        [self.parent1.sensosrPopupView dismissPopoverAnimated:YES];
        [self.parent1 loadSelectedStoreSensors :self.currentStore];
        
        }
        else{
           self.Statuslbl.text = @"Failed to add Sensor";
        
        }
}

- (IBAction)dismissPopUp:(id)sender {
    
    [self.parent1.sensosrPopupView dismissPopoverAnimated:YES];
 [self.parent1 loadSelectedStoreSensors :self.currentStore];
}


#pragma mark -
#pragma mark DropDownViewDelegate

-(void)dropDownCellSelected:(NSInteger)returnIndex{
	
	[self.gatewayBtn setTitle:((RMSSensor *)[gatewaysData objectAtIndex:returnIndex]).sensorSerialNumber  forState:UIControlStateNormal];
    selectedGatewayId=((RMSSensor *)[gatewaysData objectAtIndex:returnIndex]).sensorID;
}


#pragma mark -
#pragma mark Class methods

- (IBAction)BindGateways:(id)sender {
    [dropDownView openAnimation];
}
@end
