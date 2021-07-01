//
//  ChoosetimeVC.m
//  Rabbit
//
//  Created by subhashsanghani on 2/4/17.
//  Copyright © 2017 Rabbit. All rights reserved.
//

#import "ChoosetimeVC.h"
#import "TimeslotCell.h"
#import "Languge.h"
#import "Common.h"

@interface ChoosetimeVC ()
{
    NSMutableArray *timeSlotArray;
}
@end

@implementation ChoosetimeVC
@synthesize tableview,selected_date;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedStrings(@"Choose Time", nil);
    // Do any additional setup after loading the view.
    timeSlotArray = [[NSMutableArray alloc] init];
    [self getTimeSlot];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getTimeSlot{
    //NSLog(@"date : %@",self.selected_date);
    NSDictionary *dictParams = @{
                                 @"date": [self getStringDateFormate:[[NSUserDefaults standardUserDefaults] valueForKey:@"selected_date"]]
                                 };
    [self postResponseFromURL:[self getStringURLForAPI:URL_API_TIMESLOT] withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
            timeSlotArray = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"times"]];
            
            [tableview reloadData];
        }
        else{
            [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showLoader:YES hideLoader:YES];
}
-(NSString*)getStringDateFormate:(NSDate*)date{
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:usLocale];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString* finalDateString = [format stringFromDate:date];
    
    
    return finalDateString;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TimeslotCell *cell= [tableView dequeueReusableCellWithIdentifier:@"TimeslotCell"];
    
    cell.lblTime.text = [timeSlotArray objectAtIndex:indexPath.row];
   
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (timeSlotArray!=nil) {
        return timeSlotArray.count;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] setObject:[timeSlotArray objectAtIndex:indexPath.row] forKey:@"selected_time"];
    [self.navigationController popViewControllerAnimated:true];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
