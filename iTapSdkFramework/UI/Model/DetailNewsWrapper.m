//
//  DetailNewsWrapper.m
//  iTapSdk
//
//  Created by TranCong on 10/11/2021.
//

#import "DetailNewsWrapper.h"

@implementation DetailNewsWrapper
-(instancetype)initFromDictionary:(NSDictionary *)dict{
    if(self = [super init]){
        [KZPropertyMapper mapValuesFrom:dict toInstance:self usingMapping:@{
            @"thumbUrl" : KZBox(URL, thumbUrlNews),
            @"content" : KZProperty(contentNews),
            @"title" : KZProperty(titleNews),
            @"publishedAt" : KZBox(Date,publishedAt)
        }];
    }
    return  self;
}
@end
