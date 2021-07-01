//
//  AddressCell.h
//  Rabbit
//
//  Created by subhashsanghani on 2/6/17.
//  Copyright © 2017 Rabbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblStreet;
@property (strong, nonatomic) IBOutlet UILabel *lblDeliveryCharge;
@property (strong, nonatomic) IBOutlet UILabel *lblReciverPhone;
@property (strong, nonatomic) IBOutlet UIImageView *imgRadioImage;
@end
