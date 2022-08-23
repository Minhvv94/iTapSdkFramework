//
//  UserWrapper.m
//  iTapSdk
//
//  Created by TranCong on 07/01/2022.
//

#import "UserWrapper.h"

@implementation UserWrapper
-(instancetype)initFromDictionary:(NSDictionary *)dict{
    if(self = [super init]){
        [KZPropertyMapper mapValuesFrom:dict toInstance:self usingMapping:@{
            @"AccountID" : KZProperty(accountID),
            @"AccountName" : KZProperty(accountName),
            @"Fullname" : KZProperty(fullname),
            @"Email" : KZProperty(email),
            @"Mobile" : KZProperty(mobile),
            @"Address" : KZProperty(address),
            @"Birthday" : KZProperty(birthday),
            @"Gender" : KZProperty(gender),
            @"Status" : KZProperty(status),
            @"Passport" : KZProperty(passport),
            @"ConfirmCode" : KZProperty(confirmCode)
        }];
    }
    return  self;
}
@end
