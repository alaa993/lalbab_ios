//
//  CartVC.h
//  Rabbit
//
//  Created by subhashsanghani on 2/3/17.
//  Copyright © 2017 Rabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "CartCell.h"
@interface CartVC : BaseVC<UITableViewDelegate, UITableViewDataSource, CartCellDelegate>
@property (strong, nonatomic) IBOutlet UIButton *clearPrd;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalItem;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblDeliveryCharge;

@property (strong, nonatomic) IBOutlet UIButton *btnContinue;
@end
