//
//  ResponeJson.m
//  VnptSdk
//
//  Created by TranCong on 01/09/2021.
//

#import "ResponseJson.h"
#import "KZPropertyMapper.h"

@implementation ResponseJson

-(instancetype)initFromDictionary:(NSDictionary *)dict{
    if(self = [super init]){
        [KZPropertyMapper mapValuesFrom:dict toInstance:self usingMapping:@{
            @"IsSuccessed" : KZProperty(success),
            @"message" : KZProperty(message),
            @"code" : KZProperty(statusCode),
            @"data" : KZCall(passData:forPropertyName:, data)
        }];
    }
    return  self;
}
-(id)passData:(id)data forPropertyName:(NSString *)propertyName{
    if([data isKindOfClass:[NSDictionary class]]){
        return [self passDictionary:data forPropertyName:propertyName];
    }
    if([data isKindOfClass:[NSArray class]]){
        return [self passArray:data forPropertyName:propertyName];
    }
    if(data != NULL){
        return [self passId:data forPropertyName:propertyName];
    }
    return nil;
}
-(id)passDictionary:(NSDictionary *)dictionary forPropertyName:(NSString *)propertyName{
    Class aClass = [self dataClass];
    if([aClass isSubclassOfClass:[DataWrapper class]]){
        return [[aClass alloc] initFromDictionary:dictionary];
    }
    return nil;
}
-(id)passArray:(NSArray *)array forPropertyName:(NSString *)propertyName{
    Class aClass = [self dataClass];
    if([aClass isSubclassOfClass:[DataWrapper class]]){
        return [[aClass alloc] initFromArray:array];
    }
    return nil;
}
-(id)passId:(id)data forPropertyName:(NSString *)propertyName{
    Class aClass = [self dataClass];
    if([aClass isSubclassOfClass:[DataWrapper class]]){
        return [[aClass alloc] initFromId:data];
    }
    return nil;
}
-(Class)dataClass{
    return NSNull.class;
}
@end
