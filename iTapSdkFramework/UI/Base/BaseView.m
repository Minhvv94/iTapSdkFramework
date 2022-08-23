//
//  BaseView.m
//  testgame
//
//  Created by Tran Trong Cong on 8/10/21.
//

#import "BaseView.h"
#import "LoadingView.h"
#import "Utils.h"
#import "UpdatePushIDRepo.h"
#import <Firebase.h>
#import "LoginJson.h"
#import "WelcomeView.h"
@implementation BaseView
{
    LoadingView *loadingView;
    BOOL isInited;
}
@synthesize callback;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //init from frame
        [self initInternals];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //init from xib or storyboard
        [self initInternals];
    }
    return self;
}
//init variable in here
-(void) initInternals{
    isInited = FALSE;
    if (@available(iOS 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    } else {
        // Fallback on earlier versions
    }
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    if(!isInited){
        [self configUI:newSuperview];
        isInited = TRUE;
    }
}
-(void)btnClose:(id)sender{
    if(callback != nil){
        NSString* identifier = NSStringFromClass(self.class);
        self.callback(identifier);
    }
}
-(void)configUI:(UIView *)parentView{
    
}

-(void)sayHi:(NSString *)userName{
    UIViewController *topView = [Utils topViewController];
    
    WelcomeView *customView = (WelcomeView*)[Utils loadViewFromNibFile:[WelcomeView class] universalWithNib:@"WelcomeView"];
    customView.vBackground.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    NSString* sayHelloUser = [NSString stringWithFormat:@"%@%@",[TSLanguageManager localizedString:@"Chào mừng"],userName];
    float w = [Utils widthOfString:sayHelloUser withFont:[UIFont systemFontOfSize:20]];
    
    if(customView.superview == NULL){
        [topView.view addSubview:customView];
        float wView = topView.view.frame.size.width;
        float hView = topView.view.frame.size.height;
        float top = 20;
        [Utils addConstraintForChild:(UIView *)topView.view andChild:customView withLeft:0.5*(wView-w) withTop:top andRight:-0.5*(wView-w) withBottom:hView-top-40];
        [customView sayHi:userName];
        [customView waitAndHide:2 durationTime:1];
    }
}
-(void)showLoading{
    //display loading
    if(self->loadingView == NULL){
        self->loadingView = (LoadingView*)[Utils loadViewFromNibFile:[LoadingView class] universalWithNib:@"LoadingView"];


    [self addSubview:self->loadingView];
    [Utils addConstraintForChild:self andChild:self->loadingView withLeft:0 withTop:0 andRight:0 withBottom:0];
    }
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @0.0f;
    animation.toValue = @(2*M_PI);
    animation.duration = 1;             // this might be too fast
    animation.repeatCount = HUGE_VALF;     // HUGE_VALF is defined in math.h so import it
    [self->loadingView.iconLoading.layer addAnimation:animation forKey:@"rotation"];
    self->loadingView.noteLoading.hidden = YES;
    self->loadingView.translatesAutoresizingMaskIntoConstraints = NO;
}

-(void)showLoading:(NSString*)note{
    //display loading
    if(self->loadingView == NULL){
        self->loadingView = (LoadingView*)[Utils loadViewFromNibFile:[LoadingView class] universalWithNib:@"LoadingView"];

   
    self->loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self->loadingView];
    [Utils addConstraintForChild:self andChild:self->loadingView withLeft:0 withTop:0 andRight:0 withBottom:0];
    }
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @0.0f;
    animation.toValue = @(2*M_PI);
    animation.duration = 1;             // this might be too fast
    animation.repeatCount = HUGE_VALF;     // HUGE_VALF is defined in math.h so import it
    [self->loadingView.iconLoading.layer addAnimation:animation forKey:@"rotation"];
    self->loadingView.noteLoading.hidden = NO;
    self->loadingView.noteLoading.text = note;
}

