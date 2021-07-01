//
//  ViewController.m
//  Grocery Store
//
//  Created by subhashsanghani on 7/27/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import "ViewController.h"
#import "CategoryCell.h"
#import "Category_Cell.h"
#import "ProductPagerVC.h"
#import "RegisterVC.h"
#import "LoginVC.h"
#import "Languge.h"
#import "Common.h"
#import "ControleDawa.h"
#import "CatS.h"




@import FirebaseInstanceID;
@import FirebaseMessaging;
@import FirebaseAuth;
@interface ViewController ()
{
    NSMutableArray *categoryArray;
    
    NSMutableArray *myImages;
    NSTimer *timer;
    NSInteger imageCount;
    BOOL animating;

    __weak IBOutlet UILabel *txt_products;
}
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedStrings(@"Glocery", nil);
    
   collectionView.dataSource = self;
      collectionView.delegate = self;
    
    [btn_loginH setTitle:NSLocalizedStrings(@"Login Now", nil) forState:UIControlStateNormal];
    [btnCreateH setTitle:NSLocalizedStrings(@"Register Now", nil) forState:UIControlStateNormal];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_USERDATA]){
        btn_loginH.hidden = YES;
        btnCreateH.hidden = YES;
        ViewLogin.hidden = YES;

        
    }
   
    // set other properties as per tour needs .

    
    // Do any additional setup after loading the view, typically from a nib.
    categoryArray = [[NSMutableArray alloc] init];
    myImages = [[NSMutableArray alloc] init];
    [self load_slides];
    [self getCategories];
    [self addMenuButton];
    
    
    if ([FIRAuth auth].currentUser != nil) {
        
        [self registerGCMTokenToSite];
       }
    
  
    
    
    
   
    
   // MySwiftClass * myOb = [MySwiftClass new];

    //[myOb prentmsgWithStr:@"kj"];
   
    
    //[myOb someFunction:@"Arg"];
    //[MySwiftClass storeWithData:@"Hi" password:@"secret"];
    //[MySwiftClass hamaWithIndex:10 str:@"jhj"];
   
      [self checkLang];
    
  

}

