//
//  LoginView.m
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import "LoginView.h"
#import "Utils.h"
#import "NSLayoutConstraint+Multiplier.h"
#import "RegistrationView.h"
#import "APIRequest.h"
#import "ApiConfig.h"
#import "Sdk.h"
#import "LoginJson.h"
#import "DataUtils.h"
#import "UpdatePushIDRepo.h"
#import "GameApiRequest.h"
#import <GoogleSignIn.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <AppsFlyerLib/AppsFlyerLib.h>
#import "DevicesUtil.h"
#import "NSString+AESCrypt.h"
#import <AuthenticationServices/AuthenticationServices.h>

NSString* const setCurrentIdentifier = @"setCurrentIdentifier";
@implementation LoginView
{
    UIImage *checked;
    UIImage *unchecked;
    BOOL isCheck;
    float offset;
    GIDConfiguration *signInConfig;
}
@synthesize lbNote;
@synthesize lbError;
@synthesize lbTitleLoginBy;

@synthesize holderPwd;
@synthesize holderUsrname;

@synthesize btnApple;
@synthesize btnLogin;
@synthesize btnForget;
@synthesize btnPlayNow;
@synthesize btnRegister;
@synthesize btnFacebook;
@synthesize btnGoogle;
@synthesize layoutBottomContainer;
@synthesize layoutArrange;
@synthesize layoutOpenId;
@synthesize maitainCheckerJson;

@synthesize stackFastLogin;
@synthesize layoutBgRoundCorner;

@synthesize holerSavePass;
@synthesize lbSavePass;
@synthesize cbSavePass;

@synthesize layoutFacebook;
@synthesize layoutGoogle;
@synthesize layoutApple;

@synthesize layoutHolder;
@synthesize bgRoundCorner;

