//
//  TrackingEventRepo.m
//  iTapSdk
//
//  Created by TranCong on 06/04/2022.
//

#import "TrackingEventRepo.h"
#import <AppsFlyerLib/AppsFlyerLib.h>
@implementation TrackingEventRepo
{
    //retry 3 time in case call api error
    int numRetryServer;
    //retry 3 time in case call api error
    int numRetryAppsflyer;
    
    //check in case server return data successful
    bool hasTrackingData;
    //check in case server return data successful
    bool hasSentAppsflyer;
}

-(void)execute{
    numRetryServer = 0;
    hasTrackingData = false;
    hasSentAppsflyer = false;
    numRetryAppsflyer = 0;
    [self doGetTrackingFromServer];
}
-(void) doGetTrackingFromServer{
    [Utils logMessage:[NSString stringWithFormat:@"doGetTrackingFromServer:  %d",numRetryServer]];
    if(!hasTrackingData){
        if(numRetryServer < 2){
            numRetryServer++;
            AppInfo *appInfo = [[Sdk sharedInstance] getAppInfo];
            NSString* accessToken = [[Sdk sharedInstance] accessToken];
            
            NSString* appsflyerId = [[AppsFlyerLib shared] getAppsFlyerUID];
            if(appsflyerId == NULL){
                appsflyerId = @"";
            }
            
            NSDictionary* params = @{
                request_app_package:appInfo.packageId,
                request_appsflyer_id:appsflyerId,
                request_platformOS: [appInfo.platformOS lowercaseString]
            };
            [[GameApiRequest sharedInstance] callGetMethod:PATH_GAME_RETENTION withParams:params withBody:nil withToken:accessToken completion:^(id  _Nullable result) {
                [Utils logMessage:[NSString stringWithFormat:@"retention content %@",result]];
                TrackingEventJson *resp = [[TrackingEventJson alloc] initFromDictionary:result];
                if(resp != NULL){
                    if(resp.statusCode == CODE_200 || resp.statusCode == CODE_0){
                        self->hasTrackingData = true;
                        if(resp.data != NULL && ![Utils isNullOrEmpty:resp.data.eventName]){
                            [Utils logMessage:[NSString stringWithFormat:@"tracking eventName %@",resp.data.eventName]];
                            //[[Sdk sharedInstance] trackingEvent:resp.data.eventName withParams:nil];
                            [self doTrackingGoogleAndFacebook:resp.data.eventName];
                            [self doTrackingAppsflyer:resp.data.eventName];
                        }
                    }
                }} error:^(NSError * _Nonnull error, id  _Nullable result, int httpCode) {
                    [Utils logMessage:[NSString stringWithFormat:@"error result:  %@",result]];
                    [self doGetTrackingFromServer];
                }];
        }
    }
}
-(void) doTrackingGoogleAndFacebook:(NSString*) eventName{
    [[Sdk sharedInstance] trackingEventGoogleAndFace:eventName withParams:nil];
}
-(void) doTrackingAppsflyer:(NSString*) eventName{
    [Utils logMessage:[NSString stringWithFormat:@"doTrackingAppsflyer sent event %@ to appsflyer in %d time",eventName,numRetryAppsflyer]];
    if(!hasSentAppsflyer){
        if(numRetryAppsflyer < 2){
            numRetryAppsflyer++;
            [[Sdk sharedInstance] trackingEventAppsflyer:eventName withParams:nil completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
                if (!error) {
                    //success
                    self->hasSentAppsflyer = true;
                    [Utils logMessage:[NSString stringWithFormat:@"sent event %@ to appsflyer successful",eventName]];
                } else {
                    [Utils logMessage:[NSString stringWithFormat:@"sent event %@ to appsflyer error",eventName]];
                    [Utils logMessage:[NSString stringWithFormat:@"sent event %@ to appsflyer error",error.localizedDescription]];
                    [self doTrackingAppsflyer:eventName];
                }
            }];
        }
    }
}
@end
