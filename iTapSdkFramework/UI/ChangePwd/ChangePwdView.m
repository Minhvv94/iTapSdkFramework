//
//  RegistrationView.m
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import "ChangePwdView.h"
#import "Utils.h"
#import "TermConditionView.h"
#import "APIRequest.h"
#import "ApiConfig.h"
#import "DataUtils.h"
#import "LoginJson.h"
#import "NSLayoutConstraint+Multiplier.h"
@implementation ChangePwdView
{
    float offset;
}
@synthesize lbError;
@synthesize lbTitle;
@synthesize txtPwd;
@synthesize txtNewPwd;
@synthesize txtConfirmNewPwd;

@synthesize holderPwd;
@synthesize holderNewPwd;
@synthesize holderConfirmNewPwd;

@synthesize btnChangePwd;

@synthesize layoutBottomContainer;

-(void) initInternals{
    [super initInternals];
    offset = 0;
}

- (void) setupLabel{
    self.txtPwd.placeholder = [TSLanguageManager localizedString:@"Nhập mật khẩu cũ"];
    self.txtNewPwd.placeholder = [TSLanguageManager localizedString:@"Nhập mật khẩu mới"];
    self.txtConfirmNewPwd.placeholder = [TSLanguageManager localizedString:@"Nhập mật khẩu mới"];
    
    self.lbTitle.text = [TSLanguageManager localizedString:@"ĐỔI MẬT KHẨU"];
    [self.btnChangePwd setTitle:[TSLanguageManager localizedString:@"ĐỔI MẬT KHẨU"] forState:UIControlStateNormal];
    
    [self.btnChangePwd setTintColor:[Utils colorFromHexString:color_main_orange]];
}
-(void)configUI:(UIView *)parentView{
    
    [super configUI:parentView];
    self.txtPwd.delegate = self;
    self.txtNewPwd.delegate = self;
    self.txtConfirmNewPwd.delegate = self;
    
    [self setupLabel];
    [self configScale];
    
    [self configFontByScreen];
    [self configKeyboard:80.0];
}

-(void) configScale{
    float heigh = [Utils heightScreen];
    [Utils logMessage:[NSString stringWithFormat:@"heigh: %f",heigh]];
    if(heigh < 1335){
        if([Utils screenInPortrait]){
            self.layoutHeightStack = [self.layoutHeightStack updateMultiplier:0.3];
        }
    }
}
-(void)configFontByScreen{
    float heightScreen = [Utils heightScreen];
    if(heightScreen <=375){
        
    }
}

-(void)configKeyboard:(CGFloat) newOffset{
    self->offset = newOffset;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

    }
