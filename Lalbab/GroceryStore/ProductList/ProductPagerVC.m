//
//  ProductPagerVC.m
//  Grocery Store
//
//  Created by subhashsanghani on 7/30/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import "ProductPagerVC.h"
#import "ProductListVC.h"

#import "Languge.h"
#import "Common.h"

@interface ProductPagerVC ()
{
    NSMutableArray *categories_array;
    UIView *indicator;
}
@end

@implementation ProductPagerVC
@synthesize pageContainer,category;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCartButton];
    
    if (category.count >0 ) {
        NSLog(@"categoryshop ");
    }else{
        
        [self showAlertForTitle:NSLocalizedStrings(@"Empty Catagory", @"Empty Catagory") withMessage:NSLocalizedStrings(@"Not Found Products", @"Not Found Products")];
        
        return ;
    }
    
    // Do any additional setup after loading the view.
    
    if ([NSLocalizedStrings(@"lg", @"ar")  isEqual: @"ar"]) {
          self.navigationItem.title = [category valueForKey:@"title"];
       } else if ([NSLocalizedStrings(@"lg", @"fa")  isEqual: @"fa"]) {
           self.navigationItem.title = [category valueForKey:@"title_ku"];
       }else if ([NSLocalizedStrings(@"lg", @"en")  isEqual: @"en"]) {
           self.navigationItem.title = [category valueForKey:@"title_en"];
       }
    

    if (category != nil && ![[category objectForKey:@"sub_cat"] isEqual:[NSNull null]] && [category objectForKey:@"sub_cat"] != nil) {
        
        categories_array = [[NSMutableArray alloc] initWithArray:[category objectForKey:@"sub_cat"]];
        
        
        
        [self createSeriesTabs:0];
        [self setTabSelected:0];
    }else{
        categories_array = [[NSMutableArray alloc] init];
        [categories_array addObject:category];
    }
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    ProductListVC *initialViewController = [self viewControllerAtIndex:0];
    
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
     NSLog(@"createSeriesTabs");
    for (UIView *subView in tabscrollview.subviews)
    {
        
        [subView removeFromSuperview];
        
    }
    
    if(categories_array!= nil){
        //if([self isRTL]){
            NSLog(@"isRTL");
         //   [tabscrollview setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
            
            for (int i = 0; i < [categories_array count]; i++) {
                [self addTabToScroll:i index:i title:[[categories_array objectAtIndex:i] valueForKey:@"title"]];
                
                
            }
       // }
        [tabscrollview setContentSize:CGSizeMake(([categories_array count] + 1) * 90  + (([categories_array count] - 1) * 12) , tabscrollview.frame.size.height)];
        
        indicator = [[UIView alloc] initWithFrame:CGRectMake(0, tabscrollview.frame.size.height - 2,kScreenWidth, 2)];
        [indicator setBackgroundColor:[UIColor whiteColor]];
        [tabscrollview addSubview:indicator];
        
    }
    
    
    
}
-(void)addTabToScroll:(int)i index:(int)index title:(NSString *)title{
    
    float tab_width = kScreenWidth / 4;
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



- (ProductListVC *)viewControllerAtIndex:(NSUInteger)index {
    
    ProductListVC *childViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductListVC"];
    childViewController.category = [categories_array objectAtIndex:index];
    childViewController.index = index;
    childViewController.parentview = self;
    return childViewController;
    
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    
    NSUInteger index = [(ProductListVC *)viewController index];
    [self setTabSelected:(int)index];
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(ProductListVC *)viewController index];
    [self setTabSelected:(int)index];
    
    index++;
    
    if (index == [categories_array count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}



- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return [categories_array count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}
@end
