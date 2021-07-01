//
//  ProductPagerVC.h
//  Grocery Store
//
//  Created by subhashsanghani on 7/30/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
@interface ProductPagerVC : BaseVC<UIPageViewControllerDelegate,UIPageViewControllerDataSource>{
    IBOutlet UIScrollView *tabscrollview;
    
    
}
@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) IBOutlet UIView *pageContainer;
@property (assign, nonatomic) NSMutableDictionary *category;
-(void)updateBudget;


@end
