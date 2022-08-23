//
//  DataUtils.m
//  VnptSdk
//
//  Created by TranCong on 30/08/2021.
//

#import "DataUtils.h"
#import "Utils.h"
@implementation DataUtils
{
}
+(DataUtils *)sharedInstance{
    static DataUtils *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[DataUtils alloc] init];
    });
    return _sharedInstance;
}
/*-(void)saveUser:(User *)user{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:user];
    NSString *base64Encode = [Utils base64EncodeData:encodedObject];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:base64Encode forKey:KeyUserInfo];
    [defaults synchronize];
}
-(User *)getUser{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *encodedObject = [defaults objectForKey:KeyUserInfo];
    if([Utils isNullOrEmpty:encodedObject]){
        return nil;
    }
    NSData * decodeData = [Utils base64DecodeData:encodedObject];
    //NSData *encodedObject = [defaults objectForKey:KeyUserInfo];
    User *object = [NSKeyedUnarchiver unarchiveObjectWithData:decodeData];
    return object;
}
 */
-(NSString *)accessToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults stringForKey:KeyAccessToken];
    return value;
}
-(NSString *)refreshToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults stringForKey:KeyRefreshToken];
    return value;
}
-(void)saveAccessToken:(NSString*) accessToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:KeyAccessToken];
    [defaults synchronize];
}
-(void)saveRefreshToken:(NSString *)refreshToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:refreshToken forKey:KeyRefreshToken];
    [defaults synchronize];
}
-(NSString *)fcmToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults stringForKey:KeyFcmToken];
    return value;
}
-(void)saveFcmToken:(NSString *)fcmToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:fcmToken forKey:KeyFcmToken];
    [defaults synchronize];
}
-(void)saveRegisteredFcm:(BOOL)isRegistered{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isRegistered forKey:KeyRegisteredFcm];
    [defaults synchronize];
}
-(BOOL)registeredFcm{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL value = [defaults boolForKey:KeyRegisteredFcm];
    return value;
}
-(BOOL)isFirstLaunch{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL value = [defaults boolForKey:KeyIsFirstLaunch];
    return value;
}
-(void)saveIsFirstLaunch:(BOOL)isFirstLaunch{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isFirstLaunch forKey:KeyIsFirstLaunch];
    [defaults synchronize];
}
-(void)clearData{
    /*NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
        NSDictionary * dict = [defs dictionaryRepresentation];
        for (id key in dict) {
            [defs removeObjectForKey:key];
        }
        [defs synchronize];
    */
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    [defs removeObjectForKey:KeyUserInfo];
    [defs removeObjectForKey:KeyAccessToken];
    [defs removeObjectForKey:KeyRefreshToken];
    [defs removeObjectForKey:KeyFcmToken];
    [defs removeObjectForKey:KeyRegisteredFcm];
    [defs removeObjectForKey:KeyAuthedGame];
    [defs synchronize];
}
-(void)removeStringKey:(NSString *)key{
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    [defs removeObjectForKey:key];
    [defs synchronize];
}
-(void)setStringValue:(NSString *)value forKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(value == NULL){
        value = @"";
    }
    [defaults setValue:value forKey:key];
    [defaults synchronize];
}
-(NSString *)getStringValue:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults stringForKey:key];
    if(value == NULL){
        value = @"";
    }
    return value;
}
/*-(NSString *)userId{
    User* user = [self getUser];
    if(user != NULL){
        return user.userId;
    }
    return nil;
}*/
-(BOOL)authedGame{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL value = [defaults boolForKey:KeyAuthedGame];
    return value;
}
-(void)saveAuthedGame:(BOOL)isAuthed{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isAuthed forKey:KeyAuthedGame];
    [defaults synchronize];
}
@end
