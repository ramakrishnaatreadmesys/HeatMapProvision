//
//  RMSStoreSensors.m
//  HeatMapProvisioning
//
//  Created by MacBook  on 8/15/14.
//  Copyright (c) 2014 ReadMeSys. All rights reserved.
//

#import "RMSStoreSensors.h"
#import "RMSSensorDetailsCell.h"
@interface RMSStoreSensors ()

@end

@implementation RMSStoreSensors

NSMutableArray *sensors ;

- (void)viewDidLoad
{
    [super viewDidLoad];
    sensors=[[NSMutableArray alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.dbManager=[[RMSDBManager alloc]init];
    
    [self loadSensors];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    if(section==0)
        return 1;
    else return (!sensors || sensors==nil )? 1 :[sensors count]+1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 40.0;
//}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // if(indexPath.section==0 && indexPath.row==0)  return 120;
    //else
        return 65;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0 )  return @"Store Details";
    else return @"Available sensors";
}

//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    //Headerview
//    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 20.0)] ;
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    [button setFrame:CGRectMake(275.0, 5.0, 30.0, 30.0)];
//    button.tag = section;
//    button.hidden = NO;
//    [button setBackgroundColor:[UIColor clearColor]];
//    [button addTarget:self action:@selector(addStore:) forControlEvents:UIControlEventTouchDown];
//    [myView addSubview:button];
//    return myView;
//}
//- (IBAction)addStore:(id)sender {
//
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString *CellIdentifier = @"Cell";
    
    if(indexPath.section==0 && indexPath.row==0){
        
        RMSSensorDetailsCell *cell = (RMSSensorDetailsCell *)[tableView dequeueReusableCellWithIdentifier:@"sensorDetailsCell"];
        
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RMSSensorDetailsCell" owner:self options:nil];
            for (id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell =  (RMSSensorDetailsCell *) currentObject;
                    break;
                }
            }
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
       // cell.parent=self;
         cell.currentStore=self.currentStore;
        [cell loadStore];
        return cell;
    }else
    {
        
        RMSSensorDetailsCell *cell = (RMSSensorDetailsCell *)[tableView dequeueReusableCellWithIdentifier:@"sensorDetailsCell"];
        
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RMSSensorDetailsCell" owner:self options:nil];
            for (id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell =  (RMSSensorDetailsCell *) currentObject;
                    break;
                }
            }
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if(indexPath.row==0)
        {
            cell.currentStore=self.currentStore;
            [cell loadDefaults ];
        }
        else{
            
            RMSSensor *currentSensor=(RMSSensor *) [sensors objectAtIndex:indexPath.row-1];
          //  cell.parent=self;
            cell.currentStore=self.currentStore;
            cell.currentSensor=currentSensor;
            [cell loadSensor ];
        }
        return cell;
        
    }
    
}




-(void)loadSensors
{
    [sensors removeAllObjects];
    sensors =[self.dbManager loadSensors:self.currentStore.storeId ];
    [self.tableView reloadData];
}




/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */

@end