-(void)hideLoading{
    if(self->loadingView != NULL && self->loadingView.superview != NULL){
        [self->loadingView removeFromSuperview];
        self->loadingView = NULL;
    }
}
- (void)showAlert:(NSString *)title withContent:(NSString *)content withAction:(void (^)(UIAlertAction*))action{
    NSString *newTitle = title;
    if(newTitle == nil){
        newTitle = [TSLanguageManager localizedString:@"Thông báo"];
    }
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:newTitle
                                 message:content
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:[TSLanguageManager localizedString:@"Đồng ý"]
                                style:UIAlertActionStyleDefault
                                handler:action];
    [alert addAction:yesButton];
    UIViewController * top = [Utils topViewController];
    [top presentViewController:alert animated:YES completion:nil];
}
-(void)showAlertWith2Action:(NSString *)title withContent:(NSString *)content withOkAction:(void (^)(UIAlertAction * _Nonnull))okAction andCancelAction:(void (^)(UIAlertAction * _Nonnull))cancelAction{
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:content
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Ok Buttons
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:[TSLanguageManager localizedString:@"Đồng ý"]
                               style:UIAlertActionStyleDefault
                               handler:okAction];
    //Add Cancel Buttons
    
    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:[TSLanguageManager localizedString:@"Huỷ"]
                                   style:UIAlertActionStyleDefault
                                   handler:cancelAction];
    [alert addAction:okButton];
    [alert addAction:cancelButton];
    UIViewController * top = [Utils topViewController];
    [top presentViewController:alert animated:YES completion:nil];
}

