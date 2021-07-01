//
//  ChooseSocityVC.h
//  Grocery Store
//
//  Created by subhashsanghani on 7/31/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
@interface ChooseSocityVC : BaseVC<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>{
    IBOutlet UITableView *tableview;
    IBOutlet UISearchBar *mySearchBar;
}
@property (retain, readwrite) NSMutableArray *dataArray;
@property (retain, readwrite) NSString *pincode;
@end