-(void)checkLang{
    if ([NSLocalizedStrings(@"lg", @"")  isEqual: @"ar"] || [NSLocalizedStrings(@"lg", @"")  isEqual: @"fa"] ) {
          
          [self.navigationController.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
                  [self.navigationController.navigationBar setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
                
               
      }else {
          [self.navigationController.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
                [self.navigationController.navigationBar setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
                  
      }
}

-(void)registerGCMTokenToSite{
    
    NSString *token = @"";//[[FIRInstanceID instanceID] token];
    
    if (token != nil && ![token isEqual:[NSNull null]]) {
        
        
        [[FIRMessaging messaging] subscribeToTopic:@"/topics/grocerystore"];
        NSLog(@"InstanceID token: %@", token);
        if([[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_USERDATA] ){
            NSDictionary *dictParams = @{
                                         @"user_id": [app.dictUser valueForKey:@"user_id"],
                                         @"token": token,
                                         @"device" : @"ios"
                                         };
            
            
            [self postResponseFromURL:[self getStringURLForAPI:URL_API_APN_REGISTER] withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
                
            } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
                if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
                    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"apn_registered"];
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            } showLoader:YES hideLoader:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [self addCartButton];
}
-(void)getCategories{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init] ;
    [params setValue:@"52" forKey:@"parent"] ;
    
    [self postResponseFromURL:[self getStringURLForAPI:URL_API_CATEGORY] withParams:params progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
            [self->categoryArray removeAllObjects];
            [self->categoryArray addObjectsFromArray:[responseObject objectForKey:@"data"]];
            [self->collectionView reloadData];
            // [tableview reloadData];
            
            
        }
        else{
            [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showLoader:YES hideLoader:YES];
}
-(void)load_slides{
    NSURL *URL = [NSURL URLWithString:[self getStringURLForAPI:URL_API_SLIDERS]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:responseObject];
        for (int i = 0; i < [array count]; i++) {
            NSMutableDictionary *desc = [array objectAtIndex:i];
            [myImages addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",URL_API_HOST_BASE,SLIDER_IMAGE_BIG_PATH,[desc valueForKey:@"slider_image"]]]];
            
            
            
        }
        
        [self createSlider];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}
-(void)createSlider{
    slider_scroll_view.frame = CGRectMake(0, 0, kScreenWidth, slider_scroll_view.frame.size.height);
    for (int i=0; i<[myImages count]; i++) {
        
        AsyncImageView *recipeImageView ;
        recipeImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake((kScreenWidth)*i, 0, kScreenWidth , slider_scroll_view.frame.size.height)];
        recipeImageView.clipsToBounds = YES;
        recipeImageView.contentMode = UIViewContentModeScaleAspectFill;
        recipeImageView.imageURL = [myImages objectAtIndex:i];
        //recipeImageView.image = [UIImage imageNamed:[myImages objectAtIndex:i]];
        
        [slider_scroll_view addSubview:recipeImageView];
    }
    [slider_scroll_view setContentSize:CGSizeMake(kScreenWidth * [myImages count] - 1, slider_scroll_view.frame.size.height)];
    timer = [NSTimer scheduledTimerWithTimeInterval:(6.0) target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    [timer fire];
}
-(void)changeImage{
    
    if(imageCount>([myImages count]-1)){
        imageCount=0;
        [UIImageView beginAnimations:nil context:NULL];
        [UIImageView setAnimationDuration:0.6];
        slider_scroll_view.contentOffset = CGPointMake(imageCount*self.view.frame.size.width,slider_scroll_view.contentOffset.y);
        [UIImageView commitAnimations];
        imageCount+=1;}
    else{
        [UIImageView beginAnimations:nil context:NULL];
        [UIImageView setAnimationDuration:0.6];
        slider_scroll_view.contentOffset = CGPointMake(imageCount*self.view.frame.size.width,slider_scroll_view.contentOffset.y);
        [UIImageView commitAnimations];
        imageCount+=1;
    }
}
/*
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    NSString *simpleTableIdentifier = nil;
    
    simpleTableIdentifier=@"CategoryCell";
    
    
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
   
    NSMutableDictionary *dictdoct = [categoryArray objectAtIndex:indexPath.row];
    cell.lblName.text = [dictdoct valueForKey:@"title"];
    
   // cell.lblName.text = @"test";
    
 
    
    [self setSimpleImageToView:cell.imageIcon imgpath:[NSString stringWithFormat:@"%@%@%@",URL_API_HOST_BASE,PATH_CATEGORY_IMAGE,[dictdoct valueForKey:@"image"]]];
    //[cell.imageIcon.layer setCornerRadius:cell.imageIcon.frame.size.width / 2];
    [cell.imageIcon setClipsToBounds:true];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageIcon.layer.cornerRadius = 4.0f;

    cell.viewFrame.layer.cornerRadius = 4.0f;
    cell.viewFrame.layer.masksToBounds = NO;
    cell.viewFrame.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.viewFrame.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    cell.viewFrame.layer.shadowOpacity = 0.5f;
    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   if (categoryArray!=nil) {
        return categoryArray.count;
    }
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductPagerVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductPagerVC"];
    vc.category = [categoryArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:true];
}*/
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
     Category_Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Category_Cell" forIndexPath:indexPath];
       
    
     NSMutableDictionary *dictdoct1 = [categoryArray objectAtIndex:indexPath.row];
    //cell.layer.shadowColor = [UIColor blackColor].CGColor;
   // cell.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
   // cell.layer.shadowOpacity = 0.5f;
    if ([NSLocalizedStrings(@"lg", @"ar")  isEqual: @"ar"]) {
       cell.lblName1.text = [dictdoct1 valueForKey:@"title"];
    } else if ([NSLocalizedStrings(@"lg", @"fa")  isEqual: @"fa"]) {
         cell.lblName1.text = [dictdoct1 valueForKey:@"title_ku"];
    }else if ([NSLocalizedStrings(@"lg", @"en")  isEqual: @"en"]) {
         cell.lblName1.text = [dictdoct1 valueForKey:@"title_en"];
    }
             
            cell.viewFrame2.layer.cornerRadius = 30.0f;
             // cell.lblName.text = @"test";
              
           
              
              [self setSimpleImageToView:cell.imageIcon1 imgpath:[NSString stringWithFormat:@"%@%@%@",URL_API_HOST_BASE,PATH_CATEGORY_IMAGE,[dictdoct1 valueForKey:@"image"]]];
              //[cell.imageIcon1.layer setCornerRadius:cell.imageIcon1.frame.size.width / 2];
              [cell.imageIcon1 setClipsToBounds:true];
        
              cell.imageIcon1.layer.cornerRadius = 30.0f;

              cell.viewFrame1.layer.cornerRadius = 30.0f;
            
              cell.viewFrame1.layer.masksToBounds = NO;
   
    
   
   

    
    
           
           
       return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
     if (categoryArray!=nil) {
         return categoryArray.count;
     }
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dictdoct1 = [categoryArray objectAtIndex:indexPath.row];
    if ([[dictdoct1 valueForKey:@"id"]  isEqual: @"59"]) {
      ControleDawa *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ControleDawa"];
             
            [self.navigationController pushViewController:vc animated:true];
    } else if([[dictdoct1 valueForKey:@"CheckCat"]  isEqual: @"1"]){
         CatS *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CatS"];
                vc.category = [categoryArray objectAtIndex:indexPath.row];
                 [self.navigationController pushViewController:vc animated:true];
    }else{
        ProductPagerVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductPagerVC"];
        vc.category = [categoryArray objectAtIndex:indexPath.row];
         [self.navigationController pushViewController:vc animated:true];
    }
    
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize mElementSize;
    mElementSize = CGSizeMake((collectionView.frame.size.width/1.3) , (collectionView.frame.size.height/2.6));
    return mElementSize;
}

- (IBAction)btn_loginH:(id)sender {
    FUIAuth *authUI = [FUIAuth defaultAuthUI];
            authUI.delegate = self;

            //The following array may contain diferente options for validate the user (with Facebook, with google, e-mail...), in this case we only need the phone method
            NSArray<id<FUIAuthProvider>> * providers = @[[[FUIPhoneAuth alloc]initWithAuthUI:[FUIAuth defaultAuthUI]]];
            authUI.providers = providers;

            //You can present the screen asking for the user number with the following method.
            FUIPhoneAuth *provider = authUI.providers.firstObject;
            [provider signInWithPresentingViewController:self phoneNumber:nil];
}
- (IBAction)btnCreateH:(id)sender {
    FUIAuth *authUI = [FUIAuth defaultAuthUI];
            authUI.delegate = self;

            //The following array may contain diferente options for validate the user (with Facebook, with google, e-mail...), in this case we only need the phone method
            NSArray<id<FUIAuthProvider>> * providers = @[[[FUIPhoneAuth alloc]initWithAuthUI:[FUIAuth defaultAuthUI]]];
            authUI.providers = providers;

            //You can present the screen asking for the user number with the following method.
            FUIPhoneAuth *provider = authUI.providers.firstObject;
            [provider signInWithPresentingViewController:self phoneNumber:nil];
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


@end




