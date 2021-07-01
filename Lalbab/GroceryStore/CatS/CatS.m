//
//  CatS.m
//  GroceryStore
//
//  Created by alaa on 7/1/20.
//  Copyright © 2020 Way. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CatS.h"
#import "CatSCell.h"
#import "Languge.h"
#import "Common.h"
#import "ProductPagerVC.h"
@interface CatS ()
{
    NSMutableArray *categoryArray;
    
    NSMutableArray *myImages;
    NSTimer *timer;
    NSInteger imageCount;
    BOOL animating;

    
}
@end

@implementation CatS
@synthesize category;

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([NSLocalizedStrings(@"lg", @"ar")  isEqual: @"ar"]) {
               self.navigationItem.title = [category valueForKey:@"title"];
            } else if ([NSLocalizedStrings(@"lg", @"fa")  isEqual: @"fa"]) {
                 
                self.navigationItem.title = [category valueForKey:@"title_ku"];
            }else if ([NSLocalizedStrings(@"lg", @"en")  isEqual: @"en"]) {
                 
                self.navigationItem.title = [category valueForKey:@"title_en"];
            }
    
    
   
    
    collectionViewCatS.dataSource = self;
    collectionViewCatS.delegate = self;
    categoryArray = [[NSMutableArray alloc] init];
    [self getCategories];
    
}
-(void)getCategories{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init] ;
    [params setValue:@"52" forKey:@"parent"] ;
    [params setValue:[category valueForKey:@"id"] forKey:@"catS"] ;
    
    [self postResponseFromURL:[self getStringURLForAPI:URL_API_CATEGORY1] withParams:params progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
            [self->categoryArray removeAllObjects];
            [self->categoryArray addObjectsFromArray:[responseObject objectForKey:@"data"]];
            [self->collectionViewCatS reloadData];
            // [tableview reloadData];
            
            
        }
        else{
            [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showLoader:YES hideLoader:YES];
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    CatSCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CatSCell" forIndexPath:indexPath];
          
       
        NSMutableDictionary *dictdoct1 = [categoryArray objectAtIndex:indexPath.row];
         //cell.layer.shadowColor = [UIColor blackColor].CGColor;
        // cell.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
        // cell.layer.shadowOpacity = 0.5f;
         if ([NSLocalizedStrings(@"lg", @"ar")  isEqual: @"ar"]) {
            cell.lblName11.text = [dictdoct1 valueForKey:@"title"];
         } else if ([NSLocalizedStrings(@"lg", @"fa")  isEqual: @"fa"]) {
              cell.lblName11.text = [dictdoct1 valueForKey:@"title_ku"];
         }else if ([NSLocalizedStrings(@"lg", @"en")  isEqual: @"en"]) {
              cell.lblName11.text = [dictdoct1 valueForKey:@"title_en"];
         }
                  
                 cell.viewFram22.layer.cornerRadius = 30.0f;
                  // cell.lblName.text = @"test";
                   
                
                   
                   [self setSimpleImageToView:cell.imageIcon11 imgpath:[NSString stringWithFormat:@"%@%@%@",URL_API_HOST_BASE,PATH_CATEGORY_IMAGE,[dictdoct1 valueForKey:@"image"]]];
                   //[cell.imageIcon1.layer setCornerRadius:cell.imageIcon1.frame.size.width / 2];
                   [cell.imageIcon11 setClipsToBounds:true];
             
                   cell.imageIcon11.layer.cornerRadius = 30.0f;

                   cell.viewFram11.layer.cornerRadius = 30.0f;
                 
                   cell.viewFram11.layer.masksToBounds = NO;
                   cell.viewFram11.layer.shadowColor = [UIColor blackColor].CGColor;
                   cell.viewFram11.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
                   cell.viewFram11.layer.shadowOpacity = 0.5f;
              
          return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { 
    if (categoryArray!=nil) {
            return categoryArray.count;
        }
       return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dictdoct1 = [categoryArray objectAtIndex:indexPath.row];
    
        ProductPagerVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductPagerVC"];
        vc.category = [categoryArray objectAtIndex:indexPath.row];
         [self.navigationController pushViewController:vc animated:true];
    
    
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize mElementSize;
    mElementSize = CGSizeMake((collectionView.frame.size.width/4)+8 , (collectionView.frame.size.height/4.5)+5);
    return mElementSize;
}


@end
