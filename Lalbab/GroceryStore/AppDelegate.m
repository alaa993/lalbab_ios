//
//  AppDelegate.m
//  Grocery Store
//
//  Created by subhashsanghani on 7/27/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import "AppDelegate.h"
#import "Languge.h"
#import "Common.h"



@import Firebase;
@import FirebaseAuth;
@import FirebaseInstanceID;




#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif
@import FirebaseInstanceID;
@import FirebaseMessaging;
// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above. Implement FIRMessagingDelegate to receive data message via FCM for
// devices running iOS 10 and above.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate () <UNUserNotificationCenterDelegate, FIRMessagingDelegate>
@end
#endif

// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif

@interface AppDelegate ()

@end

@implementation AppDelegate




NSString *const kGCMMessageIDKey = @"gcm.message_id";
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self loadSharedInstance];
    [self loadAppSettings];
     
    [FIRApp configure];
    
    [FIRMessaging messaging].delegate = self;
     
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
   
    
    
    if ([UNUserNotificationCenter class] != nil) {
      // iOS 10 or later
      // For iOS 10 display notification (sent via APNS)
      [UNUserNotificationCenter currentNotificationCenter].delegate = self;
      UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
          UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
      [[UNUserNotificationCenter currentNotificationCenter]
          requestAuthorizationWithOptions:authOptions
          completionHandler:^(BOOL granted, NSError * _Nullable error) {
            // ...
          }];
    } else {
      // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
      UIUserNotificationType allNotificationTypes =
      (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
      UIUserNotificationSettings *settings =
      [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
      [application registerUserNotificationSettings:settings];
    }

    [application registerForRemoteNotifications];
    
    
        // [END register_for_notifications]
   // }
    
    // [START configure_firebase]
    
   
    
    
    
    // [END configure_firebase]
    // Add observer for InstanceID token refresh callback.

    
    
    
    return YES;
}

-(void)loadAppSettings{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_APPSETTINGS])
    {
        self.app_settings = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_APPSETTINGS]];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:[URL_API_HOST stringByAppendingString:URL_API_APP_SETTINGS] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
            [[NSUserDefaults standardUserDefaults] setObject:[[NSMutableArray alloc] initWithArray:responseObject] forKey:USERDEFAULTS_APPSETTINGS];
            self.app_settings = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_APPSETTINGS]];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@",error);
        
    }];
}
-(void)loadSharedInstance{
    
   
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_USERDATA];
    self.dictUser = [[NSMutableDictionary alloc] initWithDictionary:[[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy]];
    NSLog(@"%@",self.dictUser);
    
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}





/** FCM Configuration stated **/
- (void)showAlert:(NSString *)title withMessage:(NSString *) message{
    
    // iOS 7.1 or earlier
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedStrings(@"Dismiss", nil)
                                          otherButtonTitles:NSLocalizedStrings(@"Ok",nil),nil];
    [alert show];
}

-(void)sendNotificationView:(NSDictionary*)userInfo  application:(UIApplication *)application{
    UIApplicationState state1 = [application applicationState];
   
        //NSDictionary *userToken = @{@"registrationToken":[[FIRInstanceID instanceID] token]};
        //[[NSNotificationCenter defaultCenter] postNotificationName:[[FIRInstanceID instanceID] token]
        //                                                    object:nil
        //                                                  userInfo:userToken];
        if (state1 == UIApplicationStateActive)
        {
               NSLog(@"userInfo ID: %@", userInfo);
            
            [self setScheduleNotification:userInfo];
            /*   if ([UIApplication sharedApplication].applicationIconBadgeNumber >0) {
             [UIApplication sharedApplication].applicationIconBadgeNumber -= 1;
             }else{
             application.applicationIconBadgeNumber = 0;
             }*/
            //[[NSNotificationCenter defaultCenter] postNotificationName:_messageKey
            //                                                    object:nil
            //                                                  userInfo:userInfo];
            [self showAlert:userInfo[@"title"] withMessage:userInfo[@"message"]];
            
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }else if (state1 == UIApplicationStateBackground){
            
            [self setScheduleNotification:userInfo];
            [UIApplication sharedApplication].applicationIconBadgeNumber += 1;
            
        }else if (state1 == UIApplicationStateInactive){
            
            [self setScheduleNotification:userInfo];
            [UIApplication sharedApplication].applicationIconBadgeNumber += 1;
            
        }else {
            [self setScheduleNotification:userInfo];
            [UIApplication sharedApplication].applicationIconBadgeNumber += 1;
            NSLog(@"notification received in background else");
        }
        
    
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken
{
    [[FIRMessaging messaging] subscribeToTopic:@"weather"
                                    completion:^(NSError * _Nullable error) {
      NSLog(@"Subscribed to weather topic");
    }];
    
    
    NSLog(@"FCM registration token: %@", fcmToken);
       // Notify about received token.
       NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
       [[NSNotificationCenter defaultCenter] postNotificationName:
        @"FCMToken" object:nil userInfo:dataDict];
    
    
    [[FIRInstanceID instanceID] instanceIDWithHandler:^(FIRInstanceIDResult * _Nullable result,
                                                        NSError * _Nullable error) {
    
      if (error != nil) {
        NSLog(@"Error fetching remote instance ID: %@", error);
      } else {
        NSLog(@"Remote instance ID token: %@", result.token);
        NSString* message =
          [NSString stringWithFormat:@"Remote InstanceID token: %@", result.token];
      //  self.instanceIDTokenMessage.text = message;
      }
    }];
}

// [START receive_message]
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
  // If you are receiving a notification message while your app is in the background,
  // this callback will not be fired till the user taps on the notification launching the application.
  // TODO: Handle data of notification

  // With swizzling disabled you must let Messaging know about the message, for Analytics
  // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];

  // Print message ID.
  if (userInfo[kGCMMessageIDKey]) {
    NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
  }

  // Print full message.
  NSLog(@"%@", userInfo);
}

