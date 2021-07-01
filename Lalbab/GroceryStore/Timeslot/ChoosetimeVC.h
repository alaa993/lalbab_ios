//
//  ChoosetimeVC.h
//  Rabbit
//
//  Created by subhashsanghani on 2/4/17.
//  Copyright © 2017 Rabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
@interface ChoosetimeVC : BaseVC<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (assign, readwrite) NSString *selected_date;
@end
