//
//  ConfirmDeliveryVC.m
//  Grocery Store
//
//  Created by subhashsanghani on 8/2/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import "ConfirmDeliveryVC.h"
#import "ThanksScreenVC.h"
#import "Languge.h"
#import "Common.h"

@interface ConfirmDeliveryVC ()
{
    NSString *note_txt;
    NSMutableDictionary *selected_location;
}
@end

@implementation ConfirmDeliveryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedStrings(@"Confirm", nil);
    // Do any additional setup after loading the view.
    lbl_date_time.text = [NSString stringWithFormat:@" %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"txt_note"]];
    selected_location = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"selected_location"]];
    
    lbl_receiver_name.text = [NSString stringWithFormat:@"%@ : %@",NSLocalizedStrings(@"Receiver Name", nil),[selected_location valueForKey:@"receiver_name"]];
    lbl_receiver_mobile.text = [NSString stringWithFormat:@"%@ : %@",NSLocalizedStrings(@"Receiver Mobile No.", nil),[selected_location valueForKey:@"receiver_mobile"]];
    lbl_pincode.text = [NSString stringWithFormat:@"%@ : %@",NSLocalizedStrings(@"Pincode", nil),[selected_location valueForKey:@"pincode"]];
    lbl_house_no.text = [NSString stringWithFormat:@"%@ : %@",NSLocalizedStrings(@"House No.", nil),[selected_location valueForKey:@"house_no"]];

    
    lbl_total_item.text = [NSString stringWithFormat:@"%@ : %d",NSLocalizedStrings(@"Items", nil),[cart getCartItemCount]];
    lbl_amount.text = [NSString stringWithFormat:@"%@ : %.0f",NSLocalizedStrings(@"Amount", nil),[cart getCartTotal]];
    
    self->DeliveryAdd.text=
   [NSString stringWithFormat:@"%@ ",NSLocalizedStrings(@"Delivery Address", nil)];
    
    self->TotalIAA.text=
    [NSString stringWithFormat:@"%@ ",NSLocalizedStrings(@"Total items and amount", nil)];
    
    
    self->DeliveryDAT.text=
    [NSString stringWithFormat:@"%@ ",NSLocalizedStrings(@"Delivery Date and Time", nil)];
    
    [orderNow setTitle:NSLocalizedStrings(@"ORDER NOW", nil) forState:UIControlStateNormal];
    
    [self setShadowView:frame1];
    [self setShadowView:frame2];
    [self setShadowView:frame3];
    
}
-(void)setShadowView:(UIView*)viewFrame{
    viewFrame.layer.masksToBounds = NO;
    viewFrame.layer.shadowColor = [UIColor blackColor].CGColor;
    viewFrame.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    viewFrame.layer.shadowOpacity = 0.5f;
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
-(IBAction)btnSendOrderClick:(id)sender{
    BOOL isValidated = YES;
    NSString *strMessage=@"";
    
  
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"selected_location"] == nil)
    {
        isValidated = NO;
        strMessage = NSLocalizedStrings(@"Please Choose Delivery Location", @"");
    }
    
    if(isValidated){
        NSArray *info = [NSArray arrayWithArray:[cart getCartItems]];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[cart getCartItems]
                                                           options:0 error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSDictionary *dictParams = @{
                    @"user_id": [app.dictUser valueForKey:@"user_id"],
                    @"location" : [selected_location valueForKey:@"location_id"],
                    @"note" : [[NSUserDefaults standardUserDefaults] valueForKey:@"txt_note"],
                    @"seler_id": @"52" ,
                    @"phone": @"52" ,
                    @"name_resever": @"52" ,
                    @"data" : jsonString
                                     };
        
        [self postResponseFromURL:[self getStringURLForAPI:URL_API_ADD_ORDER] withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
            
        } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
            if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
                
                [cart emptyCart];
                
                
                ThanksScreenVC *VC =
                [self.storyboard instantiateViewControllerWithIdentifier:@"ThanksScreenVC"];
                VC.appointment = [responseObject valueForKey:@"data"];
                
                [self.navigationController pushViewController:VC animated:true];
                
            }
            else{
                [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        } showLoader:YES hideLoader:YES];
    }else{
        [self showAlertForTitle:NSLocalizedStrings(@"Error!", nil) withMessage:NSLocalizedStrings(strMessage, nil)];
    }
    
}
@end
