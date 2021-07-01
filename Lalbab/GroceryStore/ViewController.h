//
//  ViewController.h
//  Grocery Store
//
//  Created by subhashsanghani on 7/27/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
@interface ViewController : BaseVC<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
{
    IBOutlet UIScrollView *slider_scroll_view;
    IBOutlet UITableView *tableview;
    IBOutlet UICollectionView *collectionView;
   
    __weak IBOutlet UIView *ViewLogin;
    __weak IBOutlet UIButton *btn_loginH;
    __weak IBOutlet UIButton *btnCreateH;
    
}


@end

