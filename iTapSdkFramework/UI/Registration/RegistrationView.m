//
//  RegistrationView.m
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import "RegistrationView.h"
#import "Utils.h"
#import "TermConditionView.h"
#import "ApiConfig.h"
#import "DataUtils.h"
#import "LoginJson.h"
#import "UpdatePushIDRepo.h"
#import <AppsFlyerLib/AppsFlyerLib.h>
#import "DevicesUtil.h"
#import "NSLayoutConstraint+Multiplier.h"
@implementation RegistrationView
{
    UIImage *checked;
    UIImage *unchecked;
    BOOL isCheck;
    float offset;
}
@synthesize lbNote;
@synthesize lbError;
@synthesize lbTitle;

@synthesize holderPwd;
@synthesize holderUsrname;

@synthesize btnRegister;
@synthesize checkbox;
@synthesize layoutBottomContainer;
@synthesize stackViewRegistration;

-(void) initInternals{
    [super initInternals];
    offset = 0;
    isCheck = TRUE;
    checked = [UIImage imageNamed:@"checked" inBundle:[NSBundle bundleForClass:self.class]
    compatibleWithTraitCollection:nil];
    unchecked = [UIImage imageNamed:@"unchecked" inBundle:[NSBundle bundleForClass:self.class]
      compatibleWithTraitCollection:nil];

}

- (void) setupLabelAndColor{
    NSString * iAgree = [TSLanguageManager localizedString:@"Tôi đã đọc và đồng ý"];
    NSString * term = [TSLanguageManager localizedString:@"Điều khoản"];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:iAgree attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)}];
    
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:term attributes:@{
        NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
        NSForegroundColorAttributeName: UIColor.blueColor
    }]];
    
    [lbNote setAttributedText:attrString];
    self.lbTitle.text = [TSLanguageManager localizedString:@"Đăng ký tài khoản"];
    self.txtUsrname.placeholder = [TSLanguageManager localizedString:@"Tên đăng nhập"];
    self.txtPwd.placeholder = [TSLanguageManager localizedString:@"Mật khẩu"];
    
    [self.btnRegister setTintColor:[Utils colorFromHexString:color_main_orange]];
    
}
-(void)configUI:(UIView *)parentView{
    
    [super configUI:parentView];
    self.txtUsrname.delegate = self;
    self.txtPwd.delegate = self;
    
    [self setupLabelAndColor];
    
    [self configFontByScreen];
    [self configKeyboard:50.0];
    float ratioScreen = [Utils ratioScreen];
    NSLog(@"ratioScreen : %f",ratioScreen);
    
    if(ratioScreen > 2){
        stackViewRegistration = [stackViewRegistration updateMultiplier:2.1];
    }else{
        stackViewRegistration = [stackViewRegistration updateMultiplier:2.4];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    singleTap.numberOfTapsRequired = 1;
    [checkbox setUserInteractionEnabled:YES];
    [checkbox addGestureRecognizer:singleTap];
    
    
    UITapGestureRecognizer *singleTapCondition = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCondition:)];
    singleTapCondition.numberOfTapsRequired = 1;
    [lbNote setUserInteractionEnabled:YES];
    [lbNote addGestureRecognizer:singleTapCondition];

    if(isCheck){
        [checkbox setImage:checked];
    }
    else{
        [checkbox setImage:unchecked];
    }
}

-(void)tapCondition:(id)sender{
    NSLog(@"tapCondition");
    TermConditionView *customView =(TermConditionView*) [Utils loadViewFromNibFile:[self class] universalWithNib:@"TermConditionView"];
    customView.delegate = self.delegate;
    customView.callback = ^(NSString* identifier) {
        NSLog(@"Hide %@",identifier );
    };
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    customView.tag = 202;
    [self addSubview:customView];
    [Utils addConstraintForChild:self andChild:customView withLeft:0 withTop:0 andRight:0 withBottom:0];
    
}

