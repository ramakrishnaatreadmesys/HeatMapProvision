//
//  RMSStoresManagementTableViewController.m
//  HeatMapProvisioning
//
//  Created by MacBook  on 8/14/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import "RMSStoresManagementTableViewController.h"
#import "RMSStoreDetailsTableViewCell.h"
#import "RMSStore.h"
#import "RMSManageStore.h"
#import "RMSStoreSensors.h"
#import "RMSUtil.h"


@interface RMSStoresManagementTableViewController ()

@end

@implementation RMSStoresManagementTableViewController

NSMutableArray *stores ;
RMSUtil *util;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    util=[[RMSUtil alloc]init];
    self.dbManager=[[RMSDBManager alloc]init];
    self.OrgId=[util GetOrgId];
    stores=[[NSMutableArray alloc] init];
     [self loadStors];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0f, 0.0f, 293.0f, 50.0f)];
    [btn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"safewayLogo.gif"] forState:UIControlStateNormal];
    self.navigationItem.titleView = btn;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   [self loadStors];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    return 1;
    else return (!stores || stores==nil )? 1 :[stores count]+1;
}

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    return YES;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if(indexPath.section==0 && indexPath.row==0)  return 50;
        else return 65;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0 )  return @"Add Store";
    else return @"Available Stores";
    
}

- (void)showStore:(id)sender {
    
    
    long index=((UIButton *)sender).tag;
    
    RMSManageStore *ManageStoreViewController =  [[RMSManageStore alloc] initWithNibName:@"RMSManageStore" bundle:nil];
   
    if(index>=0){
        RMSStore *store=(RMSStore *) [stores objectAtIndex:index];
         ManageStoreViewController.currentStore=store;
    }
    
    self.userDataPopover = [[UIPopoverController alloc] initWithContentViewController:ManageStoreViewController];
    
    [self.userDataPopover setPopoverContentSize:CGSizeMake( ManageStoreViewController.view.frame.size.width, ManageStoreViewController.view.frame.size.height)];
    
    [self.userDataPopover presentPopoverFromRect:CGRectMake(10,10, 10.0,10.0)
                                          inView:((UIButton *)sender)
                        permittedArrowDirections:  UIPopoverArrowDirectionLeft |UIPopoverArrowDirectionRight
                                        animated:YES];
   
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
        RMSStore *store=(RMSStore *) [stores objectAtIndex:index];
        ManageStoreViewController.currentStore=store;
    }
    
    self.userDataPopover = [[UIPopoverController alloc] initWithContentViewController:ManageStoreViewController];
    
    [self.userDataPopover setPopoverContentSize:CGSizeMake( ManageStoreViewController.view.frame.size.width, ManageStoreViewController.view.frame.size.height)];
    
    [self.userDataPopover presentPopoverFromRect:CGRectMake(10,10, 10.0,10.0)
                                          inView:((UIButton *)sender)
                        permittedArrowDirections:  UIPopoverArrowDirectionLeft |UIPopoverArrowDirectionRight
                                        animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0 && indexPath.row==0){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"] ;
        }
        
        UIButton *addbtn=[UIButton buttonWithType:UIButtonTypeContactAdd];
        [addbtn setFrame:CGRectMake(170,5, 50, 50)];
        addbtn.tag=-1;
       //  [addbtn setTitle:@"Add" forState:UIControlStateNormal];
        
        [addbtn addTarget:self action:@selector(showStore:) forControlEvents:UIControlEventTouchUpInside];
        //[cell addSubview:addbtn];
        [cell.contentView addSubview:addbtn];
        
    return cell;
    }else
    {
        RMSStoreDetailsTableViewCell *cell = (RMSStoreDetailsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"storeDetailsCell"];
        
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RMSStoreDetailsTableViewCell" owner:self options:nil];
            for (id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell =  (RMSStoreDetailsTableViewCell *) currentObject;
                    break;
                }
            }
        }
       // [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
           [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        if(indexPath.row==0)
        {
            [cell loadDefaults ];
        }
        else{
            
            RMSStore *currentStore=(RMSStore *) [stores objectAtIndex:indexPath.row-1];
            cell.parent=self;
            cell.currentStore=currentStore;
            
            [cell.uploadStorePlanBtn setTag:indexPath.row-1];
            [cell.uploadStorePlanBtn addTarget:self action:@selector(showStore:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [cell.storeSensorsCountBtn setTag:indexPath.row-1];
            [cell.storeSensorsCountBtn addTarget:self action:@selector(showStoreSensors:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell loadStore ];
                   }
        return cell;
       }
}

-(void)loadStors
{
    [stores removeAllObjects];
    stores=[self.dbManager loadStors: [util GetOrgId]];
    [self.tableView reloadData];
}

@end
