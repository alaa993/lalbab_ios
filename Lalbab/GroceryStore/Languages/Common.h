//
//  Common.h
//  Custom Localization Demo
//
//  Created by SIYAD on 8/16/15.
//  Copyright (c) 2015 Temp. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef NSLocalizedStrings
#define NSLocalizedStrings(key,_comment) [Common localizedString:key withComment:_comment]

@interface Common : NSObject

+ (Common *)sharedCommon;
+ (NSString *)languageCode;
+ (NSString *)localizedString:(NSString *)key withComment:(NSString *)comment;

@end

