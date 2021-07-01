//
//  MyRequestsVC.h
//  GroceryStore
//
//  Created by Admin on 27/11/2562 BE.
//  Copyright © 2562 Way. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseVC.h"
@interface MyRequestsVC : BaseVC<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *tableview;
}

@end
