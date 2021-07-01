//
//  OrderDetailsVC.m
//  Grocery Store
//
//  Created by subhashsanghani on 8/1/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import "OrderDetailsVC.h"
#import "OrderDetailsCell.h"
#import "Languge.h"
#import "Common.h"

@interface OrderDetailsVC ()
{
    NSMutableArray *dataArray;
}
@end

@implementation OrderDetailsVC
@synthesize dictOrder;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedStrings(@"Order Details", nil);
    // Do any additional setup after loading the view.
    
    NSString * timeStampString = [dictOrder valueForKey:@"on_date"];
    NSTimeInterval _interval=[timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"dd/MM/yy HH:mm:ss "];
    
    txt_name.text = [NSString stringWithFormat:@"%@", [dictOrder valueForKey:@"name_resever"]];
     txt_address.text = [NSString stringWithFormat:@"%@", [dictOrder valueForKey:@"delivery_address"]];
       
          NSString *noteall;
          NSString *note_sel;
          NSString *note;
          
          note_sel = [dictOrder valueForKey:@"note_sel"] ;
          note = [dictOrder valueForKey:@"note"] ;
       

       if (note_sel.length > 0 &&  note.length > 0) {
           noteall = [NSString stringWithFormat:@"%@ : %@ \n%@ : %@ ",NSLocalizedStrings(@"Note seler", nil), note_sel, NSLocalizedStrings(@"Note", nil) , note ];
           
           
           
          }else if (note_sel.length > 0 ) {
             noteall =   [NSString stringWithFormat:@"%@ : %@",NSLocalizedStrings(@"Note seler", nil), note_sel ];
              
          }else if (note.length > 0 ) {
              noteall =   [NSString stringWithFormat:@"%@ : %@",NSLocalizedStrings(@"Note", nil), note ];
          }
          
          lblDate.text = [NSString stringWithFormat:@"%@ :%@",NSLocalizedStrings(@"Date", nil),  [_formatter stringFromDate:date]];
          
          lblTotal.text = [NSString stringWithFormat:@"%@ : %@ %@",NSLocalizedStrings(@"Total", nil), [dictOrder valueForKey:@"total_amount"], NSLocalizedStrings(CURRENCY, nil)];
       
       lblTime.text = noteall;
    
    lblDeliveryCharge.text = [NSString stringWithFormat:@"%@ : %@",NSLocalizedStrings(@"Delivery Charges", nil), [dictOrder valueForKey:@"phone"]];
    
    [self getDetails];
    [btnCancelOrder setHidden:true];
    
    if ([[dictOrder valueForKey:@"status"] integerValue] == 0) {
        [btnCancelOrder setHidden:false];
    }
    
}
- (IBAction)cancelOrderClick:(id)sender{
    
    NSDictionary *dictParams = nil;
    NSString *url;
    
    dictParams =  @{
                    @"sale_id": [dictOrder valueForKey:@"sale_id"],
                    @"user_id": [app.dictUser valueForKey:@"user_id"]
                    };
    url = [self getStringURLForAPI:URL_API_CANCLE_ORDER];
    [self postResponseFromURL:url withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
           [btnCancelOrder setHidden:true];
           [self showAlertForTitle:@"Canceled" withMessage:@"Your order canceled successfully"];
        }
        else{
            [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showLoader:YES hideLoader:YES];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getDetails{
    
    NSDictionary *dictParams = @{
                                 @"sale_id": [dictOrder valueForKey:@"sale_id"]
                                 };
    [self postResponseFromURL:[self getStringURLForAPI:URL_API_ORDER_DETAILS] withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
        
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrderDetailsCell *cell;
    
        cell= [tableView dequeueReusableCellWithIdentifier:@"OrderDetailsCell"];
   
    
    
    NSMutableDictionary *dict = [dataArray objectAtIndex:indexPath.row];
   
   if ([NSLocalizedStrings(@"lg", @"ar")  isEqual: @"ar"]) {
       cell.lblProductTitle.text =  [dict valueForKey:@"product_name"];
   } else if ([NSLocalizedStrings(@"lg", @"fa")  isEqual: @"fa"]) {
       cell.lblProductTitle.text =  [dict valueForKey:@"product_name_ku"];
   }else if ([NSLocalizedStrings(@"lg", @"en")  isEqual: @"en"]) {
       cell.lblProductTitle.text =  [dict valueForKey:@"product_name_en"];
   }
    
    
    
    
    cell.lblProductPrice.text = [NSString stringWithFormat:@"%@ %@:%@ %@", NSLocalizedStrings(@"Price per", nil), [dict valueForKey:@"unit"], [dict valueForKey:@"price"], NSLocalizedStrings(CURRENCY, nil)];
    
   
    cell.lblQty.text = [NSString stringWithFormat:@"%@ : %@",NSLocalizedStrings(@"Qty", nil),[dict valueForKey:@"qty"]];
    
    cell.imageview.clipsToBounds = YES;
    cell.imageview.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageview.imageURL =  [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", URL_API_HOST_BASE, PRO_IMAGE_SMALL_PATH,[dict valueForKey:@"product_image"]]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataArray!=nil) {
        return dataArray.count;
    }
    return 0;
}
@end
