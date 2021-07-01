//
//  CartVC.m
//  Rabbit
//
//  Created by subhashsanghani on 2/3/17.
//  Copyright © 2017 Rabbit. All rights reserved.
//

#import "CartVC.h"

#import "ViewController.h"
#import "LoginVC.h"
#import "DeliveryDetailsVC.h"

#import "Languge.h"
#import "Common.h"

@interface CartVC ()
{
    NSMutableArray *cartArray;
    NSMutableArray *settings;
}
@end

@implementation CartVC
@synthesize tableview,lblTotalItem,lblTotalPrice,lblDeliveryCharge;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedStrings(@"Cart", nil);
    // Do any additional setup after loading the view.
    cartArray = [[NSMutableArray alloc] initWithArray:[cart getCartItems]];
    tableview.allowsMultipleSelectionDuringEditing = NO;
    
    UIButton *btnShowMenu = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnShowMenu setImage:[UIImage imageNamed:@"delete_item"] forState:UIControlStateNormal];
    btnShowMenu.frame = CGRectMake(0, 0, 30, 30);
    [btnShowMenu addTarget:self action:@selector(emptyCart) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:btnShowMenu];
    //    [btnShowMenu setBackgroundColor:[UIColor blueColor]];
    [_btnContinue setTitle:NSLocalizedStrings(@"CONTINUE CHECKOUT", nil) forState:UIControlStateNormal];
    [_clearPrd setTitle:NSLocalizedStrings(@"Clear All Products", nil) forState:UIControlStateNormal];
   
    self.navigationItem.rightBarButtonItem = customBarItem;
    
    [self updateUI];
    
    [lblTotalPrice setTextAlignment:NSTextAlignmentLeft];
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
/** This will remove all data from cart  Also effect BaseCart.m controller **/
-(void)emptyCart{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:NSLocalizedStrings(@"Empty Cart", @"")
                                 message:NSLocalizedStrings(@"Are you sure to remove all items from cart", @"")
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:NSLocalizedStrings(@"Ok", @"")
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [cart emptyCart];
                                    [cartArray removeAllObjects];
                                    [tableview reloadData];
                                    [self updateUI];
                                    [[NSUserDefaults standardUserDefaults] setBool:true forKey:BOOL_UPDATE];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:NSLocalizedStrings(@"No", @"")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}
/** ---- **/
-(void)updateUI{
    float total_price = 0;
    for (int i = 0; i < cartArray.count; i++) {
        NSDictionary *dict = [cartArray objectAtIndex:i];
        float price = [[dict valueForKey:@"price"] floatValue];
        //if (![[dict valueForKey:@"discount"] isEqualToString:@""] && ![[dict valueForKey:@"discount"] isEqualToString:@"0"] ) {
        //    price = price - ( [[dict valueForKey:@"discount"] floatValue] * price / 100 );
        //}
        total_price = total_price + ( price * [[dict valueForKey:@"qty"] floatValue] );
    }
    lblTotalPrice.text = [NSString stringWithFormat:@"%@ : %.0f %@",NSLocalizedStrings(@"Total", nil),total_price,NSLocalizedStrings(CURRENCY, nil)];
    lblTotalItem.text = [NSString stringWithFormat:@"%@ : %d",NSLocalizedStrings(@"Item", nil),[cart getCartItemCount]];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CartCell *cell;
    cell= [tableView dequeueReusableCellWithIdentifier:@"CartCell"];
    
    cell.tag = indexPath.row;
    cell.delegate = self;
    NSMutableDictionary *dict = [cartArray objectAtIndex:indexPath.row];
    cell.product_desc = dict;
    //cell.btnAdd.tag = indexPath.row;
    NSString *product_name=@"";
    if ([NSLocalizedStrings(@"lg", @"ar")  isEqual: @"ar"]) {
       product_name = [dict valueForKey:@"product_name"];
    } else if ([NSLocalizedStrings(@"lg", @"fa")  isEqual: @"fa"]) {
        product_name = [dict valueForKey:@"product_name_ku"];
        
    }else if ([NSLocalizedStrings(@"lg", @"en")  isEqual: @"en"]) {
         product_name = [dict valueForKey:@"product_name_en"];
    
    }
    
    
    
    cell.lblProductTitle.text = product_name;
    
    NSString *unit =[dict valueForKey:@"unit"];
    
    cell.lblProductPrice.text = [NSString stringWithFormat:@"%@ %@:%@ %@", NSLocalizedStrings(@"Price per", nil), unit, [dict valueForKey:@"price"], NSLocalizedStrings(CURRENCY, nil)];
    
    cell.product_price = [[dict valueForKey:@"price"] doubleValue];
    cell.qty = [[dict valueForKey:@"qty"] floatValue];
    
    cell.imageview.clipsToBounds = YES;
    cell.imageview.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageview.imageURL =  [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", URL_API_HOST_BASE, PRO_IMAGE_SMALL_PATH,[dict valueForKey:@"product_image"]]];
    
    [cell updateUI];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.lblProductTitle setTextAlignment:NSTextAlignmentLeft];
    [cell.lblProductPrice setTextAlignment:NSTextAlignmentLeft];
    [cell.lblProductTotal setTextAlignment:NSTextAlignmentLeft];
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (cartArray!=nil) {
        return cartArray.count;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLocalizedStrings(@"Remove", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        NSLog(@"Remove");
                                        // Delete something here
                                        [self removeCartItem:indexPath];
                                    }];
    delete.backgroundColor = [UIColor redColor];
    
    /*UITableViewRowAction *more = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Edit " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
     {
     NSLog(@"Edit");
     AddAddressVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAddressVC"];
     vc.is_edit = true;
     vc.address_desc = [dataArray objectAtIndex:indexPath.row];
     [self.navigationController pushViewController:vc animated:true];
     //Just as an example :
     //[self presentUIAlertControllerActionSheet];
     }];
     more.backgroundColor = [UIColor colorWithRed:0.188 green:0.514 blue:0.984 alpha:1];
     */
    
    return @[delete]; //array with all the buttons you want. 1,2,3, etc...
}
// Override to support editing the table view.
/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 //add code here for when you hit delete
 [cartArray removeObjectAtIndex:indexPath.row];
 [cart removeCartItemAtIndex:indexPath.row];
 [tableview reloadData];
 [self updateUI];
 numberBudget.value = [cart getCartItemCount];
 [[NSUserDefaults standardUserDefaults] setBool:true forKey:BOOL_UPDATE];
 }
 }
 */
