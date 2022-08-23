//
//  OtpWrapper.m
//  iTapSdk
//
//  Created by TranCong on 13/10/2021.
//

#import "OtpWrapper.h"

@implementation OtpWrapper
-(instancetype)initFromDictionary:(NSDictionary *)dict{
    if(self = [super init]){
        [KZPropertyMapper mapValuesFrom:dict toInstance:self usingMapping:@{
            @"otp" : KZProperty(otp)
        }];
    }
    return  self;
}
@end
