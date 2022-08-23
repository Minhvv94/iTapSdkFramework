//
//  GameApiRequest.m
//  iTapSdk
//
//  Created by TranCong on 25/10/2021.
//

#import "GameApiRequest.h"

@implementation GameApiRequest
+ (APIRequest *)sharedInstance{
    static APIRequest *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[APIRequest alloc] init];
        BOOL isProdEnv = [[Sdk sharedInstance] isProdEnv];
        NSString* baseUrl = PROD_BASE_GAME_HUB;
        if(!isProdEnv){
            baseUrl = DEV_BASE_GAME_HUB;
        }
        //NSURL* baseUrl = [Utils getUrl:@"GAME_BASE_URL"];
        //[_sharedInstance initBaseUrl:[baseUrl absoluteString]];
        [_sharedInstance initBaseUrl:baseUrl];
    });
    return _sharedInstance;
}
@end