- (void)keyboardWillShow:(NSNotification*)aNotification {
        [UIView animateWithDuration:0.25 animations:^
         {
             /*CGRect newFrame = [self frame];
            newFrame.origin.y -=  self->offset; // tweak here to adjust the moving position
             [self setFrame:newFrame];*/
            self.layoutBottomContainer.constant = - self->offset;
            [self layoutIfNeeded];
            
         }completion:^(BOOL finished)
         {
         }];
    }
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
        [UIView animateWithDuration:0.25 animations:^
         {
             /*CGRect newFrame = [self frame];
            newFrame.origin.y +=  self->offset; // tweak here to adjust the moving position
             [self setFrame:newFrame];*/
            self.layoutBottomContainer.constant = 0;
            [self layoutIfNeeded];

         }completion:^(BOOL finished)
         {

         }];

}
-(void)doRefreshToken{
    AppInfo *appInfo = [[Sdk sharedInstance] getAppInfo];
    NSString * refreshToken = [[Sdk sharedInstance] refreshToken];
    NSDictionary *body = @{
        request_jwt:refreshToken,
        request_cid:appInfo.client_id,
        request_client_id: appInfo.client_id
    };
    __weak typeof(self) weakSelf = self;
    [[IdApiRequest sharedInstance] callPostMethod:PATH_REFRESH_TOKEN withBody:body withToken:nil completion:^(id  _Nullable result) {
        [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
        [self hideLoading];
        LoginJson *loginJson = [[LoginJson alloc] initFromDictionary:result];
        if(loginJson != NULL){
            if(loginJson.statusCode == CODE_0){
                //success
                [[DataUtils sharedInstance] saveAccessToken:loginJson.data.accessToken];
                [weakSelf btnChangePwdClick:nil];
            }
            else{
                [self handleErrorCode:loginJson.statusCode andMessage:loginJson.message andAction:^(UIAlertAction * _Nonnull) {
                    /*if(loginJson.statusCode == CODE_86){
                        if(self.callback !=NULL){
                            self.callback(CallbackHide);
                        }
                        [[Sdk sharedInstance] forceLogout];
                    }*/
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

                }];*/
            }
        }
    } error:^(NSError * _Nonnull error,  id  _Nullable result,int httpCode) {
        [Utils logMessage:[NSString stringWithFormat:@"error %ld",error.code]];
        [Utils logMessage:[NSString stringWithFormat:@"desc %@",error.description]];
        [self hideLoading];
        [self showAlert:nil withContent:[TSLanguageManager localizedString:@"Lỗi không xác định"] withAction:nil];
    }];
}
-(void)btnChangePwdClick:(id)sender{
    
    NSString* oldPwd = self.txtPwd.text;
    NSString* newPwd = self.txtNewPwd.text;
    NSString* confirmNewPwd = self.txtConfirmNewPwd.text;
    self.lbError.text = @"";
    self.holderPwd.borderColor = UIColor.lightGrayColor;
    self.holderNewPwd.borderColor = UIColor.lightGrayColor;
    self.holderConfirmNewPwd.borderColor = UIColor.lightGrayColor;
    if(oldPwd.length <=0){
        self.holderPwd.borderColor = UIColor.redColor;
        [self.holderPwd refresh];
        [self.holderNewPwd refresh];
        [self.holderConfirmNewPwd refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Hãy nhập mật khẩu!"];
        return;
    }
    
    if(newPwd.length <=0){
        self.holderNewPwd.borderColor = UIColor.redColor;
        [self.holderPwd refresh];
        [self.holderNewPwd refresh];
        [self.holderConfirmNewPwd refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Hãy nhập mật khẩu!"];
        return;
    }
    
    if(confirmNewPwd.length <=0){
        self.holderConfirmNewPwd.borderColor = UIColor.redColor;
        [self.holderPwd refresh];
        [self.holderNewPwd refresh];
        [self.holderConfirmNewPwd refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Hãy nhập mật khẩu!"];
        return;
    }
    
    if(oldPwd.length > 0 && oldPwd.length < 6){
        self.holderPwd.borderColor = UIColor.redColor;
        [self.holderPwd refresh];
        [self.holderNewPwd refresh];
        [self.holderConfirmNewPwd refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Mật khẩu quá ngắn!"];
        return;
    }
    if(newPwd.length > 0 && newPwd.length < 6){
        self.holderNewPwd.borderColor = UIColor.redColor;
        [self.holderPwd refresh];
        [self.holderNewPwd refresh];
        [self.holderConfirmNewPwd refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Mật khẩu quá ngắn!"];
        return;
    }
    NSString *patternPassRegex = REGEX_CHECK_PASS_WORD;
    if(![Utils validateString:oldPwd withPattern:patternPassRegex caseSensitive:NO]){
        self.holderPwd.borderColor = UIColor.redColor;
        [self.holderPwd refresh];
        [self.holderNewPwd refresh];
        [self.holderConfirmNewPwd refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Mật khẩu không hợp lệ"];
        return;
    }
    if(![Utils validateString:newPwd withPattern:patternPassRegex caseSensitive:NO]){
        self.holderNewPwd.borderColor = UIColor.redColor;
        [self.holderPwd refresh];
        [self.holderNewPwd refresh];
        [self.holderConfirmNewPwd refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Mật khẩu không hợp lệ"];
        return;
    }
    if(![newPwd isEqual:confirmNewPwd]){
        self.holderConfirmNewPwd.borderColor = UIColor.redColor;
        [self.holderPwd refresh];
        [self.holderNewPwd refresh];
        [self.holderConfirmNewPwd refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Mật khẩu mới không khớp nhau"];
        return;
    }
    if([newPwd isEqual:oldPwd]){
        self.holderNewPwd.borderColor = UIColor.redColor;
        [self.holderPwd refresh];
        [self.holderNewPwd refresh];
        [self.holderConfirmNewPwd refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Mật khẩu mới phải khác mật khẩu cũ"];
        return;
    }
    [self.holderPwd refresh];
    [self.holderNewPwd refresh];
    [self.holderConfirmNewPwd refresh];
    //User* user = [[Sdk sharedInstance] currentUser];
    AppInfo* appInfo = [[Sdk sharedInstance] getAppInfo];
    NSString* accessToken =[[Sdk sharedInstance] accessToken];
    NSString* pwdMd5 = [Utils md5str:oldPwd];
    NSString* newPwdMd5 = [Utils md5str:newPwd];
    NSDictionary *body = @{
                            request_jwt : accessToken,
                            request_cid:appInfo.client_id,
                            request_client_id: appInfo.client_id,
                            request_mkc2:pwdMd5,
                            request_passwordMd5:newPwdMd5
    };
    __weak typeof(self) weakSelf = self;
    [self showLoading];
    [Utils delayAction:^{

        [[IdApiRequest sharedInstance] callPostMethod:PATH_CHANGE_PWD withBody:body withToken:nil completion:^(id  _Nullable result) {
            [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
            
            LoginJson *loginJson = [[LoginJson alloc] initFromDictionary:result];
            if(loginJson != NULL){
                if(loginJson.statusCode == CODE_0){
                    [self hideLoading];
                    [self showAlert:nil withContent:[TSLanguageManager localizedString:@"Thao tác thành công"] withAction:^(UIAlertAction * _Nonnull) {
                        [self btnClose:nil];
                    }];
                }
                //httpCode=200 but code is 400 or 401
                else{
                    /*NSString *errorText = [TSLanguageManager localizedString:[NSString stringWithFormat:@"E_CODE_%d",loginJson.statusCode]];
                    if([errorText containsString:@"E_CODE_"]){
                        if(![Utils isNullOrEmpty:loginJson.message]){
                            errorText = loginJson.message;
                        }
                        else{
                            errorText = [TSLanguageManager localizedString:@"Lỗi không xác định"];
                        }
                    }*/
                    if(loginJson.statusCode != CODE_86){
                        [self hideLoading];
                        [self handleErrorCode:loginJson.statusCode andMessage:loginJson.message andAction:nil];
                        //[self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:errorText withAction:nil];
                    }
                    else{
                        [self doRefreshToken];
                    }
                }
            }
            else{
                [self hideLoading];
                [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"Lỗi không xác định"] withAction:nil];
            }
            } error:^(NSError * _Nonnull error,  id  _Nullable result,int httpCode) {
                [self hideLoading];
                [self handleError:error withResult:result andHttpCode:httpCode];
                [Utils logMessage:[NSString stringWithFormat:@"error %ld",error.code]];
                [Utils logMessage:[NSString stringWithFormat:@"desc %@",error.description]];
                
            }];
    } withTime:0.5f];
}

-(void)btnClose:(id)sender{
    [super btnClose:sender];
    NSLog(@"btnClose");
    [self removeFromSuperview];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([self.txtPwd isEqual:textField] && textField.returnKeyType == UIReturnKeyNext){
        [self.txtNewPwd becomeFirstResponder];
    }
    if([self.txtNewPwd  isEqual:textField] && textField.returnKeyType == UIReturnKeyNext){
        [self.txtConfirmNewPwd  becomeFirstResponder];
    }
    if([self.txtConfirmNewPwd  isEqual:textField] && textField.returnKeyType == UIReturnKeyDone){
        [self.txtConfirmNewPwd  resignFirstResponder];
    }
    return NO;
}
@end
