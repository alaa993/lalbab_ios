//
//  MyOrdersVC.h
//  Rabbit
//
//  Created by subhashsanghani on 2/6/17.
//  Copyright © 2017 Rabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
@interface MyOrdersVC : BaseVC<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *tableview;
}

@end
