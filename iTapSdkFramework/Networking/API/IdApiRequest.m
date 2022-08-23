//
//  IdApiRequest.m
//  iTapSdk
//
//  Created by TranCong on 25/10/2021.
//

#import "IdApiRequest.h"

@implementation IdApiRequest
+ (APIRequest *)sharedInstance{
    static APIRequest *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[APIRequest alloc] init];
        BOOL isProdEnv = [[Sdk sharedInstance] isProdEnv];
        NSString* baseUrl = PROD_BASE_ID;
        if(!isProdEnv){
            baseUrl = DEV_BASE_ID;
        }
        /*NSURL* baseUrl = [Utils getUrl:@"ID_BASE_URL"];
        [_sharedInstance initBaseUrl:[baseUrl absoluteString]];*/
        [_sharedInstance initBaseUrl:baseUrl];
    });

    return _sharedInstance;
}
@end
