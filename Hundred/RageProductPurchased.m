//
//  RSRageProductPurchased.m
//  beads
//
//  Created by Вадим on 03.09.14.
//  Copyright (c) 2014 Вадим. All rights reserved.
//

#import "RageProductPurchased.h"

@implementation RageProductPurchased

+ (RageProductPurchased *)sharedInstance
{
    static dispatch_once_t once;
    static RageProductPurchased * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.company.Handred.iAdoff",
                                      nil];

        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
