//
//  MyOrdersVC.m
//  Rabbit
//
//  Created by subhashsanghani on 2/6/17.
//  Copyright © 2017 Rabbit. All rights reserved.
//

#import "MyRequestsVC.h"
#import "MyOrderCell.h"
#import "RequestDetailsVC.h"

#import "Languge.h"
#import "Common.h"

@interface MyRequestsVC ()
{
    NSMutableArray *dataArray;
}
@end

@implementation MyRequestsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedStrings(@"My Requests", nil);
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    dataArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"my_orders"]];
    [self getTimeSlot];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)getTimeSlot{
   // params.put("cat_id", cat_id);
     //     params.put("user_phone", user_phone);
    
    NSDictionary *dictParams = @{
                                 @"user_id": [app.dictUser valueForKey:@"user_id"]
                                 ,@"cat_id": [app.dictUser valueForKey:@"id_catagore"]
                                 ,@"user_phone": [app.dictUser valueForKey:@"user_phone"]
                                 
                                 };
    
    [self postResponseFromURL:[self getStringURLForAPI:URL_API_LIST_REQUEST] withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        //if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
            dataArray = [[NSMutableArray alloc] initWithArray:responseObject];
            
            [tableview reloadData];
        //}
        //else{
        //    [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
        //}
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showLoader:YES hideLoader:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyOrderCell *cell;
    
        cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderCell"];
    
    
    NSMutableDictionary *desc = [dataArray objectAtIndex:indexPath.row];
    cell.lblOrderNo.text = [NSString stringWithFormat:@"%@ :%@",NSLocalizedStrings(@"Order No.", nil),[desc valueForKey:@"sale_id"]];
    
    NSString * timeStampString = [desc valueForKey:@"on_date"];
    NSTimeInterval _interval=[timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"dd/MM/yy HH:mm:ss "];
    
    
   // NSLog(@"%@", [_formatter stringFromDate:date]);
    
    cell.lblDate.text = [NSString stringWithFormat:@"%@ :%@",NSLocalizedStrings(@"Date", nil), [_formatter stringFromDate:date]];
    
    cell.lblTotal.text = [NSString stringWithFormat:@"%@ %@",  NSLocalizedStrings(CURRENCY, nil), [desc valueForKey:@"total_amount"]];
    cell.lblTime.text = [NSString stringWithFormat:@"%@" ,[desc valueForKey:@"name_resever"]];
    cell.lblItems.text = [NSString stringWithFormat:@"%@ : %@",NSLocalizedStrings(@"Items", nil), [desc valueForKey:@"total_items"]];
    
    if ([[desc valueForKey:@"status"] intValue] == 0) {
        cell.lblStatus.text = NSLocalizedStrings(@"Pending", nil);
        [cell.lblStatus setTextColor:[UIColor grayColor]];
    }else if ([[desc valueForKey:@"status"] intValue] == 1) {
        cell.lblStatus.text = NSLocalizedStrings(@"Confirm", nil);
        [cell.lblStatus setTextColor:[UIColor colorWithRed:27.0/255.0 green:220.0/255.0 blue:132.0/255.0 alpha:1.0]];
    }else if ([[desc valueForKey:@"status"] intValue] == 2) {
        cell.lblStatus.text = NSLocalizedStrings(@"Delivered", nil);
        [cell.lblStatus setTextColor:[UIColor colorWithRed:27.0/255.0 green:77.0/255.0 blue:220.0/255.0 alpha:1.0]];
    }else if ([[desc valueForKey:@"status"] intValue] == 3) {
        cell.lblStatus.text = NSLocalizedStrings(@"Cancel", nil);
        [cell.lblStatus setTextColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:35.0/255.0 alpha:1.0]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self isRTL]) {
        [cell.lblTotal setTextAlignment:NSTextAlignmentRight];
        [cell.lblStatus setTextAlignment:NSTextAlignmentRight];
        [cell.lblOrderNo setTextAlignment:NSTextAlignmentRight];
        [cell.lblDate setTextAlignment:NSTextAlignmentRight];
        [cell.lblItems setTextAlignment:NSTextAlignmentRight];
    }else{
        [cell.lblTotal setTextAlignment:NSTextAlignmentLeft];
        [cell.lblStatus setTextAlignment:NSTextAlignmentLeft];
        [cell.lblOrderNo setTextAlignment:NSTextAlignmentLeft];
        [cell.lblDate setTextAlignment:NSTextAlignmentLeft];
        [cell.lblItems setTextAlignment:NSTextAlignmentLeft];
    }
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataArray!=nil) {
        return dataArray.count;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RequestDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RequestDetailsVC"];
    vc.dictOrder = [dataArray objectAtIndex:indexPath.row];
  
    [self.navigationController pushViewController:vc animated:true];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    NSMutableDictionary *desc = [dataArray objectAtIndex:indexPath.row];
    if ([[desc valueForKey:@"status"] intValue] == 0) {
    return YES;
    }
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
    }else if (editingStyle == UITableViewCellEditingStyleInsert) {
        //add code here for when you hit delete
        
    }
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[[dataArray objectAtIndex:indexPath.row] valueForKey:@"status"] integerValue] == 0) {
        
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLocalizedStrings(@"Change Order", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        NSLog(@"Delete");
                                        // Delete something here
                                        [self deleteAddress:[[dataArray objectAtIndex:indexPath.row] valueForKey:@"sale_id"] index:indexPath.row];
                                    }];
    delete.backgroundColor = [UIColor redColor];
    
    /*UITableViewRowAction *more = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Edit " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                  {
                                      NSLog(@"Edit");
                                      AddAddressVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAddressVC"];
                                      vc.is_edit = true;
                                      vc.address_desc = [dataArray objectAtIndex:indexPath.row];
                                      [self.navigationController pushViewController:vc animated:true];
                                      //Just as an example :
                                      //[self presentUIAlertControllerActionSheet];
                                  }];
    more.backgroundColor = [UIColor colorWithRed:0.188 green:0.514 blue:0.984 alpha:1];
    */
    
    return @[delete]; //array with all the buttons you want. 1,2,3, etc...
    }else{
        return nil;
    }
}
- (void)deleteAddress:(NSString*)deleted_id  index:(NSInteger)index{
    
    NSDictionary *dictParams = nil;
    NSString *url;
    
    dictParams =  @{
                    @"sale_id": deleted_id,
                    @"user_id": [app.dictUser valueForKey:@"user_id"]
                    };
    url = [self getStringURLForAPI:URL_API_CANCLE_ORDER];
    [self postResponseFromURL:url withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
            [dataArray removeObjectAtIndex:index];
            [tableview reloadData];
        }
        else{
            [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showLoader:YES hideLoader:YES];
    
    
}
@end
