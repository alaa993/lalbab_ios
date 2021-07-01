//
//  ConfirmDeliveryVC.h
//  Grocery Store
//
//  Created by subhashsanghani on 8/2/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
@interface ConfirmDeliveryVC : BaseVC
{
    IBOutlet UILabel *lbl_date_time, *lbl_receiver_name, *lbl_receiver_mobile, *lbl_pincode, *lbl_house_no, *lbl_total_item, *lbl_amount;
    NSString *txtnote;
  
    IBOutlet UIView *frame1, *frame2, *frame3;
    IBOutlet UILabel *DeliveryAdd;
    IBOutlet UILabel *DeliveryDT;
    
    IBOutlet UIButton *orderNow;
    
    IBOutlet UILabel *DeliveryDAT;
    IBOutlet UILabel *TotalIAA;
    
}
@end
