//
//  OrderWrapper.m
//  iTapSdk
//
//  Created by TranCong on 19/01/2022.
//

#import "OrderWrapper.h"

@implementation OrderWrapper
-(instancetype)initFromId:(id)value{
    if(self = [super init]){
        NSNumber* num = (NSNumber*)value;
        self.transId = [num longValue];
    }
    return  self;
}

@end