-(void) initInternals{
    [super initInternals];
    offset = 0;
    isCheck = TRUE;
    checked = [UIImage imageNamed:@"checked" inBundle:[NSBundle bundleForClass:self.class]
    compatibleWithTraitCollection:nil];
    unchecked = [UIImage imageNamed:@"unchecked" inBundle:[NSBundle bundleForClass:self.class]
      compatibleWithTraitCollection:nil];
}
-(void) configLabelAndColor{
    self.txtUsrname.placeholder = [TSLanguageManager localizedString:@"Tên đăng nhập"];
    self.txtPwd.placeholder = [TSLanguageManager localizedString:@"Mật khẩu"];
    self.lbNote.text = [TSLanguageManager localizedString:@"Chơi quá 180 phút một ngày sẽ ảnh hưởng xấu đến sức khoẻ"];
    self.lbTitleLoginBy.text = [TSLanguageManager localizedString:@"Đăng nhập bằng tài khoản"];
    self.lbSavePass.text = [TSLanguageManager localizedString:@"Ghi nhớ tài khoản"];
    
    [self.btnLogin setTitle:[TSLanguageManager localizedString:@"Đăng nhập"] forState:UIControlStateNormal];
    [self.btnPlayNow setTitle:[TSLanguageManager localizedString:@"Chơi ngay"] forState:UIControlStateNormal];
    [self.btnForget setTitle:[TSLanguageManager localizedString:@"Quên mật khẩu?"] forState:UIControlStateNormal];
//    [self.btnRegister setTitle:[TSLanguageManager localizedString:@"Đăng ký ID"] forState:UIControlStateNormal];
    
    [self.btnLogin setTintColor:[Utils colorFromHexString:color_main_orange]];
    [self.btnForget setTitleColor:[Utils colorFromHexString:color_main_orange] forState:UIControlStateNormal];
//    [self.btnRegister setTitleColor:[Utils colorFromHexString:color_main_orange] forState:UIControlStateNormal];
}
-(void)configUI:(UIView *)parentView{
    [super configUI:parentView];
    bool isPortrait = [Utils screenInPortrait];
    float heightOpenId = 0.6;
    float widthFastLogin = 0.75;
    if(isPortrait){
        heightOpenId = 0.2;
    }
    int buttonLen = 1;
    int totalButtonLen = 4;
    int totalButtonFastLogin = 3;
    bool enableFacebookLogin = false;
    bool enableGoogleLogin = false;
    bool enableAppleLogin = false;
    
    if(self.maitainCheckerJson != NULL && self.maitainCheckerJson.data != NULL){
        enableFacebookLogin  = self.maitainCheckerJson.data.enableFacebookLogin;
        enableGoogleLogin  = self.maitainCheckerJson.data.enableGoogleLogin;
        enableAppleLogin  = self.maitainCheckerJson.data.enableAppleLogin;
    }
    
    if(enableFacebookLogin){
        buttonLen += 1;
    }
    if(enableGoogleLogin){
        buttonLen += 1;
    }
    if(enableAppleLogin){
        buttonLen += 1;
    }
    if(!isPortrait){
        btnFacebook.hidden = !enableFacebookLogin;
        btnGoogle.hidden = !enableGoogleLogin;
        btnApple.hidden = !enableAppleLogin;
    }else{
        layoutFacebook.hidden = !enableFacebookLogin;
        layoutGoogle.hidden = !enableGoogleLogin;
        layoutApple.hidden = !enableAppleLogin;
    }
    float realHeigtOpenId = heightOpenId * buttonLen / totalButtonLen;
    float realWidthFastLogin = widthFastLogin * (buttonLen - 1)/ totalButtonFastLogin;
    NSLog(@"realHeigtOpenId: %f",realHeigtOpenId);
    
    
    if(!isPortrait){
        layoutOpenId = [layoutOpenId updateMultiplier:realHeigtOpenId];
    }else{
        
        NSLog(@"realWidthFastLogin: %f",realWidthFastLogin);
        stackFastLogin = [stackFastLogin updateMultiplier:realWidthFastLogin];
    }
    
    
    NSString *deviceId =[Utils getDeviceId];
    NSLog(@"configUI: %@",deviceId);
    
    self.txtUsrname.delegate = self;
    self.txtPwd.delegate = self;
    float ratioScreen = [Utils ratioScreen];
    NSLog(@"ratioScreen : %f",ratioScreen);
    
    if(buttonLen == 1){
        layoutBgRoundCorner = [layoutBgRoundCorner updateMultiplier:0.75];
    }else{
        layoutBgRoundCorner = [layoutBgRoundCorner updateMultiplier:0.75];
    }
    
    
    if(ratioScreen <= 1.4){
        if(layoutArrange != NULL){
            if([Utils screenInPortrait]){
                layoutArrange = [layoutArrange updateMultiplier:0.7];
            }
            else{
                layoutArrange = [layoutArrange updateMultiplier:0.5];
            }
        }
    }
    [self configLabelAndColor];
    
    [self configFontByScreen];
    [self configKeyboard:50.0];
    
    [self layoutIfNeeded];
    //set on click on holder saving password
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    singleTap.numberOfTapsRequired = 1;
    [holerSavePass setUserInteractionEnabled:YES];
    [holerSavePass addGestureRecognizer:singleTap];
    
    if(isCheck){
        [cbSavePass setImage:checked];
    }
    else{
        [cbSavePass setImage:unchecked];
    }
    
    if(isCheck){
        NSString* lastUserName = [[DataUtils sharedInstance] getStringValue:KeyUserName];
        if(![Utils isNullOrEmpty:lastUserName]){
            self.txtUsrname.text = lastUserName;
        }
        
        NSString* pwdEncrypted = [[DataUtils sharedInstance] getStringValue:KeyPassword];
        if(![Utils isNullOrEmpty:pwdEncrypted] && ![Utils isNullOrEmpty:lastUserName]){
            AppInfo* appInfo = [[Sdk sharedInstance] getAppInfo];
            NSString* key = [NSString stringWithFormat:@"%@-%@",appInfo.client_secret,lastUserName];
            NSString* lastPwd = [pwdEncrypted AES256DecryptWithKey:key];
            if(![Utils isNullOrEmpty:lastPwd]){
                self.txtPwd.text = lastPwd;
            }
        }
    }
    [[Sdk sharedInstance] trackingEvent:EVENT_OPEN_LOGIN withParams:nil];
}
-(void)configFontByScreen{
    float heightScreen = [Utils heightScreen];
    if(heightScreen <=375){
        
    }
}
-(void)tapDetected:(id)sender{
    NSLog(@"tapDetected");
    isCheck = !isCheck;
    if(isCheck){
        [cbSavePass setImage:checked];
    }
    else{
        [cbSavePass setImage:unchecked];
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
- (void)btnRegisterClick:(id)sender {
    /*RegistrationView *customView = (RegistrationView*)[[[NSBundle mainBundle] loadNibNamed:@"RegistrationView-landscape" owner:self options:nil] objectAtIndex:0];
     customView.callback = ^(NSString* identifier) {
     NSLog(@"Hide %@",identifier );
     };
     customView.translatesAutoresizingMaskIntoConstraints = NO;
     [self addSubview:customView];
     [Utils addConstraintForChild:self andChild:customView withLeft:0 withTop:0 andRight:0 withBottom:0];*/
    
    RegistrationView *customView =(RegistrationView*) [Utils loadViewFromNibFile:[self class] withNib:@"RegistrationView"];
    customView.delegate = self.delegate;
    __weak typeof(self) weakSelf = self;
    customView.callback = ^(NSString* identifier) {
        NSLog(@"Hide %@",identifier );
        if([identifier isEqual:CallbackRegisterSuccess]){
            [weakSelf btnClose:nil];
        }
    };
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    customView.tag = 201;
    [self addSubview:customView];
    [Utils addConstraintForChild:self andChild:customView withLeft:0 withTop:0 andRight:0 withBottom:0];
    //Tracking register button
    NSDictionary* eventParams = @{
        PARAM_CLICK_BUTTON: @"register"
    };
    [[Sdk sharedInstance] trackingEvent:EVENT_CLICK_LOGIN withParams:eventParams];
}
-(void)btnLoginClick:(id)sender{
    
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
    
    NSString *patternPassRegex = REGEX_CHECK_PASS_WORD;
    NSString *patternRegex = REGEX_CHECK_LOGIN_USERNAME;
    if(![Utils validateString:ursName withPattern:patternRegex caseSensitive:NO]){
        self.holderUsrname.borderColor = UIColor.redColor;
        [self.holderUsrname refresh];
        [self.holderPwd refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Tên đăng nhập phải từ 6 đến 30 ký không bao gồm ký tự đặc biệt!"];
        return;
    }
    if(![Utils validateString:pwd withPattern:patternPassRegex caseSensitive:NO]){
        self.holderPwd.borderColor = UIColor.redColor;
        [self.holderUsrname refresh];
        [self.holderPwd refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Mật khẩu không hợp lệ"];
        return;
    }
    [self.holderUsrname refresh];
    [self.holderPwd refresh];
    
    [Utils doGetServerTime:^(long time) {
        [self showLoading];
        [Utils delayAction:^{
            NSString* pwdMd5 = [Utils md5str:pwd];
            //NSString *deviceID = [Utils getDeviceId];
            //NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
            AppInfo* appInfo = [[Sdk sharedInstance] getAppInfo];
            NSDictionary *jdt = @{ request_username : ursName,
                                   request_passwordMd5 : pwdMd5,
                                   request_Os : [ appInfo.platformOS lowercaseString]
                                   
            };
            NSDictionary *body = [Utils createJwtFromJdt:jdt withTime:time];
            
            [[IdApiRequest sharedInstance] callPostMethod:PATH_LOGIN withBody:body withToken:nil completion:^(id  _Nullable result) {
                [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
                [self hideLoading];
                LoginJson *loginJson = [[LoginJson alloc] initFromDictionary:result];
                if(loginJson != NULL){
                    if(loginJson.statusCode == CODE_0){
                        //[Utils logMessage:[NSString stringWithFormat:@"accessToken %@",loginJson.data.accessToken]];
                        
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
                        
                        [self sayHi:accountName];
                        
                        if(uid != NULL){
                            NSString* cID =[uid stringValue];
                            [Utils logMessage:[NSString stringWithFormat:@"cID %@",cID]];
                            [[AppsFlyerLib shared] setCustomerUserID:cID];
                        }
                        //[[AppsFlyerLib shared] setCustomerUserID:loginJson.data.user.userId];
                        [self updatePushId];
                        [self btnClose:nil];
                        NSDictionary* eventParams = @{
                            PARAM_LOGIN_TYPE : @"Username"
                        };
                        [[Sdk sharedInstance] trackingEvent:EVENT_LOGIN_SUCCESS withParams:eventParams];
                        [self authenGame:loginJson withType:@"Username"];
                        //Tracking retention
                        TrackingEventRepo* trackingRepo = [[TrackingEventRepo alloc] init];
                        [trackingRepo execute];
                        if(self->isCheck){
                            AppInfo* appInfo = [[Sdk sharedInstance] getAppInfo];
                            NSString* key = [NSString stringWithFormat:@"%@-%@",appInfo.client_secret,userInfo.accountName];
                            NSString* pwd = self.txtPwd.text;
                        
                            NSString* pwdEncrypted = [pwd AES256EncryptWithKey:key];
                            [[DataUtils sharedInstance] setStringValue:userInfo.accountName forKey:KeyUserName];
                            [[DataUtils sharedInstance] setStringValue:pwdEncrypted forKey:KeyPassword];
                        }
                        else{
                            [[DataUtils sharedInstance] setStringValue:@"" forKey:KeyUserName];
                            [[DataUtils sharedInstance] setStringValue:@"" forKey:KeyPassword];
                        }
                    }
                    //code is not equal 0 or IsSuccessed = false
                    else{
                        [self handleErrorCode:loginJson.statusCode andMessage:loginJson.message andAction:NULL];
                    }
                }
                else{
                    [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"Lỗi không xác định"] withAction:nil];
                }
            } error:^(NSError * _Nonnull error,  id  _Nullable result,int httpCode) {
                [self hideLoading];
                [self handleError:error withResult:result andHttpCode:httpCode];
                [Utils logMessage:[NSString stringWithFormat:@"error %ld",error.code]];
                [Utils logMessage:[NSString stringWithFormat:@"desc %@",error.localizedDescription]];
                
            }];
        } withTime:0.5f];
    } andFail:^{
        [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"E_CODE_89"] withAction:nil];
        //Tracking register button
        NSDictionary* eventParams = @{
            PARAM_API: @"id_get_time_api"
        };
        [[Sdk sharedInstance] trackingEvent:EVENT_ERROR_API withParams:eventParams];
    }];
    
    //Tracking register button
    NSDictionary* eventParams = @{
        PARAM_CLICK_BUTTON: @"login"
    };
    [[Sdk sharedInstance] trackingEvent:EVENT_CLICK_LOGIN withParams:eventParams];
}

-(void) authenGame:(LoginJson *)loginJson withType:(NSString*) typeLogin{
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
        /*[self hideLoading];
         [Utils logMessage:[NSString stringWithFormat:@"result:  %@",result]];
         [[DataUtils sharedInstance] saveRefreshToken:loginJson.data.refreshToken];
         [[DataUtils sharedInstance] saveAccessToken:loginJson.data.accessToken];
         [[DataUtils sharedInstance] saveUser:loginJson.data.user];
         User* user = [[DataUtils sharedInstance] getUser];
         if(self.delegate){
         [self.delegate loginSuccess:nil withAccessToken:loginJson.data.accessToken andRefreshToken:loginJson.data.refreshToken];
         }
         [[AppsFlyerLib shared] setCustomerUserID:loginJson.data.user.userId];
         [self updatePushId];
         [self btnClose:nil];
         NSDictionary* eventParams = @{
         PARAM_LOGIN_TYPE : typeLogin
         };
         [[Sdk sharedInstance] trackingEvent:EVENT_LOGIN_SUCCESS withParams:eventParams];*/
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
    //Tracking close button
    NSDictionary* eventParams = @{
        PARAM_CLICK_BUTTON: @"close"
    };
    [[Sdk sharedInstance] trackingEvent:EVENT_CLICK_LOGIN withParams:eventParams];
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
- (void)btnGoogleClick:(id)sender {
    if(signInConfig == nil){
        AppInfo* appInfo = [[Sdk sharedInstance] getAppInfo];
        NSDictionary *mainDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GoogleService-Info" ofType:@"plist"]];
        NSString *clientID = [mainDictionary objectForKey:@"CLIENT_ID"];
        signInConfig = [[GIDConfiguration alloc] initWithClientID:clientID serverClientID:appInfo.googleWebClient];
    }
    UIViewController *topViewController = [Utils topViewController];
    [GIDSignIn.sharedInstance signInWithConfiguration:signInConfig
                             presentingViewController:topViewController
                                             callback:^(GIDGoogleUser * _Nullable user,
                                                        NSError * _Nullable error) {
        if (error) {
            return;
        }
        NSLog(@"email: %@",user.userID);
        NSLog(@"serverAuthCode: %@",user.serverAuthCode);
        NSLog(@"name: %@",user.profile.name);
        NSLog(@"email: %@",user.profile.email);
        [self doLoginGoogle:user.userID andGgEmail:user.profile.email andGgName:user.profile.name andCode:user.serverAuthCode];
        /*[user.authentication doWithFreshTokens:^(GIDAuthentication * _Nullable authentication,
                                                 NSError * _Nullable error) {
            if (error) { return; }
            if (authentication == nil) { return; }
            
            NSString *idToken = authentication.idToken;
            // Send ID token to backend (example below).
            NSLog(@"idToken: %@",idToken);
        }];*/
        // If sign in succeeded, display the app's main content View.
    }];
    //Tracking google button
    NSDictionary* eventParams = @{
        PARAM_CLICK_BUTTON: @"google"
    };
    [[Sdk sharedInstance] trackingEvent:EVENT_CLICK_LOGIN withParams:eventParams];
}
- (void)btnFacebookClick:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    UIViewController *topViewController = [Utils topViewController];
    [login logInWithPermissions:@[@"public_profile",@"email"] fromViewController:topViewController handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Process error");
        } else if (result.isCancelled) {
            
        } else {
            NSLog(@"Logged in");
            NSLog(@"Token1:%@",result.token.tokenString);
            NSLog(@"Token2:%@",[FBSDKAccessToken currentAccessToken].tokenString);
            [self businessTokenByGraphAPI];
        }
    }];
    //Tracking google button
    NSDictionary* eventParams = @{
        PARAM_CLICK_BUTTON: @"facebook"
    };
    [[Sdk sharedInstance] trackingEvent:EVENT_CLICK_LOGIN withParams:eventParams];
}
- (void)btnPlayNowClick:(id)sender {
    NSString *deviceId =[Utils getDeviceId];
    AppInfo *appInfo = [[Sdk sharedInstance] getAppInfo];
    [Utils doGetServerTime:^(long time) {
        NSDictionary *jdt = @{
            request_Os: [appInfo.platformOS lowercaseString],
            request_device_id : deviceId
        };

        NSDictionary *body = [Utils createJwtFromJdt:jdt withTime:time];

        [self showLoading];
        [Utils delayAction:^{
            [[IdApiRequest sharedInstance] callPostMethod:PATH_REGISTER_FAST withBody:body withToken:nil completion:^(id  _Nullable result) {
                [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
                [self hideLoading];
                LoginJson *loginJson = [[LoginJson alloc] initFromDictionary:result];
                if(loginJson != NULL){
                    if(loginJson.statusCode == CODE_0){
                        //[Utils logMessage:[NSString stringWithFormat:@"accessToken %@",loginJson.data.accessToken]];

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
                        //[[AppsFlyerLib shared] setCustomerUserID:loginJson.data.user.userId];
                        [self updatePushId];
                        [self btnClose:nil];
                        NSDictionary* eventParams = @{
                            PARAM_LOGIN_TYPE: @"Fast"
                        };
                        [[Sdk sharedInstance] trackingEvent:EVENT_LOGIN_SUCCESS withParams:eventParams];

                        /*NSDictionary* eventParams1 = @{
                            PARAM_REG_TYPE: @"Fast"
                        };
                        [[Sdk sharedInstance] trackingEvent:EVENT_REGISTER_SUCCESS withParams:eventParams1];*/

                        [self authenGame:loginJson withType:@"Fast"];
                        TrackingEventRepo* trackingRepo = [[TrackingEventRepo alloc] init];
                        [trackingRepo execute];
                    }
                    //code is 400 or 401
                    else{
                        [self handleErrorCode:loginJson.statusCode andMessage:loginJson.message andAction:nil];
                        /*NSString *errorText = [TSLanguageManager localizedString:[NSString stringWithFormat:@"E_CODE_%d",loginJson.statusCode]];
                        if([errorText containsString:@"E_CODE_"]){
                            if(![Utils isNullOrEmpty:loginJson.message]){
                                errorText = loginJson.message;
                            }
                            else{
                                errorText = [TSLanguageManager localizedString:@"Lỗi không xác định"];
                            }
                        }
                        [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:errorText withAction:nil];*/
                    }
                }
                else{
                    [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"Lỗi không xác định"] withAction:nil];
                }

            } error:^(NSError * _Nonnull error,  id  _Nullable result,int httpCode) {
                [self hideLoading];
                [self handleError:error withResult:result andHttpCode:httpCode];
                [Utils logMessage:[NSString stringWithFormat:@"error %ld",error.code]];
                [Utils logMessage:[NSString stringWithFormat:@"desc %@",error.localizedDescription]];
            }];
        } withTime:0.5f];
        } andFail:^{
            [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"E_CODE_89"] withAction:nil];
            //Tracking register button
            NSDictionary* eventParams = @{
                PARAM_API: @"id_get_time_api"
            };
            [[Sdk sharedInstance] trackingEvent:EVENT_ERROR_API withParams:eventParams];
        }];
    //Tracking google button
    NSDictionary* eventParams = @{
        PARAM_CLICK_BUTTON: @"fast"
    };
    [[Sdk sharedInstance] trackingEvent:EVENT_CLICK_LOGIN withParams:eventParams];

}
- (void)btnAppleClick:(id)sender {
    // login apple id start
    if (@available(iOS 13.0, *)) {
        // A mechanism for generating requests to authenticate users based on their Apple ID.
        ASAuthorizationAppleIDProvider  *appleIDProvider = [ASAuthorizationAppleIDProvider new];
        ASAuthorizationAppleIDRequest *request = appleIDProvider.createRequest;
        // The contact information to be requested from the user during authentication.
        request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];

        // A controller that manages authorization requests created by a provider.
        ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];

        // A delegate that the authorization controller informs about the success or failure of an authorization attempt.
        controller.delegate = self;

        // A delegate that provides a display context in which the system can present an authorization interface to the user.
        controller.presentationContextProvider = self;

        // starts the authorization flows named during controller initialization.
        [controller performRequests];
    }

}
#pragma mark - Delegate

 - (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)){
    
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", controller);
    NSLog(@"%@", authorization);
    
    NSLog(@"authorization.credential：%@", authorization.credential);
    
    NSMutableString *mStr = [NSMutableString string];

    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
        NSString *user = appleIDCredential.user;
        NSString *appleIDToken = [[NSString alloc]initWithData:appleIDCredential.identityToken
                                                      encoding: NSUTF8StringEncoding];
        
        NSLog(@"appleIDToken : %@", appleIDToken);
        
        [[NSUserDefaults standardUserDefaults] setValue:user forKey:setCurrentIdentifier];

        NSString* apId = appleIDCredential.user?:@"";
        NSString* apEmail = appleIDCredential.email? : @"";
        NSString* apName =  @"";
        
        // doc jwt
        NSDictionary* payload = [Utils getPayloadInToken:appleIDToken];
        if(!appleIDCredential.email){
            apEmail = [Utils getEmailInPayload:appleIDToken usingCache:payload];
        }
        
        NSLog(@"email：%@", apEmail);
        [self doLoginApple:appleIDToken andApId:apId andApName:apName andApEmail:apEmail];

        
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        ASPasswordCredential *passwordCredential = authorization.credential;
        NSString *user = passwordCredential.user;
        NSString *password = passwordCredential.password;
        [mStr appendString:user?:@""];
        [mStr appendString:password?:@""];
        [mStr appendString:@"\n"];
        NSLog(@"mStr：%@", mStr);
    } else {
         mStr = [@"check" mutableCopy];

    }
}
 

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)){
    
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"error ：%@", error);
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"ASAuthorizationErrorCanceled";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"ASAuthorizationErrorFailed";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"ASAuthorizationErrorInvalidResponse";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"ASAuthorizationErrorNotHandled";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"ASAuthorizationErrorUnknown";
            break;
    }
    if (errorMsg) {
        return;
    }
    
    if (error.localizedDescription) {
       
    }
    NSLog(@"controller requests：%@", controller.authorizationRequests);
    
}

