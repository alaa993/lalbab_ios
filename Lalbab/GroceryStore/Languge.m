//
//  Languge.m
//  GroceryStore
//
//  Created by Admin on 27/11/2562 BE.
//  Copyright © 2562 Way. All rights reserved.
//

#import  "InfoPagesVC.h"
//lkaka awa jar ajr estapi namini hhh

#import "Languge.h"
#import "Common.h"
@interface Languge ()
@property (weak, nonatomic) IBOutlet UILabel *txt_test;

@end

@implementation Languge
- (IBAction)kurdish:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
       [defaults setObject:@"fa" forKey:@"LngCode"];
    UINavigationController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"homeCV"];
                    // vc.api_url = URL_API_ABOUTUS;
                     //vc.title = AMLocalizedString(@"About Us", nil);
                     [self.navigationController pushViewController:vc animated:true];
                  
}

- (IBAction)arabic:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"ar" forKey:@"LngCode"];
    UINavigationController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"homeCV"];
    // vc.api_url = URL_API_ABOUTUS;
     //vc.title = AMLocalizedString(@"About Us", nil);
     [self.navigationController pushViewController:vc animated:true];

    
}
- (IBAction)Englsih:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      [defaults setObject:@"en" forKey:@"LngCode"];

    UINavigationController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"homeCV"];
     [self.navigationController pushViewController:vc animated:true];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // self.txt_test.text = NSLocalizedStrings(@"Error!", @"");
    // daye la viewdidload bas aw ha realdi bkaye war dagretawa rastaw xo

     self.txt_test.text = NSLocalizedStrings(@"lg", @"");
           
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
