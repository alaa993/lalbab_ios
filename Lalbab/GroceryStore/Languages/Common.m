//
//  Common.m
//  Custom Localization Demo
//
//  Created by SIYAD on 8/16/15.
//  Copyright (c) 2015 Temp. All rights reserved.
//

#import "Common.h"

@implementation Common

static Common *sharedInstance  = nil;


+ (Common *)sharedCommon {
    
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

+ (NSString *)languageCode{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *languageCode = [defaults objectForKey:@"LngCode"];
    return languageCode;
    
}

+ (NSString *)localizedString:(NSString *)key withComment:(NSString *)comment{
    
    NSString *path = [[ NSBundle mainBundle ] pathForResource:[Common languageCode] ofType:@"lproj" ];
    NSString * localizedString = [[NSBundle bundleWithPath:path] localizedStringForKey:key value:key table:nil];
    return localizedString;
}


@end

