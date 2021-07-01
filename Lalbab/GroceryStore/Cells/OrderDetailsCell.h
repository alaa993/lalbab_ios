//
//  OrderDetailsCell.h
//  Grocery Store
//
//  Created by subhashsanghani on 8/1/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface OrderDetailsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblProductTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblProductPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblQty;
@property (strong, nonatomic) IBOutlet AsyncImageView *imageview;
@end
