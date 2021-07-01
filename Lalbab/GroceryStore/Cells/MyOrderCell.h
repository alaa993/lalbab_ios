//
//  MyOrderCell.h
//  Rabbit
//
//  Created by subhashsanghani on 2/6/17.
//  Copyright © 2017 Rabbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblOrderNo;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblItems;
@end
