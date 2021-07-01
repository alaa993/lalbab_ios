//
//  ProductListVC.m
//  Grocery Store
//
//  Created by subhashsanghani on 7/30/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import "ProductListVC.h"
#import "LocalizeLabel.h"
#import "LocalizeButton.h"
#import "ProductPagerVC.h"

#import "CartCell2.h"

#import "Languge.h"
#import "Common.h"

@interface ProductListVC ()
{
    NSMutableArray *products_array;
    NSString *cat_id;
    BOOL is_load_more;
    int page_index;
}
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation ProductListVC
@synthesize   category,is_search,search_view,searchField,btnSearch;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    is_load_more = true;
    page_index = 1;
   
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self
                            action:@selector(getProducts)
                  forControlEvents:UIControlEventValueChanged];
  
    
        cat_id = [category valueForKey:@"id"];
        [self getProducts];
    
    
    [bt_complet setTitle:NSLocalizedStrings(@"Cart", nil) forState:UIControlStateNormal];
    
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
    if (is_search != nil) {
        dictParams = @{
                       @"search": is_search,
                       @"page" : [NSString stringWithFormat:@"%d",page_index]
                       };
    }else{
        dictParams = @{
                       @"cat_id": cat_id,
                       @"page" : [NSString stringWithFormat:@"%d",page_index]
                       };
    }
    
    [self postResponseFromURL:[self getStringURLForAPI:URL_API_PRODUCTS] withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
            NSMutableArray *responce_Array = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"data"]];
            if (page_index == 1) {
                if(products_array != nil)
                    [products_array removeAllObjects];
                
                products_array = responce_Array;
                
            }else{
                [products_array addObjectsFromArray:responce_Array];
            }
            
            
              [tb_products reloadData];
           // [self generateListView];
            
            [[NSUserDefaults standardUserDefaults] setObject:products_array forKey:[NSString stringWithFormat:@"products_%@",cat_id]];
            
        }
        else{
            [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
        }
        [self.refreshControl endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.refreshControl endRefreshing];
    } showLoader:YES hideLoader:YES];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CartCell2 *cell;
    
    
        cell= [tableView dequeueReusableCellWithIdentifier:@"CartCell2"];
   
    
    
    
    NSMutableDictionary *dict = [products_array objectAtIndex:indexPath.row];
    cell.dict_ = dict;
    
    NSMutableDictionary *product_desc = [products_array objectAtIndex:indexPath.row];
    
    if (cart != nil) {
    NSMutableDictionary *cart_item = [cart getCartItemByKey:[product_desc valueForKey:@"product_id"]];
    
    if (cart_item != nil) {
      //  NSLog(@"%@", cart_item);
        

        cell.lblQty.text = [NSString stringWithFormat:@"%.0f",[[cart_item valueForKey:@"qty"] floatValue]];
        

        float qty = [[cart_item valueForKey:@"qty"] floatValue];
        float product_price = [[cart_item valueForKey:@"price"] floatValue];
        
      cell.lblProductTotal.text =   [NSString stringWithFormat:@"%@ : %.0f %@",NSLocalizedStrings(@"Total", nil),(product_price * qty),NSLocalizedStrings(CURRENCY, nil) ];
        
        
           
        
    }else {
        cell.lblQty.text = @"0";
        cell.lblProductTotal.text =   [NSString stringWithFormat:@"%@ : %.0d %@",NSLocalizedStrings(@"Total", nil),( 0),NSLocalizedStrings(CURRENCY, nil) ];
        
    }
    }
    
    
  //  NSLog(@"%@", dict);
   
    
   
    
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
    
    
    cell.lblProductPrice.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"price"]];
    

    
    cell.lblQty.tag = indexPath.row +1000;
    
    
    
    cell.btnIncrease.tag = indexPath.row;
    cell.btnDecrease.tag = indexPath.row;
    
    [cell.btnIncrease addTarget:self action:@selector(btnIncrease:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btnDecrease addTarget:self action:@selector(btnDecrese:) forControlEvents:UIControlEventTouchUpInside];

  
    
    
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





/*
-(void)generateListView{
    int cell_height = 80;
    if(products_array !=nil){
        
        for (int i = ((page_index - 1) * PAGE_LIMIT); i < [products_array count]; i++) {
            
            UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(10, (cell_height * i) + (i*5), kScreenWidth - 20, cell_height)];
            [cell setClipsToBounds:true];
            UIView *frame = [[UIView alloc] initWithFrame:CGRectMake(2, 2, cell.frame.size.width - 4, cell.frame.size.height - 4)];
            
            frame.layer.cornerRadius = 4.0f;
            frame.layer.masksToBounds = NO;
            frame.layer.shadowColor = [UIColor blackColor].CGColor;
            frame.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
            frame.layer.shadowOpacity = 0.5f;
            frame.layer.borderWidth = 0.5f;
            frame.layer.borderColor = [[UIColor lightTextColor] CGColor];
            
            [frame setClipsToBounds:true];
            [cell addSubview:frame];
            
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
            lblQty.text = @"0";
            
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

*/



-(IBAction)btnIncrease:(id)sender{
    
    
    int tag = (int)[sender tag];
        NSLog(@"%d", tag);
    
   
    
   NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
    
   CartCell2 *cell = (CartCell2 *)[tb_products cellForRowAtIndexPath:indexPath];
    
    float qty = [cell.lblQty.text floatValue];
    
    
       
    
    NSMutableDictionary *product_desc = [products_array objectAtIndex:tag];
    
  //  NSMutableDictionary *cart_item = [cart getCartItemByKey:[product_desc valueForKey:@"product_id"]];
    
   // BaseCart *cart = [[BaseCart alloc] init];

    
    
    
        
    
        
        if ([[product_desc valueForKey:@"increament"] doubleValue] > 0) {
            qty  =qty + [[product_desc valueForKey:@"increament"] doubleValue];
        }else{
            qty  =qty + 1;
        }
        
 
           // cell.lblQty.text = [NSString stringWithFormat:@"%.0f",qty];
 
    
        float product_price = [[product_desc valueForKey:@"price"] floatValue];
     
 
    
        
        
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
        
        ProductPagerVC *ppv = (ProductPagerVC *) _parentview;
        [ppv updateBudget];
    
   // NSMutableArray *cartArray = [[NSMutableArray alloc] initWithArray:[cart getCartItems]];
  
      
    
    
     [tb_products reloadData];
    
    
}
-(IBAction)btnDecrese:(id)sender{
    
    int tag = (int)[sender tag];
    NSMutableDictionary *product_desc = [products_array objectAtIndex:tag];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
       
    CartCell2 *cell = (CartCell2 *)[tb_products cellForRowAtIndexPath:indexPath];
    float qty = [cell.lblQty.text floatValue];
       
    
   
    

    NSMutableArray *cartArray = [[NSMutableArray alloc] initWithArray:[cart getCartItems]];
    
  
    if (qty  == 1) {
        qty = 0;
        
        if (cart != nil) {
        
        NSMutableDictionary *cart_item = [cart getCartItemByKey:[product_desc valueForKey:@"product_id"]];
          

        int index = [cart getCartItemIndexByKey:[cart_item objectForKey:CART_PRIMARY_KEY]];

        [cart removeCartItemAtIndex:index];
        }
        
    }
    
        if(qty > 0){
            if ([[product_desc valueForKey:@"increament"] doubleValue] > 0) {
                qty  =qty - [[product_desc valueForKey:@"increament"] doubleValue];
            }else{
                qty  =qty - 1;
            }
            
        }
    
    cell.lblQty.text = [NSString stringWithFormat:@"%.0f",qty];
    
    
    
        float product_price = [[product_desc valueForKey:@"price"] floatValue];
      
    
    
    
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
        
               
                [cart addToCart:[[NSMutableDictionary alloc] initWithDictionary:cartitem copyItems:true]];
    }
    
        numberBudget.value = [cart getCartItemCount];
        
        ProductPagerVC *ppv = (ProductPagerVC *) _parentview;
        [ppv updateBudget];
        
        
          
        
    
}


 


/*
 #pragma mark - Navigation
 

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