-(void)tapDetected:(id)sender{
    NSLog(@"tapDetected");
    isCheck = !isCheck;
    if(isCheck){
        [checkbox setImage:checked];
    }
    else{
        [checkbox setImage:unchecked];
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
-(void)btnRegisteClick:(id)sender{
    
    NSString *deviceId =[Utils getDeviceId];
    NSLog(@"btnLogin: %@",deviceId);
    
    NSString* ursName = self.txtUsrname.text;
    NSString* pwd = self.txtPwd.text;
    self.lbError.text = @"";
    self.holderUsrname.borderColor = UIColor.lightGrayColor;
    if(ursName.length <=0){
        self.holderUsrname.borderColor = UIColor.redColor;
        [self.holderUsrname refresh];
        [self.holderPwd refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Hãy nhập username!"];
        return;
    }
    
    self.holderPwd.borderColor = UIColor.lightGrayColor;
    if(pwd.length <=0){
        self.holderPwd.borderColor = UIColor.redColor;
        [self.holderUsrname refresh];
        [self.holderPwd refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Hãy nhập mật khẩu!"];
        return;
    }
    if(ursName.length > 0 && ursName.length < 6){
        self.holderUsrname.borderColor = UIColor.redColor;
        [self.holderUsrname refresh];
        [self.holderPwd refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Tên đăng nhập quá ngắn!"];
        return;
    }
    if(pwd.length > 0 && pwd.length < 6){
        self.holderPwd.borderColor = UIColor.redColor;
        [self.holderUsrname refresh];
        [self.holderPwd refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Mật khẩu quá ngắn!"];
        return;
    }
    
    NSString *patternRegex = REGEX_CHECK_USERNAME;
    if(![Utils validateString:ursName withPattern:patternRegex caseSensitive:NO]){
        self.holderUsrname.borderColor = UIColor.redColor;
        [self.holderUsrname refresh];
        [self.holderPwd refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Tên đăng nhập phải từ 6 đến 30 ký không bao gồm ký tự đặc biệt!"];
        return;
    }
    NSString *patternPassRegex = REGEX_CHECK_PASS_WORD;
    if(![Utils validateString:pwd withPattern:patternPassRegex caseSensitive:NO]){
        self.holderPwd.borderColor = UIColor.redColor;
        [self.holderUsrname refresh];
        [self.holderPwd refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Mật khẩu không hợp lệ"];
        return;
    }
    [self.holderUsrname refresh];
    [self.holderPwd refresh];
    if(!isCheck){
        [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"Vui lòng chọn đồng ý điều khoản và điều kiện"] withAction:^(UIAlertAction * _Nonnull) {
            
        }];
        return;
    }
    
    [Utils doGetServerTime:^(long time) {
        AppInfo * appInfo = [[Sdk sharedInstance] getAppInfo];
        NSDictionary *jdt = @{
            request_password : pwd,
            request_username : ursName,
            request_Os: [appInfo.platformOS lowercaseString]
        };
        
        NSDictionary *body = [Utils createJwtFromJdt:jdt];
        
        [self showLoading];
        [Utils delayAction:^{
            
            [[IdApiRequest sharedInstance] callPostMethod:PATH_REGISTER withBody:body withToken:nil completion:^(id  _Nullable result) {
                
                [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
                [self hideLoading];
                LoginJson *loginJson = [[LoginJson alloc] initFromDictionary:result];
                if(loginJson != NULL){
                    if(loginJson.statusCode == CODE_0){
                        [[DataUtils sharedInstance] saveRefreshToken:loginJson.data.refreshToken];
                        [[DataUtils sharedInstance] saveAccessToken:loginJson.data.accessToken];
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
                        //NSNumber* uid = [Utils getAccountIdInPayload:loginJson.data.accessToken usingCache:NULL];
                        [self sayHi:accountName];
                        if(uid != NULL){
                            [[AppsFlyerLib shared] setCustomerUserID:[uid stringValue]];
                        }
                        [self updatePushId];
                        if(self.callback != nil){
                            self.callback(CallbackRegisterSuccess);
                            [self removeFromSuperview];
                        }
                        /*NSDictionary *eventParams = @{
                            PARAM_REG_TYPE : @"Username"
                        };
                        [[Sdk sharedInstance] trackingEvent:EVENT_REGISTER_SUCCESS withParams:eventParams];*/
                        
                        NSDictionary *eventParams1 = @{
                            PARAM_LOGIN_TYPE : @"Username"
                        };
                        [[Sdk sharedInstance] trackingEvent:EVENT_LOGIN_SUCCESS withParams:eventParams1];
                        
                        [self authenGame:loginJson];
                        
                        //Tracking retention
                        TrackingEventRepo* trackingRepo = [[TrackingEventRepo alloc] init];
                        [trackingRepo execute];
                        
                    }
                    //code is 400 or 401
                    else{
                        [self handleErrorCode:loginJson.statusCode andMessage:loginJson.message andAction:nil];
                    }
                }
                else{
                    [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"Lỗi không xác định"] withAction:nil];
                }
            } error:^(NSError * _Nonnull error,  id  _Nullable result,int httpCode) {
                [self hideLoading];
                [self handleError:error withResult:result andHttpCode:httpCode];
                [Utils logMessage:[NSString stringWithFormat:@"error %ld",error.code]];
                [Utils logMessage:[NSString stringWithFormat:@"desc %@",error.description]];
                
            }];
        } withTime:0.5f];
        } andFail:^{
            [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"E_CODE_89"] withAction:nil];
        }];
    
}

-(void) authenGame:(LoginJson *)loginJson{
    NSString* accessToken = loginJson.data.accessToken;
    if([Utils isNullOrEmpty:accessToken]){
        accessToken = [[Sdk sharedInstance] accessToken];
    }
    if(accessToken == NULL){
        //[self hideLoading];
        //[self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"Đăng nhập thất bại"] withAction:NULL];
        return;
    }
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
        [Utils logMessage:@"ok game auth"];
        [Utils logMessage:[NSString stringWithFormat:@"result:  %@",result]];
        //[[DataUtils sharedInstance] saveAuthedGame:true];
        
    } error:^(NSError * _Nonnull error, id  _Nullable result, int httpCode) {
        //[self hideLoading];
        //[self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"Đăng nhập thất bại"] withAction:NULL];
    }];
}

-(void)btnClose:(id)sender{
    [super btnClose:sender];
    NSLog(@"btnClose");
    [self removeFromSuperview];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if([self.txtUsrname isEqual:textField] && textField.returnKeyType == UIReturnKeyNext){
        [self.txtPwd becomeFirstResponder];
    }
    if([self.txtPwd  isEqual:textField] && textField.returnKeyType == UIReturnKeyDone){
        [self.txtPwd  resignFirstResponder];
    }
    return NO;
}
@end
