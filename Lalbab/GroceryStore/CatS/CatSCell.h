//
//  CatSCell.h
//  GroceryStore
//
//  Created by alaa on 7/1/20.
//  Copyright © 2020 Way. All rights reserved.
//

#ifndef CatSCell_h
#define CatSCell_h
#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface CatSCell : UICollectionViewCell
@property (nonatomic, assign) UICollectionView *collectionViewCatS;
@property (weak, nonatomic) IBOutlet UIView *viewFram11;
@property (weak, nonatomic) IBOutlet UIView *viewFram22;
@property (weak, nonatomic) IBOutlet AsyncImageView *imageIcon11;
@property (weak, nonatomic) IBOutlet UILabel *lblName11;


@end

#endif /* CatSCell_h */
