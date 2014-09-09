//
//  RMSDBManager.m
//  HeatMapProvisioning
//
//  Created by MacBook  on 8/20/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import "RMSDBManager.h"
#import "RMSUtil.h"
@implementation RMSDBManager

NSString *docsDir;
NSArray *dirPaths;
const char *dbpath;
sqlite3_stmt *statement;
NSMutableArray *data;
RMSUtil * util;
//-(id)init
//{
//    util=[[RMSUtil alloc]init];
//    
//    return nil;
//}

-(void)initDB
{
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"ReadMeSysProvision.db"]];
    dbpath = [_databasePath UTF8String];
}


-(void)createDatabase
{
    [self initDB];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS STORES (STOREID INTEGER PRIMARY KEY AUTOINCREMENT,ORGID INTEGER, STORE_NAME TEXT,HASSTOREPLAN INTEGER, STORE_DESCRIPTION TEXT,STOREIMAGE BLOB)";
            
            if (sqlite3_exec(_contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog( @"Failed to create table STORES");
            }
 
            sql_stmt =
            "CREATE TABLE IF NOT EXISTS SENSORS(SENSORID INTEGER PRIMARY KEY AUTOINCREMENT,STOREID INTEGER,DEVICETYPE INTEGER, SENSOR_SERIAL_NUMBER TEXT,SENSOR_MACADDRESS TEXT, SENSOR_DESCRIPTION TEXT, X_AXIS TEXT, Y_AXIS TEXT,GATEWAYID INTEGER)";
            
            //DEVICETYPE =1 MEANS GATEWAY AND DEVICETYPE=2 MEANS SENSOR
            if (sqlite3_exec(_contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog( @"Failed to create table SENSORS");
            }
            
            
            sqlite3_close(_contactDB);
        } else {
            NSLog( @"Failed to open/create database");
        }
    }
}

-(NSMutableArray *)loadStors:(NSString *)OrgId
{
    [self initDB];
   data=[[NSMutableArray alloc] init];
     
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        //  NSMutableArray *retval = [[NSMutableArray alloc] init];
        NSString *query =[NSString stringWithFormat:@"%@%@", @"SELECT STR.ORGID,STOREID, STR.STORE_NAME , STR.STORE_DESCRIPTION,(SELECT COUNT(SENSORID) FROM SENSORS  WHERE STOREID=STR.STOREID) ,STR.HASSTOREPLAN ,STOREIMAGE  FROM STORES STR where STR.ORGID=",OrgId ];
        
        if (sqlite3_prepare_v2(_contactDB, [query UTF8String], -1, &statement, nil)
            == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                RMSStore *currentStore=[RMSStore alloc];
                
                currentStore.orgId=[NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 0)] ;
                
                currentStore.storeId= [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 1)] ;
                
                currentStore.storeName= [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                currentStore.storeDesc= [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                currentStore.sensorsCount=[NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 4)] ;
                
                currentStore.HasStorePlan= sqlite3_column_int(statement, 5) ;
                
                int length = sqlite3_column_bytes(statement, 6);
               currentStore. storePlanImgData       = [NSData dataWithBytes:sqlite3_column_blob(statement, 6) length:length];
                
                [data addObject:currentStore];
                
            }
            sqlite3_finalize(statement);
        }
    }
    return data;
}

