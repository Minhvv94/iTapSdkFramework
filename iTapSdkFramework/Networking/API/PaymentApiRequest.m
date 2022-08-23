//
//  PaymentApiRequest.m
//  iTapSdk
//
//  Created by TranCong on 25/10/2021.
//

#import "PaymentApiRequest.h"

@implementation PaymentApiRequest
+ (APIRequest *)sharedInstance{
    static APIRequest *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[APIRequest alloc] init];
        BOOL isProdEnv = [[Sdk sharedInstance] isProdEnv];
        NSString* baseUrl = PROD_BASE_PAYMENT;
        if(!isProdEnv){
            baseUrl = DEV_BASE_PAYMENT;
        }
        /*NSURL* baseUrl = [Utils getUrl:@"PAYMENT_BASE_URL"];
        [_sharedInstance initBaseUrl:[baseUrl absoluteString]];*/
        [_sharedInstance initBaseUrl:baseUrl];
    });

    return _sharedInstance;
}
@end
