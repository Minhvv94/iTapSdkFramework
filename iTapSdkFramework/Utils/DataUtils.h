//
//  DataUtils.h
//  VnptSdk
//
//  Created by TranCong on 30/08/2021.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Constant.h"
NS_ASSUME_NONNULL_BEGIN

@interface DataUtils : NSObject
+ (DataUtils *)sharedInstance;
/*- (NSString*) userId;
- (void) saveUser:(User*) user;
- (User*)getUser;*/
- (NSString*) accessToken;
- (void) saveAccessToken:(NSString*) accessToken;
- (NSString*) refreshToken;
- (void) saveRefreshToken:(NSString*) refreshToken;
- (NSString*) fcmToken;
- (void) saveFcmToken:(NSString*) fcmToken;
- (BOOL) registeredFcm;
- (void) saveRegisteredFcm:(BOOL) isRegistered;
- (BOOL) isFirstLaunch;
- (void) saveIsFirstLaunch:(BOOL) isFirstLaunch;

- (BOOL) authedGame;
- (void) saveAuthedGame:(BOOL) isAuthed;
- (void) removeStringKey:(NSString*) key;
- (NSString*) getStringValue:(NSString*) key;
- (void) setStringValue:(NSString*)value forKey:(NSString*) key;
-(void) clearData;
@end

NS_ASSUME_NONNULL_END
