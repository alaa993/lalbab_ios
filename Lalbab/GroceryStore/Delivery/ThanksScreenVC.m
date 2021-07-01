//
//  ThanksScreenVC.m
//  Grocery Store
//
//  Created by subhashsanghani on 8/3/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import "ThanksScreenVC.h"
#import "MyOrdersVC.h"
#import "Languge.h"
#import "Common.h"

@interface ThanksScreenVC ()

@end

@implementation ThanksScreenVC
@synthesize lblMessage,appointment;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = true;
    // Do any additional setup after loading the view.
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[appointment dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    lblMessage.attributedText = attrStr;
    lblMessage.numberOfLines = 0;
    [lblMessage sizeToFit];
    
    [_cHome setTitle:NSLocalizedStrings(@"CONTINUE HOME", nil) forState:UIControlStateNormal];
    
    [_TMYOrder setTitle:NSLocalizedStrings(@"TRACK MY ORDER", nil) forState:UIControlStateNormal];

    self.TYFYOrder.text=
        [NSString stringWithFormat:@"%@ ",NSLocalizedStrings(@"Thank you for your order.", nil)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)homeClick:(id)sender{
    UINavigationController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"homeCV"];
    [self.navigationController pushViewController:vc animated:true];
      
    /*
    UINavigationController *secondViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"HomeNavigation"];
    [self presentViewController:secondViewController animated:YES completion:nil];
    */
}
-(IBAction)appointmentClick:(id)sender{
    MyOrdersVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyOrdersVC"];
    [self.navigationController pushViewController:vc animated:true];
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
