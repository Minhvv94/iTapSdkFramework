//
//  LoginView.m
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import "CheckLoginView.h"
#import "Utils.h"
#import "NSLayoutConstraint+Multiplier.h"
#import "RegistrationView.h"
#import "APIRequest.h"
#import "ApiConfig.h"
#import "Sdk.h"
#import "LoginJson.h"
#import "DataUtils.h"
#import "UpdatePushIDRepo.h"
/*#import <GoogleSignIn.h>
 #import <FBSDKLoginKit.h>*/
#import <AppsFlyerLib/AppsFlyerLib.h>
#import "DevicesUtil.h"
@implementation CheckLoginView
{
    NSString* refreshToken;
    
}
-(void)initInternals{
    [super initInternals];
    refreshToken = [[Sdk sharedInstance] refreshToken];
}
-(void)configUI:(UIView *)parentView{
    [self deviceLogin];
}
-(void)deviceLogin{
    [self showLoading];
    [Utils logMessage:@"device login!"];
    AppInfo *appInfo = [[Sdk sharedInstance] getAppInfo];
    NSDictionary *body = @{
        request_cid:appInfo.client_id,
        request_client_id: appInfo.client_id,
        request_jwt:refreshToken
    };
    __weak typeof(self) weakSelf = self;
    [Utils delayAction:^{
        [[IdApiRequest sharedInstance] callPostMethod:PATH_DEVICE_LOGIN withBody:body withToken:nil completion:^(id  _Nullable result) {
            [self hideLoading];
            [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
            LoginJson *loginJson = [[LoginJson alloc] initFromDictionary:result];
            if(loginJson != NULL){
                if(loginJson.statusCode == CODE_0){
                    //success
                    //[Utils logMessage:[NSString stringWithFormat:@"userName %@",loginJson.data.user.userName]];
                    [[DataUtils sharedInstance] saveAccessToken:loginJson.data.accessToken];
                    [[DataUtils sharedInstance] saveRefreshToken:loginJson.data.refreshToken];
                    //[[DataUtils sharedInstance] saveUser:loginJson.data.user];
                    NSDictionary* payload = [Utils getPayloadInToken:loginJson.data.accessToken];
                    NSNumber* uid = [Utils getAccountIdInPayload:loginJson.data.accessToken usingCache:payload];
                    NSString* accountName = [Utils getAccountNameInPayload:loginJson.data.accessToken usingCache:payload];
                    User* userInfo = [[User alloc] init];
                    userInfo.accountID = [uid longValue];
                    userInfo.accountName = accountName;
                    if(self.delegate){
                        [self.delegate loginSuccess:userInfo withAccessToken:loginJson.data.accessToken andRefreshToken:loginJson.data.refreshToken];
                    }
                    [self updatePushId];
                    [self authenGame];
                    //Tracking retention
                    TrackingEventRepo* trackingRepo = [[TrackingEventRepo alloc] init];
                    [trackingRepo execute];
                    
                    [self btnClose:nil];
                }
                else{
                    [self handleErrorCode:loginJson.statusCode andMessage:loginJson.message andAction:^(UIAlertAction * _Nonnull) {
                        if(loginJson.statusCode == CODE_86 || loginJson.statusCode == CODE_98 ||loginJson.statusCode == CODE_85 || loginJson.statusCode == CODE_83 || loginJson.statusCode == CODE_99){
                            [[Sdk sharedInstance] forceLogout];
                            [weakSelf btnClose:nil];
                        }
                    }];
                    /*NSString *errorText = [TSLanguageManager localizedString:[NSString stringWithFormat:@"E_CODE_%d",loginJson.statusCode]];
                    if([errorText containsString:@"E_CODE_"]){
                        if(![Utils isNullOrEmpty:loginJson.message]){
                            errorText = loginJson.message;
                        }
                        else{
                            errorText = [TSLanguageManager localizedString:@"Lỗi không xác định"];
                        }
                    }
                    
                    [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:errorText withAction:^(UIAlertAction * _Nonnull) {
                        if(loginJson.statusCode == CODE_86){
                            [[Sdk sharedInstance] forceLogout];
                            [weakSelf btnClose:nil];
                        }
                    }];*/
                }
            }
            else{
                [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"Lỗi không xác định"] withAction:^(UIAlertAction * _Nonnull) {
                    [[Sdk sharedInstance] forceLogout];
                    [weakSelf btnClose:nil];
                }];
            }
            
            
        } error:^(NSError * _Nonnull error,  id  _Nullable result,int httpCode) {
            [self hideLoading];
            [self handleError:error withResult:result andHttpCode:httpCode];
            [Utils logMessage:[NSString stringWithFormat:@"error %ld",error.code]];
            [Utils logMessage:[NSString stringWithFormat:@"desc %@",error.description]];
            //Tracking check token
            NSDictionary* eventParams = @{
                PARAM_API: @"id_check_token_api"
            };
            [[Sdk sharedInstance] trackingEvent:EVENT_ERROR_API withParams:eventParams];
        }];
    } withTime:0.5f];
}
-(void) authenGame{
    NSString *accessToken = [[Sdk sharedInstance] accessToken];
    if(accessToken == NULL){
        //[self hideLoading];
        //[self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"Đăng nhập thất bại"] withAction:NULL];
        return;
    }
    //BOOL authedGame = [[DataUtils sharedInstance] authedGame];
    
    //if(authedGame) return;
    
    AppInfo* appInfo = [[Sdk sharedInstance] getAppInfo];
    NSString* appsflyerId = [[AppsFlyerLib shared] getAppsFlyerUID];
    if(appsflyerId == NULL){
        appsflyerId = @"";
    }
    NSDictionary *body = @{
        request_app_package: appInfo.packageId,
        request_platformOS: [appInfo.platformOS lowercaseString],
        //@"device" : [[UIDevice currentDevice] name],
        @"device" : [DevicesUtil getDeviceModel],
        request_appsflyer_id : appsflyerId,
        request_conversion_type: [[DataUtils sharedInstance] getStringValue:request_conversion_type],
        request_campaign: [[DataUtils sharedInstance] getStringValue:request_campaign],
        request_media_source: [[DataUtils sharedInstance] getStringValue:request_media_source],
        request_adset: [[DataUtils sharedInstance] getStringValue:request_adset],
        request_ads_channel: [[DataUtils sharedInstance] getStringValue:request_ads_channel],
        request_idfa:[DevicesUtil getIdfa],
        request_idfv:[DevicesUtil getIdfv]
    };
    
    [[GameApiRequest sharedInstance] callPostMethod:PATH_GAME_AUTH withBody:body withToken:accessToken completion:^(id  _Nullable result) {
        [Utils logMessage:@"ok game auth from checking"];
        [Utils logMessage:[NSString stringWithFormat:@"result:  %@",result]];
        //[[DataUtils sharedInstance] saveAuthedGame:true];
        
    } error:^(NSError * _Nonnull error, id  _Nullable result, int httpCode) {
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
-(void)btnClose:(id)sender{
    [super btnClose:sender];
    NSLog(@"btnClose");
    [self removeFromSuperview];
}
@end
