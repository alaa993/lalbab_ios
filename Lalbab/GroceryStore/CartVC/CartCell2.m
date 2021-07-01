//
//  CartCell.m
//  Rabbit
//
//  Created by subhashsanghani on 2/4/17.
//  Copyright © 2017 Rabbit. All rights reserved.
//

#import "CartCell2.h"
#import "BaseVC.h"

#import "ProductListVC.h"
#import "ProductPagerVC.h"


#import "Languge.h"
#import "Common.h"



@implementation CartCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_imageview.layer setCornerRadius:_imageview.layer.frame.size.height / 2];
    [_imageview.layer setBorderWidth:1.0];
    [_imageview.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    //_qty = 0;
    
   // [_btnIncrease addTarget:self action:@selector(btnIncrease:) forControlEvents:UIControlEventTouchUpInside];
   // [_btnDecrease addTarget:self action:@selector(btnDecrese:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self lblTotalSet:_qty];
    _lblQty.text = [NSString stringWithFormat:@"%.0f",_qty];
}
-(void)updateUI{
    [self lblTotalSet:_qty];
    _lblQty.text = [NSString stringWithFormat:@"%.0f",_qty];
}
-(IBAction)btnIncrease:(id)sender{
    _qty  =_qty + 1;
    _lblQty.text = [NSString stringWithFormat:@"%.0f",_qty];
    [self lblTotalSet:_qty];
    
    BaseCart *bc = [[BaseCart alloc] init];
    
    NSString *strQty = [NSString stringWithFormat:@"%.0f",_qty];
    _product_desc = [bc getCartItemAtIndex:(int)self.tag];
    
    NSDictionary *cartitem = @{
                               @"product_id": [_product_desc valueForKey:@"product_id"],
                               @"currency" : CURRENCY,
                               @"price" : [_product_desc valueForKey:@"price"],
                               @"product_name" : [_product_desc valueForKey:@"product_name"],
                               @"product_image" : [_product_desc valueForKey:@"product_image"],
                               @"title" : [_product_desc valueForKey:@"title"],
                               @"unit" : [_product_desc valueForKey:@"unit"],
                               @"unit_value" : [_product_desc valueForKey:@"unit_value"],
                               @"qty" :strQty
                               };
    _product_desc = [[NSMutableDictionary alloc] initWithDictionary:cartitem];
    [self.delegate addToCartTap:self cartitem:cartitem];
}

-(IBAction)btnDecrese:(id)sender{
    if(_qty > 0){
        _qty  =_qty - 1;
        _lblQty.text = [NSString stringWithFormat:@"%.0f",_qty];
        [self lblTotalSet:_qty];
        
        BaseCart *bc = [[BaseCart alloc] init];
        
        NSString *strQty = [NSString stringWithFormat:@"%.0f",_qty];
        _product_desc = [bc getCartItemAtIndex:(int)self.tag];
        
        NSDictionary *cartitem = @{
                                   @"product_id": [_product_desc valueForKey:@"product_id"],
                                   @"currency" : CURRENCY,
                                   @"price" : [_product_desc valueForKey:@"price"],
                                   @"product_name" : [_product_desc valueForKey:@"product_name"],
                                   @"product_image" : [_product_desc valueForKey:@"product_image"],
                                   @"title" : [_product_desc valueForKey:@"title"],
                                   @"unit" : [_product_desc valueForKey:@"unit"],
                                   @"unit_value" : [_product_desc valueForKey:@"unit_value"],
                                   @"qty" :strQty
                                   };
        _product_desc = [[NSMutableDictionary alloc] initWithDictionary:cartitem];
        [self.delegate addToCartTap:self cartitem:cartitem];
    }
}



