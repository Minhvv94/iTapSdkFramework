//
//  ListNewsWrapper.m
//  iTapSdk
//
//  Created by TranCong on 09/11/2021.
//

#import "ListNewsWrapper.h"

@implementation ListNewsWrapper
-(instancetype)initFromDictionary:(NSDictionary *)dict{
    if(self = [super init]){
        [KZPropertyMapper mapValuesFrom:dict toInstance:self usingMapping:@{
            @"total" : KZProperty(totalPost),
            @"posts" : KZCall(passArray:forPropertyName:,listPostInPage)
        }];
    }
    return  self;
}
-(id)passArray:(NSArray *)array forPropertyName:(NSString *)propertyName{
    NSMutableArray* listPost = [[NSMutableArray alloc] init];
    for (int i= 0; i<array.count; i++) {
        NSDictionary * dictItem = [array objectAtIndex:i];
        ListNews *post = [[ListNews alloc] init];
        [KZPropertyMapper mapValuesFrom:dictItem toInstance:post usingMapping:@{
            @"categoryName" : KZPropertyT(post,categoryName),
            @"title" : KZPropertyT(post,titleNews),
            @"createdAt" : KZBoxT(post,Date,createdAt),
            @"publishedAt" : KZBoxT(post,Date,publishedAt),
            @"thumbUrl" : KZBoxT(post,URL,thumbUrl),
            @"id" : KZPropertyT(post,newsId)
        }];
        [listPost addObject:post];
    }
    return [[NSArray alloc] initWithArray:listPost];
}
@end
