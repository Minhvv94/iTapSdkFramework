//
//  LoginWrapper.m
//  VnptSdk
//
//  Created by TranCong on 04/09/2021.
//

#import "LoginWrapper.h"

@implementation LoginWrapper
-(instancetype)initFromDictionary:(NSDictionary *)dict{
    if(self = [super init]){
        [KZPropertyMapper mapValuesFrom:dict toInstance:self usingMapping:@{
            @"access_token" : KZProperty(accessToken),
            @"refresh_token" : KZProperty(refreshToken),
            //@"user" : KZCall(passDictionary:forPropertyName:, user)
        }];
    }
    return  self;
}
/*-(id)passDictionary:(NSDictionary *)dictionary forPropertyName:(NSString *)propertyName{
    User *user = [User initFromJsonDict:dictionary];
    return user;
}*/
@end
