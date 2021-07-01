//
//  ProductShopListVC.m
//  Grocery Store
//
//  Created by subhashsanghani on 7/30/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import "ProductShopListVC.h"
#import "LocalizeLabel.h"
#import "LocalizeButton.h"
#import "ProductShopPagerVC.h"
#import "OrderDetailsCell.h"

#import "Languge.h"
#import "Common.h"

@interface ProductShopListVC ()
{
    NSMutableArray *products_array;
    NSString *cat_id;
    BOOL is_load_more;
    int page_index;
    int islive ;
}
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation ProductShopListVC
@synthesize categoryshop,is_search,search_view,searchField,btnSearch;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    is_load_more = true;
    page_index = 1;
    islive = 0;
    
    
    
      [bt_edit setTitle:NSLocalizedStrings(@"Edit", @"Edit") forState:UIControlStateNormal];
    
    
    
    NSLog(@"ProductShopListVC");
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self
                            action:@selector(getProducts)
                  forControlEvents:UIControlEventValueChanged];
  
    
        cat_id = [categoryshop valueForKey:@"id"];
      
        [self getProducts];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)searchClick:(id)sender{
   // [scrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if(searchField.text.length > 0){
        is_search = searchField.text;
        [self getProducts];
    }
}
-(void)getProducts{
    [self.refreshControl beginRefreshing];
    NSDictionary *dictParams = nil;
    NSString *user_phone = @"";
    NSString *user_uid = @"";
    
    if ([FIRAuth auth].currentUser != nil) {
           user_uid = [FIRAuth auth].currentUser.uid;
           user_phone = [FIRAuth auth].currentUser.phoneNumber;
       }
    
    if (is_search != nil) {
        dictParams = @{
                       @"search": is_search,
                       @"page" : [NSString stringWithFormat:@"%d",page_index]
                       };
    }else{
        dictParams = @{
                        @"cat_id": cat_id,
                        @"user_phone": user_phone,
                        @"user_uid": user_uid,
                        @"page" : [NSString stringWithFormat:@"%d",page_index]
                       };
    }
    
    /*
    params.put("cat_id", cat_id);
          params.put("user_phone", user_phone);
          params.put("user_uid", user_uid);
*/
    
    [self postResponseFromURL:[self getStringURLForAPI:URL_API_PRODUCTS_SHOP] withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
       
            NSMutableArray *responce_Array = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"data"]];
           
        if(products_array != nil)
                    [products_array removeAllObjects];
                
                products_array = responce_Array;
                
         [tableviewshop reloadData];
         //   [self generateListView];
            
            [[NSUserDefaults standardUserDefaults] setObject:products_array forKey:[NSString stringWithFormat:@"products_%@",cat_id]];
            
        
        [self.refreshControl endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.refreshControl endRefreshing];
    } showLoader:YES hideLoader:YES];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrderDetailsCell *cell;
    
        cell= [tableView dequeueReusableCellWithIdentifier:@"OrderDetailsCell"];
   
    
    
    NSMutableDictionary *dict = [products_array objectAtIndex:indexPath.row];
   
    
   
    
    if ([NSLocalizedStrings(@"lg", @"ar")  isEqual: @"ar"]) {
         cell.lblProductTitle.text =  [dict valueForKey:@"product_name"];
         } else if ([NSLocalizedStrings(@"lg", @"fa")  isEqual: @"fa"]) {
             cell.lblProductTitle.text =  [dict valueForKey:@"product_name_ku"];
         }else if ([NSLocalizedStrings(@"lg", @"en")  isEqual: @"en"]) {

             cell.lblProductTitle.text =  [dict valueForKey:@"product_name_en"];
         }
    
    
    if ([[dict valueForKey:@"in_stock"] intValue] == 1) {

        UIColor *color = [UIColor blackColor];
        [cell.lblProductTitle setTextColor:color];
        
    }else{

        UIColor *color2 = [UIColor redColor];
        [cell.lblProductTitle setTextColor:color2];
    }
    
    
  //  cell.lblProductPrice.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"price"]];
    
   
    cell.lblQty.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"price"]];
    
    cell.imageview.clipsToBounds = YES;
    cell.imageview.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageview.imageURL =  [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", URL_API_HOST_BASE, PRO_IMAGE_SMALL_PATH,[dict valueForKey:@"product_image"]]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (products_array!=nil) {
        return products_array.count;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    page_index = indexPath.row;
   
   
    
    NSMutableDictionary *dict = [products_array objectAtIndex:indexPath.row];
    
    islive = [[dict valueForKey:@"in_stock"] intValue] ;
    
    img.imageURL =  [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", URL_API_HOST_BASE, PRO_IMAGE_SMALL_PATH,[dict valueForKey:@"product_image"]]];
      
    
    [view_shop setHidden:false];
    
  //  [txt_name setText:[dict valueForKey:@"product_name"]];
    
    if ([NSLocalizedStrings(@"lg", @"ar")  isEqual: @"ar"]) {
         [txt_name setText:[dict valueForKey:@"product_name"]];
       } else if ([NSLocalizedStrings(@"lg", @"fa")  isEqual: @"fa"]) {
            [txt_name setText:[dict valueForKey:@"product_name_ku"]];
       }else if ([NSLocalizedStrings(@"lg", @"en")  isEqual: @"en"]) {
           [txt_name setText:[dict valueForKey:@"product_name_en"]];
       }
    
    [txt_price setText:[dict valueForKey:@"price"]];
    
    if (islive == 1) {
        [lab_isavilable setText:NSLocalizedStrings(@"Is Live", @"Is Live")];
        [swich_live setOn:true];
        
    }else{
        [lab_isavilable setText:NSLocalizedStrings(@"Offline", @"Offline")];
        [swich_live setOn:false];
    }
    
    
    
}


- (IBAction)act_swich:(UISwitch *)sender {
    
    if ([swich_live isOn ]) {
        [lab_isavilable setText:NSLocalizedStrings(@"Is Live", @"Is Live")];
        islive = 1;
    }else{
        [lab_isavilable setText:NSLocalizedStrings(@"Offline", @"Offline")];
        islive = 0;
    }
    
    
}


- (IBAction)bt_act_edit:(UIButton *)sender {
    NSLog(@"%@ %d", [txt_price text] ,islive );
    
    // URL_API_LIST_EDIT_PRODUCTS
    
    
   
     
        NSDictionary *dictParams = nil;
        NSString *url;
        NSString *user_phone;
        NSString *user_uid;
    
    if ([FIRAuth auth].currentUser != nil) {
              user_uid =  [FIRAuth auth].currentUser.uid;
              user_phone =  [FIRAuth auth].currentUser.phoneNumber;
       }
  
    
     NSMutableDictionary *dict = [products_array objectAtIndex:page_index];
    
        dictParams =  @{
                        @"parent": [dict valueForKey:@"category_id"],
                        @"parent_id": [dict valueForKey:@"product_id"],
                        @"prod_status": @"1",
                        @"price": [txt_price text],
                        @"in_stock": [@(islive) stringValue],
                        @"user_phone": user_phone,
                        @"user_uid": user_uid
                        
                        
                        };
        url = [self getStringURLForAPI:URL_API_LIST_EDIT_PRODUCTS];
        [self postResponseFromURL:url withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
            
        } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
            [self showAlertForTitle:NSLocalizedStrings(@"Product Changed", @"Product Changed") withMessage:NSLocalizedStrings(@"The Product Changed successfully", @"The Product Changed successfully")];
                        [view_shop setHidden:true];
             [self getProducts];
            
 
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self showAlertForTitle:NSLocalizedStrings(@"Failed" , nil) withMessage:NSLocalizedStrings(@"Failed Internet" , nil)];
        } showLoader:YES hideLoader:YES];
        
        
    
}
- (IBAction)bt_act_close:(UIButton *)sender {
    
    [view_shop setHidden:true];
    
}



