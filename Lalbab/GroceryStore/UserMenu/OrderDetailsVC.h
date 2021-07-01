//
//  OrderDetailsVC.h
//  Grocery Store
//
//  Created by subhashsanghani on 8/1/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
@interface OrderDetailsVC : BaseVC<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tableview;
    IBOutlet UILabel *lblTime;
    IBOutlet UILabel *lblDate;
    IBOutlet UILabel *lblDeliveryCharge;
    IBOutlet UILabel *lblTotal;
    
    IBOutlet UIButton *btnCancelOrder;
    
    IBOutlet UILabel *txt_name;
    IBOutlet UILabel *txt_address;
    
}
@property (retain, readwrite) NSMutableArray *dictOrder;
@end
