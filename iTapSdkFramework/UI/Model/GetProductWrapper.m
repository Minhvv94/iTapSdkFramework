//
//  GetProductWrapper.m
//  VnptSdk
//
//  Created by TranCong on 07/09/2021.
//

#import "GetProductWrapper.h"
@implementation GetProductWrapper
-(instancetype)initFromArray:(NSArray *)array{
    if(self = [super init]){
        self.listProduct = [self passArray:array forPropertyName:@"data"];
    }
    return self;
}
-(id)passArray:(NSArray *)array forPropertyName:(NSString *)propertyName{
    NSMutableArray* products = [[NSMutableArray alloc] init];
    for (int i= 0; i<array.count; i++) {
        NSDictionary * dictItem = [array objectAtIndex:i];
        IAPProduct *newProduct = [[IAPProduct alloc] init];
        [KZPropertyMapper mapValuesFrom:dictItem toInstance:newProduct usingMapping:@{
            @"productId" : KZPropertyT(newProduct,productId),
            @"platform" : KZPropertyT(newProduct,flatformOS),
            @"description" : KZPropertyT(newProduct,productDescription),
            @"appAmount" : KZPropertyT(newProduct,appAmount),
            @"amount" : KZPropertyT(newProduct,amount)
        }];
        [products addObject:newProduct];
    }
    return [[NSArray alloc] initWithArray:products];
}
@end
