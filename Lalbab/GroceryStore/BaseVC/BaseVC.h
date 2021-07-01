//
//  BaseVC.h
//  FruitMarket
//
//  Created by subhashsanghani on 9/21/16.
//  Copyright © 2016 com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BaseCart.h"
#import "API_Parameters.h"
#import "API_Settings.h"
#import "Constants.h"
#import "LocalizationSystem.h"
#import "Reachability.h"
#import "LocalizeButton.h"

#import "AsyncImageView.h"
#import "MKNumberBadgeView.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "AFNetworking/AFHTTPSessionManager.h"
@interface BaseVC : UIViewController
{
    AppDelegate *app;
    BaseCart *cart;
    MKNumberBadgeView *numberBudget;
}

/**
 *  Add Menu buttons in Navigation
 */
-(NSString*)getStringDateFormate:(NSDate*)date;
-(NSString*)getMySqlDateFormate:(NSDate*)date;

-(void)addMenuButton;
-(void)setActionbarLogo;
-(void)setSimpleImageToView:(UIImageView*)imgView imgpath:(NSString*)imgPath;
/**
 *  Add three buttons in Navigation
 */


/**
 *  Gets response from the specified URL GET request
 *
 *  @param strURL              URL from where response is to be fetched
 *  @param dictParams          Parameters
 *  @param blockSuccess        Block to be called on success
 *  @param blockFailure        Block to be called on failure
 *  @param isShowDefaultLoader YES = Will show default loader
 *  @param isShowLoaderAnimated YES = Loader will be animated when shown
 *  @param isHideDefaultLoader YES = Hides loader
 */
-(void)getResponseFromURL:(NSString*)strURL withParam:(NSMutableDictionary*)dictParams progress:(void(^)(NSProgress *downloadProgress))blockProgress success:(void (^)(NSURLSessionDataTask *task, id responseObject, bool isSuccess))blockSuccess failure:(void(^)(NSURLSessionDataTask *task, NSError *error))blockFailure showLoader:(BOOL)isShowDefaultLoader showAnimated:(BOOL)isShowAnimated hideLoader:(BOOL)isHideDefaultLoader;

/*
 **
 *  Gets response from the specified URL GET request
 *
 *  @param strURL              URL from where response is to be fetched
 *  @param dictParams          Parameters
 *  @param blockSuccess        Block to be called on success
 *  @param blockFailure        Block to be called on failure
 *  @param isShowDefaultLoader YES = Will show default loader
 *  @param isHideDefaultLoader YES = Hides loader
 */
-(void)getResponseFromURL:(NSString*)strURL withParam:(NSMutableDictionary*)dictParams progress:(void(^)(NSProgress *downloadProgress))blockProgress success:(void (^)(NSURLSessionDataTask *task, id responseObject, bool isSuccess))blockSuccess failure:(void(^)(NSURLSessionDataTask *task, NSError *error))blockFailure showLoader:(BOOL)isShowDefaultLoader hideLoader:(BOOL)isHideDefaultLoader;

/**
 *  Gets response from the specified URL using POST request
 *
 *  @param strURL              URL from where response is to be fetched
 *  @param dictParams          Parameters
 *  @param blockSuccess        Block to be called on success
 *  @param blockFailure        Block to be called on failure
 *  @param isShowDefaultLoader YES = Will show default loader
 *  @param isShowLoaderAnimated YES = Loader will be animated when shown
 *  @param isHideDefaultLoader YES = Hides loader
 */
-(void)postResponseFromURL:(NSString *)strURL withParams:(NSMutableDictionary *)dictParams progrss:(void(^)(NSProgress *uploadProgress))blockProgress success:(void (^)(NSURLSessionDataTask *task, id responseObject, bool isSuccess))blockSuccess failure:(void (^)(NSURLSessionDataTask *task, NSError *error))blockFailure showLoader:(BOOL)isShowDefaultLoader showAnimated:(BOOL)isShowLoaderAnimated hideLoader:(BOOL)isHideDefaultLoader;

/**
 *  Gets response from the specified URL POST request
 *
 *  @param strURL              URL from where response is to be fetched
 *  @param dictParams          Parameters
 *  @param blockSuccess        Block to be called on success
 *  @param blockFailure        Block to be called on failure
 *  @param isShowDefaultLoader YES = Will show default loader
 *  @param isHideDefaultLoader YES = Hides loader
 */
-(void)postResponseFromURL:(NSString *)strURL withParams:(NSMutableDictionary *)dictParams progrss:(void(^)(NSProgress *uploadProgress))blockProgress success:(void (^)(NSURLSessionDataTask *task, id responseObject, bool isSuccess))blockSuccess failure:(void (^)(NSURLSessionDataTask *task, NSError *error))blockFailure showLoader:(BOOL)isShowDefaultLoader hideLoader:(BOOL)isHideDefaultLoader;

/**
 *  Displays alert with Ok button
 *
 *  @param strTitle   Title
 *  @param strMessage Message
 */
-(void)showAlertForTitle:(NSString *)strTitle withMessage:(NSString *)strMessage;

-(NSString *)getStringURLForAPI:(NSString *)strAPI;


/**
 * This will show number of items in carts on top view 
 **/
-(void)addCartButton;
-(void)updateCart;
-(BOOL)isRTL;
-(CGRect)changeViewDirection:(CGRect)frame screenwidth:(double)screenwidth extraOffset:(double)extraoffcet;
-(CGRect)changeViewToStart:(CGRect)frame;
-(IBAction)chooseLang:(id)sender;
-(IBAction)btnlanguageChange:(id)sender;
@end
