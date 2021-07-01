//
//  BaseVC.m
//  FruitMarket
//
//  Created by subhashsanghani on 9/21/16.
//  Copyright © 2016 com. All rights reserved.
//

#import "BaseVC.h"
#import <sys/xattr.h>
#import "CartVC.h"
#import "ViewController.h"
#import "LeftMenuViewController.h"
#import "ProductListVC.h"

#import "Languge.h"
#import "Common.h"

@interface BaseVC ()<LeftMenuViewControllerDelegate>{
    UIView *unsubscribe_alertview;
    LocalizeButton *btnArabic, *btnEnglish;
    LeftMenuViewController *objMenu;
}
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    cart = [[BaseCart alloc] init];
    numberBudget = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(20, 00, 35,20)];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    numberBudget.value = [cart getCartItemCount];
    //[self changeDirection];
}
-(void)changeDirection{
    if([[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULTS_APP_LANGUAGE] isEqualToString:@"en"]){
        [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight relativeToLayoutDirection:UIUserInterfaceLayoutDirectionLeftToRight];
        [[UINavigationBar appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
       
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }else{
        [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft relativeToLayoutDirection:UIUserInterfaceLayoutDirectionRightToLeft];
        [[UINavigationBar appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
                [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setActionbarLogo{
    UIImageView *headerImageView;
    //if ([[LocalizationSystem sharedLocalSystem] isDirectionRTL]) {
        headerImageView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_top.png"]];
    //}else{
    //    headerImageView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_logo.png"]];
    //}
    
    headerImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGRect frame = headerImageView.frame;
    frame.size.height = 40;
    frame.origin.x = 20;
    headerImageView.frame = frame;
    
    [[self navigationItem] setTitleView:headerImageView];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/*-- App task following with fetch data from API
*/
#pragma mark - Get and Post method

-(void)getResponseFromURL:(NSString*)strURL withParam:(NSMutableDictionary*)dictParams progress:(void(^)(NSProgress *downloadProgress))blockProgress success:(void (^)(NSURLSessionDataTask *task, id responseObject, bool isSuccess))blockSuccess failure:(void(^)(NSURLSessionDataTask *task, NSError *error))blockFailure showLoader:(BOOL)isShowDefaultLoader showAnimated:(BOOL)isShowAnimated hideLoader:(BOOL)isHideDefaultLoader{
    MBProgressHUD *hudProgress;
    if (isShowDefaultLoader) {
        hudProgress = [MBProgressHUD showHUDAddedTo:self.view animated:isShowAnimated];
        hudProgress.labelText = NSLocalizedStrings(@"Loading", @"") ;
        //hudProgress.color = [UIColor clearColor];
        //hudProgress.activityIndicatorColor = [self colorFromRed:82 green:82 blue:82 alpha:1.0];
        hudProgress.mode = MBProgressHUDModeIndeterminate;
        //hudProgress.dimBackground = NO;
    }
    if (!dictParams)
    {
        dictParams = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    
    NSLog(@"Calling URL : %@",strURL);
    NSLog(@"Parameters  : %@",dictParams);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:strURL parameters:dictParams progress:^(NSProgress * _Nonnull downloadProgress) {
        blockProgress(downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Response: %@",responseObject);
        BOOL isSuccess = NO;
        
        if ([[responseObject objectForKey:@"response"] isEqual:@1]) {
            isSuccess = YES;
        }
        
        if (isHideDefaultLoader) {
            [hudProgress hide:YES];
        }
        
        blockSuccess(task, responseObject, isSuccess);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@",error);
        
        if (isHideDefaultLoader)
        {
            [hudProgress hide:YES];
        }
        
        blockFailure(task,error);
    }];
}

-(void)getResponseFromURL:(NSString*)strURL withParam:(NSMutableDictionary*)dictParams progress:(void(^)(NSProgress *downloadProgress))blockProgress success:(void (^)(NSURLSessionDataTask *task, id responseObject, bool isSuccess))blockSuccess failure:(void(^)(NSURLSessionDataTask *task, NSError *error))blockFailure showLoader:(BOOL)isShowDefaultLoader hideLoader:(BOOL)isHideDefaultLoader{
    if([self isInternetConnected]){
        if([self isHostReachability]){
            [self getResponseFromURL:strURL withParam:dictParams progress:blockProgress success:blockSuccess failure:blockFailure showLoader:isShowDefaultLoader showAnimated:YES hideLoader:isHideDefaultLoader];
        }else{
            [self noInternetScreenOpen];
        }
    }else{
        [self noInternetScreenOpen];
    }
}

-(void)postResponseFromURL:(NSString *)strURL withParams:(NSMutableDictionary *)dictParams progrss:(void(^)(NSProgress *uploadProgress))blockProgress success:(void (^)(NSURLSessionDataTask *task, id responseObject, bool isSuccess))blockSuccess failure:(void (^)(NSURLSessionDataTask *task, NSError *error))blockFailure showLoader:(BOOL)isShowDefaultLoader showAnimated:(BOOL)isShowLoaderAnimated hideLoader:(BOOL)isHideDefaultLoader{
    
    MBProgressHUD *hudProgress;
    if (isShowDefaultLoader)
    {
        hudProgress = [MBProgressHUD showHUDAddedTo:self.view animated:isShowLoaderAnimated];
        //hudProgress.activityIndicatorColor = [self colorFromRed:82 green:82 blue:82 alpha:1.0];
        hudProgress.mode = MBProgressHUDModeIndeterminate;
        hudProgress.labelText = NSLocalizedStrings(@"Loading", @"");
    }
    
    if (!dictParams)
    {
        dictParams = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    
    NSLog(@"Calling URL : %@",strURL);
    NSLog(@"Parameters  : %@",dictParams);
    [dictParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULTS_APP_LANGUAGE] forKey:@"lang"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
     //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:strURL parameters:dictParams progress:^(NSProgress * _Nonnull uploadProgress) {
        blockProgress(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Response: %@",responseObject);
        
        BOOL isSuccess = NO;
        
        if (isHideDefaultLoader)
        {
            [hudProgress hide:YES];
        }
        
        blockSuccess(task, responseObject, isSuccess);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@",error);
        
        if (isHideDefaultLoader)
        {
            [hudProgress hide:YES];
        }
        
        blockFailure(task, error);
    }];
}


-(void)postResponseFromURL:(NSString *)strURL withParams:(NSMutableDictionary *)dictParams progrss:(void(^)(NSProgress *uploadProgress))blockProgress success:(void (^)(NSURLSessionDataTask *task, id responseObject, bool isSuccess))blockSuccess failure:(void (^)(NSURLSessionDataTask *task, NSError *error))blockFailure showLoader:(BOOL)isShowDefaultLoader hideLoader:(BOOL)isHideDefaultLoader{
    if([self isInternetConnected]){
        if([self isHostReachability]){
            [self postResponseFromURL:strURL withParams:dictParams progrss:blockProgress success:blockSuccess failure:blockFailure showLoader:isShowDefaultLoader showAnimated:YES hideLoader:isHideDefaultLoader];
        }else{
            [self noInternetScreenOpen];
        }
    }else{
        [self noInternetScreenOpen];
    }
}

- (void)showAlertForTitle:(NSString *)strTitle withMessage:(NSString *)strMessage
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:NSLocalizedStrings(strTitle, nil)
                                 message:NSLocalizedStrings(strMessage, nil)
                                 preferredStyle:UIAlertControllerStyleAlert];
    
  
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:NSLocalizedStrings(@"Ok", @"")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];

}

-(NSString *)getStringURLForAPI:(NSString *)strAPI
{
    return [URL_API_HOST stringByAppendingString:strAPI];
}
-(void)addMenuButton
{
    UIButton *btnShowMenu = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnShowMenu setImage:self.defaultMenuImage forState:UIControlStateNormal];
    btnShowMenu.frame = CGRectMake(0, 0, 30, 30);
    [btnShowMenu addTarget:self action:@selector(onShowMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:btnShowMenu];
    //    [btnShowMenu setBackgroundColor:[UIColor blueColor]];
    
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    objMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
    
    [objMenu setDelegate:self];
    [self.view addSubview:objMenu.view];
    [self addChildViewController:objMenu];
    
    [objMenu.view layoutIfNeeded];
    
}
- (UIImage *)defaultMenuImage {
    static UIImage *defaultMenuImage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.f, 22.f), NO, 0.0f);
        
        [[UIColor blackColor] setFill];
        [[UIBezierPath bezierPathWithRect:CGRectMake(0, 3, 20, 1)] fill];
        [[UIBezierPath bezierPathWithRect:CGRectMake(0, 10, 20, 1)] fill];
        [[UIBezierPath bezierPathWithRect:CGRectMake(0, 17, 20, 1)] fill];
        
        [[UIColor whiteColor] setFill];
        [[UIBezierPath bezierPathWithRect:CGRectMake(0, 4, 20, 1)] fill];
        [[UIBezierPath bezierPathWithRect:CGRectMake(0, 11,  20, 1)] fill];
        [[UIBezierPath bezierPathWithRect:CGRectMake(0, 18, 20, 1)] fill];
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    });
    return defaultMenuImage;
}
-(void)onShowMenu{
    [objMenu leftSideMenuButtonPressed];
    
}
-(void)addCartButton{
    
    numberBudget.lineWidth = 0.0;
    
    numberBudget.value = [cart getCartItemCount];
    
    // Allocate UIButton
    UIButton *btn = [UIButton  buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    btn.layer.cornerRadius = 8;
    [btn setTitle:@"" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onShowCart:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];
    
    [btn setFont:[UIFont systemFontOfSize:13]];
    [btn addSubview:numberBudget]; //Add NKNumberBadgeView as a subview on UIButton
    
    
    
    // Initialize UIBarbuttonitem...
    UIBarButtonItem *proe = [[UIBarButtonItem alloc] initWithCustomView:btn];
/*
  
    UIButton *btnShowMenu = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnShowMenu setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    btnShowMenu.frame = CGRectMake(0, 0, 30, 30);
    [btnShowMenu addTarget:self action:@selector(openSearchScreen) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:btnShowMenu];
    */
    
    //    [btnShowMenu setBackgroundColor:[UIColor blueColor]];
    
 //   self.navigationItem.rightBarButtonItems = @[proe, customBarItem];
    
    self.navigationItem.rightBarButtonItem = proe;
 
}


-(void)updateCart{
    
    numberBudget.lineWidth = 0.0;
    numberBudget.value = [cart getCartItemCount];
    
   
    
}


-(void)openSearchScreen{
    ProductListVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductListVC"];
    vc.is_search = @"true";
    [self.navigationController pushViewController:vc animated:true];
}
-(IBAction)onShowCart:(UIButton *)sender
{
    if ([cart getCartItemCount] > 0) {
        CartVC *voice = [self.storyboard instantiateViewControllerWithIdentifier:@"CartVC"];
        [self.navigationController pushViewController:voice animated:YES];
    }else{
        [self showAlertForTitle:NSLocalizedStrings(@"Empty", @"") withMessage:NSLocalizedStrings(@"No any items in your Cart", nil)];
    }
    
}
-(IBAction)onSearchView:(id)sender{
    //SearchVC *voice = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchVC"];
    //[self.navigationController pushViewController:voice animated:YES];
}

-(void)noInternetScreenOpen{
    //NoInternetVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NoInternetVC"];
    //[self.navigationController pushViewController:vc animated:TRUE];
    [self showAlertForTitle:NSLocalizedStrings(@"Internet!", @"") withMessage:NSLocalizedStrings(@"No internet connection available..", nil)];
}
-(BOOL)isHostReachability{
    self.hostReachability = [Reachability reachabilityWithHostName:URL_API_HOST_BASE];
    [self.internetReachability startNotifier];
    NetworkStatus netStatus = [self.internetReachability currentReachabilityStatus];
    switch (netStatus)
    {
        case NotReachable:        {
            return false;
            break;
        }
            
        case ReachableViaWWAN:        {
            return true;
            break;
        }
        case ReachableViaWiFi:        {
            return true;
            break;
        }
    }
    return false;
}
-(BOOL)isInternetConnected{
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    NetworkStatus netStatus = [self.internetReachability currentReachabilityStatus];
    //BOOL connectionRequired = [self.internetReachability connectionRequired];
    //NSString* statusString = @"";
    
    switch (netStatus)
    {
        case NotReachable:        {
            return false;
            break;
        }
            
        case ReachableViaWWAN:        {
            return true;
            break;
        }
        case ReachableViaWiFi:        {
            return true;
            break;
        }
    }
    return false;
}
-(BOOL)isRTL{
    if ([[[LocalizationSystem sharedLocalSystem] getLanguage] isEqualToString:@"ar"] ) {
        return true;
    }else{
        return false;
    }
    
}
-(CGRect)changeViewDirection:(CGRect)frame screenwidth:(double)screenwidth extraOffset:(double)extraoffcet{
    
    frame.origin.x =   screenwidth- frame.size.width - frame.origin.x - extraoffcet;
    return frame;
}
-(CGRect)changeViewToStart:(CGRect)frame {
    frame.origin.x =   15;
    return frame;
}

-(IBAction)chooseLang:(id)sender{
    if(![unsubscribe_alertview isDescendantOfView:self.view]) {
        
        
        unsubscribe_alertview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [unsubscribe_alertview setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
        
        int alert_width = kScreenWidth - 20;
        int alert_pading_hr = 10;
        int alert_height = 120;
        
        
        UIView *alertbox = [[UIView alloc] initWithFrame:CGRectMake( alert_pading_hr, (kScreenHeight / 2) - alert_height , alert_width, alert_height)];
        [alertbox.layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
        [alertbox.layer setCornerRadius:4];
        
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, alertbox.frame.size.width, 20)];
        lblTitle.text = NSLocalizedStrings( @"Language Preference", nil);
        [lblTitle setTextAlignment:NSTextAlignmentCenter];
        [alertbox addSubview:lblTitle];
        
        UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, alertbox.frame.size.width -10 , 30)];
        lblDescription.text = NSLocalizedStrings(@"Select your preferred language", nil);
        [lblDescription setTextAlignment:NSTextAlignmentCenter];
        [lblDescription setFont:[UIFont systemFontOfSize:10]];
        [lblDescription setNumberOfLines:2];
        [alertbox addSubview:lblDescription];
        
        btnEnglish = [[LocalizeButton alloc] initWithFrame:CGRectMake(10, 65, (alertbox.frame.size.width / 2 ) - 12, 40)];
        
        
        [btnEnglish setTitle: @"English" forState:UIControlStateNormal];
        [btnEnglish addTarget:self action:@selector(btnlanguageChange:) forControlEvents:UIControlEventTouchUpInside];
        [btnEnglish setTag:1];
        [btnEnglish setBackgroundColor:PRIMARY_COLOR];
        [alertbox addSubview:btnEnglish];
        
        
        btnArabic = [[LocalizeButton alloc] initWithFrame:CGRectMake( (alertbox.frame.size.width / 2 ) + 2  , 65, (alertbox.frame.size.width / 2) - 10, 40)];
        
        
        [btnArabic setTitle: @"العربية" forState:UIControlStateNormal];
        [btnArabic addTarget:self action:@selector(btnlanguageChange:) forControlEvents:UIControlEventTouchUpInside];
        [btnArabic setTag:2];
        [btnArabic setBackgroundColor:PRIMARY_COLOR];
        [alertbox addSubview:btnArabic];
        
        
        
        //[btnEnglish setBackgroundImage:[UIImage imageNamed:@"popup_buttton_small"] forState:UIControlStateNormal];
        //[btnArabic setBackgroundImage:[UIImage imageNamed:@"button_border"] forState:UIControlStateNormal];
        [btnEnglish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnArabic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        /*if([[LocalizationSystem sharedLocalSystem] isDirectionRTL]){
         btnArabic.frame =  CGRectMake(10, 65, (alertbox.frame.size.width / 2 ) - 12, 40);
         btnEnglish.frame = CGRectMake( (alertbox.frame.size.width / 2 ) + 2  , 65, (alertbox.frame.size.width / 2) - 10, 40);
         [btnRemember setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
         [btnRemember setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
         }*/
        
        [unsubscribe_alertview addSubview:alertbox];
        [self.view addSubview:unsubscribe_alertview];
        //[common animateShow:unsubscribe_alertview];
        
    } else {
        [unsubscribe_alertview removeFromSuperview];
    }
}
-(IBAction)btnlanguageChange:(id)sender{
    int buttonIndex = (int) [sender tag];
    if (buttonIndex==1) {
        [[LocalizationSystem sharedLocalSystem] setLanguage:@"en"];
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:USERDEFAULTS_APP_LANGUAGE];
        [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
        [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight relativeToLayoutDirection:UIUserInterfaceLayoutDirectionLeftToRight];
        }
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [[UINavigationBar appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [[UITabBar appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        
    }
    else if (buttonIndex==2)
    {
        [[LocalizationSystem sharedLocalSystem] setLanguage:@"ar"];
        [[NSUserDefaults standardUserDefaults] setObject:@"ar" forKey:USERDEFAULTS_APP_LANGUAGE];
        //[[LocalizationSystem sharedLocalSystem] setLanguage:@"ar-KW"];
        //[[NSUserDefaults standardUserDefaults] setObject:@"ar-KW" forKey:USERDEFAULTS_APP_LANGUAGE];
        [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
            [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft relativeToLayoutDirection:UIUserInterfaceLayoutDirectionRightToLeft];
        }
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [[UINavigationBar appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [[UITabBar appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate loadSharedInstance];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_USERDATA])
    {
        UINavigationController *secondViewController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"HomeviewControler"];
        [self presentViewController:secondViewController animated:YES completion:nil];
    }else{
        UINavigationController *secondViewController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"LoginBaseVC"];
        [self presentViewController:secondViewController animated:YES completion:nil];
    }
     
    
}
-(void)setSimpleImageToView:(UIImageView*)imgView imgpath:(NSString*)imgPath
{
    [imgView setImage:[UIImage imageNamed:@"loading.png"] ];
    
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *imgName = [imgPath lastPathComponent];
    NSString *imagePath = [documentsDir stringByAppendingPathComponent:imgName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    bool success = [fileManager fileExistsAtPath: imagePath];
    
    if (!success)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[imgPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]]];
                           
                           //NSLog(@"%@", [NSString stringWithFormat:@"http://tilesstore.in/admin/userfiles/products/small/%@", imageName]);
                           
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              if(image!=nil)
                                              {
                                                  NSString *documentsDir = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                                                  
                                                  [UIImageJPEGRepresentation(image, 1.0) writeToFile:imagePath options:NSAtomicWrite error:nil];
                                                  
                                                  [self addSkipBackupAttributeToPath:[documentsDir stringByAppendingPathComponent:imgPath]];
                                                  
                                                  [imgView setImage:image];
                                                  
                                                  //                                                  [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                              }
                                          });
                       });
    }
    else
    {
        [imgView setImage: [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:imagePath ]]]];
    }
    
}
-(void)addSkipBackupAttributeToPath:(NSString*)path
{
    //    NSLog(@"%@", path);
    u_int8_t b = 1;
    setxattr([path fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
}

-(NSString*)getStringDateFormate:(NSDate*)date{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yyyy"];
    NSString* finalDateString = [format stringFromDate:date];
    
    
    return finalDateString;
}
-(NSString*)getMySqlDateFormate:(NSDate*)date{
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:usLocale];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString* finalDateString = [format stringFromDate:date];
    
    
    return finalDateString;
}
@end

