//
//  PaymentView.h
//  iTapSdk
//
//  Created by TranCong on 09/03/2022.
//

#import "BaseView.h"
#import <StoreKit/StoreKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface PaymentView : BaseView<SKPaymentTransactionObserver>

@property (nonatomic, strong) NSArray<IAPProduct*> *products;
@property (nonatomic, strong) NSString *serverId;
@property (nonatomic, strong) NSString *characterId;
@property (nonatomic, strong) NSString *productId;
@end

NS_ASSUME_NONNULL_END
