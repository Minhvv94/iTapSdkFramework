//
//  GameConfigWrapper.m
//  iTapSdk
//
//  Created by TranCong on 26/10/2021.
//

#import "GameConfigWrapper.h"

@implementation GameConfigWrapper
-(instancetype)initFromDictionary:(NSDictionary *)dict{
    if(self = [super init]){
        [KZPropertyMapper mapValuesFrom:dict toInstance:self usingMapping:@{
            @"hotLinkHomepage" : KZProperty(hotLinkHomepage),
            @"hotLinkFanpage" : KZProperty(hotLinkFanpage),
            @"hotLinkGroup" : KZProperty(hotLinkGroup),
            @"hotLinkChat" : KZProperty(hotLinkChat),
            @"hotline" : KZProperty(hotline)
        }];
    }
    return  self;
}
@end