-(void)removeCartItem:(NSIndexPath *)indexPath{
    [cartArray removeObjectAtIndex:indexPath.row];
    [cart removeCartItemAtIndex:indexPath.row];
    [tableview reloadData];
    [self updateUI];
    numberBudget.value = [cart getCartItemCount];
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:BOOL_UPDATE];
}
-(void)loadAppSettings{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:[URL_API_HOST stringByAppendingString:URL_API_APP_SETTINGS] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:USERDEFAULTS_APPSETTINGS];
        app.app_settings = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_APPSETTINGS]];
        
        double min_order_amount = 0;
        double max_order_amount = 0;
        for (int i = 0 ; i < [app.app_settings count]; i++) {
            if ([[[app.app_settings objectAtIndex:i] valueForKey:@"id"] isEqualToString:@"1"]) {
                min_order_amount = [[[app.app_settings objectAtIndex:i] valueForKey:@"value"] doubleValue];
                
            }
            if ([[[app.app_settings objectAtIndex:i] valueForKey:@"id"] isEqualToString:@"2"]) {
                max_order_amount = [[[app.app_settings objectAtIndex:i] valueForKey:@"value"] doubleValue];
                
            }
        }
        float total_amount = [cart getCartTotal];
        if (total_amount >= min_order_amount && total_amount <= max_order_amount) {
            DeliveryDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DeliveryDetailsVC"];
            [self.navigationController pushViewController:vc animated:TRUE];
        }else{
            [self showAlertForTitle:NSLocalizedStrings(@"Order Limit", nil) withMessage:[NSString stringWithFormat:@"%@ %.0f %@ %@ %.0f %@",NSLocalizedStrings(@"Order must between", nil), min_order_amount, NSLocalizedStrings(CURRENCY, nil),NSLocalizedStrings(@"To", nil), max_order_amount, NSLocalizedStrings(CURRENCY, nil)]];
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@",error);
        
    }];
}
-(IBAction)btnCheckOutClick:(id)sender{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_USERDATA]){
        if ([cart getCartItemCount] > 0) {
            
            [self loadAppSettings];
        }
    }else{
        LoginVC *vcc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:vcc animated:YES];
    }
    
    
}
-(void)addToCartTap:(CartCell *)sender cartitem:(NSDictionary*)cartitem{
    [cart addToCart:[[NSMutableDictionary alloc] initWithDictionary:cartitem copyItems:true]];
    cartArray = [[NSMutableArray alloc] initWithArray:[cart getCartItems]];
    numberBudget.value = [cart getCartItemCount];
    [self updateUI];
    
}
-(IBAction)btnClearCard:(id)sender{
    
       
    [self emptyCart];
}
@end