-(bool)SaveStore:(RMSStore *)currentStore forOrg:(NSString *)OrgId
{
    bool returnStatus=false;
    [self initDB];
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *sqlQuery;
        
        if(currentStore.storeId==nil || currentStore.storeId==0)
        {
            sqlQuery =  [NSString stringWithFormat:
                         @"INSERT INTO STORES (ORGID,STORE_NAME, STORE_DESCRIPTION,HASSTOREPLAN,STOREIMAGE) VALUES (\"%@\", \"%@\", \"%@\",1 ,?)",
                         OrgId,currentStore.storeName, currentStore.storeDesc];
        }
        else{
            sqlQuery = [NSString stringWithFormat:
                        @"UPDATE STORES SET STORE_NAME= \"%@\",STORE_DESCRIPTION= \"%@\",STOREIMAGE=?,HASSTOREPLAN=1  WHERE STOREID=%@",
                        currentStore.storeName,currentStore.storeDesc,currentStore.storeId];
        }
        
        
        const char *sql_stmt = [sqlQuery UTF8String];
        
        
        int result = sqlite3_prepare_v2(_contactDB, sql_stmt,
                                        -1, &statement, NULL);
        if(result != SQLITE_OK) {
            returnStatus=false;
            NSLog(@"Prepare-error #%i: %s", result, sqlite3_errmsg(_contactDB));
        }
        else{
            sqlite3_bind_blob(statement, 1, [currentStore.storePlanImgData  bytes], (int)[currentStore.storePlanImgData length], SQLITE_TRANSIENT);
            // sqlite3_step(statement);
            
            result = sqlite3_step(statement);
            if (result != SQLITE_DONE) {
                NSLog(@"Step-error #%i for '%@': %s", result, sqlQuery, sqlite3_errmsg(_contactDB));
                //self.statusLbl.text = @"Failed to upload Store Map";
           returnStatus=false ;
            }
            else{
                
               returnStatus=true;
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_contactDB);
    }
    return returnStatus;
}



-(NSMutableArray *)loadSensors:(NSString *)storeId
{
    [self initDB];
    data=[[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        //  NSMutableArray *retval = [[NSMutableArray alloc] init];
        NSString *query =[NSString stringWithFormat:@"%@%@", @"SELECT SENSORID, SENSOR_SERIAL_NUMBER ,SENSOR_MACADDRESS  , SENSOR_DESCRIPTION , X_AXIS , Y_AXIS,DEVICETYPE  FROM SENSORS WHERE STOREID=",storeId];
        
                if (sqlite3_prepare_v2(_contactDB, [query UTF8String], -1, &statement, nil)
            == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                RMSSensor *currentSensor=[RMSSensor alloc];
                
                currentSensor.sensorID=[NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 0)] ;
                
                currentSensor.sensorSerialNumber= [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                currentSensor.sensorMACAddress= [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                currentSensor.sensorDesc= [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                currentSensor.sensor_X_axis=[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 4)] ;
                
                currentSensor.sensor_Y_axis=[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 5)] ;
                
                 currentSensor.deviceType=[NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 6)] ;
                
                [data addObject:currentSensor];
            }
            sqlite3_finalize(statement);
        }
        
    }
    return data;
}


