//
//  OHUtils.h
//  OneHundred
//
//  Created by Вадим on 15.07.14.
//  Copyright (c) 2014 Вадим. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OHUtils : NSObject

+ (NSMutableDictionary*)getSetting;
+ (BOOL)writeSettingName:(NSString*)name value:(NSObject*)val;

+ (float)getVersion;

@end
