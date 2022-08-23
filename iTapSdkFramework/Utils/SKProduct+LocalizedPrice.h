//
//  SKProduct+LocalizedPrice.h
//  testgame
//
//  Created by TranCong on 20/08/2021.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface SKProduct(LocalizedPrice)

- (NSString *)localizedPrice;
- (NSString*)currencyCode;
@end

NS_ASSUME_NONNULL_END
