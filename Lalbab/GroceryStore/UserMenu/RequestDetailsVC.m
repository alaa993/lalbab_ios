//
//  RequestDetailsVC.m
//  GroceryStore
//
//  Created by Admin on 28/11/2562 BE.
//  Copyright © 2562 Way. All rights reserved.
//


#import "RequestDetailsVC.h"
#import "OrderDetailsCell.h"
#import "Languge.h"
#import "Common.h"

@interface RequestDetailsVC ()
{
    NSMutableArray *dataArray;
}
@end

@implementation RequestDetailsVC
@synthesize dictOrder;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedStrings(@"Order Details", nil);
    // Do any additional setup after loading the view.
    NSLog(@"test6");
    
    NSString * timeStampString = [dictOrder valueForKey:@"on_date"];
    NSTimeInterval _interval=[timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"dd/MM/yy HH:mm:ss "];
    
    txt_name.text = [dictOrder valueForKey:@"name_resever"];
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
    [btnCancelOrder setHidden:false];
    
    pic_view.delegate = self;
    pic_view.dataSource = self;
    pic_view.showsSelectionIndicator = YES;
    
    [bt_edit setTitle:NSLocalizedStrings(@"Edit", @"nil") forState:UIControlStateNormal];
    
    row_select = [[dictOrder valueForKey:@"status"] integerValue];
 
    
    
   
    
    
    /*
    if ([[dictOrder valueForKey:@"status"] integerValue] == 0) {
        [btnCancelOrder setHidden:false];
    }
     */
    
}


- (IBAction)btEdit:(id)sender{
    NSLog(@"%@", [txt_note text]);
    NSLog(@" Index of selected %li", row_select);
    
    
    
    
    NSDictionary *dictParams = nil;
    NSString *url;
    NSString *note_sel = [txt_note text];
    NSString *status = [@((long)row_select) stringValue]; ;
    
    dictParams =  @{
                    @"sale_id": [dictOrder valueForKey:@"sale_id"],
                    @"user_id": [app.dictUser valueForKey:@"user_id"],
                    @"status": status,
                    @"note_sel": note_sel
                    
                    
                    
                    };
    url = [self getStringURLForAPI:URL_API_CHANGE_ORDER];
    [self postResponseFromURL:url withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        [self showAlertForTitle:NSLocalizedStrings(@"Order Changed", nil) withMessage:NSLocalizedStrings(@"The order Changed successfully", nil)];
                    [view_pop setHidden:true];
        
/*
        if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
           [btnCancelOrder setHidden:true];
          
        }
        else{
            [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
        }
*/
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showAlertForTitle:NSLocalizedStrings(@"Failed" , nil) withMessage:NSLocalizedStrings(@"Failed Internet" , nil)];
    } showLoader:YES hideLoader:YES];
    
    
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 4;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString * title = nil;
    switch(row) {
            case 0:
                title = NSLocalizedStrings(@"Pending", nil);
                break;
            case 1:
                title = NSLocalizedStrings(@"Confirm", nil);
                break;
                case 2:
                    title = NSLocalizedStrings(@"Delivered", nil);
                    break;
                case 3:
                    title = NSLocalizedStrings(@"Cancel Order", nil);
                    break;
    }
    return title;
}

- (void)pickerView:(UIPickerView *)thePickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {

//Here, like the table view you can get the each section of each row if you've multiple sections

    row_select = &row;
  

}


- (IBAction)cancelOrderClick:(id)sender{
  
    /*
    IBOutlet UIView *view_pop;
    
    IBOutlet UIPickerView *pic_view;
    
    IBOutlet UITextView *txt_note;
    
    IBOutlet UIButton *bt_edit;
    */
    if ([view_pop isHidden] == true) {
         [view_pop setHidden:false];
        
        [pic_view reloadAllComponents];
        [pic_view selectRow:[[dictOrder valueForKey:@"status"] integerValue] inComponent:0 animated:YES];
      NSString *note_sel = [dictOrder valueForKey:@"note_sel"];
        if (note_sel.length >0  ) {
            txt_note.text =  [dictOrder valueForKey:@"note_sel"];
        }else {
            txt_note.text =  NSLocalizedStrings(@"Note seler", nil) ;
        }
       
        
    }else{
        [view_pop setHidden:true];
    }
    
   // NSLog(@"%@", [view_pop isHidden]);
    
    /*
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
    */
    
    
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
   
    
   // cell.lblProductTitle.text =  [dict valueForKey:@"product_name"];
    
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