-(IBAction)btnIncrease2:(id)sender{
  
    
    
    int tag = (int)[sender tag];
           NSLog(@"%d", tag);
       BaseCart *cart = [[BaseCart alloc] init];
       
    NSMutableDictionary *product_desc = _dict_;
       
       NSMutableDictionary *cart_item = [cart getCartItemByKey:[product_desc valueForKey:@"product_id"]];
       

    
    
           
    
           
           if ([[product_desc valueForKey:@"increament"] doubleValue] > 0) {
               _qty  =_qty + [[product_desc valueForKey:@"increament"] doubleValue];
           }else{
               _qty  =_qty + 1;
           }
           
           _lblQty.text = [NSString stringWithFormat:@"%.0f",_qty];
           
           float product_price = [[product_desc valueForKey:@"price"] floatValue];
           _lblProductTotal.text =   [NSString stringWithFormat:@"%@ : %.0f %@",NSLocalizedStrings(@"Total", nil),(product_price * _qty),NSLocalizedStrings(CURRENCY, nil) ];
       
    
       
       
           
           
           NSString *strQty = [NSString stringWithFormat:@"%f",_qty];
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
        
        
    
    
    
    // numberBudget.value = [cart getCartItemCount];
       
       NSMutableArray *cartArray = [[NSMutableArray alloc] initWithArray:[cart getCartItems]];
    
    NSLog(@"%@", cartArray);
     
         
        
    
    /*
    
   // [self lblTotalSet:_qty];
    BaseCart *cart = [[BaseCart alloc] init];
    
    NSMutableDictionary *cart_item = [cart getCartItemByKey:[_dict_ valueForKey:@"product_id"]];
      
  
    NSLog(@"%@",cart_item);
    NSLog(@"%@",[_dict_ valueForKey:@"increament"]);
    NSLog(@"%@",[_dict_ valueForKey:@"product_id"]);
    
    
    NSString *strQty = [NSString stringWithFormat:@"%.0f",_qty];
    
     if(_dict_ != nil){
           
         //  UILabel *lblQty = [scrollview viewWithTag:tag+1000];
         //  float qty = [lblQty.text floatValue];
           
         if ([[_dict_ valueForKey:@"increament"] doubleValue] > 0) {
             _qty  =  _qty + [[_dict_ valueForKey:@"increament"] doubleValue];
           }else{
               _qty  = _qty + 1;
           }
         _lblQty.text = [NSString stringWithFormat:@"%.0f",_qty];
           
      
         
          
           float product_price = [[_dict_ valueForKey:@"price"] floatValue];
         
         
           _lblProductTotal.text =   [NSString stringWithFormat:@"%@ : %.0f %@",NSLocalizedStrings(@"Total", nil),(product_price * _qty),NSLocalizedStrings(CURRENCY, nil) ];
       
    
           
           NSString *strQty = [NSString stringWithFormat:@"%f",_qty];
      
          NSDictionary *cartitem = @{
                                      @"product_id": [_dict_ valueForKey:@"product_id"],
                                      @"currency" : CURRENCY,
                                      @"price" : [_dict_ valueForKey:@"price"],
                                      @"product_name" : [_dict_ valueForKey:@"product_name"],
                                      @"product_name_en" : [_dict_ valueForKey:@"product_name_en"],
                                      @"product_name_ku" : [_dict_ valueForKey:@"product_name_ku"],
                                      @"product_image" : [_dict_ valueForKey:@"product_image"],
                                      @"title" : [_dict_ valueForKey:@"title"],
                                      @"unit" : [_dict_ valueForKey:@"unit"],
                                      @"unit_value" : [_dict_ valueForKey:@"unit_value"],
                                      @"qty" :strQty
                                      };
     
           [cart addToCart:[[NSMutableDictionary alloc] initWithDictionary:cartitem copyItems:true]];
         
       //  numberBudget.value = [cart getCartItemCount];
           
        //   ProductPagerVC *ppv = (ProductPagerVC *) _parentview;
        //   [ppv updateBudget];
       
       NSMutableArray *cartArray = [[NSMutableArray alloc] initWithArray:[cart getCartItems]];
     
         
       
     */
       
       
       
    

    
    
   
 
    
    /*
    NSDictionary *cartitem = @{
                               @"product_id": [_product_desc valueForKey:@"product_id"],
                               @"currency" : CURRENCY,
                               @"price" : [_product_desc valueForKey:@"price"],
                               @"product_name" : [_product_desc valueForKey:@"product_name"],
                               @"product_image" : [_product_desc valueForKey:@"product_image"],
                               @"title" : [_product_desc valueForKey:@"title"],
                               @"unit" : [_product_desc valueForKey:@"unit"],
                               @"unit_value" : [_product_desc valueForKey:@"unit_value"],
                               @"qty" :strQty
                               };
    _product_desc = [[NSMutableDictionary alloc] initWithDictionary:cartitem];
    [self.delegate addToCartTap:self cartitem:cartitem];
    */
    
}

-(IBAction)btnDecrese2:(id)sender{
    
   if(_qty > 0){
        _qty  =_qty - 1;
        _lblQty.text = [NSString stringWithFormat:@"%.0f",_qty];
        [self lblTotalSet:_qty];
        
        BaseCart *bc = [[BaseCart alloc] init];
        
        NSString *strQty = [NSString stringWithFormat:@"%.0f",_qty];
        _product_desc = [bc getCartItemAtIndex:(int)self.tag];
        
        NSDictionary *cartitem = @{
                                   @"product_id": [_product_desc valueForKey:@"product_id"],
                                   @"currency" : CURRENCY,
                                   @"price" : [_product_desc valueForKey:@"price"],
                                   @"product_name" : [_product_desc valueForKey:@"product_name"],
                                   @"product_image" : [_product_desc valueForKey:@"product_image"],
                                   @"title" : [_product_desc valueForKey:@"title"],
                                   @"unit" : [_product_desc valueForKey:@"unit"],
                                   @"unit_value" : [_product_desc valueForKey:@"unit_value"],
                                   @"qty" :strQty
                                   };
        _product_desc = [[NSMutableDictionary alloc] initWithDictionary:cartitem];
        [self.delegate addToCartTap:self cartitem:cartitem];
    }
     
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)lblTotalSet:(float)intQty{
    _lblProductTotal.text =   [NSString stringWithFormat:@"%@ : %.0f %@",NSLocalizedStrings(@"Total", nil),(_product_price * intQty),NSLocalizedStrings(CURRENCY, nil) ];
}


@end
