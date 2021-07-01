//
//  LeftMenuViewController.h
//  reportapp
//
//  Created by subhashsanghani on 10/30/15.
//  Copyright © 2015 com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
@protocol LeftMenuViewControllerDelegate <NSObject>
@end
@interface LeftMenuViewController : BaseVC<UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *tableview;
    IBOutlet UIImageView *userImage;
    IBOutlet UILabel *lblUserName;
    IBOutlet UILabel *lblEmailId;
    
     NSMutableArray *categoryArrayShop;
    
}
- (void)leftSideMenuButtonPressed;
@property (assign,readwrite) BOOL is_open_menu;
@property (retain, atomic) NSMutableArray *userMenu;
@property (nonatomic, assign) id<LeftMenuViewControllerDelegate> delegate;
@end

