//
//  InfoPagesVC.h
//  Grocery Store
//
//  Created by subhashsanghani on 8/2/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
@interface InfoPagesVC : BaseVC<UIWebViewDelegate>
{
    IBOutlet UIWebView *webview;
}
@property (retain, readwrite) NSString *api_url;
@property (retain, readwrite) NSString *title;
@end
