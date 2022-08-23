//
//  AppleApiRequest.m
//  iTapSdk
//
//  Created by Minh Vu on 29/07/2022.
//

#import "AppleApiRequest.h"

@implementation AppleApiRequest
+ (APIRequest *)sharedInstance{
    static APIRequest *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[APIRequest alloc] init];
        NSString* baseUrl = APPLE_BASE_ID;
        [_sharedInstance initBaseUrl:baseUrl];
    });

    return _sharedInstance;
}
@end
