//
//  API_Parameters.h
//
//
//  Created by subhashsanghani on 9/21/16.
//  Copyright © 2016 com. All rights reserved.
//

#ifndef API_Parameters_h
#define API_Parameters_h

#pragma mark- API Request parameters

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define PARAM_RESPONSE @"responce"
#define PARAM_chekRESPONSE @"responcee"
#define PARAM_DATA @"data"
#define PARAM_ERROR @"error"
#define BOOL_UPDATE @"bool_update"

#define URL_API_CheckLOGIN @"/api/checklogin"
#define URL_API_LOGIN @"/api/login"
#define URL_API_FORGOT_PASSWORD @"/api/forgot_password"
#define URL_API_REGISTER @"/api/signup"

#define URL_API_APP_SETTINGS @"/api/get_limit_settings"
#define URL_API_CATEGORY @"/api/get_categories"
#define URL_API_CATEGORY1 @"/api/get_categories1"
#define URL_API_CATEGORY_SHOP @"/api/get_categories_shop"
#define URL_API_PRODUCTS @"/api/get_products"
#define URL_API_PRODUCTS_SHOP @"/api/get_products_all"
#define URL_API_TIMESLOT @"/api/get_time_slot"
#define URL_API_SOCITY @"/api/get_society"
#define URL_API_ADDRESS @"/api/get_address"
#define URL_API_ADD_ADDRESS @"/api/add_address"
#define URL_API_EDIT_ADDRESS @"/api/edit_address"
#define URL_API_DELETET_ADDRESS @"/api/delete_address"
#define URL_API_ADD_ORDER @"/api/send_order"
#define URL_API_LIST_ORDER @"/api/my_orders"
#define URL_API_LIST_REQUEST @"/api/my_requests"
#define URL_API_LIST_EDIT_PRODUCTS @"/api/edit_products"



#define URL_API_ORDER_DETAILS @"/api/order_details"
#define URL_API_CANCLE_ORDER @"/api/cancel_order"
#define URL_API_CHANGE_ORDER @"/api/confirm_order"
#define URL_API_PROFILE_UPDATE @"/api/update_userdata"
#define URL_API_CHANGE_PASSWORD @"/api/change_password"
#define URL_API_USER_DATA @"/api/get_userdata"
#define URL_API_UPDATE_PROFILE_IMAGE @"/api/update_profile_pic"
#define URL_API_APN_REGISTER @"/api/register_fcm"

#define URL_API_SLIDERS @"/api/get_sliders"

#define URL_API_ABOUTUS @"/api/aboutus"
#define URL_API_SUPPORT @"/api/support"
#define URL_API_TERMS @"/api/terms"


//#define PATH_CATEGORY_IMAGE @"/uploads/category/"
#define PATH_CATEGORY_IMAGE @"/uploads/products/"

#define SLIDER_IMAGE_BIG_PATH @"/uploads/sliders/"


#define PRO_IMAGE_BIG_PATH @"/uploads/products/"
#define PRO_IMAGE_SMALL_PATH @"/uploads/products/"
#define PRO_IMAGE_ICON_PATH @"/uploads/products/"

#define IMAGE_PROFILE_PATH @"/uploads/profile/"



#endif /* API_Parameters_h */
