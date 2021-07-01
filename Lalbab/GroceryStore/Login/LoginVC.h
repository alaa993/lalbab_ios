//
//  LoginVC.h
//  Clinic App
//
//  Created by subhashsanghani on 7/7/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
@interface LoginVC : BaseVC<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;

@property (weak, nonatomic) IBOutlet UILabel *txt_login;

@property (weak, nonatomic) IBOutlet UILabel *txt_phone;

@property (weak, nonatomic) IBOutlet UILabel *txt_code;

@property (weak, nonatomic) IBOutlet UILabel *lb_code;
@property (strong, nonatomic) IBOutlet UITextField *codetxt;

- (IBAction)code:(id)sender;

@end
