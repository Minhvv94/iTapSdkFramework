//
//  ApiConfig.m
//  Connection
//
//  Created by Kcatta on 6/5/19.
//  Copyright © 2019 SHB. All rights reserved.
//

#import "ApiConfig.h"

@implementation ApiConfig
NSString * const PROD_BASE_ID = @"https://id.vplay.vn/";
NSString * const DEV_BASE_ID = @"https://dev-id.vplay.vn/";

NSString * const PROD_BASE_GAME_HUB = @"https://hub.vplay.vn/";//@"https://sdk-api.vplay.vn/";
NSString * const DEV_BASE_GAME_HUB = @"https://dev-hub.vplay.vn/";

NSString * const PROD_BASE_PAYMENT = @"https://id.vplay.vn/";
NSString * const DEV_BASE_PAYMENT = @"https://dev-id.vplay.vn/";

NSString * const PROD_BASE_WEB_ID = @"https://id.vplay.vn/";
NSString * const DEV_BASE_WEB_ID = @"https://dev-id.vplay.vn/";

NSString * const APPLE_BASE_ID = @"https://appleid.apple.com/";
NSString * const PATH_APPLE_REVOKE = @"auth/revoke";

NSString *const PATH_FORGET_PASS = @"/Account/ForgotPassword";
NSString *const PATH_TIME_SERVER = @"/api-core/v1/authen-service/infos/getservertime";
NSString *const  PATH_LOGIN = @"/api-core/v1/authen-service/loginSDK";
NSString *const  PATH_DEVICE_LOGIN = @"/api-core/v1/authen-service/devicelogin";
NSString *const PATH_USER_INFO = @"/api-core/v1/authen-service/users/get/info";
NSString *const PATH_REFRESH_TOKEN = @"/api-core/v1/authen-service/refreshtoken";
NSString *const  PATH_REGISTER = @"/api-core/v1/authen-service/register";
NSString *const PATH_SWITCH_ACCOUNT = @"/api-core/v1/authen-service/users/update/rename";
NSString *const  PATH_REGISTER_FAST = @"/api-core/v1/authen-service/loginfast";
NSString *const PATH_LOGIN_FACEBOOK = @"api-core/v1/authen-service/loginfacebook";
NSString *const PATH_LOGIN_GOOGLE = @"api-core/v1/authen-service/logingoogle";
NSString *const PATH_LOGIN_APPLE = @"api-core/v1/authen-service/loginapple";
NSString *const  PATH_LOGOUT = @"/api-core/v1/authen-service/logout";
NSString *const  PATH_UPDATE_INFO = @"/api-core/v1/authen-service/users/v3/update/info";
NSString *const  PATH_UPDATE_PASSPORT = @"/api-core/v1/authen-service/users/update/passport";
NSString *const  PATH_CHANGE_PWD = @"/api-core/v1/authen-service/users/update/pass";
NSString *const  PATH_GET_OTP = @"/change_mobile/get_otp";
NSString *const  PATH_VERIFY_OTP_PHONE = @"/api-core/v1/authen-service/users/update/verifyphone";
NSString *const  PATH_PING = @"/api-core/v1/authen-service/validatetoken";
NSString *const  PATH_DEACTIVE = @"/api-core/v1/authen-service/users/update/deactive";

NSString *const  PATH_OTP_EMAIL = @"/api-core/v1/authen-service/users/otp/mail";
NSString *const  PATH_OTP_PHONE = @"/api-core/v1/authen-service/users/otp/phone";

NSString *const  PATH_GAME_CONFIG = @"/sdk-api/service/hotlink";
NSString *const  PATH_GAME_AUTH = @"/sdk-api/auth/authenticate";
NSString *const  PATH_GAME_ADD_PUSH_ID = @"/sdk-api/auth/add-push-id";
NSString *const  PATH_GAME_LIST_NEWS = @"/sdk-api/news/posts";
NSString *const  PATH_GAME_DETAIL_NEWS = @"/sdk-api/news/posts";
NSString *const  PATH_GAME_MAP_USER = @"/sdk-api/service-account-character/on-selected";
NSString *const  PATH_GAME_CHECK_MAINTAIN = @"/sdk-api/service/app-config";
NSString *const  PATH_GAME_LIST_PRODUCTS = @"/sdk-api/payment/GetIapProduct";
NSString *const  PATH_GAME_RETENTION = @"/sdk-api/auth/retention-day";

NSString *const PATH_PAYMENT_VERIFY = @"/api/Payment/IapBuyPackage";

NSString *const PATH_PAYMENT_CREATE_ORDER_IAP = @"/api-core/v1/payment-service/gate/api/iap/createorder";
NSString *const PATH_PAYMENT_CONFIRM_ORDER_IAP = @"/api-core/v1/payment-service/gate/api/iap/confirm";

NSString * const POST = @"POST";
NSString * const PUT = @"PUT";
NSString * const PATCH = @"PATCH";
NSString * const GET = @"GET";
NSString * const DELETE = @"DELETE";
NSString* const RESPONSE_CONTENT_TYPE = @"application/json";
NSString* const PATH_LIST_PRODUCT = @"payment/iap/products";
NSString* const PATH_VERIFY_PRODUCT = @"payment/iap/verify-purchase";
@end
