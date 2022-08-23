//
//  RegistrationView.m
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import "VerifyEmail.h"
#import "Utils.h"
#import "NSLayoutConstraint+Multiplier.h"
#import "LoginJson.h"
@implementation VerifyEmail
{
    float offset;
}
@synthesize lbError;
@synthesize lbTitle;
@synthesize txt;

@synthesize holderBirthday;
@synthesize btnUpdate;
@synthesize layoutHeightStack;
@synthesize layoutBottomContainer;
@synthesize userEmail;
-(void) initInternals{
    [super initInternals];
    offset = 0;
}

- (void) setupLabel{
    self.txt.placeholder = [TSLanguageManager localizedString:@"Nhập email"];
    
    if(![Utils isNullOrEmpty:userEmail]){
        self.txt.text = userEmail;
    }
    self.lbTitle.text = [TSLanguageManager localizedString:@"CẬP NHẬT EMAIL"];
    [self.btnUpdate setTitle:[TSLanguageManager localizedString:@"GỬI MÃ XÁC NHẬN"] forState:UIControlStateNormal];
    
    [self.btnUpdate setTintColor:[Utils colorFromHexString:color_main_orange]];
}
-(void)configUI:(UIView *)parentView{
    
    [super configUI:parentView];
    self.txt.delegate = self;

    [self setupLabel];
    [self configScale];
    
    [self configFontByScreen];
    [self configKeyboard:50.0];
}

