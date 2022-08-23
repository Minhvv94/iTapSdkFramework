//
//  Constant.m
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/6/21.
//

#import "Constant.h"

@implementation Constant

NSString * const  KEY_DEVICE_ID = @"KEY_DEVICE_ID";
NSString * const  AppIdentifierPrefix = @"AppIdentifierPrefix";
NSString * const  KeychainGroup =@ "KeychainGroup";
NSString *const KeyFcmToken = @"FcmToken";
NSString *const KeyRegisteredFcm = @"KeyRegisteredFcm";
NSString *const KeyIsFirstLaunch = @"KeyIsFirstLaunch";

NSString *const KeyAccessToken = @"KeyAccessToken";
NSString *const KeyRefreshToken = @"KeyRefreshToken";
NSString *const KeyAuthedGame = @"KeyAuthedGame";
NSString *const KeyLastestVersion = @"KeyLastestVersion";

NSString *const KeyUserInfo = @"KeyUserInfo";
NSString *const KeyUserId = @"KeyUserId";
NSString *const KeyUserEmail = @"KeyUserEmail";
NSString *const KeyUserName = @"KeyUserName";
NSString *const KeyPassword = @"KeyPassword";
NSString *const KeyUserDisplay = @"KeyUserDisplay";
//NSString *const KeySdkToken = @"KeySdkToken";
//NSString *const KeyServiceToken = @"KeyServiceToken";
NSString *const KeyUserAvatarImgLink = @"KeyUserAvatarImgLink";
NSString *const KeyUserPhone = @"KeyUserPhone";
NSString *const KeyUserDeviceId = @"KeyUserDeviceId";
NSString *const KeyUserPushId = @"KeyUserPushId";
NSString *const KeyUserBirthday = @"KeyUserBirthday";
NSString *const KeyUserIdCard = @"KeyUserIdCard";
NSString *const KeyUserPlatform = @"KeyUserPlatform";
NSString *const KeyUserLoginAt = @"KeyLoginAt";
NSString *const KeyUserRegType = @"KeyUserRegType";
NSString *const KeyUserIsGuest = @"KeyUserIsGuest";
NSString *const KeyUserStatus = @"KeyUserStatus";
NSString *const KeyUserIapLock = @"KeyUserIapLock";
NSString *const KeyUserIsEmailVerified = @"KeyUserIsEmailVerified";
NSString *const KeyUserRegion = @"KeyUserRegion";
NSString *const KeyUserAddress = @"KeyUserAddress";
NSString *const KeyUserPostalCode = @"KeyUserPostalCode";
NSString *const KeyUserCountry = @"KeyUserCountry";

NSString *const CallbackRegisterSuccess = @"CallbackRegisterSuccess";
NSString *const CallbackLoginSuccess = @"CallbackLoginSuccess";
NSString *const CallbackSuccess = @"CallbackSuccess";
NSString *const CallbackHide = @"CallbackHide";

NSString *const KeyJsonTitle = @"title";
NSString *const KeyJsonAccessToken = @"access_token";
NSString *const KeyJsonRefreshToken = @"refresh_token";
NSString *const KeyJsonUser = @"user";
NSString *const KeyJsonUsername = @"username";
NSString *const KeyJsonPassword= @"password";

NSString *const EVENT_OPEN_LOGIN = @"af_open_login";
NSString *const EVENT_OPEN_LOGOUT = @"af_logout";

NSString *const EVENT_RESOURCE_STARTED = @"af_resource_started";
NSString *const EVENT_RESOURCE_FINISHED = @"af_resource_finished";

NSString *const EVENT_EXTRACT_STARTED = @"af_extract_started";
NSString *const EVENT_EXTRACT_FINISHED = @"af_extract_finished";


NSString *const EVENT_CHARACTER_CREATION_STARTED = @"af_character_creation_started";
NSString *const EVENT_CHARACTER_CREATION_FINISHED = @"af_character_creation_finished";


