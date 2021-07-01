//
//  ControleDawaa.m
//  GroceryStore
//
//  Created by alaa on 6/9/20.
//  Copyright © 2020 Way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "ControleDawa.h"
@interface ControleDawa()
@end
@implementation ControleDawa

- (void)viewDidLoad {
    
    
    
    
}
- (IBAction)btnWhatsAppAction:(id)sender {
      NSURL *whatsappURL = [NSURL URLWithString:@"https://api.whatsapp.com/send?phone=9647503886300"];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
    
  // UIApplication *application = [UIApplication sharedApplication];
    //[application openURL:[NSURL URLWithString: @"whatsapp://send?phone=+9647503886300"] options:@{} completionHandler:nil];

}
- (IBAction)btnWhats1:(id)sender {
   UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString: @"whatsapp://send?phone=9647503886300"] options:@{} completionHandler:nil];
}


@end
