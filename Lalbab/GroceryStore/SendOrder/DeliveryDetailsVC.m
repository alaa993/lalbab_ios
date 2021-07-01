//
//  DeliveryDetailsVC.m
//  Grocery Store
//
//  Created by subhashsanghani on 7/31/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import "DeliveryDetailsVC.h"
#import "CalenderVC.h"
#import "ChoosetimeVC.h"
#import "AddressCell.h"
#import "AddAddressVC.h"
#import "ConfirmDeliveryVC.h"

#import "Languge.h"
#import "Common.h"

@interface DeliveryDetailsVC ()
{
    NSMutableDictionary *selected_location;
    NSString *note_txt;
    NSMutableArray *addresses;
    float cart_total;
    
}
@end

@implementation DeliveryDetailsVC
@synthesize txt_note, lblTotalCharges,lblDeliveryCharge, btn_add;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedStrings(@"Delivery", nil);
    cart_total = [cart getCartTotal];
    
    self.AddressD.text=
    [NSString stringWithFormat:@"%@ ",NSLocalizedStrings(@"Delivery Address", nil)];
    
    self.TimeDel.text=
       [NSString stringWithFormat:@"%@ ",NSLocalizedStrings(@"Delivery Time", nil)];
    
    
    
    
    [_BtnContinue setTitle:NSLocalizedStrings(@"CONTINUE CHECKOUT", nil) forState:UIControlStateNormal];
   
    
    [btn_add setTitle:NSLocalizedStrings(@"Add", nil) forState:UIControlStateNormal];
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"selected_date"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"selected_time"];
  
    btn_add.layer.cornerRadius = 4.0f;
    [self getAddress];
}
-(void)updateTotal{
    lblTotalCharges.text = [NSString stringWithFormat:@"%@ : %.0f %@ + %@ %.0f %@",NSLocalizedStrings(@"Total", nil),cart_total,NSLocalizedStrings(CURRENCY, nil), NSLocalizedStrings(@"Delivery Charges", nil),[[selected_location valueForKey:@"delivery_charge"] floatValue],NSLocalizedStrings(CURRENCY, nil)];
    _lblTotalItems.text = [NSString stringWithFormat:@"%@ : %d",NSLocalizedStrings(@"Item", nil),[cart getCartItemCount]];
}
-(void)viewWillAppear:(BOOL)animated{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"refresh_address"]){
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"refresh_address"];
        [self getAddress];
    }
   
    
}


-(IBAction)btnChooseTime:(id)sender{
   
    
}

-(void)getAddress{
    
    NSDictionary *dictParams = @{
                                 @"user_id": [app.dictUser valueForKey:@"user_id"]
                                 };
    [self postResponseFromURL:[self getStringURLForAPI:URL_API_ADDRESS] withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
            addresses = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"data"]];
            if (addresses != nil && [addresses count] > 0) {
                selected_location = [addresses objectAtIndex:0];
                [tableview reloadData];
                [self updateTotal];
            }
            
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
    
    AddressCell *cell= [tableView dequeueReusableCellWithIdentifier:@"AddressCell"];
    NSMutableDictionary *desc = [addresses objectAtIndex:indexPath.row];
  
    cell.lblAddress.text = [NSString stringWithFormat:@"%@ : %@",NSLocalizedStrings(@"Name", nil),[desc valueForKey:@"receiver_name"]];
      
    cell.lblStreet.text = [NSString stringWithFormat:@"%@ : %@",NSLocalizedStrings(@"Phone", nil),[desc valueForKey:@"receiver_mobile"]];
    
    
  //  cell.lblReciverPhone.text = [desc valueForKey:@"receiver_mobile"];
    
  
    cell.lblDeliveryCharge.text = [NSString stringWithFormat:@"%@ : %@ - %@",NSLocalizedStrings(@"Address", nil),[desc valueForKey:@"pincode"],[desc valueForKey:@"house_no"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    if ([desc isEqual:selected_location]) {
        [cell.imgRadioImage setImage:[UIImage imageNamed:@"radio_checked"]];
    }else{
        [cell.imgRadioImage setImage:[UIImage imageNamed:@"radio"]];
    }
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (addresses!=nil) {
        return addresses.count;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selected_location = [addresses objectAtIndex:indexPath.row];
    [tableview reloadData];
    [self updateTotal];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
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
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        NSLog(@"Delete");
                                        // Delete something here
                                        [self deleteAddress:[[addresses objectAtIndex:indexPath.row] valueForKey:@"location_id"] index:indexPath.row];
                                    }];
    delete.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *more = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Edit " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                  {
                                      NSLog(@"Edit");
                                      AddAddressVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAddressVC"];
                                      vc.is_edit = true;
                                      vc.address_desc = [addresses objectAtIndex:indexPath.row];
                                      [self.navigationController pushViewController:vc animated:true];
                                      //Just as an example :
                                      //[self presentUIAlertControllerActionSheet];
                                  }];
    more.backgroundColor = [UIColor colorWithRed:0.188 green:0.514 blue:0.984 alpha:1];
    
    return @[delete, more]; //array with all the buttons you want. 1,2,3, etc...
}
- (void)deleteAddress:(NSString*)deleted_id  index:(NSInteger)index{
    
    NSDictionary *dictParams = nil;
    NSString *url;
    
    dictParams =  @{
                    @"location_id": deleted_id,
                    @"user_id": [app.dictUser valueForKey:@"user_id"]
                    };
    url = [self getStringURLForAPI:URL_API_DELETET_ADDRESS];
    [self postResponseFromURL:url withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
            [addresses removeObjectAtIndex:index];
            [tableview reloadData];
        }
        else{
            [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showLoader:YES hideLoader:YES];
    
    
}
-(IBAction)btnSendOrderClick:(id)sender{
    BOOL isValidated = YES;
    NSString *strMessage=@"";
    
    /*
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"selected_date"] == nil)
    {
        isValidated = NO;
        strMessage = NSLocalizedStrings(@"Please Choose Delivery Date", @"");
    }
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"selected_time"] == nil)
    {
        isValidated = NO;
        strMessage = NSLocalizedStrings(@"Please Choose Delivery Time", @"");
    }
    */
    if(selected_location == nil)
    {
        
        isValidated = NO;
        strMessage = NSLocalizedStrings(@"Please Choose Delivery Location", @"");
    }
    
    if(isValidated){
        [[NSUserDefaults standardUserDefaults] setObject:selected_location forKey:@"selected_location"];
        note_txt = txt_note.text;
       // NSLog(txt_note.text);
        
        [[NSUserDefaults standardUserDefaults] setObject:note_txt forKey:@"txt_note"];
        
        
        ConfirmDeliveryVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmDeliveryVC"];
        
        [self.navigationController pushViewController:vc animated:true];
    }else{
        [self showAlertForTitle:NSLocalizedStrings(@"Error!", nil) withMessage:NSLocalizedStrings(strMessage, nil)];
    }
}
@end
