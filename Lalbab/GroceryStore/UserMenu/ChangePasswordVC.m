//
//  ChangePasswordVC.m
//  Clinic App
//
//  Created by subhashsanghani on 7/8/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "Languge.h"
#import "Common.h"

@interface ChangePasswordVC ()

@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedStrings(@"Change Password", nil);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)changePasswordClick:(id)sender {
    [_txtRePassword resignFirstResponder];
    
    [_txtNewPassword resignFirstResponder];
    [_txtCurrentPassword resignFirstResponder];
    BOOL isValidated = YES;
    NSString *strMessage=@"";
    
    if (_txtCurrentPassword.text.length == 0)
    {
        isValidated = NO;
        strMessage = NSLocalizedStrings(@"Please Enter Current Password", @"");
    }
    
    else if (_txtNewPassword.text.length == 0)
    {
        isValidated = NO;
        strMessage = NSLocalizedStrings(@"Please Enter New Password", @"");
    }else if (_txtRePassword.text.length == 0)
    {
        isValidated = NO;
        strMessage = NSLocalizedStrings(@"Please Enter New Password Again", @"");
    }else if (![_txtNewPassword.text isEqualToString:_txtRePassword.text])
    {
        isValidated = NO;
        strMessage = NSLocalizedStrings(@"Please Enter New Password Again not march with New Password", @"");
    }
    
    if (!isValidated)
    {
        [self showAlertForTitle:NSLocalizedStrings(@"Error!",@"") withMessage:strMessage];
        return;
    }
    
    NSDictionary *dictParams = @{
                                 @"user_id": [app.dictUser valueForKey:@"user_id"],
                                 @"current_password": _txtCurrentPassword.text,
                                 @"new_password": _txtNewPassword.text
                                 };
    
    [self postResponseFromURL:[self getStringURLForAPI:URL_API_CHANGE_PASSWORD] withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
            [self showAlertForTitle:@"Success" withMessage:@"Password Change Successfully"];
            _txtRePassword.text = @"";
            _txtNewPassword.text = @"";
            _txtCurrentPassword.text = @"";
        }
        else{
            [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showLoader:YES hideLoader:YES];
    
    
}
@end