- (void)dealloc {
    
    if (@available(iOS 13.0, *)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    }
}

-(void)doLoginApple:(NSString*) apAccessToken andApId:(NSString*) apId andApName:(NSString*) apName andApEmail:(NSString*) apEmail {
    
    NSLog(@"apAccessToken: %@",apAccessToken);
    NSLog(@"apId: %@",apId);
    NSLog(@"apName: %@",apName);
    NSLog(@"apEmail: %@",apEmail);
    
    AppInfo* appInfo = [[Sdk sharedInstance] getAppInfo];
    
    [Utils doGetServerTime:^(long time) {
        NSDictionary* jdt = @{
            @"apId" : apId,
            @"apEmail" : apEmail,
            @"apName" : apName,
            @"token" : apAccessToken,
            request_Os : [ appInfo.platformOS lowercaseString]
        };
        
        NSDictionary* body = [Utils createJwtFromJdt:jdt withTime:time];
        [self showLoading];
        [Utils delayAction:^{
            [[IdApiRequest sharedInstance] callPostMethod:PATH_LOGIN_APPLE withBody:body withToken:nil completion:^(id  _Nullable result) {
                [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
                [self hideLoading];
                LoginJson *loginJson = [[LoginJson alloc] initFromDictionary:result];
                if(loginJson != NULL){
                    if(loginJson.statusCode == CODE_0){
                        //[Utils logMessage:[NSString stringWithFormat:@"accessToken %@",loginJson.data.accessToken]];
                        
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
                        //[[AppsFlyerLib shared] setCustomerUserID:loginJson.data.user.userId];
                        [self updatePushId];
                        [self btnClose:nil];
                        NSDictionary* eventParams = @{
                            PARAM_LOGIN_TYPE: @"Apple"
                        };
                        [[Sdk sharedInstance] trackingEvent:EVENT_LOGIN_SUCCESS withParams:eventParams];
                        
                        /*NSDictionary* eventParams1 = @{
                            PARAM_REG_TYPE: @"Facebook"
                        };
                        [[Sdk sharedInstance] trackingEvent:EVENT_REGISTER_SUCCESS withParams:eventParams1];*/
                        
                        [self authenGame:loginJson withType:@"Apple"];
                        TrackingEventRepo* trackingRepo = [[TrackingEventRepo alloc] init];
                        [trackingRepo execute];
                    }
                    //code is 400 or 401
                    else{
                        [self handleErrorCode:loginJson.statusCode andMessage:loginJson.message andAction:nil];
                        /*NSString *errorText = [TSLanguageManager localizedString:[NSString stringWithFormat:@"E_CODE_%d",loginJson.statusCode]];
                        if([errorText containsString:@"E_CODE_"]){
                            if(![Utils isNullOrEmpty:loginJson.message]){
                                errorText = loginJson.message;
                            }
                            else{
                                errorText = [TSLanguageManager localizedString:@"Lỗi không xác định"];
                            }
                        }
                        [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:errorText withAction:nil];*/
                    }
                }
                else{
                    [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"Lỗi không xác định"] withAction:nil];
                }
                
            } error:^(NSError * _Nonnull error,  id  _Nullable result,int httpCode) {
                [self hideLoading];
                [self handleError:error withResult:result andHttpCode:httpCode];
                [Utils logMessage:[NSString stringWithFormat:@"error %ld",error.code]];
                [Utils logMessage:[NSString stringWithFormat:@"desc %@",error.localizedDescription]];
            }];
        } withTime:0.5f];
        } andFail:^{
            [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"E_CODE_89"] withAction:nil];
            //Tracking register button
            NSDictionary* eventParams = @{
                PARAM_API: @"id_get_time_api"
            };
            [[Sdk sharedInstance] trackingEvent:EVENT_ERROR_API withParams:eventParams];
        }];
    

}




