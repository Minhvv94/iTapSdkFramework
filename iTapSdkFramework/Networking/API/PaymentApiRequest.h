//
//  PaymentApiRequest.h
//  iTapSdk
//
//  Created by TranCong on 25/10/2021.
//

#import <Foundation/Foundation.h>
#import "APIRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface PaymentApiRequest : APIRequest
+ (APIRequest *)sharedInstance;
@end

NS_ASSUME_NONNULL_END
