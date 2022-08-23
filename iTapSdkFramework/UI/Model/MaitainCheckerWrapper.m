//
//  MaitainCheckerWrapper.m
//  iTapSdk
//
//  Created by TranCong on 03/12/2021.
//

#import "MaitainCheckerWrapper.h"

@implementation MaitainCheckerWrapper
-(instancetype)initFromDictionary:(NSDictionary *)dict{
    if(self = [super init]){
        [KZPropertyMapper mapValuesFrom:dict toInstance:self usingMapping:@{
            @"isMaintained" : KZProperty(isMaintained),
            @"messageMaintain" : KZProperty(messageMaintain),
            @"enableGoogleLogin" : KZProperty(enableGoogleLogin),
            @"enableFacebookLogin" : KZProperty(enableFacebookLogin),
            @"enableAppleLogin" : KZProperty(enableAppleLogin)
        }];
    }
    return  self;
}
@end
