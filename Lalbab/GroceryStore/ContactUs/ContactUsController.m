//
//  ContactUsController.m
//  GroceryStore
//
//  Created by alaa on 4/30/20.
//  Copyright © 2020 Way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ContactUsController.h"
#import "Languge.h"
#import "Common.h"

@interface ContactUsController()
@end

@implementation ContactUsController

- (void)viewDidLoad {
    
    _lblTitleContact.text = NSLocalizedStrings(@"Contact us", nil);
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnCall1:(id)sender {
     UIApplication *application = [UIApplication sharedApplication];
     [application openURL:[NSURL URLWithString: @"tel:+9647503886300"] options:@{} completionHandler:nil];

    }

- (IBAction)btnCall:(id)sender {
 UIApplication *application = [UIApplication sharedApplication];
 [application openURL:[NSURL URLWithString: @"whatsapp://send?phone=9647503886300"] options:@{} completionHandler:nil];

}

- (IBAction)btnCall2:(id)sender {
    UIApplication *application = [UIApplication sharedApplication];
        [application openURL:[NSURL URLWithString: @"tel:+9647723888300"] options:@{} completionHandler:nil];
}
- (IBAction)btnCall21:(id)sender {
    
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString: @"whatsapp://send?phone=9647723888300"] options:@{} completionHandler:nil];
}
- (IBAction)btnemail:(id)sender {
    if([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
            mailCont.mailComposeDelegate = self;
        
            [mailCont setSubject:@""];
         [mailCont setToRecipients:[NSArray arrayWithObject:@"info@lalbab.net"]];
            [mailCont setMessageBody:[@"Your body for this message is " stringByAppendingString:@" this is awesome"] isHTML:NO];
            [self presentViewController:mailCont animated:YES completion:nil];
        }

    }

    - (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
        //handle any error
        [controller dismissViewControllerAnimated:YES completion:nil];
    }

@end

