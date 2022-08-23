//
//  GameConfigRepo.m
//  iTapSdk
//
//  Created by TranCong on 26/10/2021.
//

#import "GameConfigRepo.h"

@implementation GameConfigRepo
-(void)execute{
    AppInfo *appInfo = [[Sdk sharedInstance] getAppInfo];
    NSDictionary* params = @{
        request_app_package:appInfo.packageId
    };
    [[GameApiRequest sharedInstance] callGetMethod:PATH_GAME_CONFIG withParams:params withBody:nil withToken:nil completion:^(id  _Nullable result) {
        [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
        GameConfigJson *resp = [[GameConfigJson alloc] initFromDictionary:result];
        if(resp != NULL){
            if(resp.statusCode == CODE_200 || resp.statusCode == CODE_0){
                appInfo.hotLinkHomepage = resp.data.hotLinkHomepage;
                appInfo.hotLinkFanpage = resp.data.hotLinkFanpage;
                appInfo.hotLinkGroup = resp.data.hotLinkGroup;
                appInfo.hotLinkChat = resp.data.hotLinkChat;
                appInfo.hotline = resp.data.hotline;
            }
        }} error:^(NSError * _Nonnull error, id  _Nullable result, int httpCode) {
            [Utils logMessage:[NSString stringWithFormat:@"error content %@",result]];
        }];
}
@end
