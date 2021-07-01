//
//  UpdateProfileVC.m
//  Clinic App
//
//  Created by subhashsanghani on 7/8/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import "UpdateProfileVC.h"
#import "ChangePasswordVC.h"
#import "Languge.h"
#import "Common.h"

@interface UpdateProfileVC ()

@end

@implementation UpdateProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
   //ic_change_password
    self.navigationItem.title = NSLocalizedStrings(@"Update Profile", nil);
    _updateButton.layer.cornerRadius = _updateButton.frame.size.height / 2;
    
  
    
    
    //    [btnShowMenu setBackgroundColor:[UIColor blueColor]];
    
  
    
    [_userImage.layer setCornerRadius:_userImage.layer.frame.size.height / 2];
    [_userImage.layer setBorderWidth:1.0];
    [_userImage setClipsToBounds:true];
    [_userImage setBackgroundColor:[UIColor whiteColor]];
    
    [_userImage.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    // Do any additional setup after loading the view.
    [self loadUserData];
    
    [_scrollview setContentSize:CGSizeMake(kScreenWidth, kScreenHeight)];
    
    
     self.lb_name.text = NSLocalizedStrings(@"Your full name", nil);
     self.lb_phone.text = NSLocalizedStrings(@"Your phone", nil);
  
    
}
-(void)openChangePassword{
    /*
    ChangePasswordVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordVC"];
    [self.navigationController pushViewController:vc animated:true];
    */
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadUserData{
    _txtPhone.text = [app.dictUser valueForKey:@"user_phone"];
    _txtEmailId.text = [app.dictUser valueForKey:@"user_email"];
    _txtUsername.text = [app.dictUser valueForKey:@"user_fullname"];
    [self setSimpleImageToView:_userImage imgpath:[NSString stringWithFormat:@"%@%@/%@",URL_API_HOST_BASE,IMAGE_PROFILE_PATH,[app.dictUser valueForKey:@"user_image"]]];
    /*NSDictionary *dictParams = @{
                                 @"user_id": [app.dictUser valueForKey:@"user_id"]
                                 };
    
    
    [self postResponseFromURL:[self getStringURLForAPI:URL_API_USER_DATA] withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
            if(![[responseObject objectForKey:PARAM_DATA] isEqual:[NSNull null]] ){
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[responseObject objectForKey:PARAM_DATA]] forKey:USERDEFAULTS_USERDATA];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[[responseObject objectForKey:PARAM_DATA] mutableCopy]];
                
                _txtPhone.text = [dict valueForKey:@"user_phone"];
                _txtEmailId.text = [dict valueForKey:@"user_email"];
                _txtUsername.text = [dict valueForKey:@"user_fullname"];
            }
        }
        else{
            [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showLoader:YES hideLoader:YES];
    */
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)registerButtonClicked:(id)sender {
    [_txtPhone resignFirstResponder];
    [_txtEmailId resignFirstResponder];
    [_txtUsername resignFirstResponder];
    BOOL isValidated = YES;
    NSString *strMessage=@"";
    
    if (_txtPhone.text.length == 0)
    {
        isValidated = NO;
        strMessage = NSLocalizedStrings(@"Please Enter Phone Number", @"");
    }
    
    else if (_txtUsername.text.length == 0)
    {
        isValidated = NO;
        strMessage = NSLocalizedStrings(@"Please Enter User Name", @"");
    }
    
    if (!isValidated)
    {
        [self showAlertForTitle:NSLocalizedStrings(@"Error!",@"") withMessage:strMessage];
        return;
    }
    
    NSDictionary *dictParams = @{
                                 @"user_id": [app.dictUser valueForKey:@"user_id"],
                                 @"user_mobile": _txtPhone.text,
                                 @"user_fullname": _txtUsername.text
                                 };
    
    [self postResponseFromURL:[self getStringURLForAPI:URL_API_PROFILE_UPDATE] withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
            
            app.dictUser = [[NSMutableDictionary alloc] initWithDictionary:[responseObject valueForKey:@"data"]];
            [self showAlertForTitle:@"Success!" withMessage:@"Profile Updated Successfully"];
            
        }
        else{
            [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showLoader:YES hideLoader:YES];
    
    
}


-(IBAction)btnChooseImage:(id)sender{
    UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
    videoPicker.delegate = self;
    //videoPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    // videoPicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    // videoPicker.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
    videoPicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    [self presentViewController:videoPicker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImageBig = info[UIImagePickerControllerOriginalImage];
    //UIImage *small = [UIImage imageWithCGImage:chosenImageBig.CGImage scale:0.25 orientation:chosenImageBig.imageOrientation];
    
    NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(chosenImageBig, 0.5f)];//1.0f = 100% quality
    
    [self uploadProfileImage:data2];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (NSString*)getTimeString
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSInteger day = [components day];
    NSInteger week = [components month];
    NSInteger year = [components year];
    NSInteger hour = [components hour];
    NSInteger minut = [components minute];
    NSInteger second = [components second];
    
    NSString *string = [NSString stringWithFormat:@"%ld%ld%ld%ld.jpg", (long)day,(long)hour, (long)minut, (long)second];
    return string;
    
    
}
-(void)uploadProfileImage:(NSData*)datafile{
    NSDictionary *dictParams = @{
                                 @"user_id": [app.dictUser valueForKey:@"user_id"]
                                 };
    
    MBProgressHUD *hudProgress;
        hudProgress = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        hudProgress.labelText = NSLocalizedStrings(@"Loading", @"") ;
        hudProgress.mode = MBProgressHUDModeIndeterminate;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:[self getStringURLForAPI:URL_API_UPDATE_PROFILE_IMAGE] parameters:dictParams
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
    [formData appendPartWithFileData:datafile name:@"image" fileName:[self getTimeString] mimeType:@"image/jpeg"];
}
         progress:^(NSProgress * _Nonnull downloadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             
             if ([[responseObject objectForKey:@"responce"] integerValue] == 1 ) {
                 
                 NSString *imageUrl = [NSString stringWithFormat:@"%@%@%@",URL_API_HOST_BASE,IMAGE_PROFILE_PATH,[responseObject valueForKey:PARAM_DATA]];
                 [self setImage:imageUrl];
                 [app.dictUser setValue:[responseObject valueForKey:PARAM_DATA] forKey:@"user_image"];
                 
             }else{
                 
                 [self showAlertForTitle:@"Error!" withMessage:[responseObject valueForKey:@"error"]];
             }
             
             [hudProgress hide:YES];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"Error: %@",error);
             [hudProgress hide:YES];
         }];
}
-(void)setImage:(NSString *)imageUrl{
    _userImage.imageURL = [NSURL URLWithString:imageUrl];
    [_userImage setClipsToBounds:true];
    /* [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
     logoImage.image = [UIImage imageWithData:data];
     }];*/
}
@end
