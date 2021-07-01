//
//  Category_Cell.h
//  GroceryStore
//
//  Created by alaa on 2/19/20.
//  Copyright © 2020 Way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface Category_Cell : UICollectionViewCell
@property (nonatomic, assign) UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet AsyncImageView *imageIcon1;
@property (strong, nonatomic) IBOutlet UILabel *lblName1;
@property (strong, nonatomic) IBOutlet UIView *viewFrame1;
@property (strong, nonatomic) IBOutlet UIView *viewFrame2;
@end
