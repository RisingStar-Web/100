//
//  OHResouces.h
//  OneHundred
//
//  Created by Вадим on 12.07.14.
//  Copyright (c) 2014 Вадим. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHResouces : NSObject

- (id)init;

- (UIFont*) fontOpenSansSemibold12;
- (UIFont*) fontOpenSansSemibold48;
- (UIFont*) fontOpenSansLight15;
- (UIFont*) fontOpenSansLight36;
- (UIFont*) fontOpenSansLight48;
- (UIFont*) fontOpenSansLight55;
- (UIFont*) fontOpenSansLight70;

- (UIColor*) colorBG;
- (UIColor*) colorblackActive;
- (UIColor*) colorgrenNoActive;

- (NSArray *)leaderboardIDs;

+ (void)loadToMemory;

@end
