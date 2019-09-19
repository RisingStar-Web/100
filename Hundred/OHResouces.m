//
//  OHResouces.m
//  OneHundred
//
//  Created by Вадим on 12.07.14.
//  Copyright (c) 2014 Вадим. All rights reserved.
//

#import "OHResouces.h"

UIFont* __OpenSansSemibold12;
UIFont* __OpenSansSemibold48;
UIFont* __OpenSansLight15;
UIFont* __OpenSansLight36;
UIFont* __OpenSansLight48;
UIFont* __OpenSansLight55;
UIFont* __OpenSansLight70;

UIColor* __BG;
UIColor* __blackActive;
UIColor* __grenNoActive;

NSArray *__leaderboardIDs;

@implementation OHResouces

- (id)init
{
    return self;
}

- (UIFont*) fontOpenSansSemibold12 { return __OpenSansSemibold12; }
- (UIFont*) fontOpenSansSemibold48 { return __OpenSansSemibold48; }
- (UIFont*) fontOpenSansLight15 { return __OpenSansLight15; }
- (UIFont*) fontOpenSansLight36 { return __OpenSansLight36; }
- (UIFont*) fontOpenSansLight55 { return __OpenSansLight55; }
- (UIFont*) fontOpenSansLight48 { return __OpenSansLight48; }
- (UIFont*) fontOpenSansLight70 { return __OpenSansLight70; }

- (UIColor*) colorBG { return __BG; }
- (UIColor*) colorblackActive { return __blackActive; }
- (UIColor*) colorgrenNoActive { return __grenNoActive; }

- (NSArray *)leaderboardIDs { return __leaderboardIDs; }

+ (void)loadToMemory
{
    __OpenSansSemibold12 = [UIFont fontWithName:@"OpenSans-Semibold"  size:12.0f];
    __OpenSansSemibold48 = [UIFont fontWithName:@"OpenSans-Semibold"  size:48.0f];
    __OpenSansLight15 = [UIFont fontWithName:@"OpenSans-Light" size:15.0f];
    __OpenSansLight36 = [UIFont fontWithName:@"OpenSans-Light" size:36.0f];
    __OpenSansLight48 = [UIFont fontWithName:@"OpenSans-Light" size:48.0f];
    __OpenSansLight55 = [UIFont fontWithName:@"OpenSans-Light" size:55.0f];
    __OpenSansLight70 = [UIFont fontWithName:@"OpenSans-Light" size:70.0f];

    __BG = [UIColor colorWithRed:0.9647f green:0.9647f blue:0.9647f alpha:1.0f];
    __blackActive = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f];
    __grenNoActive = [UIColor colorWithRed:0.8196f green:0.8196f blue:0.8196f alpha:1.0f];

    __leaderboardIDs = [NSArray arrayWithObjects:@"6rep", @"6norep", @"3rep", @"3norep", nil];
}

@end
