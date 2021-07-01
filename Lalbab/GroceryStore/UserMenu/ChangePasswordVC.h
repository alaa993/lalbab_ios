//
//  ChangePasswordVC.h
//  Clinic App
//
//  Created by subhashsanghani on 7/8/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
@interface ChangePasswordVC : BaseVC
@property (strong, nonatomic) IBOutlet UITextField *txtCurrentPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtRePassword;

@property (strong, nonatomic) IBOutlet UILabel *titCurrentPassword, *titNewPassword, *titRePassword;
@end
