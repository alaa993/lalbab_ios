
//
//  RegisterVC.m
//  Clinic App
//
//  Created by subhashsanghani on 7/7/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import "RegisterVC.h"
#import "Languge.h"
#import "Common.h"
#import "CountryListViewController.h"
#import "LoginVC.h"

@import FirebaseAuth;


@interface RegisterVC ()

@end

@implementation RegisterVC



NSString *user_mobile=@"";
NSString *password=@"";
NSString *user_name=@"";



- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.navigationItem.title = NSLocalizedStrings(@"Register", nil);
    _btnRegister.layer.cornerRadius = _btnRegister.frame.size.height / 2;
    // abey lera bangi textakan bkai hata la reload value new war grnawa
    //bo nmuna codak denm esta
    
    // Do any additional setup after loading the view.
    [_scrollview setContentSize:CGSizeMake(kScreenWidth, 550)];
    
    
   
    [_lb_code setHidden:true];
    [_txtPassword setHidden:true];
    
    
    
    self.lb_name.text = NSLocalizedStrings(@"Your full name", nil);
    self.lb_phone.text = NSLocalizedStrings(@"Your phone", nil);
    self.lb_code.text = NSLocalizedStrings(@"Code", nil);

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
bool *iscode2;

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)registerButtonClicked:(id)sender {
    
    [_txtUsername resignFirstResponder];
    BOOL isValidated = YES;
    NSString *strMessage=@"";
    
    
    if (_txtUsername.text.length == 0)
    {
        isValidated = NO;
        strMessage = NSLocalizedStrings(@"Please Enter User Name", @"");
    }
    
   
    [self requestRegester1:_uid :_mobile :_token :_txtUsername.text];
    
/*
    
    [aTimer2 invalidate];
    
    aTimer2 = [NSTimer timerWithTimeInterval:(2.0f) target:self selector:@selector(methodC:) userInfo:nil repeats:YES];
           
           NSRunLoop *runner = [NSRunLoop currentRunLoop];
           [runner addTimer:aTimer2 forMode: NSDefaultRunLoopMode];
    
    
    if (myswift2.isCodeSend) {
        [myswift2 viryfyWithCode:_txtPassword.text];
        
       
        
    }else{
        NSString *string1 = [_textCodeR.text stringByAppendingString:_txtPhone.text];
               NSLog(@"phone number %@", string1);
        [myswift2 logphoneWithPhone:string1];
        
        
        
    }
 */
    

    
}






-(void)requestRegester1 :(NSString*) uid : (NSString*) phone : (NSString*) token :(NSString*) name{
    
    
    NSDictionary *dictParams = @{
                               
                                
                        
                                 @"user_phone": phone,
                                 @"user_uid": uid,
                                  @"user_email": @"",
                                 @"user_name": name
                                 
                                 };
    
    [self postResponseFromURL:[self getStringURLForAPI:URL_API_REGISTER] withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
           
            [self login2:uid :phone :token];
            
        }
        else{
            [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showLoader:YES hideLoader:YES];
    
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
                self->app.dictUser = [[NSMutableDictionary alloc] initWithDictionary:[[responseObject objectForKey:PARAM_DATA] mutableCopy]];
                
                ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"homeCV"];
                [self.navigationController pushViewController:vc animated:true];
                                      
                
                
                
                
            }
            else{
              MySwiftClass *myswift2 = [MySwiftClass new];
                [myswift2 logout];
                
                [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        } showLoader:YES hideLoader:YES];
        
}
@end
