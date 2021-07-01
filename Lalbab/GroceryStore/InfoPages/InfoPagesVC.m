//
//  InfoPagesVC.m
//  Grocery Store
//
//  Created by subhashsanghani on 8/2/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import "InfoPagesVC.h"
#import "Languge.h"
#import "Common.h"

@interface InfoPagesVC ()

@end

@implementation InfoPagesVC
@synthesize api_url, title;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = title;
    // Do any additional setup after loading the view.
    [self getInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getInfo{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init] ;
    [self postResponseFromURL:[self getStringURLForAPI:api_url] withParams:params progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
           NSMutableArray *dataArray = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:PARAM_DATA]];
            [webview loadHTMLString:[[[dataArray objectAtIndex:0] valueForKey:@"pg_descri"] stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"] baseURL:nil];
           

        }
        else{
            [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showLoader:YES hideLoader:YES];
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
