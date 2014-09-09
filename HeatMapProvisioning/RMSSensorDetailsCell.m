//
//  RMSSensorDetailsCell.m
//  HeatMapProvisioning
//
//  Created by MacBook  on 8/15/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import "RMSSensorDetailsCell.h"

@implementation RMSSensorDetailsCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadSensor
{
    self.sensorNameLbl.text=self.currentSensor.sensorSerialNumber;
     self.sensorMACAddressLbl.text=self.currentSensor.sensorMACAddress;
    
    self.sensorDescLbl.text=self.currentSensor.sensorDesc;
     self.SensorPositionLbl.text=[NSString stringWithFormat:@"( %@ , %@ )",self.currentSensor.sensor_X_axis,self.currentSensor.sensor_Y_axis] ;
    
    if([self.currentSensor.deviceType isEqualToString:@"1"])
    {
        self.sensorImg.image = [UIImage imageNamed:@"imgGateway.png"];
    }
    else
    {
        self.sensorImg.image = [UIImage imageNamed:@"imgSensor.png"];
    }
    
}
-(void)loadDefaults{
    self.sensorNameLbl.text=@"Serial Number";
    self.sensorMACAddressLbl.text=@"MAC Address";
    self.sensorDescLbl.text=@"Description";
    self.SensorPositionLbl.text=@"Position( x , y )" ;
}

-(void)loadStore
{
    self.sensorNameLbl.text=self.currentStore.storeName;
    self.sensorMACAddressLbl.text=self.currentStore.storeDesc;
    
    self.sensorDescLbl.text=self.currentStore.sensorsCount;
    self.SensorPositionLbl.text= @"" ;
}

@end
