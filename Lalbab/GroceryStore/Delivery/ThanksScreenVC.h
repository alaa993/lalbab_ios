//
//  ThanksScreenVC.h
//  Grocery Store
//
//  Created by subhashsanghani on 8/3/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
@interface ThanksScreenVC : BaseVC
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet UIButton *cHome;
@property (strong, nonatomic) IBOutlet UIButton *TMYOrder;
@property (strong, nonatomic) IBOutlet UILabel *TYFYOrder;
@property (retain, readwrite) NSString *appointment;
@end