-(void)btnForgetPwdClick:(id)sender{
    NSLog(@"btnForgetPwdClick");
    NSURL *pURL = NULL;
    if([[Sdk sharedInstance] isProdEnv]){
        pURL = [[NSURL URLWithString:PROD_BASE_WEB_ID]  URLByAppendingPathComponent:PATH_FORGET_PASS];
    }
    else{
        pURL = [[NSURL URLWithString:DEV_BASE_WEB_ID]  URLByAppendingPathComponent:PATH_FORGET_PASS];
    }
    //NSURL *pURL = [[Utils getUrl:@"ID_BASE_URL"]  URLByAppendingPathComponent:PATH_FORGET_PASS];
    if( [[UIApplication sharedApplication] canOpenURL:pURL])
        [[UIApplication sharedApplication] openURL:pURL options:@{} completionHandler:^(BOOL success) {

        }];
    //Tracking google button
    NSDictionary* eventParams = @{
        PARAM_CLICK_BUTTON: @"forget_pass"
    };
    [[Sdk sharedInstance] trackingEvent:EVENT_CLICK_LOGIN withParams:eventParams];
}
-(void)businessTokenByGraphAPI{
    FBSDKAccessToken *fbAccessToken = [FBSDKAccessToken currentAccessToken];
    if(fbAccessToken != NULL && !fbAccessToken.isExpired){
        
        NSDictionary* params = @{
            @"fields":@"id,name,email,token_for_business"
        };
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"/me"
                                      parameters:params
                                      HTTPMethod:FBSDKHTTPMethodGET];
        
        [request startWithCompletion:^(id<FBSDKGraphRequestConnecting>  _Nullable connection, id  _Nullable result, NSError * _Nullable error) {
            if (!error){
                NSLog(@"FB GRAPH result: %@",result);
                NSDictionary* data = (NSDictionary*)result;
                NSString* fbId = @"";
                NSString* businessToken = @"";
                NSString* fbEmail = @"";
                NSString* fbName = @"";
                if(data != NULL){
                    if([data objectForKey:@"id"] != NULL){
                        fbId = [data objectForKey:@"id"];
                    }
                    if([data objectForKey:@"email"] != NULL){
                        fbEmail = [data objectForKey:@"email"];
                    }
                    if([data objectForKey:@"token_for_business"] != NULL){
                        businessToken = [data objectForKey:@"token_for_business"];
                    }
                    if([data objectForKey:@"name"] != NULL){
                        fbName = [data objectForKey:@"name"];
                    }
                }
                NSLog(@"fbId: %@",fbId);
                NSLog(@"businessToken: %@",businessToken);
                NSLog(@"fbEmail: %@",fbEmail);
                NSLog(@"fbName: %@",fbName);
                [self doLoginFacebook:fbAccessToken.tokenString  andFbId:fbId andFbName:fbName andFbEmail:fbEmail andBusinessToken:businessToken];
            }
            else {
                NSLog(@"FB GRAPH error result: %@",[error description]);
            }
        }];
    }
}
-(void)doLoginFacebook:(NSString*) fbAccessToken andFbId:(NSString*) fbId andFbName:(NSString*) fbName andFbEmail:(NSString*) fbEmail andBusinessToken:(NSString*) businessToken{
    AppInfo* appInfo = [[Sdk sharedInstance] getAppInfo];
    [Utils doGetServerTime:^(long time) {
        NSDictionary* jdt = @{
            @"fbId" : fbId,
            @"fbEmail" : fbEmail,
            @"fbName" : fbName,
            @"fbToken" : fbAccessToken,
            @"businessToken" : businessToken,
            request_Os : [ appInfo.platformOS lowercaseString]
        };
        
        NSDictionary* body = [Utils createJwtFromJdt:jdt withTime:time];
        [self showLoading];
        [Utils delayAction:^{
            [[IdApiRequest sharedInstance] callPostMethod:PATH_LOGIN_FACEBOOK withBody:body withToken:nil completion:^(id  _Nullable result) {
                [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
                [self hideLoading];
                LoginJson *loginJson = [[LoginJson alloc] initFromDictionary:result];
                if(loginJson != NULL){
                    if(loginJson.statusCode == CODE_0){
                        //[Utils logMessage:[NSString stringWithFormat:@"accessToken %@",loginJson.data.accessToken]];
                        
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
                        //[[AppsFlyerLib shared] setCustomerUserID:loginJson.data.user.userId];
                        [self updatePushId];
                        [self btnClose:nil];
                        NSDictionary* eventParams = @{
                            PARAM_LOGIN_TYPE: @"Facebook"
                        };
                        [[Sdk sharedInstance] trackingEvent:EVENT_LOGIN_SUCCESS withParams:eventParams];
                        
                        /*NSDictionary* eventParams1 = @{
                            PARAM_REG_TYPE: @"Facebook"
                        };
                        [[Sdk sharedInstance] trackingEvent:EVENT_REGISTER_SUCCESS withParams:eventParams1];*/
                        
                        [self authenGame:loginJson withType:@"Facebook"];
                        TrackingEventRepo* trackingRepo = [[TrackingEventRepo alloc] init];
                        [trackingRepo execute];
                    }
                    //code is 400 or 401
                    else{
                        [self handleErrorCode:loginJson.statusCode andMessage:loginJson.message andAction:nil];
                        /*NSString *errorText = [TSLanguageManager localizedString:[NSString stringWithFormat:@"E_CODE_%d",loginJson.statusCode]];
                        if([errorText containsString:@"E_CODE_"]){
                            if(![Utils isNullOrEmpty:loginJson.message]){
                                errorText = loginJson.message;
                            }
                            else{
                                errorText = [TSLanguageManager localizedString:@"Lỗi không xác định"];
                            }
                        }
                        [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:errorText withAction:nil];*/
                    }
                }
                else{
                    [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"Lỗi không xác định"] withAction:nil];
                }
                
            } error:^(NSError * _Nonnull error,  id  _Nullable result,int httpCode) {
                [self hideLoading];
                [self handleError:error withResult:result andHttpCode:httpCode];
                [Utils logMessage:[NSString stringWithFormat:@"error %ld",error.code]];
                [Utils logMessage:[NSString stringWithFormat:@"desc %@",error.localizedDescription]];
            }];
        } withTime:0.5f];
        } andFail:^{
            [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"E_CODE_89"] withAction:nil];
            //Tracking register button
            NSDictionary* eventParams = @{
                PARAM_API: @"id_get_time_api"
            };
            [[Sdk sharedInstance] trackingEvent:EVENT_ERROR_API withParams:eventParams];
        }];
    
    
    
}
-(void)doLoginGoogle:(NSString*)ggId andGgEmail:(NSString*) ggEmail andGgName:(NSString*) ggName andCode:(NSString*) code{
    AppInfo* appInfo = [[Sdk sharedInstance] getAppInfo];
    [Utils doGetServerTime:^(long time) {
        NSDictionary* jdt = @{
            @"ggId" : ggId,
            @"ggEmail" : ggEmail,
            @"ggName" : ggName,
            @"code" : code,
            request_Os : [ appInfo.platformOS lowercaseString]
        };
        
        NSDictionary* body = [Utils createJwtFromJdt:jdt withTime:time];
        [self showLoading];
        [Utils delayAction:^{
            [[IdApiRequest sharedInstance] callPostMethod:PATH_LOGIN_GOOGLE withBody:body withToken:nil completion:^(id  _Nullable result) {
                [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
                [self hideLoading];
                LoginJson *loginJson = [[LoginJson alloc] initFromDictionary:result];
                if(loginJson != NULL){
                    if(loginJson.statusCode == CODE_0){
                        //[Utils logMessage:[NSString stringWithFormat:@"accessToken %@",loginJson.data.accessToken]];
                        
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
                        //[[AppsFlyerLib shared] setCustomerUserID:loginJson.data.user.userId];
                        [self updatePushId];
                        [self btnClose:nil];
                        NSDictionary* eventParams = @{
                            PARAM_LOGIN_TYPE: @"Google"
                        };
                        [[Sdk sharedInstance] trackingEvent:EVENT_LOGIN_SUCCESS withParams:eventParams];
                        
                        /*NSDictionary* eventParams1 = @{
                            PARAM_REG_TYPE: @"Google"
                        };
                        [[Sdk sharedInstance] trackingEvent:EVENT_REGISTER_SUCCESS withParams:eventParams1];*/
                        
                        [self authenGame:loginJson withType:@"Google"];
                        TrackingEventRepo* trackingRepo = [[TrackingEventRepo alloc] init];
                        [trackingRepo execute];
                    }
                    //code is 400 or 401
                    else{
                        [self handleErrorCode:loginJson.statusCode andMessage:loginJson.message andAction:nil];
                        /*NSString *errorText = [TSLanguageManager localizedString:[NSString stringWithFormat:@"E_CODE_%d",loginJson.statusCode]];
                        if([errorText containsString:@"E_CODE_"]){
                            if(![Utils isNullOrEmpty:loginJson.message]){
                                errorText = loginJson.message;
                            }
                            else{
                                errorText = [TSLanguageManager localizedString:@"Lỗi không xác định"];
                            }
                        }
                        [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:errorText withAction:nil];*/
                    }
                }
                else{
                    [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"Lỗi không xác định"] withAction:nil];
                }
                
            } error:^(NSError * _Nonnull error,  id  _Nullable result,int httpCode) {
                [self hideLoading];
                [self handleError:error withResult:result andHttpCode:httpCode];
                [Utils logMessage:[NSString stringWithFormat:@"error %ld",error.code]];
                [Utils logMessage:[NSString stringWithFormat:@"desc %@",error.localizedDescription]];
            }];
        } withTime:0.5f];
        } andFail:^{
            [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"E_CODE_89"] withAction:nil];
            //Tracking register button
            NSDictionary* eventParams = @{
                PARAM_API: @"id_get_time_api"
            };
            [[Sdk sharedInstance] trackingEvent:EVENT_ERROR_API withParams:eventParams];
        }];
    
}
@end
