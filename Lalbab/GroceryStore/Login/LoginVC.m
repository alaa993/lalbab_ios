//
//  LoginVC.m
//  Clinic App
//
//  Created by subhashsanghani on 7/7/17.
//  Copyright © 2017 Way. All rights reserved.
//
#import "RegisterVC.h"
#import "LoginVC.h"
#import "Languge.h"
#import "Common.h"
#import "CountryListViewController.h"

@import FirebaseAuth;

@interface LoginVC ()

@end

@implementation LoginVC





- (void)viewDidLoad {
    [super viewDidLoad];

     
    self.navigationItem.title = NSLocalizedStrings(@"Login Now", nil);
    self.txt_login.text = NSLocalizedStrings(@"Login Now", nil);
    self.txt_phone.text = NSLocalizedStrings(@"Your phone", nil);
    self.txt_code.text = NSLocalizedStrings(@"Code", nil);
    
    
    [self.btnRegister setTitle:NSLocalizedStrings(@"Register", nil) forState:UIControlStateNormal];
    


    // Do any additional setup after loading the view.
    _btnLogin.layer.cornerRadius = _btnLogin.frame.size.height / 2;
    _btnRegister.layer.cornerRadius = _btnRegister.frame.size.height / 2;
     [_scrollview setContentSize:CGSizeMake(kScreenWidth, 550)];
    
   // [FIRAuth auth].currentUser.uid;
    
    // [FIRAuth auth].currentUser.uid ;
   /*
    if ([FIRAuth auth].currentUser != nil) {
        NSLog(@"currentUser.uid: %@", [FIRAuth auth].currentUser.uid);
        NSLog(@"currentUser.phoneNumber: %@", [FIRAuth auth].currentUser.phoneNumber);
           
    }else {
         NSLog(@"Login");
    }
    [_txtUsername resignFirstResponder];
    [_txtPassword resignFirstResponder];
    
   // _txtUsername.text = @"+16505553555";
   // _txtPassword.text = @"123456";
      
    _txtUsername.text = @"";
    _txtPassword.text = @"";
          
    
    myswift = [MySwiftClass new];
   // [myswift logout];
    [self  login];
    
    [_txtPassword setHidden:true];
    [_lb_code setHidden:true];
    */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonClicked:(id)sender {
    /*
     [aTimer invalidate];
    
    aTimer = [NSTimer timerWithTimeInterval:(2.0f) target:self
                                   selector:@selector(methodB:) userInfo:nil repeats:YES];
              
           NSRunLoop *runner = [NSRunLoop currentRunLoop];
           [runner addTimer:aTimer forMode: NSDefaultRunLoopMode];
             
    
    
    if ([myswift isCodeSend]) {
        
        if (_txtPassword.text .length != 6) {
            return ;
        }
        
        [myswift viryfyWithCode:_txtPassword.text];
        
      ;
        
       
           
    }else {
        NSString *string1 = [_codetxt.text stringByAppendingString:_txtUsername.text];
        NSLog(@"phone number %@", string1);
           [myswift logphoneWithPhone:string1];
      
        
    }
    
   
 
    
    */
    FUIAuth *authUI = [FUIAuth defaultAuthUI];
         authUI.delegate = self;

         //The following array may contain diferente options for validate the user (with Facebook, with google, e-mail...), in this case we only need the phone method
         NSArray<id<FUIAuthProvider>> * providers = @[[[FUIPhoneAuth alloc]initWithAuthUI:[FUIAuth defaultAuthUI]]];
         authUI.providers = providers;

         //You can present the screen asking for the user number with the following method.
         FUIPhoneAuth *provider = authUI.providers.firstObject;
         [provider signInWithPresentingViewController:self phoneNumber:nil];
}



-(void) login2:(NSString*) uid :(NSString*) phone :(NSString*) token{
    
      
    
        NSDictionary *dictParams = @{
                                     @"password": uid,
                                     @"user_email": phone,
                                     @"token_ios": token
                                     };
        
        [self postResponseFromURL:[self getStringURLForAPI:URL_API_LOGIN] withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
            
        } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
            if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
                
               // [self showAlertForTitle:NSLocalizedStrings(@"Login",@"Login") withMessage:@"Sussess"];
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[responseObject objectForKey:PARAM_DATA]] forKey:USERDEFAULTS_USERDATA];
                [[NSUserDefaults standardUserDefaults] synchronize];
                app.dictUser = [[NSMutableDictionary alloc] initWithDictionary:[[responseObject objectForKey:PARAM_DATA] mutableCopy]];
                
                ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"homeCV"];
                                     [self.navigationController pushViewController:vc animated:true];
                                      
                
                
                
                
            }
            else{
                RegisterVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVC"];
                                         vc.uid = uid;
                                         vc.mobile = phone;
                                         vc.token = token;
                                      [self.navigationController pushViewController:vc animated:true];
            //  MySwiftClass *myswift2 = [MySwiftClass new];
             //   [myswift2 logout];
                
              //  [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
          
        } showLoader:YES hideLoader:YES];
        
}

-(void) checklogin2:(NSString*) uid :(NSString*) phone :(NSString*) token{
    
        NSDictionary *dictParams = @{
                                     @"password": uid,
                                     @"user_email": phone,
                                     @"token_ios": token
                                     };
        
        [self postResponseFromURL:[self getStringURLForAPI:URL_API_CheckLOGIN] withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
            
        } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
            if ([[[responseObject objectForKey:PARAM_chekRESPONSE] stringValue]   isEqual: @"L"]) {
                
               // [self showAlertForTitle:NSLocalizedStrings(@"Login",@"Login") withMessage:@"Sussess"];
              
                
                 [self login2:uid :phone :token];
                                      
                
                
                
                
            }
            else{
             RegisterVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVC"];
                vc.uid = uid;
                vc.mobile = phone;
                vc.token = token;
             [self.navigationController pushViewController:vc animated:true];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        } showLoader:YES hideLoader:YES];
        
        
  
}


- (void)authUI:(FUIAuth *)authUI didSignInWithUser:(nullable FIRUser *)user error:(nullable NSError *)error {
    if (error == nil) {
        NSLog(@"%@",user.phoneNumber);
        NSLog(@"%@",user.uid);
        [self login2:user.uid :user.phoneNumber :user.refreshToken];
    }
    else{
        NSLog(@"%@",error);
    }
}
- (FUIAuthPickerViewController *)authPickerViewControllerForAuthUI:(FUIAuth *)authUI {
    return [[FUIAuthPickerViewController alloc] initWithNibName:@"FUICustomAuthPickerViewController"
                                                             bundle:[NSBundle mainBundle]
                                                             authUI:authUI];
}
@end
