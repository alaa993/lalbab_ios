//
//  CategoryCell.h
//  Grocery Store
//
//  Created by subhashsanghani on 7/29/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface CategoryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet AsyncImageView *imageIcon;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UIView *viewFrame;
@end
