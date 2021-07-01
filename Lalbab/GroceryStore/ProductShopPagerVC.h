//
//  ProductShopPagerVC.h
//  GroceryStore
//
//  Created by Admin on 01/12/2562 BE.
//  Copyright © 2562 Way. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseVC.h"
@interface ProductShopPagerVC : BaseVC<UIPageViewControllerDelegate,UIPageViewControllerDataSource>{
    IBOutlet UIScrollView *tabscrollview;
}
@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) IBOutlet UIView *pageContainer;
@property (assign, nonatomic) NSMutableDictionary *categoryshop;
-(void)updateBudget;
@end
