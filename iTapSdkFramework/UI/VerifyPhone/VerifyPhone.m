//
//  RegistrationView.m
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import "VerifyPhone.h"
#import "Utils.h"
#import "NSLayoutConstraint+Multiplier.h"
#import "OtpJson.h"
#import <QuartzCore/QuartzCore.h>
@implementation VerifyPhone
{
    float offset;
    int timeCount;
    NSTimer* timerOtp;
}
@synthesize phoneNum;
@synthesize txtPhone;
-(void) initInternals{
    [super initInternals];
    offset = 0;
    timerOtp = NULL;
    //phoneNum = NULL;
}

- (void) setupLabel{
    self.txtPhone.placeholder = [TSLanguageManager localizedString:@"Nhập số điện thoại"];

    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[TSLanguageManager localizedString:@"Nhập OTP"] attributes:@{
        NSForegroundColorAttributeName: [Utils colorFromHexString:@"#8a8a8a"]}];
    
    [self.txtOtp setAttributedPlaceholder:attrString];
    self.lbTitle.text = [TSLanguageManager localizedString:@"CẬP NHẬT SỐ ĐIỆN THOẠI"];
    [self.btnUpdate setTitle:[TSLanguageManager localizedString:@"CẬP NHẬT"] forState:UIControlStateNormal];
    [self.btnReceiveOtp setTitle:[TSLanguageManager localizedString:@"Nhận mã"] forState:UIControlStateNormal];
    //self.btnReceiveOtp.layer.borderWidth = 1.0;
}
-(void)configUI:(UIView *)parentView{
    
    [super configUI:parentView];
    self.txtPhone.delegate = self;
    self.txtOtp.delegate = self;
    [self setupLabel];
    [self configScale];
    
    //[self.btnUpdate setTintColor:[Utils colorFromHexString:color_main_orange]];
    [self.btnUpdate setBackgroundImage:[Utils imageWithColor:[Utils colorFromHexString:color_main_orange]] forState:UIControlStateNormal];
    [self.btnUpdate setBackgroundImage:[Utils imageWithColor:[UIColor darkGrayColor]] forState:UIControlStateDisabled];
    self.btnUpdate.layer.cornerRadius = 5; // this value vary as per your desire
    self.btnUpdate.clipsToBounds = YES;
    
    [self.btnReceiveOtp setBackgroundImage:[Utils imageWithColor:[Utils colorFromHexString:@"#00B389"]] forState:UIControlStateNormal];
    [self.btnReceiveOtp setBackgroundImage:[Utils imageWithColor:[UIColor darkGrayColor]] forState:UIControlStateDisabled];
    
    //[self.txtOtp setDisabledBackground:[Utils imageWithColor:[UIColor darkGrayColor]]];
    //[self.txtOtp setBackground:[Utils imageWithColor:[UIColor greenColor]]];
    self.btnReceiveOtp.layer.cornerRadius = 5; // this value vary as per your desire
    self.btnReceiveOtp.clipsToBounds = YES;
    
    self.btnUpdate.enabled = false;
    self.btnReceiveOtp.enabled = false;
    if(![Utils isNullOrEmpty:self.phoneNum]){
        self.txtPhone.text = self.phoneNum;
        self.btnReceiveOtp.enabled = true;
    }
    self.txtOtp.enabled = false;
    [self.holderOtp setBackgroundColor:[UIColor darkGrayColor]];
    [self.txtPhone addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    
    [self configFontByScreen];
    [self configKeyboard:50.0];
}

-(void)textFieldDidChange :(UITextField *) textField{
    //your code
    if(![Utils isNullOrEmpty:textField.text]){
        self.btnReceiveOtp.enabled = true;
    }
    else{
        self.btnReceiveOtp.enabled = false;
    }
    if(timerOtp != NULL){
        self.btnReceiveOtp.enabled = false;
    }
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
-(void)btnReceiveOtpClick:(id)sender{
    NSString* phone = self.txtPhone.text;
    
    self.lbError.text = @"";
    self.holderOtp.borderColor = UIColor.lightGrayColor;
    self.holderPhone.borderColor = UIColor.lightGrayColor;
    if(phone.length <=0){
        self.holderOtp.borderColor = UIColor.redColor;
        [self.holderOtp refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Nhập số điện thoại"];
        return;
    }
    
    NSString *patternRegex = REGEX_PHONE;//;@"^(0[1-9])+([0-9]{8})$";
    if(![Utils validateString:phone withPattern:patternRegex caseSensitive:NO]){
        self.holderPhone.borderColor = UIColor.redColor;
        [self.holderPhone refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Số điện thoại không hợp lệ, vui lòng nhập lại"];
        return;
    }
    [self.holderPhone refresh];
    [self doSendOTP:phone];
    /*[self showLoading];
    __weak typeof(self) weakSelf = self;
    [Utils delayAction:^{
        AppInfo* appInfo = [[Sdk sharedInstance] getAppInfo];
        //User* currentUer = [[Sdk sharedInstance] currentUser];
        NSString* accessToken = [[Sdk sharedInstance] accessToken];
        NSDictionary *body = @{
            request_jwt:accessToken,
            @"mobile":phone,
            request_cid:appInfo.client_id,
            request_client_id: appInfo.client_id
        };
        [[IdApiRequest sharedInstance] callPostMethod:PATH_UPDATE_INFO withBody:body withToken:nil completion:^(id  _Nullable result) {
            [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
            OtpJson *resp = [[OtpJson alloc] initFromDictionary:result];
            if(resp != NULL){
                if(resp.statusCode == CODE_0){
                    [self hideLoading];
                    //[Utils logMessage:[NSString stringWithFormat:@"otp %@",resp.data.otp]];
                    if(resp.data != NULL && resp.data.otp != NULL){
                        weakSelf.lbError.text =resp.data.otp;
                    }
                    self->phoneNum = phone;
                    [weakSelf canSendOtpAgain];
                    [weakSelf doSendOTP:phone];
                }
                //httpCode=200 but code is 400 or 401
                else{
                    //NSString *errorText = [TSLanguageManager localizedString:[NSString stringWithFormat:@"E_CODE_%d",resp.statusCode]];
                    if(resp.statusCode != CODE_86){
                        [self hideLoading];
                        [self handleErrorCode:resp.statusCode andMessage:resp.message andAction:nil];
                        //[self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:errorText withAction:nil];
                    }
                    else{
                        [self doRefreshWithAction:^{
                            [weakSelf btnReceiveOtpClick:nil];
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

-(void) canSendOtpAgain{
    if(timerOtp == NULL){
        timeCount = timeOutOtpAgain;
        timerOtp = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(theAction)
                                                  userInfo:nil
                                                   repeats:YES];
        [timerOtp fire];
        self.btnReceiveOtp.enabled = false;
        self.txtPhone.enabled = false;
        NSString* formatText = [NSString stringWithFormat:@"%@(%d)",[TSLanguageManager localizedString:@"Nhận mã sau"],timeCount];
        [self.btnReceiveOtp setTitle:formatText forState:UIControlStateDisabled];
        [self.holderOtp setBackgroundColor:[UIColor clearColor]];
        [self.holderOtp refresh];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[TSLanguageManager localizedString:@"Nhập OTP"] attributes:@{
            NSForegroundColorAttributeName: UIColor.lightGrayColor}];
        
        [self.txtOtp setAttributedPlaceholder:attrString];
        
        self.txtOtp.enabled = true;
        self.btnUpdate.enabled = true;
    }
}
-(void) doUpdatePhone:(NSString*) phone{
    __weak typeof(self) weakSelf = self;
    AppInfo* appInfo = [[Sdk sharedInstance] getAppInfo];
    //User* currentUer = [[Sdk sharedInstance] currentUser];
    NSString* accessToken = [[Sdk sharedInstance] accessToken];
    NSDictionary *body = @{
        request_jwt:accessToken,
        @"mobile":phone,
        request_cid:appInfo.client_id,
        request_client_id: appInfo.client_id
    };
    [[IdApiRequest sharedInstance] callPostMethod:PATH_UPDATE_INFO withBody:body withToken:nil completion:^(id  _Nullable result) {
        [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
        ResponseJson *resp = [[ResponseJson alloc] initFromDictionary:result];
        if(resp != NULL){
            if(resp.statusCode == CODE_0){
            }
            else{
                if(resp.statusCode != CODE_86){
                }
                else{
                    [self doRefreshWithAction:^{
                        [weakSelf doUpdatePhone:phone];
                    }];
                }
            }
        }
    } error:^(NSError * _Nonnull error,  id  _Nullable result,int httpCode) {
        [Utils logMessage:[NSString stringWithFormat:@"error %ld",error.code]];
        [Utils logMessage:[NSString stringWithFormat:@"desc %@",error.description]];
    }];
}
-(void) doSendOTP:(NSString*)phone{
    self.phoneNum = phone;
    [self showLoading];
    __weak typeof(self) weakSelf = self;
    [Utils delayAction:^{
    NSString* accessToken = [[Sdk sharedInstance] accessToken];
    AppInfo * appInfo = [[Sdk sharedInstance] getAppInfo];
    /*long time = ([[NSDate date] timeIntervalSince1970]);
    NSString* secureSand = [NSString stringWithFormat:@"%ld",time];
    NSString* command = @"0";
    NSString* secureHash = [Utils md5str:[NSString stringWithFormat:@"%@%@%@%@%@",phone,command,SDK_CLIENT_ID_KEY_VERIFY,secureSand,SDK_SECRET_KEY_VERIFY]];
    long accountId = 0;
    NSString* accountName = @"";
    NSDictionary* payload = [Utils getPayloadInToken:accessToken];
    NSNumber* accountIdNumber = [Utils getAccountIdInPayload:accessToken usingCache:payload];
    if(accountIdNumber != NULL){
        accountId = [accountIdNumber longValue];
    }
    NSString* accountNameString = [Utils getAccountNameInPayload:accessToken usingCache:payload];
    if(![Utils isNullOrEmpty:accountNameString]){
        accountName = accountNameString;
    }
    NSDictionary* body = @{
        request_phone:phone,
        @"command":command,
        @"clientId":SDK_CLIENT_ID_KEY_VERIFY,
        @"accountId":[NSNumber numberWithLong:accountId],
        @"accountName":accountName,
        @"secureSand":secureSand,
        @"secureHash":secureHash
    };*/
    
    //0: Verify Phone, 1: Verify Mail, 2: One Time Authen Phone, 3: One Time Authen Mail , 4: One  time transaction phone, 5 One  time transaction mail
    NSDictionary* body = @{
        request_phone:phone,
        request_jwt:accessToken,
        request_cid:appInfo.client_id,
        request_client_id: appInfo.client_id,
        @"type":[NSNumber numberWithInt:0]
    };
    
    [[IdApiRequest sharedInstance] callPostMethod:PATH_OTP_PHONE
                                             withBody:body
                                            withToken:nil
        completion:^(id  _Nullable result) {
        [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
        ResponseJson *resp = [[ResponseJson alloc] initFromDictionary:result];
        if(resp != NULL){
            if(resp.statusCode == CODE_0){
                [self hideLoading];
                    self->phoneNum = phone;
                    [weakSelf canSendOtpAgain];
                    //[weakSelf doUpdatePhone:phone];
            }
            //httpCode=200 but code is 400 or 401
            else{
                if(resp.statusCode != CODE_86){
                    [self hideLoading];
                    [self handleErrorCode:resp.statusCode andMessage:resp.message andAction:nil];
                }
                else{
                    [self doRefreshWithAction:^{
                        [weakSelf btnReceiveOtpClick:nil];
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
    } withTime:0.5f];
}
-(void) theAction {
    NSLog(@"Will appear after a 1 second delay: %d",timeCount);
    timeCount = timeCount - 1;
    if(timeCount > 0){
        NSString* formatText = [NSString stringWithFormat:@"%@(%d)",[TSLanguageManager localizedString:@"Nhận mã sau"],timeCount];
        [self.btnReceiveOtp setTitle:formatText forState:UIControlStateDisabled];
        
    }
    if(timeCount <= 0){
        if(timerOtp != NULL){
            self.btnReceiveOtp.enabled = true;
            self.txtPhone.enabled = true;
            [timerOtp invalidate];
            timerOtp = NULL;
        }
    }
}
//verify phone with otp
-(void)btnUpdateClick:(id)sender{
    
    NSString* otp = self.txtOtp.text;
    
    self.lbError.text = @"";
    self.holderOtp.borderColor = UIColor.lightGrayColor;
    self.holderPhone.borderColor = UIColor.lightGrayColor;
    if(otp.length <=0){
        self.holderOtp.borderColor = UIColor.redColor;
        [self.holderOtp refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Nhập OTP"];
        return;
    }
    
    [self.holderPhone refresh];
    
    [self showLoading];
    __weak typeof(self) weakSelf = self;
    
    [Utils delayAction:^{
        AppInfo* appInfo = [[Sdk sharedInstance] getAppInfo];
        NSString* accessToken = [[Sdk sharedInstance] accessToken];
        NSDictionary *body = @{
            request_jwt:accessToken,
            request_cid:appInfo.client_id,
            request_otp:otp,
            request_client_id: appInfo.client_id,
            request_phone: self->phoneNum
        };
        [[IdApiRequest sharedInstance] callPostMethod:PATH_VERIFY_OTP_PHONE withBody:body withToken:nil completion:^(id  _Nullable result) {
            [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
            
            ResponseJson *resp = [[ResponseJson alloc] initFromDictionary:result];
            
            if(resp != NULL){
                if(resp.statusCode == CODE_0){
                    [self hideLoading];
                    [self showAlert:nil withContent:[TSLanguageManager localizedString:@"Cập nhật thành công"] withAction:^(UIAlertAction * _Nonnull) {
                        if(self.callback != NULL){
                            //callback to refresh data
                            self.callback(CallbackSuccess);
                        }
                        if(timerOtp != nil){
                            [timerOtp invalidate];
                            timerOtp = NULL;
                        }
                        [self removeFromSuperview];
                    }];
                }
                //httpCode=200 but code is 400 or 401
                else{
                    //NSString *errorText = [TSLanguageManager localizedString:[NSString stringWithFormat:@"E_CODE_%d",resp.statusCode]];
                    if(resp.statusCode != CODE_86){
                        [self hideLoading];
                        [self handleErrorCode:resp.statusCode andMessage:resp.message andAction:nil];
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
    } withTime:0.5f];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
-(void)btnClose:(id)sender{
    [super btnClose:sender];
    NSLog(@"btnClose");
    if(self->timerOtp != NULL){
        [self->timerOtp invalidate];
        self->timerOtp = NULL;
    }
    [self removeFromSuperview];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([self.txtPhone isEqual:textField] && textField.returnKeyType == UIReturnKeyDone){
        [self.txtPhone resignFirstResponder];
    }
    return NO;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([textField isEqual:self.txtPhone]){
        int maxLen = 10;
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        NSString* s = [[string componentsSeparatedByCharactersInSet:myCharSet.invertedSet] componentsJoinedByString:@""];
        // manually replace the range in the textView
        textField.text = [textField.text stringByReplacingCharactersInRange:range withString:s];
        if([textField.text length] > maxLen){
            textField.text =[textField.text substringWithRange:NSMakeRange(0, maxLen)];
        }
        if(![Utils isNullOrEmpty:textField.text]){
            self.btnReceiveOtp.enabled = true;
        }
        else{
            self.btnReceiveOtp.enabled = false;
        }
        return NO;
    }
    else{
        return YES;
    }
}
@end
