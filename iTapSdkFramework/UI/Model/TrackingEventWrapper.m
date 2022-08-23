//
//  TrackingEventWrapper.m
//  iTapSdk
//
//  Created by TranCong on 06/04/2022.
//

#import "TrackingEventWrapper.h"

@implementation TrackingEventWrapper
-(instancetype)initFromDictionary:(NSDictionary *)dict{
    if(self = [super init]){
        [KZPropertyMapper mapValuesFrom:dict toInstance:self usingMapping:@{
            @"eventName" : KZProperty(eventName)
        }];
    }
    return self;
}
@end