NSString *const EVENT_LEVEL_ACHIEVEMENT = @"af_level_achievement";
NSString *const EVENT_VIP_ACHIEVEMENT = @"af_vip_achievement";
NSString *const EVENT_LEVEL_ACHIEVED_AT = @"af_level_achieved_at";
NSString *const EVENT_VIP_ACHIEVED_AT = @"af_vip_achieved_at";

NSString *const EVENT_SHOW_START_GAME = @"af_show_start_game";
NSString *const EVENT_ENTER_GAMEPLAY = @"af_enter_gameplay";

NSString *const EVENT_OPEN_REGISTRATION = @"af_open_registration";
NSString *const EVENT_LOGIN_SUCCESS = @"af_login";
NSString *const EVENT_LOGOUT_SUCCESS = @"af_logout";
NSString *const EVENT_REGISTER_SUCCESS = @"af_complete_registration";
NSString *const EVENT_COMPLETE_TUTORIAL = @"af_complete_tutorial";
NSString *const EVENT_START_TUTORIAL = @"af_start_tutorial";

NSString *const EVENT_OPEN_PURCHASE_SCREEN = @"af_open_payment_screen";
NSString *const EVENT_FINISH_PURCHASE = @"af_purchase";
NSString *const EVENT_FINISH_SUCCESS = @"af_payment_success";

NSString *const EVENT_CANCEL_PURCHASE = @"af_cancel_purchase";
NSString *const EVENT_ERROR_PURCHASE = @"af_error_purchase";

NSString *const EVENT_APP_LAUNCH = @"af_app_launch";
NSString *const EVENT_FIRST_LAUNCH = @"af_first_launch";
NSString *const EVENT_UPGRADE_VERSION_SUCCESS = @"af_upgrade_version_success";

NSString *const EVENT_CLICK_LOGIN = @"af_click_login";
NSString *const PARAM_CLICK_BUTTON = @"af_click_button";

NSString *const EVENT_ERROR_API = @"af_error_api";
NSString *const PARAM_API = @"af_api";

NSString *const PARAM_LOGIN_TYPE = @"af_login_method";
NSString *const PARAM_REG_TYPE = @"af_registration_method";




NSString *const REGEX_CHECK_PASS_WORD = @"^.{6,30}$";//@"^(?=.*([a-z]|[A-Z]|[!@#$&*]))(?=.*[0-9]).{6,30}$";
NSString *const REGEX_CHECK_USERNAME= @"^[a-z][(a-z)|(0-9)_]{5,30}$";//@"^[(a-z)|(0-9)]{6,30}$";
NSString *const REGEX_CHECK_LOGIN_USERNAME= @"^[(a-z)|(0-9)_]{6,30}$";
NSString *const REGEX_PHONE = @"^(0[1-9])+([0-9]{8})$";
NSString *const SDK_CLIENT_ID_KEY_VERIFY = @"vtvlivesdk";
NSString *const SDK_SECRET_KEY_VERIFY = @"dnR2bGl2ZXNkaw";

int const CODE_0= 0;
int const CODE_86 = 86; //Invalid_token
int const CODE_85 = 85; //token is invalid
int const CODE_99 = 99; //General error
int const CODE_83 = 83; //invalid signature
int const CODE_98 = 98; //login other device
int const CODE_200 = 200;
int const CODE_400 = 400;
int const CODE_401 = 401;

int const ACCOUNT_VTVLIVEID = 1;
int const ACCOUNT_FASTLOGIN = 21;
int const ACCOUNT_FACEBOOK = 31;
int const ACCOUNT_GOOGLE = 51;
int const ACCOUNT_APPLE = 61;
int const CODE_NO_INTERNET = -9999;
int const CODE_PAYMENT_ERROR_NO_CONFIG = -7000;
int const CODE_CONNECT_GAME = -9990;

NSString* const DATA_TRANSFER_DEACTIVE = @"DEACTIVE";
@end
