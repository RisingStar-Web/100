//
//  OHUtils.m
//  OneHundred
//
//  Created by Вадим on 15.07.14.
//  Copyright (c) 2014 Вадим. All rights reserved.
//

#import "OHUtils.h"

float _versionIOS_;

@implementation OHUtils

+ (NSMutableDictionary*)getSetting
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    if (![defaults dictionaryForKey:@"root"]) {
        [result setObject:[NSNumber numberWithBool:YES] forKey:@"audio_param"];
        [result setObject:[NSNumber numberWithBool:NO] forKey:@"six_or_three_digits"];
        [result setObject:[NSNumber numberWithInteger:0] forKey:@"run"];
        [result setObject:[NSNumber numberWithBool:YES] forKey:@"iAd"];
        [result setObject:[[NSArray alloc] initWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES], nil] forKey:@"functions"];
        [defaults setObject:result forKey:@"root"];
        [defaults synchronize];
    } else {
        result = [[NSMutableDictionary alloc] initWithDictionary:[defaults dictionaryForKey:@"root"]];
    }

    return result;
}

+ (BOOL)writeSettingName:(NSString*)name value:(NSObject*)val
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *tmp = [[NSMutableDictionary alloc] initWithDictionary:[defaults dictionaryForKey:@"root"]];
    [tmp setValue:val forKey:name];
    [defaults setObject:tmp forKey:@"root"];
    [defaults synchronize];

    return YES;
}

+ (float)getVersion
{
    if (_versionIOS_ <= 0) {
        _versionIOS_ = [[[UIDevice currentDevice] systemVersion] floatValue];
    }

    return _versionIOS_;
}

@end