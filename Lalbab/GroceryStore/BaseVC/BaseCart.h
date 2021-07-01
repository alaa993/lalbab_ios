//
//  BaseCart.h
//  FruitMarket
//
//  Created by subhashsanghani on 9/22/16.
//  Copyright © 2016 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#define CART_PREF @"cart"
#define CART_PRIMARY_KEY @"product_id"
@interface BaseCart : NSObject
-(void)addToCart : (NSMutableDictionary *)item;
-(NSMutableDictionary*)getCartItemAtIndex : (int) index;
-(NSMutableArray*)getCartItems;
-(void)removeCartItemAtIndex : (int) index;
-(void)updateCartItemAtIndex : (NSMutableDictionary*)item index:(int)index;
-(int)getCartItemCount;
-(int)getCartItemIndexByKey : (NSString *)key;
-(void)emptyCart;
-(float)getCartTotal;
-(NSMutableDictionary*)getCartItemByKey : (NSString *)key;
@end
