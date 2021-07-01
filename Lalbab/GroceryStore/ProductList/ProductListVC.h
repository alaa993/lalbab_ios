//
//  ProductListVC.h
//  Grocery Store
//
//  Created by subhashsanghani on 7/30/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"



@interface ProductListVC :

BaseVC<UITableViewDataSource,UITableViewDelegate>
{
    
  IBOutlet UITableView *tb_products;
    
    
    __weak IBOutlet UIButton *bt_complet;
    
}
@property (assign, nonatomic) IBOutlet UIView *search_view;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) UIViewController *parentview;
@property (assign, nonatomic) NSMutableDictionary *category;
@property (assign, nonatomic) NSString *is_search;
@property (assign, nonatomic) IBOutlet UITextField *searchField;
@property (assign, nonatomic) IBOutlet UIButton *btnSearch;
@end