-(NSMutableArray *)loadSensorsByType:(NSString *)storeId forDeviceType:(NSString *)deviceType;
{
    [self initDB];
    data=[[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        //  NSMutableArray *retval = [[NSMutableArray alloc] init];
        NSString *query =[NSString stringWithFormat:@"SELECT SENSORID, SENSOR_SERIAL_NUMBER  ,SENSOR_MACADDRESS   , SENSOR_DESCRIPTION , X_AXIS , Y_AXIS ,DEVICETYPE FROM SENSORS WHERE STOREID=%@ and DEVICETYPE=%@",storeId,deviceType];
        
        if (sqlite3_prepare_v2(_contactDB, [query UTF8String], -1, &statement, nil)
            == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                RMSSensor *currentSensor=[RMSSensor alloc];
                
                currentSensor.sensorID=[NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 0)] ;
                
                currentSensor.sensorSerialNumber= [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                currentSensor.sensorMACAddress= [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                
                currentSensor.sensorDesc= [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                currentSensor.sensor_X_axis=[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 4)] ;
                
                currentSensor.sensor_Y_axis=[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 5)] ;
                
                 currentSensor.deviceType= [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                
                [data addObject:currentSensor];
            }
            sqlite3_finalize(statement);
        }
        
    }
    return data;
}

-(bool)SaveSensor:(RMSSensor *)currentSensor
{
    bool returnStatus=false;
    [self initDB];
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO SENSORS(STOREID,SENSOR_SERIAL_NUMBER  ,SENSOR_MACADDRESS  , SENSOR_DESCRIPTION ,DEVICETYPE, X_AXIS, Y_AXIS,GATEWAYID) VALUES (\"%@\",\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")",
                               currentSensor.storeId,currentSensor.sensorSerialNumber,currentSensor.sensorMACAddress, currentSensor.sensorDesc,currentSensor.deviceType,currentSensor.sensor_X_axis,currentSensor.sensor_Y_axis,currentSensor.GatewayId];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        
        int result = sqlite3_prepare_v2(_contactDB, insert_stmt,
                                        -1, &statement, NULL);
        if(result != SQLITE_OK) {
            NSLog(@"Prepare-error #%i: %s", result, sqlite3_errmsg(_contactDB));
            returnStatus=false;
        }
        else{
            
            result = sqlite3_step(statement);
            if (result != SQLITE_DONE) {
                NSLog(@"Step-error #%i for '%@': %s", result, insertSQL, sqlite3_errmsg(_contactDB));
                
                returnStatus=false;
            }
            else{
              returnStatus=true;
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_contactDB);
    }
    
    return returnStatus;
}

-(bool)SaveSensorLocation:(RMSSensor *)currentSensor
{
    bool returnStatus=false;
    [self initDB];
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *sqlQuery;
        
            sqlQuery = [NSString stringWithFormat:
                        @"UPDATE SENSORS SET X_AXIS= \"%@\",Y_AXIS= \"%@\" WHERE SENSORID=\"%@\"",
                        currentSensor.sensor_X_axis,currentSensor.sensor_Y_axis,currentSensor.sensorID];
       
        const char *sql_stmt = [sqlQuery UTF8String];
        
        
        int result = sqlite3_prepare_v2(_contactDB, sql_stmt,
                                        -1, &statement, NULL);
        if(result != SQLITE_OK) {
            returnStatus=false;
            NSLog(@"Prepare-error #%i: %s", result, sqlite3_errmsg(_contactDB));
        }
        else{
            
            result = sqlite3_step(statement);
            if (result != SQLITE_DONE) {
                NSLog(@"Step-error #%i for '%@': %s", result, sqlQuery, sqlite3_errmsg(_contactDB));
                //self.statusLbl.text = @"Failed to upload Store Map";
                returnStatus=false ;
            }
            else{
                
                returnStatus=true;
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_contactDB);
    }
    return returnStatus;
}

-(NSMutableArray *)loadSensorsByGateway:(NSString *)GatewayId;
{
    [self initDB];
    data=[[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        //  NSMutableArray *retval = [[NSMutableArray alloc] init];
        NSString *query =[NSString stringWithFormat:@"SELECT SENSORID, SENSOR_SERIAL_NUMBER  ,SENSOR_MACADDRESS   , SENSOR_DESCRIPTION , X_AXIS , Y_AXIS ,DEVICETYPE FROM SENSORS WHERE GATEWAYID=%@ and DEVICETYPE=2",GatewayId];
        
        if (sqlite3_prepare_v2(_contactDB, [query UTF8String], -1, &statement, nil)
            == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                RMSSensor *currentSensor=[RMSSensor alloc];
                
                currentSensor.sensorID=[NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 0)] ;
                
                currentSensor.sensorSerialNumber= [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                 currentSensor.sensorMACAddress= [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                currentSensor.sensorDesc= [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                currentSensor.sensor_X_axis=[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 4)] ;
                
                currentSensor.sensor_Y_axis=[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 5)] ;
                
                currentSensor.deviceType= [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                
                [data addObject:currentSensor];
            }
            sqlite3_finalize(statement);
        }
        
    }
    return data;
}

@end