/*
-(void)generateListView{
    int cell_height = 80;
    if(products_array !=nil){
        
        for (int i = ((page_index - 1) * PAGE_LIMIT); i < [products_array count]; i++) {
            
            UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(10, (cell_height * i) + (i*5), kScreenWidth - 20, cell_height)];
            [cell setClipsToBounds:true];
          
            
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
            [imgView.layer setCornerRadius:imgView.layer.frame.size.height / 2];
            [imgView.layer setBorderWidth:1.0];
            [imgView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
            
            LocalizeLabel *lblTitle = [[LocalizeLabel alloc] initWithFrame:CGRectMake(70, 5, cell.frame.size.width - 90 - 70 , 20)];
            lblTitle.adjustsFontSizeToFitWidth = YES;
            [lblTitle setTextColor:[UIColor darkGrayColor]];
            
            LocalizeLabel *lblPrice = [[LocalizeLabel alloc] initWithFrame:CGRectMake(70 , 25, (cell.frame.size.width - 90 - 70) / 2 , 20)];
            lblPrice.adjustsFontSizeToFitWidth = YES;
            [lblPrice setTextColor:[UIColor darkGrayColor]];
            
            LocalizeLabel *lblTotal = [[LocalizeLabel alloc] initWithFrame:CGRectMake(70 , 45, lblPrice.frame.size.width, 20)];
            lblTotal.adjustsFontSizeToFitWidth = YES;
            lblTotal.tag = i+2000;
           [lblTotal setTextColor:[UIColor darkGrayColor]];
            
            
            
            
            UIButton *btnIncrease = [[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.width - 25, 10, 20, 20)];
            [btnIncrease setBackgroundImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
            btnIncrease.tag = i;
            
            UILabel *lblQty = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 65 ,10 , 40, 20)];
            lblQty.tag = i+1000;
            [lblQty setTextAlignment:NSTextAlignmentCenter];
            lblQty.text = @"0.0";
            
            UIButton *btnDecrease = [[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.width - 85, 10, 20, 20)];
            [btnDecrease setBackgroundImage:[UIImage imageNamed:@"ic_less"] forState:UIControlStateNormal];
            btnDecrease.tag = i;
            
           
            
            
            [btnIncrease addTarget:self action:@selector(btnIncrease:) forControlEvents:UIControlEventTouchUpInside];
            [btnDecrease addTarget:self action:@selector(btnDecrese:) forControlEvents:UIControlEventTouchUpInside];
            
            
            NSMutableDictionary *dict = [products_array objectAtIndex:i];
            
            if ([ NSLocalizedStrings(@"lg", @"ar") isEqual: @"ar"]) {
                lblTitle.text = [dict valueForKey:@"product_name"];
                           
            }else if ([ NSLocalizedStrings(@"lg", @"ar") isEqual: @"fa"]) {
                lblTitle.text = [dict valueForKey:@"product_name_ku"];
                           
            }else if ([ NSLocalizedStrings(@"lg", @"ar") isEqual: @"en"]) {
                lblTitle.text = [dict valueForKey:@"product_name_en"];
                           
            }
           
            NSString *unit =[dict valueForKey:@"unit"];
            
            
            lblPrice.text = [NSString stringWithFormat:@"%@ %@:%@ %@", NSLocalizedStrings(@"Price per", nil),NSLocalizedStrings(unit, nil), [dict valueForKey:@"price"], NSLocalizedStrings(CURRENCY, nil)];
            lblTotal.text =   [NSString stringWithFormat:@"%@ : %.0f %@",NSLocalizedStrings(@"Total", nil),0.0,NSLocalizedStrings(CURRENCY, nil) ];
            
            imgView.clipsToBounds = YES;
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView.image = [UIImage imageNamed:@"180"];
            //cell.imageview.imageURL =  [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", URL_API_HOST_BASE, PRO_IMAGE_SMALL_PATH,[dict valueForKey:@"product_image"]]];
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", URL_API_HOST_BASE, PRO_IMAGE_SMALL_PATH,[dict valueForKey:@"product_image"]]]];
                if ( data == nil )
                    return;
                dispatch_async(dispatch_get_main_queue(), ^{
                    // WARNING: is the cell still using the same data by this point??
                    imgView.image = [UIImage imageWithData: data];
                });
                
            });
            
           
            [cell addSubview:imgView];
            [cell addSubview:lblPrice];
            [cell addSubview:lblQty];
            [cell addSubview:lblTitle];
            [cell addSubview:lblTotal];
            
            [cell addSubview:btnIncrease];
            
            [cell addSubview:btnDecrease];
            
            NSMutableDictionary *cart_item = [cart getCartItemByKey:[dict valueForKey:@"product_id"]];
            if(cart_item != nil){
                lblQty.text = [NSString stringWithFormat:@"%.0f",[[cart_item valueForKey:@"qty"] floatValue]];
                lblTotal.text =   [NSString stringWithFormat:@"%@ : %.0f %@",NSLocalizedStrings(@"Total", nil),[[dict valueForKey:@"price"] floatValue] * [[cart_item valueForKey:@"qty"] floatValue],NSLocalizedStrings(CURRENCY, nil) ];
            
            }
            
            cell.layer.borderColor = [[UIColor lightTextColor] CGColor];
            cell.layer.borderWidth = 0.5f;
            cell.layer.cornerRadius = 4.0f;
            
            [scrollview addSubview:cell];
        }
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:BOOL_UPDATE];
        [scrollview setContentSize:CGSizeMake(kScreenWidth, cell_height *[products_array count])];
    }
}


-(IBAction)btnIncrease:(id)sender{
    
    int tag = (int)[sender tag];
    NSMutableDictionary *product_desc = [products_array objectAtIndex:tag];
    //NSMutableDictionary *cart_item = [cart getCartItemByKey:[product_desc valueForKey:@"product_id"]];
    //if(cart_item == nil){
        
        UILabel *lblQty = [scrollview viewWithTag:tag+1000];
        float qty = [lblQty.text floatValue];
        
        if ([[product_desc valueForKey:@"increament"] doubleValue] > 0) {
            qty  =qty + [[product_desc valueForKey:@"increament"] doubleValue];
        }else{
            qty  =qty + 1;
        }
        
        lblQty.text = [NSString stringWithFormat:@"%.0f",qty];
        
        UILabel *lblProductTotal = [scrollview viewWithTag:tag+2000];
        float product_price = [[product_desc valueForKey:@"price"] floatValue];
        lblProductTotal.text =   [NSString stringWithFormat:@"%@ : %.0f %@",NSLocalizedStrings(@"Total", nil),(product_price * qty),NSLocalizedStrings(CURRENCY, nil) ];
    
 
    
    
        
        
        NSString *strQty = [NSString stringWithFormat:@"%f",qty];
        NSDictionary *cartitem = @{
                                   @"product_id": [product_desc valueForKey:@"product_id"],
                                   @"currency" : CURRENCY,
                                   @"price" : [product_desc valueForKey:@"price"],
                                   @"product_name" : [product_desc valueForKey:@"product_name"],
                                   @"product_name_en" : [product_desc valueForKey:@"product_name_en"],
                                   @"product_name_ku" : [product_desc valueForKey:@"product_name_ku"],
                                   @"product_image" : [product_desc valueForKey:@"product_image"],
                                   @"title" : [product_desc valueForKey:@"title"],
                                   @"unit" : [product_desc valueForKey:@"unit"],
                                   @"unit_value" : [product_desc valueForKey:@"unit_value"],
                                   @"qty" :strQty
                                   };
        [cart addToCart:[[NSMutableDictionary alloc] initWithDictionary:cartitem copyItems:true]];
        numberBudget.value = [cart getCartItemCount];
        
        ProductShopPagerVC *ppv = (ProductShopPagerVC *) _parentview;
        [ppv updateBudget];
    
    NSMutableArray *cartArray = [[NSMutableArray alloc] initWithArray:[cart getCartItems]];
  
      
    
    
    //}
}
-(IBAction)btnDecrese:(id)sender{
    int tag = (int)[sender tag];
    NSMutableDictionary *product_desc = [products_array objectAtIndex:tag];
    NSMutableDictionary *cart_item = [cart getCartItemByKey:[product_desc valueForKey:@"product_id"]];
    int product_id2 = [cart_item valueForKey:@"product_id"];
    

    NSMutableArray *cartArray = [[NSMutableArray alloc] initWithArray:[cart getCartItems]];
    
    //if(cart_item == nil){
        
        UILabel *lblQty = [scrollview viewWithTag:tag+1000];
        float qty = [lblQty.text floatValue];
    
    if (qty  == 1) {
        qty = 0;

        int index = [cart getCartItemIndexByKey:[cart_item objectForKey:CART_PRIMARY_KEY]];

        [cart removeCartItemAtIndex:index];
        
    }
    
        if(qty > 0){
            if ([[product_desc valueForKey:@"increament"] doubleValue] > 0) {
                qty  =qty - [[product_desc valueForKey:@"increament"] doubleValue];
            }else{
                qty  =qty - 1;
            }
            
        }
    
    lblQty.text = [NSString stringWithFormat:@"%.0f",qty];
    
    
    
        UILabel *lblProductTotal = [scrollview viewWithTag:tag+2000];
        float product_price = [[product_desc valueForKey:@"price"] floatValue];
        lblProductTotal.text =   [NSString stringWithFormat:@"%@ : %.0f %@",NSLocalizedStrings(@"Total", nil),(product_price * qty),NSLocalizedStrings(CURRENCY, nil) ];
    
    
    
    if (qty>0) {
        
      
        
    NSString *strQty = [NSString stringWithFormat:@"%f",qty];
        NSDictionary *cartitem = @{
                                   @"product_id": [product_desc valueForKey:@"product_id"],
                                   @"currency" : CURRENCY,
                                   @"price" : [product_desc valueForKey:@"price"],
                                   @"product_name" : [product_desc valueForKey:@"product_name"],
                                   @"product_name_en" : [product_desc valueForKey:@"product_name_en"],
                                   @"product_name_ku" : [product_desc valueForKey:@"product_name_ku"],
                                   @"product_image" : [product_desc valueForKey:@"product_image"],
                                   @"title" : [product_desc valueForKey:@"title"],
                                   @"unit" : [product_desc valueForKey:@"unit"],
                                   @"unit_value" : [product_desc valueForKey:@"unit_value"],
                                   @"qty" :strQty
                                   };
           // if (cartArray.count >0) {
               
                [cart addToCart:[[NSMutableDictionary alloc] initWithDictionary:cartitem copyItems:true]];
    }
          //  }
        numberBudget.value = [cart getCartItemCount];
        
        ProductShopPagerVC *ppv = (ProductShopPagerVC *) _parentview;
        [ppv updateBudget];
        
        
          
        
        
    //}
}

 */
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
