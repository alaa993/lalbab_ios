//
//  ContactUsController.h
//  GroceryStore
//
//  Created by alaa on 4/30/20.
//  Copyright © 2020 Way. All rights reserved.
//

#ifndef ContactUsController_h
#define ContactUsController_h
#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface ContactUsController : BaseVC
#endif /* ContactUsController_h */

@property (strong, nonatomic) IBOutlet UIButton *btnCall;
@property (strong, nonatomic) IBOutlet UIButton *btnCall1;
@property (strong, nonatomic) IBOutlet UIButton *btncall2;
@property (strong, nonatomic) IBOutlet UIButton *btncall21;
@property (strong, nonatomic) IBOutlet UIButton *btnemail;

@property (weak, nonatomic) IBOutlet UILabel *lblTitleContact;

@end