-(void) configScale{
    float heigh = [Utils heightScreen];
    [Utils logMessage:[NSString stringWithFormat:@"heigh: %f",heigh]];
    if(heigh < 1335){
        if([Utils screenInPortrait]){
            //self.layoutHeightStack = [self.layoutHeightStack updateMultiplier:0.3];
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

-(void)btnUpdateClick:(id)sender{
    
    NSString* email = self.txt.text;
    
    self.lbError.text = @"";
    self.holderBirthday.borderColor = UIColor.lightGrayColor;
    if(email.length <=0){
        self.holderBirthday.borderColor = UIColor.redColor;
        [self.holderBirthday refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Nhập email"];
        return;
    }
    
    NSString *patternRegex = @"^[\\w-]+(\\.[\\w-]+)*@([a-z0-9-]+(\\.[a-z0-9-]+)*?\\.[a-z]{2,6}|(\\d{1,3}\\.){3}\\d{1,3})(:\\d{4})?$";
    if(![Utils validateString:email withPattern:patternRegex caseSensitive:NO]){
        self.holderBirthday.borderColor = UIColor.redColor;
        [self.holderBirthday refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Định dạng email không đúng, vui lòng nhập lại"];
        return;
    }
    [self.holderBirthday refresh];
    [self doSendEmail:email];
    /*return;
    [self showLoading];
    __weak typeof(self) weakSelf = self;
    [Utils delayAction:^{
        
        NSString* accessToken = [[Sdk sharedInstance] accessToken];
        AppInfo* appInfo = [[Sdk sharedInstance] getAppInfo];
        NSDictionary *body = @{
                                request_jwt:accessToken,
                                request_mkc2:@"sdk",
                                request_cid:appInfo.client_id,
                                request_client_id: appInfo.client_id,
                                request_email:email
        };
        [[IdApiRequest sharedInstance] callPostMethod:PATH_UPDATE_INFO withBody:body withToken:nil completion:^(id  _Nullable result) {
            [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
            
            LoginJson *loginJson = [[LoginJson alloc] initFromDictionary:result];
            if(loginJson != NULL){
                if(loginJson.statusCode == CODE_0){
                    [self hideLoading];
                    //[Utils logMessage:[NSString stringWithFormat:@"userName %@",loginJson.data.user.userName]];
                    //[[DataUtils sharedInstance] saveUser:loginJson.data.user];
                    [self showAlert:nil withContent:[TSLanguageManager localizedString:@"Cập nhật thành công"] withAction:^(UIAlertAction * _Nonnull) {
                        if(self.callback != NULL){
                            //callback to refresh data
                            self.callback(CallbackSuccess);
                        }
                        [self removeFromSuperview];
                    }];
                    [self doSendEmail:email];
                }
                //httpCode=200 but code is 400 or 401
                else{
                    if(loginJson.statusCode != CODE_86){
                        [self hideLoading];
                        [self handleErrorCode:loginJson.statusCode andMessage:loginJson.message andAction:nil];
                        //[self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:errorText withAction:nil];
                    }
                    else{
                        [self doRefreshWithAction:^{
                            [weakSelf btnUpdateClick:nil];
                        }];
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
    } withTime:0.5f];*/
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
-(void)btnClose:(id)sender{
    [super btnClose:sender];
    NSLog(@"btnClose");
    [self removeFromSuperview];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([self.txt isEqual:textField] && textField.returnKeyType == UIReturnKeyDone){
        [self.txt resignFirstResponder];
    }
    return NO;
}
-(void) doUpdateEmail:(NSString*)email{
    __weak typeof(self) weakSelf = self;
    NSString* accessToken = [[Sdk sharedInstance] accessToken];
    AppInfo* appInfo = [[Sdk sharedInstance] getAppInfo];
    NSDictionary *body = @{
                            request_jwt:accessToken,
                            request_mkc2:@"sdk",
                            request_cid:appInfo.client_id,
                            request_client_id: appInfo.client_id,
                            request_email:email
    };
    [[IdApiRequest sharedInstance] callPostMethod:PATH_UPDATE_INFO withBody:body withToken:nil completion:^(id  _Nullable result) {
        [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
        
        ResponseJson *loginJson = [[ResponseJson alloc] initFromDictionary:result];
        if(loginJson != NULL){
            if(loginJson.statusCode == CODE_0){
            }
            //httpCode=200 but code is 400 or 401
            else{
                if(loginJson.statusCode != CODE_86){
                }
                else{
                    [self doRefreshWithAction:^{
                        [weakSelf doUpdateEmail:nil];
                    }];
                }
            }
        }
        } error:^(NSError * _Nonnull error,  id  _Nullable result,int httpCode) {
            [Utils logMessage:[NSString stringWithFormat:@"error %ld",error.code]];
            [Utils logMessage:[NSString stringWithFormat:@"desc %@",error.description]];
        }];
}
-(void) doSendEmail:(NSString*)email{
    [self showLoading];
    __weak typeof(self) weakSelf = self;
    [Utils delayAction:^{
        NSString* accessToken = [[Sdk sharedInstance] accessToken];
        AppInfo* appInfo = [[Sdk sharedInstance] getAppInfo];
        
        NSDictionary* body = @{
            @"mail":email,
            request_jwt:accessToken,
            request_cid:appInfo.client_id,
            request_client_id: appInfo.client_id,
            @"type":[NSNumber numberWithInt:1]
        };
        [[IdApiRequest sharedInstance] callPostMethod:PATH_OTP_EMAIL
                                                 withBody:body
                                                withToken:nil
            completion:^(id  _Nullable result) {
            [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
            
            ResponseJson *loginJson = [[ResponseJson alloc] initFromDictionary:result];
            if(loginJson != NULL){
                if(loginJson.statusCode == CODE_0){
                    [self hideLoading];
                    //[Utils logMessage:[NSString stringWithFormat:@"userName %@",loginJson.data.user.userName]];
                    //[[DataUtils sharedInstance] saveUser:loginJson.data.user];
                    [self showAlert:nil withContent:[TSLanguageManager localizedString:@"Cập nhật thành công"] withAction:^(UIAlertAction * _Nonnull) {
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
                    if(loginJson.statusCode != CODE_86){
                        [self hideLoading];
                        [self handleErrorCode:loginJson.statusCode andMessage:loginJson.message andAction:nil];
                        //[self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:errorText withAction:nil];
                    }
                    else{
                        [self doRefreshWithAction:^{
                            [weakSelf btnUpdateClick:nil];
                        }];
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
    } withTime:0.5f];;
}
@end
