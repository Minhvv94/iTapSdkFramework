//
//  VnptUser.m
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import "User.h"
#import "Constant.h"
#import "KZPropertyMapper.h"
@implementation User

- (void) encodeWithCoder:(NSCoder *)encoder {
    /*[encoder encodeObject:self.userId forKey:KeyUserId];
    [encoder encodeObject:self.userName forKey:KeyUserName];
    [encoder encodeObject:self.userEmail forKey:KeyUserEmail];
    [encoder encodeObject:self.userDisplayName forKey:KeyUserDisplay];
    [encoder encodeObject:self.avatarImgLink forKey:KeyUserAvatarImgLink];
    
    [encoder encodeObject:self.phone forKey:KeyUserPhone];
    [encoder encodeObject:self.platform forKey:KeyUserPlatform];
    [encoder encodeObject:self.deviceId forKey:KeyUserDeviceId];
    [encoder encodeObject:self.pushId forKey:KeyUserPushId];
    [encoder encodeObject:self.birthday forKey:KeyUserBirthday];
    [encoder encodeObject:self.idCard forKey:KeyUserIdCard];
    [encoder encodeBool:self.isGuest forKey:KeyUserIsGuest];
    [encoder encodeBool:self.emailIsVerified forKey:KeyUserIsEmailVerified];
    [encoder encodeBool:self.iapLock forKey:KeyUserIapLock];
    [encoder encodeObject:self.status forKey:KeyUserStatus];
    [encoder encodeObject:self.loginAt forKey:KeyUserLoginAt];
    [encoder encodeObject:self.region forKey:KeyUserRegion];
    [encoder encodeObject:self.address forKey:KeyUserAddress];
    [encoder encodeObject:self.country forKey:KeyUserCountry];
    [encoder encodeObject:self.postalCode forKey:KeyUserPostalCode];*/
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        /*self.userId = [decoder decodeObjectForKey:KeyUserId];
        self.userName = [decoder decodeObjectForKey:KeyUserName];
        self.userEmail = [decoder decodeObjectForKey:KeyUserEmail];
        self.userDisplayName = [decoder decodeObjectForKey:KeyUserDisplay];
        self.avatarImgLink = [decoder decodeObjectForKey:KeyUserAvatarImgLink];
        self.platform = [decoder decodeObjectForKey:KeyUserPlatform];
        self.deviceId = [decoder decodeObjectForKey:KeyUserDeviceId];
        self.pushId = [decoder decodeObjectForKey:KeyUserPushId];
        self.idCard = [decoder decodeObjectForKey:KeyUserIdCard];
        self.birthday = [decoder decodeObjectForKey:KeyUserBirthday];
        
        self.phone = [decoder decodeObjectForKey:KeyUserPhone];
        self.status = [decoder decodeObjectForKey:KeyUserStatus];
        self.loginAt = [decoder decodeObjectForKey:KeyUserLoginAt];
        self.isGuest = [decoder decodeBoolForKey:KeyUserIsGuest];
        self.emailIsVerified = [decoder decodeBoolForKey:KeyUserIsEmailVerified];
        self.iapLock = [decoder decodeBoolForKey:KeyUserIapLock];
        self.region = [decoder decodeObjectForKey:KeyUserRegion];
        self.postalCode = [decoder decodeObjectForKey:KeyUserPostalCode];
        self.address = [decoder decodeObjectForKey:KeyUserAddress];
        self.country = [decoder decodeObjectForKey:KeyUserCountry];*/
        
    }
    return self;
}
+(id)initFromJsonDict:(NSDictionary *)dict{
    User * user = [[User alloc] init];
    /*[KZPropertyMapper mapValuesFrom:dict toInstance:user usingMapping:@{
        @"idString" : KZPropertyT(user,userId),
        @"username" : KZPropertyT(user,userName),
        @"displayName" : KZPropertyT(user,userDisplayName),
        @"phone" : KZPropertyT(user,phone),
        @"lastLoginDeviceId" : KZPropertyT(user,deviceId),
        @"email" : KZPropertyT(user,userEmail),
        @"lastLoginAt": KZBoxT(user,Date, loginAt),
        @"lastLoginPlatformOS": KZPropertyT(user, platform),
        @"isGuest": KZPropertyT(user, isGuest),
        @"status": KZPropertyT(user, status),
        @"iapLock": KZPropertyT(user, iapLock),
        @"emailIsVerified": KZPropertyT(user, emailIsVerified),
        @"idCard": KZPropertyT(user, idCard),
        @"birthday": KZPropertyT(user, birthday),
        @"avatar": KZPropertyT(user, avatarImgLink),
        @"deviceID": KZPropertyT(user, deviceId),
        @"pushId": KZPropertyT(user, pushId),
        @"region": KZPropertyT(user, region),
        @"address": KZPropertyT(user, address),
        @"postalCode": KZPropertyT(user, postalCode),
        @"country": KZPropertyT(user, country)
    }];*/
    
    return user;
}
@end
