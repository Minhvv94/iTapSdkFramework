//
//  Constant.h
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/6/21.
//

#import <Foundation/Foundation.h>

@interface Constant : NSObject
#define color_main_orange @"#e13f45" //f69140
#define color_main_tab_orange @"#eb5e62" //f69140
#define request_refresh_token @"refresh_token"
#define request_client_id @"client_id"
#define request_appsflyer_id @"appsflyerId"
#define request_app_package @"appPackage"
#define request_check_again @"checkAgain"
#define request_device_id @"dvId"
#define request_raw @"raw"
#define request_pushId @"pushId"
#define request_checksum @"checksum"
#define request_id_card @"id_card"
#define request_timestamp @"timestamp"
#define request_client_secret @"client_secret"
#define request_new_password @"NewPassword"
#define request_old_password @"OldPassword"
#define request_confirm_password @"ConfirmPassword"
#define request_email @"email"
#define request_phone @"phone"
#define request_otp @"otp"

#define request_jwt @"jwt"
#define request_cid @"cid"
#define request_username @"username"
#define request_password @"password"
#define request_mkc2 @"mkc2"
#define request_passwordMd5 @"passwordmd5"
#define request_platformOS @"platformOS"
#define request_Os @"os"
#define request_maker_code @"makercode"
#define request_channel @"platform"
#define request_version @"version"
#define request_app_id @"appId"
#define request_package_name @"packageName"
#define request_amount @"amount"
#define request_refer_id @"referId"
#define request_description @"description"
#define request_product_id @"productId"
#define request_character_id @"characterId"
#define request_server_id @"serverId"
#define request_billing_info @"billingInfo"

#define request_conversion_type @"conversionType"
#define request_media_source @"mediaSource"
#define request_campaign @"campaign"
#define request_adset @"adset"
#define request_ads_channel @"adsChannel"
#define request_idfa @"idfa"
#define request_idfv @"idfv"

#define request_hash @"hash"
#define request_salt @"salt"
#define trans_character @"Character"
#define trans_server @"Server"
#define trans_order @"Order"
#define timeOutOtpAgain 100

extern NSString *const KEY_DEVICE_ID;
extern NSString *const AppIdentifierPrefix;
extern NSString *const KeychainGroup;
// Key
extern NSString *const KeyFcmToken;
extern NSString *const KeyRegisteredFcm;
extern NSString *const KeyIsFirstLaunch;
extern NSString *const KeyAccessToken;
extern NSString *const KeyRefreshToken;
extern NSString *const KeyAuthedGame;
extern NSString *const KeyLastestVersion;
extern NSString *const KeyUserInfo;

extern NSString *const KeyUserId;
extern NSString *const KeyUserEmail;
extern NSString *const KeyUserName;
extern NSString *const KeyPassword;
extern NSString *const KeyUserDisplay;
//extern NSString *const KeySdkToken;
//extern NSString *const KeyServiceToken;
extern NSString *const KeyUserAvatarImgLink;
extern NSString *const KeyUserPhone;
extern NSString *const KeyUserDeviceId;
extern NSString *const KeyUserPushId;
extern NSString *const KeyUserIdCard;
extern NSString *const KeyUserBirthday;
extern NSString *const KeyUserPlatform;
extern NSString *const KeyUserLoginAt;
extern NSString *const KeyUserRegType;
extern NSString *const KeyUserIsGuest;
extern NSString *const KeyUserStatus;
extern NSString *const KeyUserIapLock;
extern NSString *const KeyUserIsEmailVerified;
extern NSString *const KeyUserRegion;
extern NSString *const KeyUserAddress;
extern NSString *const KeyUserPostalCode;
extern NSString *const KeyUserCountry;

extern NSString *const CallbackRegisterSuccess;
extern NSString *const CallbackLoginSuccess;
extern NSString *const CallbackSuccess;
extern NSString *const CallbackHide;


extern NSString *const EVENT_OPEN_LOGIN;
extern NSString *const EVENT_OPEN_LOGOUT;
extern NSString *const EVENT_RESOURCE_STARTED;
extern NSString *const EVENT_RESOURCE_FINISHED;

extern NSString *const EVENT_EXTRACT_STARTED;
extern NSString *const EVENT_EXTRACT_FINISHED;

extern NSString *const EVENT_CHARACTER_CREATION_STARTED;
extern NSString *const EVENT_CHARACTER_CREATION_FINISHED;

extern NSString *const EVENT_LEVEL_ACHIEVEMENT;
extern NSString *const EVENT_VIP_ACHIEVEMENT;
extern NSString *const EVENT_LEVEL_ACHIEVED_AT;
extern NSString *const EVENT_VIP_ACHIEVED_AT;

extern NSString *const EVENT_SHOW_START_GAME;
extern NSString *const EVENT_ENTER_GAMEPLAY;

extern NSString *const EVENT_OPEN_REGISTRATION;
extern NSString *const EVENT_LOGIN_SUCCESS;
extern NSString *const EVENT_LOGOUT_SUCCESS;
extern NSString *const EVENT_REGISTER_SUCCESS;
extern NSString *const EVENT_COMPLETE_TUTORIAL;
extern NSString *const EVENT_START_TUTORIAL;

extern NSString *const EVENT_OPEN_PURCHASE_SCREEN;
extern NSString *const EVENT_PURCHASE;
extern NSString *const EVENT_FINISH_PURCHASE;
extern NSString *const EVENT_FINISH_SUCCESS;
extern NSString *const EVENT_CANCEL_PURCHASE;
extern NSString *const EVENT_ERROR_PURCHASE;

extern NSString *const EVENT_APP_LAUNCH;
extern NSString *const EVENT_FIRST_LAUNCH;
extern NSString *const EVENT_UPGRADE_VERSION_SUCCESS;

extern NSString *const EVENT_CLICK_LOGIN;
extern NSString *const PARAM_CLICK_BUTTON;

extern NSString *const EVENT_ERROR_API;
extern NSString *const PARAM_API;

extern NSString *const PARAM_LOGIN_TYPE;
extern NSString *const PARAM_REG_TYPE;


extern NSString *const REGEX_CHECK_PASS_WORD;
extern NSString *const REGEX_CHECK_USERNAME;
extern NSString *const REGEX_CHECK_LOGIN_USERNAME;
extern NSString *const REGEX_PHONE;
extern NSString *const SDK_SECRET_KEY_VERIFY;
extern NSString *const SDK_CLIENT_ID_KEY_VERIFY;

extern int const CODE_0;
extern int const CODE_86;
extern int const CODE_85;
extern int const CODE_83;
extern int const CODE_98;
extern int const CODE_99;
extern int const CODE_200;
extern int const CODE_400;
extern int const CODE_401;

extern int const ACCOUNT_VTVLIVEID;
extern int const ACCOUNT_FASTLOGIN;
extern int const ACCOUNT_FACEBOOK;
extern int const ACCOUNT_GOOGLE;
extern int const ACCOUNT_APPLE;

extern int const CODE_NO_INTERNET;
extern int const CODE_PAYMENT_ERROR_NO_CONFIG;
extern int const CODE_CONNECT_GAME;

extern NSString* const DATA_TRANSFER_DEACTIVE;
@end

