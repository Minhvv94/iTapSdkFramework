//
//  UpdatePushIDRepo.m
//  VnptSdk
//
//  Created by TranCong on 11/10/2021.
//

#import "UpdatePushIDRepo.h"

@implementation UpdatePushIDRepo
@synthesize pushId;
@synthesize accessToken;
@synthesize platformOs;
@synthesize packageId;
-(void)execute{
    
    NSDictionary* body = @{
        request_pushId:pushId,
        request_app_package:packageId,
        request_platformOS:platformOs
    };
    BOOL isRegistered = [[DataUtils sharedInstance] registeredFcm];
    [Utils logMessage:[NSString stringWithFormat:@"isRegistered %@", isRegistered ? @"true" : @"false"]];
    [Utils logMessage:[NSString stringWithFormat:@"pushId isRegistered: %@", pushId]];
    if(!isRegistered){
    [[GameApiRequest sharedInstance] callPostMethod:PATH_GAME_ADD_PUSH_ID withBody:body withToken:self.accessToken completion:^(id  _Nullable result) {
        [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
        ResponseJson *resp = [[ResponseJson alloc] initFromDictionary:result];
        if(resp != NULL){
            if(resp.statusCode == CODE_200 || resp.statusCode == 0){
                [Utils logMessage:@"Đăng ký pushID thành công"];
                [Utils logMessage:self.pushId];
                [[DataUtils sharedInstance] saveRegisteredFcm:TRUE];
            }
        }} error:^(NSError * _Nonnull error, id  _Nullable result, int httpCode) {
            [Utils logMessage:[NSString stringWithFormat:@"error content %@",result]];
        }];
    }
}
@end
