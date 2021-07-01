//
//  ProductShopListVC.h
//  GroceryStore
//
//  Created by Admin on 01/12/2562 BE.
//  Copyright © 2562 Way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"



@interface ProductShopListVC : BaseVC<UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UITableView *tableviewshop;
    
    IBOutlet UIView *view_shop;
    
    IBOutlet UILabel *txt_name;
    
    IBOutlet UITextField *txt_price;
    
    IBOutlet UIImageView *img;
    
    IBOutlet UILabel *lab_isavilable;
    
    IBOutlet UISwitch *swich_live;
    
    IBOutlet UIButton *bt_edit;
    
    
    IBOutlet UIButton *bt_close;
    
    
}
@property (assign, nonatomic) IBOutlet UIView *search_view;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) UIViewController *parentview;
@property (assign, nonatomic) NSMutableDictionary *categoryshop;
@property (assign, nonatomic) NSString *is_search;
@property (assign, nonatomic) IBOutlet UITextField *searchField;
@property (assign, nonatomic) IBOutlet UIButton *btnSearch;



@end
