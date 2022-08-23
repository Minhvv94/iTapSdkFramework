//
//  ApiConfig.h
//  Connection
//
//  Created by Kcatta on 6/5/19.
//  Copyright © 2019 SHB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sdk.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^SuccessBlock)(id _Nullable result);
typedef void (^ErrorBlock)(NSError* error, id _Nullable result,int httpCode);

@interface ApiConfig : NSObject
extern NSString *const PROD_BASE_ID;
extern NSString *const DEV_BASE_ID;
extern NSString *const PROD_BASE_GAME_HUB;
extern NSString *const DEV_BASE_GAME_HUB;
extern NSString *const PROD_BASE_PAYMENT;
extern NSString *const DEV_BASE_PAYMENT;

extern NSString *const PROD_BASE_WEB_ID;
extern NSString *const DEV_BASE_WEB_ID;

extern NSString *const APPLE_BASE_ID;
extern NSString *const PATH_APPLE_REVOKE;

extern NSString *const PATH_FORGET_PASS;
extern NSString *const PATH_TIME_SERVER;
extern NSString *const PATH_LOGIN;
extern NSString *const PATH_USER_INFO;
extern NSString *const PATH_DEVICE_LOGIN;
extern NSString *const PATH_REFRESH_TOKEN;
extern NSString *const PATH_REGISTER;
extern NSString *const PATH_SWITCH_ACCOUNT;
extern NSString *const PATH_REGISTER_FAST;
extern NSString *const PATH_LOGIN_FACEBOOK;
extern NSString *const PATH_LOGIN_GOOGLE;
extern NSString *const PATH_LOGIN_APPLE;
extern NSString *const PATH_LOGOUT;
extern NSString *const PATH_UPDATE_INFO;
extern NSString *const  PATH_UPDATE_PASSPORT;
extern NSString *const PATH_CHANGE_PWD;
extern NSString *const PATH_GET_OTP;
extern NSString *const PATH_VERIFY_OTP_PHONE;
extern NSString *const PATH_LIST_PRODUCT;
extern NSString *const PATH_VERIFY_PRODUCT;
extern NSString *const PATH_PING;
extern NSString *const PATH_DEACTIVE;

extern NSString *const  PATH_OTP_EMAIL;
extern NSString *const  PATH_OTP_PHONE;

extern NSString *const PATH_GAME_CONFIG;
extern NSString *const PATH_GAME_AUTH;
extern NSString *const PATH_GAME_ADD_PUSH_ID;
extern NSString *const PATH_GAME_MAP_USER;
extern NSString *const PATH_GAME_LIST_NEWS;
extern NSString *const PATH_GAME_DETAIL_NEWS;
extern NSString *const PATH_GAME_CHECK_MAINTAIN;
extern NSString *const PATH_GAME_LIST_PRODUCTS;
extern NSString *const PATH_GAME_RETENTION;

extern NSString *const PATH_PAYMENT_VERIFY;
extern NSString *const PATH_PAYMENT_CREATE_ORDER_IAP;
extern NSString *const PATH_PAYMENT_CONFIRM_ORDER_IAP;
extern NSString *const POST;
extern NSString *const PATCH;
extern NSString *const GET;
extern NSString *const PUT;
extern NSString *const DELETE;
extern NSString *const RESPONSE_CONTENT_TYPE;
@end

NS_ASSUME_NONNULL_END
