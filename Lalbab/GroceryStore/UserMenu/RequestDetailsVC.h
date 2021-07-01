//
//  RequestDetailsVC.h
//  GroceryStore
//
//  Created by Admin on 28/11/2562 BE.
//  Copyright © 2562 Way. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseVC.h"
@interface RequestDetailsVC : BaseVC<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tableview;
    IBOutlet UILabel *lblTime;
    IBOutlet UILabel *lblDate;
    IBOutlet UILabel *lblDeliveryCharge;
    IBOutlet UILabel *lblTotal;
    
    IBOutlet UIButton *btnCancelOrder;
    
    IBOutlet UIView *view_pop;
    
    IBOutlet UIPickerView *pic_view;
    
    IBOutlet UITextView *txt_note;
    
    IBOutlet UIButton *bt_edit;
    
    NSInteger *row_select ;
    
    IBOutlet UILabel *txt_name;
    
    IBOutlet UILabel *txt_address;
    
}
@property (retain, readwrite) NSMutableArray *dictOrder;


@end
