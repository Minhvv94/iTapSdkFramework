//
//  DeactiveAccountView.m
//  iTapSdk
//
//  Created by TranCong on 22/06/2022.
//

#import "DeactiveAccountView.h"
#import "ResponseJson.h"
@implementation DeactiveAccountView
@synthesize lbNote1;
@synthesize lbNote2;
@synthesize lbNote3;
-(void)configUI:(UIView *)parentView{
    [super configUI:parentView];
    [self setupLabel];
}
- (void) setupLabel{
    self.lbNote1.text = [TSLanguageManager localizedString:@"Deactive_1"];
    self.lbNote2.text = [TSLanguageManager localizedString:@"Deactive_2"];
    self.lbNote3.text = [TSLanguageManager localizedString:@"Deactive_3"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) doDeactive{
    [self showLoading];
    __weak typeof(self) weakSelf = self;
    NSString* accessToken = [[Sdk sharedInstance] accessToken];
    NSDictionary* body = @{
        request_jwt:accessToken
    };
    [[IdApiRequest sharedInstance] callPostMethod:PATH_DEACTIVE withBody:body withToken:nil completion:^(id  _Nullable result) {
        [Utils logMessage:[NSString stringWithFormat:@"result %@",result]];
        
        ResponseJson *respJson = [[ResponseJson alloc] initFromDictionary:result];
        if(respJson != NULL){
            if(respJson.statusCode == CODE_0){
                [self hideLoading];
                //[Utils logMessage:[NSString stringWithFormat:@"userName %@",loginJson.data.user.userName]];
                //[[DataUtils sharedInstance] saveUser:loginJson.data.user];
                NSString* messsage = respJson.message;
                if([Utils isNullOrEmpty:messsage]){
                    messsage = [TSLanguageManager localizedString:@"Cập nhật thành công"];
                }
                [self showAlert:nil withContent:messsage withAction:^(UIAlertAction * _Nonnull) {
                    if(self.callback != NULL){
                        //callback to refresh data
                        self.callback(CallbackSuccess);
                    }
                    [self removeFromSuperview];
                }];
                //[self doUpdateEmail:email];
            }
            //httpCode=200 but code is 400 or 401
            else{
                if(respJson.statusCode != CODE_86){
                    [self hideLoading];
                    [self handleErrorCode:respJson.statusCode andMessage:respJson.message andAction:nil];
                    //[self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:errorText withAction:nil];
                }
                else{
                    [self doRefreshWithAction:^{
                        [weakSelf doDeactive];
                    }];
                }
            }
        }
        else{
            [self hideLoading];
            [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"Lỗi không xác định"] withAction:nil];
        }
        } error:^(NSError * _Nonnull error, id  _Nullable result, int httpCode) {
            [self hideLoading];
            [self handleError:error withResult:result andHttpCode:httpCode];
            [Utils logMessage:[NSString stringWithFormat:@"error %ld",error.code]];
            [Utils logMessage:[NSString stringWithFormat:@"desc %@",error.description]];
        }];
}
-(void)btnDeactiveClick:(id)sender{
    [self showAlertWith2Action:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"Xác thực xóa tài khoản"] withOkAction:^(UIAlertAction * _Nonnull) {
        [self doDeactive];
    } andCancelAction:^(UIAlertAction * _Nonnull) {
        
    }];
}
-(void)btnClose:(id)sender{
    [super btnClose:sender];
    NSLog(@"btnClose");
    [self removeFromSuperview];
}
@end