/*
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
    fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  // If you are receiving a notification message while your app is in the background,
  // this callback will not be fired till the user taps on the notification launching the application.
  // TODO: Handle data of notification

  // With swizzling disabled you must let Messaging know about the message, for Analytics
   [[FIRMessaging messaging] appDidReceiveMessage:userInfo];

  // Print message ID.
  if (userInfo[kGCMMessageIDKey]) {
    NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
  }

  // Print full message.
  NSLog(@"%@", userInfo);

  completionHandler(UIBackgroundFetchResultNewData);
    
}
*/

- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)notification
          fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  // Pass notification to auth and check if they can handle it.
  if ([[FIRAuth auth] canHandleNotification:notification]) {
    completionHandler(UIBackgroundFetchResultNoData);
    return;
  }
  // This notification is not auth related, developer should handle it.
}

// [END receive_message]

// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // Print message ID.
    NSDictionary *userInfo = notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"user notification center : %@", userInfo);
    
    // Change this to your preferred presentation option
    completionHandler(UNNotificationPresentationOptionNone);
}





// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"user noti center compite handler : %@", userInfo);
    
    completionHandler();
}
#endif
// [END ios_10_message_handling]

// [START ios_10_data_message_handling]
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Receive data message on iOS 10 devices while app is in the foreground.

#endif
// [END ios_10_data_message_handling]
-(void)setScheduleNotification:(NSDictionary*)userInfo{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.userInfo = userInfo;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.alertBody = userInfo[@"message"];
    localNotification.alertTitle = userInfo[@"title"];
    localNotification.fireDate = [NSDate date];
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    /*
     UILocalNotification* localNotification = [[UILocalNotification alloc] init];
     localNotification.alertBody = userInfo[@"gcm.notification.message"];
     localNotification.alertTitle = userInfo[@"aps"][@"alert"][@"title"];
     localNotification.soundName = UILocalNotificationDefaultSoundName;
     localNotification.timeZone = [NSTimeZone defaultTimeZone];
     localNotification.repeatInterval = 0;
     localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
     [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
     
     [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
     */
    
}
// [START refresh_token]

// [END refresh_token]

// [START connect_to_fcm]

// [END connect_to_fcm]



- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Unable to register for remote notifications: %@", error);
}

// This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
// If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
// the InstanceID token.
/*
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"APNs token retrieved: %@", deviceToken);
    
    // [[NSUserDefaults standardUserDefaults] setValue:deviceToken forKey:@"apn_token"];
    // With swizzling disabled you must set the APNs token here.
    
    // FOR TESTING  use  FIRInstanceIDAPNSTokenTypeSandbox
    // FOR PRODUCTIOn use  FIRInstanceIDAPNSTokenTypeProd
    [FIRMessaging messaging].APNSToken = deviceToken;
    
    //[[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeProd];
    
    [[FIRAuth auth] setAPNSToken:deviceToken type:FIRAuthAPNSTokenTypeProd];
    
}
*/


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {

   // [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeSandbox];
   // [FIRMessaging messaging].autoInitEnabled = YES;
    [FIRMessaging messaging].APNSToken = deviceToken;
    NSString *newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"My token is: %@", newToken);
    
   // [FIRMessaging messaging].APNSToken = deviceToken;
    
    //[[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeProd];
    
    [[FIRAuth auth] setAPNSToken:deviceToken type:FIRAuthAPNSTokenTypeUnknown];
    

}



/*
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [FIRMessaging messaging].APNSToken = deviceToken;
}
*/



// [START connect_on_active]

// [END connect_on_active]

// [START disconnect_from_fcm]
- (void)applicationDidEnterBackground:(UIApplication *)application {
    //[[FIRMessaging messaging] disconnect];
    NSLog(@"Disconnected from FCM");
    
    /*
    UILocalNotification *notification = [[UILocalNotification alloc] init];
           notification.fireDate = [[NSDate date] dateByAddingTimeInterval:1];
           notification.alertTitle = @"test";
           notification.alertBody = @"testt";
           [[UIApplication sharedApplication] scheduleLocalNotification:notification];
*/
    
}
// [END disconnect_from_fcm]

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
}



@end
