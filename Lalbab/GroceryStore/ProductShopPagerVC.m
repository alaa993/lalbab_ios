//
//  ProductShopPagerVC.m
//  Grocery Store
//
//  Created by subhashsanghani on 7/30/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import "ProductShopPagerVC.h"
#import "ProductShopListVC.h"

#import "Languge.h"
#import "Common.h"

@interface ProductShopPagerVC ()
{
    NSMutableArray *categories_array;
    UIView *indicator;
}
@end

@implementation ProductShopPagerVC
@synthesize pageContainer,categoryshop;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCartButton];
    
     NSLog(@"categoryshop");
    
    if ([categoryshop isEqual:[NSNull null]] ) {
      [self showAlertForTitle:NSLocalizedStrings(@"Empty Catagory", @"Empty Catagory") withMessage:NSLocalizedStrings(@"Not Found Products", @"Not Found Products")];
                
             return ;
    }else{
        if (categoryshop.count >0 ) {
            NSLog(@"categoryshop %lu" , (unsigned long)categoryshop.count);
        }else {
            [self showAlertForTitle:NSLocalizedStrings(@"Empty Catagory", @"Empty Catagory") withMessage:NSLocalizedStrings(@"Not Found Products", @"Not Found Products")];
                           
                        return ;
        }
        
       
      
    }
    
    // Do any additional setup after loading the view.
     self.navigationItem.title = [categoryshop valueForKey:@"title"];
    if (categoryshop != nil && ![[categoryshop objectForKey:@"sub_cat"] isEqual:[NSNull null]] && [categoryshop objectForKey:@"sub_cat"] != nil) {
       
        categories_array = [[NSMutableArray alloc] initWithArray:[categoryshop objectForKey:@"sub_cat"]];
        
        
        
        [self createSeriesTabs:0];
        [self setTabSelected:0];
    }else{
        categories_array = [[NSMutableArray alloc] init];
        [categories_array addObject:categoryshop];
    }
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    ProductShopListVC *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.pageController.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - tabscrollview.frame.size.height);
    [self addChildViewController:self.pageController];
    [pageContainer addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createSeriesTabs:(int)index{
    
    if (categories_array == nil) {
        return;
    }
    
    for (UIView *subView in tabscrollview.subviews)
    {
        
        [subView removeFromSuperview];
        
    }
    
    if(categories_array!= nil){
        if([self isRTL]){
            
            [tabscrollview setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
            for (int i = (int)[categories_array count]; i >0 ; i--) {
                
                [self addTabToScroll:((int)[categories_array count] - i) index:i title:[[categories_array objectAtIndex:i] valueForKey:@"title"]];
                if ([self isRTL] && ![[[categories_array objectAtIndex:i] valueForKey:@"title"] isEqualToString:@""]) {
                    [self addTabToScroll:((int)[categories_array count] - i) index:i title:[[categories_array objectAtIndex:i] valueForKey:@"title_ar"]];
                }
                
            }
            
        }else{
           
            for (int i = 0; i < [categories_array count]; i++) {
                [self addTabToScroll:i index:i title:[[categories_array objectAtIndex:i] valueForKey:@"title"]];
            }
        }
        [tabscrollview setContentSize:CGSizeMake(([categories_array count] + 1) * 90  + (([categories_array count] - 1) * 12) , tabscrollview.frame.size.height)];
       
            indicator = [[UIView alloc] initWithFrame:CGRectMake(0, tabscrollview.frame.size.height - 2,kScreenWidth, 2)];
            [indicator setBackgroundColor:[UIColor whiteColor]];
            [tabscrollview addSubview:indicator];
       
    }
    
    
    
}
-(void)addTabToScroll:(int)i index:(int)index title:(NSString *)title{
    
    float tab_width = kScreenWidth / 3;
    UIButton *btnTab = [[UIButton alloc] initWithFrame:CGRectMake(i*tab_width + (i*5) , 0, tab_width, tabscrollview.frame.size.height )];
    
    [btnTab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //[btnTab.layer setBackgroundColor:[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] CGColor]];
    //[btnTab.layer setBorderWidth:1.0];
    //[btnTab.layer setBorderColor:[[UIColor colorWithRed:96.0/255.0 green:186.0/255.0 blue:122.0/255.0 alpha:1.0] CGColor]];
    btnTab.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    [btnTab addTarget:self
               action:@selector(loadProducts:)
     forControlEvents:UIControlEventTouchUpInside];
    [btnTab setTitle:title forState:UIControlStateNormal];
    btnTab.tag = index;
    [tabscrollview addSubview:btnTab];
    
    
}
-(IBAction)loadProducts:(id)sender{
    [self.pageController setViewControllers:[NSArray arrayWithObject:[self viewControllerAtIndex:[sender tag]]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self setTabSelected:[sender tag]];
}
-(void)setTabSelected:(int)index{
    int i = 0;
    for (UIButton *subview in [tabscrollview subviews]) {
        
     
        
        
        if (index == [subview tag]) {
            if (indicator != nil) {
                [UIView animateWithDuration:0.1
                                      delay:0.1
                                    options: UIViewAnimationOptionTransitionNone
                                 animations:^
                 {
                     indicator.frame = CGRectMake(subview.frame.origin.x, tabscrollview.frame.size.height - 2, subview.frame.size.width, 2);
                     
                 }
                                 completion:^(BOOL finished)
                 {
                     
                 }
                 ];
                /*CATransition *transition = [CATransition animation];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromLeft;
                transition.duration = 0.4;
                [indicator.layer addAnimation:transition forKey:nil];*/
                
            }
        }else{
            
            
        }
        i++;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)updateBudget{
    numberBudget.value = [cart getCartItemCount];
    
}
- (ProductShopListVC *)viewControllerAtIndex:(NSUInteger)index {
    
    if (categories_array == nil) {
        return nil;
    }
    
    ProductShopListVC *childViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductShopListVC"];
    childViewController.categoryshop = [categories_array objectAtIndex:index];
    childViewController.index = index;
    childViewController.parentview = self;
    return childViewController;
    
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (categories_array == nil) {
        return nil;
    }
   
    NSUInteger index = [(ProductShopListVC *)viewController index];
    [self setTabSelected:(int)index];
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (categories_array == nil) {
        return nil;
    }
    
    NSUInteger index = [(ProductShopListVC *)viewController index];
    [self setTabSelected:(int)index];
    
    index++;
    
    if (index == [categories_array count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    if (categories_array == nil) {
        return 0;
    }
    return [categories_array count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}
@end
