//
//  BaseCart.m
//  FruitMarket
//
//  Created by subhashsanghani on 9/22/16.
//  Copyright © 2016 com. All rights reserved.
//

#import "BaseCart.h"
#import "Languge.h"
#import "Common.h"


@implementation BaseCart
-(void)addToCart : (NSMutableDictionary *)item{
     NSMutableArray *items = [[NSMutableArray alloc] initWithArray:[self getCartItems]];
    int index = [self getCartItemIndexByKey:[item objectForKey:CART_PRIMARY_KEY]];
    if (index == -1) {
        [items addObject:item];
        [self setArrayToCart:items];
    }else{
        [self updateCartItemAtIndex:item index:index];
    }
    
}
-(void)emptyCart{
    [self setArrayToCart:nil];
}
-(int)getCartItemIndexByKey : (NSString *)key{
    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:[self getCartItems]];
    for (int i = 0; i < items.count; i++) {
        NSMutableDictionary *desc = [[NSMutableDictionary alloc] initWithDictionary:[items objectAtIndex:i] copyItems:true];
        if([[desc valueForKey:CART_PRIMARY_KEY] isEqualToString:key]){
            return i;
        }
    }
    return -1;
}
-(NSMutableDictionary*)getCartItemByKey : (NSString *)key{
    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:[self getCartItems]];
    for (int i = 0; i < items.count; i++) {
        NSMutableDictionary *desc = [[NSMutableDictionary alloc] initWithDictionary:[items objectAtIndex:i] copyItems:true];
        if([[desc valueForKey:CART_PRIMARY_KEY] isEqualToString:key]){
            return desc;
        }
    }
    return nil;
}
-(NSMutableDictionary*)getCartItemAtIndex : (int) index{
    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:[self getCartItems]];
    if (items.count > 0) {
        return [items objectAtIndex:index];
    }
    return nil;
}
-(NSMutableArray*)getCartItems{
    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:CART_PREF]];
    return items;
}

-(void)removeCartItemAtIndex : (int) index{
    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:[self getCartItems]];
    if (items.count > 0) {
        [items removeObjectAtIndex:index];
    }
    [self setArrayToCart:items];
}


-(void)setArrayToCart:(NSMutableArray*)array{
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:CART_PREF];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)updateCartItemAtIndex : (NSMutableDictionary*)item index:(int)index{
    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:[self getCartItems]];
    [items removeObjectAtIndex:index];
    [items insertObject:item atIndex:index];
    [self setArrayToCart:items];
}
-(int)getCartItemCount{
    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:[self getCartItems]];
    return (int)items.count;
}
-(float)getCartTotal{
    float total_price = 0.0;
    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:[self getCartItems]];
    for (int i = 0; i < items.count; i++) {
        NSDictionary *dict = [items objectAtIndex:i];
        float price = [[dict valueForKey:@"price"] floatValue];
        //if (![[dict valueForKey:@"discount"] isEqualToString:@""] && ![[dict valueForKey:@"discount"] isEqualToString:@"0"] ) {
        //    price = price - ( [[dict valueForKey:@"discount"] floatValue] * price / 100 );
        //}
        total_price = total_price + ( price * [[dict valueForKey:@"qty"] floatValue] );
    }
    return total_price;
    
}
@end
