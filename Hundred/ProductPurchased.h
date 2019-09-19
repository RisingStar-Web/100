//
//  RSProductPurchased.h
//  beads
//
//  Created by Вадим on 03.09.14.
//  Copyright (c) 2014 Вадим. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface ProductPurchased : NSObject  <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (weak, nonatomic) UIView *loaderView;
@property (weak, nonatomic) UISwitch *idSettinSwitch;

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

- (void)restoreCompletedTransactions;

// Add two new method declarations
- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchased:(NSString *)productIdentifier;

@end
