//
//  VnptUser.h
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCoding>

@property long accountID;
@property (nonatomic,strong) NSString *accountName;
/*
@property (nonatomic,strong) NSString *accountName;
@property (nonatomic,strong) NSString *serverID;
@property (nonatomic,strong) NSString *characterID;
@property (nonatomic,strong) NSString *serverName;
@property (nonatomic,strong) NSString *characterName;
@property (nonatomic,strong) NSString *characterLevel;
// Info Account
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *idCard;
@property (nonatomic,strong) NSString *userDisplayName;
@property (nonatomic,strong) NSString *userEmail;
@property (nonatomic,strong) NSString *avatarImgLink;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *deviceId;
@property (nonatomic,strong) NSString *pushId;
@property (nonatomic,strong) NSString *platform;
@property (nonatomic,strong) NSDate *loginAt;
//@property (nonatomic,strong) NSString *regType;
@property (nonatomic,assign) BOOL isGuest;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *birthday;
@property (nonatomic,assign) BOOL iapLock;
@property (nonatomic,assign) BOOL emailIsVerified;

@property (nonatomic,strong) NSString* region;
@property (nonatomic,strong) NSString* address;
@property (nonatomic,strong) NSString* postalCode;
@property (nonatomic,strong) NSString* country;
*/
//@property (nonatomic,strong) NSString *pushToken;
//@property (nonatomic,strong) NSString *apple_user_identifier;
//@property (nonatomic ,assign) BOOL new_user;
//@property (nonatomic ,assign) BOOL isPlayNow;
//@property(nonatomic, assign) BOOL isLoggingOut;

//+(User*)initFromJsonDict:(NSDictionary*)dict;
@end

