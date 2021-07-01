//
//  CatS.h
//  GroceryStore
//
//  Created by alaa on 7/1/20.
//  Copyright © 2020 Way. All rights reserved.
//

#ifndef CatS_h
#define CatS_h
#import <UIKit/UIKit.h>
#import "BaseVC.h"
@interface CatS : BaseVC< UICollectionViewDelegate,UICollectionViewDataSource>
{
    
    __weak IBOutlet UICollectionView *collectionViewCatS;
    
}
@property (assign, nonatomic) NSMutableDictionary *category;
@end

#endif /* CatS_h */