-(void)showAlertWith2Action:(NSString *)title withContent:(NSString *)content withOkTitle:(NSString*) okTitle withOkAction:(void (^)(UIAlertAction * _Nonnull))okAction andCancelAction:(void (^)(UIAlertAction * _Nonnull))cancelAction{
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:content
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Ok Buttons
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:okTitle
                               style:UIAlertActionStyleDefault
                               handler:okAction];
    //Add Cancel Buttons
    
    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:[TSLanguageManager localizedString:@"Huỷ"]
                                   style:UIAlertActionStyleDefault
                                   handler:cancelAction];
    [alert addAction:okButton];
    [alert addAction:cancelButton];
    UIViewController * top = [Utils topViewController];
    [top presentViewController:alert animated:YES completion:nil];
}
-(void)updatePushId{
    NSString* pushId = [[DataUtils sharedInstance] fcmToken];
    if(![Utils isNullOrEmpty:pushId]){
        AppInfo* appInfo = [[Sdk sharedInstance] getAppInfo];
        UpdatePushIDRepo* updatePushIdRepo = [[UpdatePushIDRepo alloc] init];
        updatePushIdRepo.pushId =pushId;
        updatePushIdRepo.packageId = appInfo.packageId;
        updatePushIdRepo.platformOs = [appInfo.platformOS lowercaseString];
        updatePushIdRepo.accessToken = [[Sdk sharedInstance] accessToken];
        [updatePushIdRepo execute];
    }
    else{
        [[FIRMessaging messaging] tokenWithCompletion:^(NSString *token, NSError *error) {
          if (error != nil) {
            NSLog(@"Error getting FCM registration token: %@", error);
          } else {
            NSLog(@"updatePushId FCM registration token: %@", token);
              [[DataUtils sharedInstance] saveFcmToken:token];
              [[DataUtils sharedInstance] saveRegisteredFcm:FALSE];
              [self updatePushId];
          }
        }];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
-(void)handleError:(NSError *)error withResult:(id)result andHttpCode:(int)httpCode{
    if(error.code == -1001){
        //The request timed out.
        [self showAlert:nil withContent:[TSLanguageManager localizedString:@"SPLASH_TIME_OUT"] withAction:nil];
        return;
    }
    if(error.code == -1009){
        //The Internet connection appears to be offline
        [self showAlert:nil withContent:[TSLanguageManager localizedString:@"SPLASH_TIME_OUT"] withAction:nil];
        return;
    }
    if(error.code == -1004){
        //cant connect to server
        [self showAlert:nil withContent:[TSLanguageManager localizedString:@"SPLASH_TIME_OUT"] withAction:nil];
        return;
    }
    if(error.code == -1003){
        //A server with the specified hostname could not be found.
        [self showAlert:nil withContent:[TSLanguageManager localizedString:@"SPLASH_TIME_OUT"] withAction:nil];
        return;
    }

    if(error.code == -1005){
        //lose connection
        [self showAlert:nil withContent:[TSLanguageManager localizedString:@"SPLASH_NO_INTERNET"] withAction:nil];
        return;
    }
    
    [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"Lỗi không xác định"] withAction:nil];
}

-(void) handleErrorCode:(int) errorCode andMessage:(NSString*)msg andAction:(void (^)(UIAlertAction*))action{
    NSString *errorText = [TSLanguageManager localizedString:[NSString stringWithFormat:@"E_CODE_%d",errorCode]];
    if([errorText containsString:@"E_CODE_"]){
        if(![Utils isNullOrEmpty:msg]){
            errorText = msg;
        }
        else{
            errorText = [TSLanguageManager localizedString:@"Lỗi không xác định"];
        }
    }    
    [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:errorText withAction:action];
}
-(void)doRefreshWithAction:(void (^)(void))action{
    AppInfo *appInfo = [[Sdk sharedInstance] getAppInfo];
    NSString * refreshToken = [[Sdk sharedInstance] refreshToken];
    NSDictionary *body = @{
        request_jwt:refreshToken,
        request_cid:appInfo.client_id,
        request_client_id: appInfo.client_id
    };
    [[IdApiRequest sharedInstance] callPostMethod:PATH_REFRESH_TOKEN withBody:body withToken:nil completion:^(id  _Nullable result) {
        [Utils logMessage:[NSString stringWithFormat:@"refresh content %@",result]];
        [self hideLoading];
        LoginJson *loginJson = [[LoginJson alloc] initFromDictionary:result];
        if(loginJson != NULL){
            if(loginJson.statusCode == CODE_0){
                //success
                [[DataUtils sharedInstance] saveAccessToken:loginJson.data.accessToken];
                if(action != NULL){
                    action();
                }
            }
            else{
                NSString *errorText = [TSLanguageManager localizedString:[NSString stringWithFormat:@"E_CODE_%d",loginJson.statusCode]];
                if([errorText containsString:@"E_CODE_"]){
                    if(![Utils isNullOrEmpty:loginJson.message]){
                        errorText = loginJson.message;
                    }
                    else{
                        errorText = [TSLanguageManager localizedString:@"Lỗi không xác định"];
                    }
                }
                [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:errorText withAction:^(UIAlertAction * _Nonnull) {
                    /*if(loginJson.statusCode == CODE_86){
                        if(self.callback !=NULL){
                            self.callback(CallbackHide);
                        }
                        [[Sdk sharedInstance] forceLogout];
                    }*/
                }];
            }
        }
    } error:^(NSError * _Nonnull error,  id  _Nullable result,int httpCode) {
        [Utils logMessage:[NSString stringWithFormat:@"error %ld",error.code]];
        [Utils logMessage:[NSString stringWithFormat:@"desc %@",error.description]];
        [self hideLoading];
        [self showAlert:nil withContent:[TSLanguageManager localizedString:@"Lỗi không xác định"] withAction:nil];
    }];
}
-(void)doRefreshWithAction:(void (^)(void))preLoad andSuccess:(void (^)(void))actionSucces andActionFail:(void (^)(NSString * _Nonnull))actionError{
    AppInfo *appInfo = [[Sdk sharedInstance] getAppInfo];
    NSString * refreshToken = [[Sdk sharedInstance] refreshToken];
    NSDictionary *body = @{
        request_jwt:refreshToken,
        request_cid:appInfo.client_id,
        request_client_id: appInfo.client_id
    };
    if(preLoad != NULL){
        preLoad();
    }
    [[IdApiRequest sharedInstance] callPostMethod:PATH_REFRESH_TOKEN withBody:body withToken:nil completion:^(id  _Nullable result) {
        [Utils logMessage:[NSString stringWithFormat:@"refresh content %@",result]];
        //[self hideLoading];
        LoginJson *loginJson = [[LoginJson alloc] initFromDictionary:result];
        if(loginJson != NULL){
            if(loginJson.statusCode == CODE_0){
                //success
                [[DataUtils sharedInstance] saveAccessToken:loginJson.data.accessToken];
                if(actionSucces != NULL){
                    actionSucces();
                }
            }
            else{
                NSString *errorText = [TSLanguageManager localizedString:[NSString stringWithFormat:@"E_CODE_%d",loginJson.statusCode]];
                if([errorText containsString:@"E_CODE_"]){
                    if(![Utils isNullOrEmpty:loginJson.message]){
                        errorText = loginJson.message;
                    }
                    else{
                        errorText = [TSLanguageManager localizedString:@"Lỗi không xác định"];
                    }
                }
                if(actionError!= NULL){
                    actionError(errorText);
                }
            }
        }
    } error:^(NSError * _Nonnull error,  id  _Nullable result,int httpCode) {
        [Utils logMessage:[NSString stringWithFormat:@"error %ld",error.code]];
        [Utils logMessage:[NSString stringWithFormat:@"desc %@",error.description]];
        //[self hideLoading];
        if(actionError != NULL){
            actionError([TSLanguageManager localizedString:@"Lỗi không xác định"]);
        };
    }];
}
@end
