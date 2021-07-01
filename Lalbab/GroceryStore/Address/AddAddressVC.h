//
//  AddAddressVC.h
//  Grocery Store
//
//  Created by subhashsanghani on 7/31/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
@interface AddAddressVC : BaseVC
@property (strong, nonatomic) IBOutlet UILabel *NameR;
@property (strong, nonatomic) IBOutlet UILabel *PhoneR;
@property (strong, nonatomic) IBOutlet UILabel *AddressR;
@property (strong, nonatomic) IBOutlet UILabel *HnumberR;
@property (strong, nonatomic) IBOutlet UIButton *addDelv;

@property (strong, nonatomic) IBOutlet UITextField *txtAddress;
@property (strong, nonatomic) IBOutlet UITextField *txtZipCode;
@property (strong, nonatomic) IBOutlet UITextField *txtReceiverName;
@property (strong, nonatomic) IBOutlet UITextField *txtReceiverPhone;
@property (assign, readwrite) BOOL is_edit;
@property (assign, readwrite) NSMutableDictionary *address_desc;
@end
