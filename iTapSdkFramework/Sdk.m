//
//  Sdk.m
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import "Sdk.h"
#import <Firebase.h>
#import "Utils.h"
#import "LoginView.h"
#import "CheckLoginView.h"
#import "GetProductJson.h"
#import "DataUtils.h"
#import "FloatingButton.h"
#import "ResponseJson.h"
#import "DashboardView.h"
#import <StoreKit/StoreKit.h>
#import "SKProduct+LocalizedPrice.h"
#import "TSLanguageManager.h"
#import "LoadingView.h"
#import "GameApiRequest.h"
#import "IdApiRequest.h"
#import "PaymentApiRequest.h"
#import "LoginJson.h"
#import "OrderJson.h"
#import "UpdatePushIDRepo.h"
#import "GameConfigRepo.h"
#import <GoogleSignIn.h>
#import <FirebaseCore/FIRApp.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <AppsFlyerLib/AppsFlyerLib.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>
#import "MaitainCheckerJson.h"
#import "PaymentView.h"
#import "WelcomeView.h"
@interface Sdk()<SKProductsRequestDelegate,SKPaymentTransactionObserver,FIRMessagingDelegate,UNUserNotificationCenterDelegate,AppsFlyerLibDelegate>

@property (nonatomic, weak) id<SdkDelegate> delegate;
@property (nonatomic, weak) UIApplication* uiApplicaion;
@property (nonatomic, copy) GetProductTask getProductTask;
@property (nonatomic, strong) NSMutableArray<IAPProduct*> *products;
@property (nonatomic, strong) AppInfo* appInfo;

@property (nonatomic, strong) NSString* serverId;
@property (nonatomic, strong) NSString* characterId;
//@property (nonatomic, strong) NSString* paymentOrderId;

@property BOOL enableTrackingFirebase;
@property BOOL enableTrackingFacebook;
@property BOOL enableTrackingAppsflyer;
@property BOOL prodEnv;
@end

@implementation Sdk
{
    BOOL isShowFloatingButton;
    FloatingButton *floatingButton;
    SKProductsRequest *request;
    LoadingView *loadingView;
    BOOL isInited;
    NSString* lastCharacterLevel;
    NSString* lastCharacterVip;
}
NSString *const kGCMMessageIDKey = @"gcm.message_id";
+ (Sdk *)sharedInstance{
    static Sdk *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[Sdk alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self->isShowFloatingButton = FALSE;
        self.enableTrackingFirebase = TRUE;
        self.enableTrackingFacebook = TRUE;
        self.enableTrackingAppsflyer = TRUE;
        self.prodEnv = TRUE;
        //add Transaction observer
        //[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}
-(void)dealloc{
    //[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    if(options == NULL){
        BOOL handledFB = [[FBSDKApplicationDelegate sharedInstance] application:application
            openURL:url
            sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
            annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
          ];
        BOOL handledGG = [GIDSignIn.sharedInstance handleURL:url];
        return handledFB || handledGG;
    }
    else{
        BOOL handledFB = [[FBSDKApplicationDelegate sharedInstance] application:application
            openURL:url
            sourceApplication:nil
            annotation:nil
          ];
        BOOL handledGG = [GIDSignIn.sharedInstance handleURL:url];
        return handledFB || handledGG;
    }
    
}
- (void)initWithDelegate:(id<SdkDelegate>)delegate appInfo:(AppInfo *)appInfo application:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions language:(NSString *)lang
{
    NSLog(@"initWithDelegate");
    /*self.enableTrackingFirebase = TRUE;
     self.enableTrackingFacebook = TRUE;
     self.enableTrackingAppsflyer = TRUE;*/
    
    self.delegate = delegate;
    self.uiApplicaion = application;
    
    [IdApiRequest sharedInstance];
    [GameApiRequest sharedInstance];
    [PaymentApiRequest sharedInstance];
    [TSLanguageManager setSelectedLanguage:lang];
    self.appInfo = appInfo;
    if(appInfo != nil){
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:appInfo.firebaseConfigFile ofType:@"plist"];
        FIROptions *options = [[FIROptions alloc] initWithContentsOfFile:filePath];
        [FIRApp configureWithOptions:options];
        [FIRMessaging messaging].delegate = self;
        
        //config facebook core
        [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
        
        [FBSDKSettings enableLoggingBehavior:FBSDKLoggingBehaviorAppEvents];
        
        [FBSDKSettings setAutoLogAppEventsEnabled:YES];
        [FBSDKSettings setAdvertiserIDCollectionEnabled:YES];
        [FBSDKSettings setAdvertiserTrackingEnabled:YES];
        //config appsflyer
        if(![Utils isNullOrEmpty:appInfo.afDevKey] && ![Utils isNullOrEmpty:appInfo.afAppId]){
            [[AppsFlyerLib shared] setAppsFlyerDevKey:appInfo.afDevKey];
            [[AppsFlyerLib shared] setAppleAppID:appInfo.afAppId];
            
            //[AppsFlyerLib shared].isDebug = true;
            [[AppsFlyerLib shared] waitForATTUserAuthorizationWithTimeoutInterval:60];
            // Must be called AFTER setting appsFlyerDevKey and appleAppID
            [AppsFlyerLib shared].delegate = self;
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(sendLaunch:)
                                                         name:UIApplicationDidBecomeActiveNotification
                                                       object:nil];
        }
        else{
            NSLog(@"No find appsflyer configuration. We need DevKey and AppId of your project");
        }
        //[self askAllowATT];
        //show ask notification
        //[self askAllowNotification:application];
        //get game config from server
        GameConfigRepo *gameConfigRepo = [[GameConfigRepo alloc] init];
        [gameConfigRepo execute];
    }
    else{
        NSLog(@"No find app configuration");
    }
}
-(void) checkInit{
    //tracking app open event
    [self trackingEvent:EVENT_APP_LAUNCH withParams:nil];
    //tracking in the case of first open
    bool isFirstLaunch = [[DataUtils sharedInstance] isFirstLaunch];
    if(!isFirstLaunch){
        [[DataUtils sharedInstance] saveIsFirstLaunch:TRUE];
        [self trackingEvent:EVENT_FIRST_LAUNCH withParams:nil];
    }
    NSString* lastVersion = [[DataUtils sharedInstance] getStringValue:KeyLastestVersion];
    if(![Utils isNullOrEmpty:lastVersion]){
        if(self.appInfo != NULL && self.appInfo.version != NULL && ![self.appInfo.version isEqual:lastVersion]){
            [[DataUtils sharedInstance] setStringValue:self.appInfo.version forKey:KeyLastestVersion];
            [self trackingEvent:EVENT_UPGRADE_VERSION_SUCCESS withParams:nil];
        }
    }
    else{
        if(self.appInfo != NULL && self.appInfo.version != NULL){
            [[DataUtils sharedInstance] setStringValue:self.appInfo.version forKey:KeyLastestVersion];
        }
    }
}
- (void)sendLaunch:(NSString *)applicationState {
    if(!isInited){
        [self askAllowATT];
        //show ask notification
        [self askAllowNotification:[UIApplication sharedApplication]];
        isInited = true;
        [self checkInit];
    }
    [[AppsFlyerLib shared] start];
    NSLog(@"Application active");
    
    
}
-(void) askAllowATT{
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            // Tracking authorization completed. Start loading ads here.
            if(status == ATTrackingManagerAuthorizationStatusAuthorized){
                [FBSDKSettings setAdvertiserTrackingEnabled:YES];
                [FBSDKSettings setAdvertiserIDCollectionEnabled:YES];
            }
            else{
                [FBSDKSettings setAdvertiserTrackingEnabled:NO];
            }
        }];
    }
}
-(void) askAllowNotification:(UIApplication*) application{
    
    // Register for remote notifications. This shows a permission dialog on first run, to
    // show the dialog at a more appropriate time move this registration accordingly.
    // [START register_for_notifications]
    if ([UNUserNotificationCenter class] != nil) {
        // iOS 10 or later
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
        UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter]
         requestAuthorizationWithOptions:authOptions
         completionHandler:^(BOOL granted, NSError * _Nullable error) {
            // ...
            if(granted){
                NSLog(@"grant");
            }
        }];
    } else {
        // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    [application registerForRemoteNotifications];
}
-(void)logout{
    
    NSString* refreshToken = [[Sdk sharedInstance] refreshToken];
    NSString* clientId = @"";
    if(_appInfo != NULL){
        clientId = _appInfo.client_id;
    }
    //if(accessToken == NULL) return;
    if(isShowFloatingButton){
        [self showOrHideFloatingButton];
    }
    NSDictionary* body = @{
        request_jwt:refreshToken,
        request_cid: clientId,
        request_client_id: clientId
    };
    [[IdApiRequest sharedInstance] callPostMethod:PATH_LOGOUT withBody:body withToken:nil completion:^(id  _Nullable result) {
        [Utils logMessage:[NSString stringWithFormat:@"Signout: %@",result]];
    } error:^(NSError * _Nonnull error, id  _Nullable result, int httpCode) {
        
    }];
    FBSDKAccessToken *fbAccessToken = [FBSDKAccessToken currentAccessToken];
    if(fbAccessToken != NULL && !fbAccessToken.isExpired){
        FBSDKLoginManager * loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
    }
    
    if([GIDSignIn.sharedInstance hasPreviousSignIn]){
        [GIDSignIn.sharedInstance signOut];
    }
    NSDictionary* payload = [Utils getPayloadInToken:refreshToken];
    User* userInfo = [[User alloc] init];
    if(payload != NULL){
        NSNumber* uid = [Utils getAccountIdInPayload:refreshToken usingCache:payload];
        if(uid != NULL){
            userInfo.accountID = [uid longValue];
        }
        NSString* userName = [Utils getAccountNameInPayload:refreshToken usingCache:payload];
        if(userName != NULL){
            userInfo.accountName = userName;
        }
    }
    [[DataUtils sharedInstance] clearData];
    [self trackingEvent:EVENT_LOGOUT_SUCCESS withParams:nil];
    [self.delegate logout:userInfo];
}
-(void)forceLogout{
    NSString* refreshToken = [[Sdk sharedInstance] refreshToken];
    if(isShowFloatingButton){
        [self showOrHideFloatingButton];
    }
    FBSDKAccessToken *fbAccessToken = [FBSDKAccessToken currentAccessToken];
    if(fbAccessToken != NULL && !fbAccessToken.isExpired){
        FBSDKLoginManager * loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
    }
    if([GIDSignIn.sharedInstance hasPreviousSignIn]){
        [GIDSignIn.sharedInstance signOut];
    }
    NSDictionary* payload = [Utils getPayloadInToken:refreshToken];
    User* userInfo = [[User alloc] init];
    if(payload != NULL){
        NSNumber* uid = [Utils getAccountIdInPayload:refreshToken usingCache:payload];
        if(uid != NULL){
            userInfo.accountID = [uid longValue];
        }
        NSString* userName = [Utils getAccountNameInPayload:refreshToken usingCache:payload];
        if(userName != NULL){
            userInfo.accountName = userName;
        }
    }
    [[DataUtils sharedInstance] clearData];
    [self trackingEvent:EVENT_LOGOUT_SUCCESS withParams:nil];
    if(self.delegate != nil){
        [self.delegate logout:userInfo];
    }
}
-(void)login{
    if(_appInfo != NULL && _appInfo.packageId != NULL){
        NSString *version = _appInfo.version == NULL ? @"1.0": _appInfo.version;
        NSDictionary *params = @{
            request_app_package:_appInfo.packageId,
            request_channel: [_appInfo.platformOS lowercaseString],
            request_version: version
        };
        [[GameApiRequest sharedInstance] callGetMethod:PATH_GAME_CHECK_MAINTAIN withParams:params withBody:nil withToken:nil completion:^(id  _Nullable result) {
            [Utils logMessage:result];
            MaitainCheckerJson * resultJson = [[MaitainCheckerJson alloc] initFromDictionary:result];
            if(resultJson.statusCode == CODE_0){
                if(resultJson.data.isMaintained){
                    NSString* msg = resultJson.data.messageMaintain;
                    UIAlertController * alert = [UIAlertController
                                                 alertControllerWithTitle:[TSLanguageManager localizedString:@"Thông báo"]
                                                 message:msg
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    
                    //Add Buttons
                    
                    UIAlertAction* yesButton = [UIAlertAction
                                                actionWithTitle:[TSLanguageManager localizedString:@"Đồng ý"]
                                                style:UIAlertActionStyleDefault
                                                handler:nil];
                    [alert addAction:yesButton];
                    UIViewController * rootView = [Utils topViewController];
                    [rootView presentViewController:alert animated:YES completion:nil];
                    return;
                }
                else{
                    [self realLogin:resultJson];
                }
            }
            else{
                [self realLogin:NULL];
            }
        } error:^(NSError * _Nonnull error, id  _Nullable result, int httpCode) {
            [self realLogin:NULL];
            //Tracking fail api
            NSDictionary* eventParams = @{
                PARAM_API: @"hub_app_config_api"
            };
            [[Sdk sharedInstance] trackingEvent:EVENT_ERROR_API withParams:eventParams];
        }];
    }
    
}

-(void) realLogin:(MaitainCheckerJson*) checker{
    //User *current = [self currentUser];
    NSString *accessToken = [self accessToken];
    NSString *refreshToken = [self refreshToken];
    if(refreshToken != NULL && accessToken != NULL){
        [self showCheckLoginUI];
    }
    else{
        [self showLoginUI:checker];
    }
}

-(void)showLoading{
    UIViewController *topViewController = [Utils topViewController];
    //display loading
    if(self->loadingView == NULL){
        self->loadingView = (LoadingView*)[Utils loadViewFromNibFile:[LoadingView class] universalWithNib:@"LoadingView"];
    }
    self->loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    [topViewController.view addSubview:self->loadingView];
    [Utils addConstraintForChild:topViewController.view andChild:self->loadingView withLeft:0 withTop:0 andRight:0 withBottom:0];
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @0.0f;
    animation.toValue = @(2*M_PI);
    animation.duration = 1;             // this might be too fast
    animation.repeatCount = HUGE_VALF;     // HUGE_VALF is defined in math.h so import it
    [self->loadingView.iconLoading.layer addAnimation:animation forKey:@"rotation"];
}
-(void)hideLoading{
    if(self->loadingView != NULL && self->loadingView.superview != NULL){
        [self->loadingView removeFromSuperview];
    }
}

-(void) showCheckLoginUI{
    UIViewController *topView = [Utils topViewController];
    
    BaseView *customView =(BaseView*) [Utils loadViewFromNibFile:[CheckLoginView class] universalWithNib:@"CheckLoginView"];
    customView.delegate = self.delegate;
    customView.callback = ^(NSString* identifier) {
        NSLog(@"Hide %@",identifier );
    };
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    topView.view.tag = 200;
    [topView.view addSubview:customView];
    [Utils addConstraintForChild:topView.view andChild:customView withLeft:0 withTop:0 andRight:0 withBottom:0];
}

-(void) showPaymentUI:(NSArray<IAPProduct*>*) listProducts andServerId:(NSString*)serverId andCharacterId:(NSString*) characterId andProductId:(NSString*)productId{
    UIViewController *topView = [Utils topViewController];
    
    PaymentView *customView =(PaymentView*) [Utils loadViewFromNibFile:[PaymentView class] universalWithNib:@"PaymentView"];
    customView.products = listProducts;
    customView.serverId = serverId;
    customView.characterId = characterId;
    customView.productId = productId;
    customView.delegate = self.delegate;
    customView.callback = ^(NSString* identifier) {
        NSLog(@"Hide %@",identifier );
    };
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    topView.view.tag = 200;
    [topView.view addSubview:customView];
    [Utils addConstraintForChild:topView.view andChild:customView withLeft:0 withTop:0 andRight:0 withBottom:0];
}

-(void) showLoginUI:(MaitainCheckerJson*) checker{
    UIViewController *topView = [Utils topViewController];
    
    LoginView *customView =(LoginView*) [Utils loadViewFromNibFile:[LoginView class] withNib:@"LoginView"];
    customView.maitainCheckerJson = checker;
    customView.delegate = self.delegate;
    customView.callback = ^(NSString* identifier) {
        NSLog(@"Hide %@",identifier );
    };
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    topView.view.tag = 200;
    [topView.view addSubview:customView];
    [Utils addConstraintForChild:topView.view andChild:customView withLeft:0 withTop:0 andRight:0 withBottom:0];
    
}
-(User *)currentUser:(NSString*) key;{
    if([Utils isNullOrEmpty:key]){
        return nil;
    }
    return nil;
}
-(void)testFunction{
    NSString* jsonString = @"{\"success\": true,\"data\": {\"access_token\":\"eyJhbGciOiJSUzI1NiIsImtpZCI6IjEzRURDNUNCRkNDQjlBQjRFQTBBRjk1MDFFQUM4NUIxIiwidHlwIjoiYXQrand0In0.eyJuYmYiOjE2MzM1MTExNTUsImV4cCI6MTYzMzUxMTQ1NSwiaXNzIjoiaHR0cHM6Ly9pZC1zYW5kYm94LnZ0dmxpdmUudm4iLCJhdWQiOiJJZGVudGl0eVNlcnZlckFwaSIsImNsaWVudF9pZCI6ImdhbWVfaHViIiwic3ViIjoiNzFjOGYyNjEtZmUwMy00YmNlLTgwNDEtMTcwZWRkZWY3ZDcyIiwiYXV0aF90aW1lIjoxNjMzNTExMTI4LCJpZHAiOiJsb2NhbCIsImlhdCI6MTYzMzUxMTE1NSwic2NvcGUiOlsib3BlbmlkIiwicHJvZmlsZSIsIklkZW50aXR5U2VydmVyQXBpIiwiYWRkcmVzcyJdfQ.cbdr4U-MSELIptGluaN4_-gg360NPfbRBGlnXg_rFFlVukX4cCTOVkLotJuGt_b6YcFtMMfEMPFI9ZDpL-KT97BpR_3h406r5uJoswQOJ6nEaqvaamGrBmjcAZqEoBP8pIm62sVhrAR-CVI5IN9nva-MQtGwwyyaKRZqmO-vFxb9vHuSFP4T9NamlHpjBqiQGCWGrOqKAsdkkuzAaMbXsJoPdsad0fOj5UirK7pyD40vu6jZBX5nwVlh78Uw2kC2FxZDvXRyZiR2MIqU1NcKdFijR8DCV-bYwU4fooRXfFCiwV9Af2g7j5oP2-skRALcJ0P8vJu5xB1J4lZ728eb6w\",\"refresh_token\":\"A5F53444DC10A2F8A5106F1BE6FCCE8432DDCDB2AEDFDDFAC1DA140E016CDBD8\",\"user\": null},\"messages\": null,\"statusCode\": 200}";
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    LoginJson *loginJson = [[LoginJson alloc] initFromDictionary:json];
    if(loginJson != NULL){
        
    }
}
-(id)getDelegate{
    return self.delegate;
}
-(void)showOrHideFloatingButton{
    NSString *refreshToken = [self refreshToken];
    NSString *accessToken = [self accessToken];
    if(refreshToken == NULL && accessToken == NULL){
        return;
    }
    
    UIViewController *topView = [Utils topViewController];
    __weak typeof(self) weakSelf = self;
    float initX = 0;
    float initY = 100;
    float width = 50;
    float height = 50;
    float offsetX = 0 ;
    offsetX = width * 0.2;
    if(floatingButton == NULL){
        
        floatingButton = [[FloatingButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [floatingButton setOffSetX:offsetX];
        UIImage *icon = [UIImage imageNamed:@"BtnDashboard"
                                   inBundle:[NSBundle bundleForClass:self.class]
              compatibleWithTraitCollection:nil];
        [floatingButton setImage:icon];
        floatingButton.onClick = ^{
            NSLog(@"onClick");
            
            DashboardView *customView = (DashboardView*)[Utils loadViewFromNibFile:[DashboardView class] withNib:@"DashboardView"];
            customView.callback = ^(NSString* identifier) {
                NSLog(@"Hide %@",identifier );
            };
            customView.translatesAutoresizingMaskIntoConstraints = NO;
            topView.view.tag = 200;
            [topView.view addSubview:customView];
            [Utils addConstraintForChild:topView.view andChild:customView withLeft:0 withTop:0 andRight:0 withBottom:0];
        };
        floatingButton.onRemove = ^{
            [weakSelf showOrHideFloatingButton];
        };
        
    }
    if(floatingButton != NULL){
        isShowFloatingButton = !isShowFloatingButton;
        if(isShowFloatingButton && floatingButton.superview == NULL){
            floatingButton.center = CGPointMake(initX+width*0.5 - offsetX, initY - height*0.5);
            [topView.view addSubview:floatingButton];
        }
        if(!isShowFloatingButton && floatingButton.superview != NULL){
            [floatingButton removeFromSuperview];
        }
    }
}
-(void)payProduct:(NSString *)productID forCharacterId:(NSString *)characterId onServerId:(NSString *)serverId{
    if([self.products count] == 0){
        [self showDialogConfirm:[TSLanguageManager localizedString:@"Không có sản phẩm"] withAction:nil];
        [self listProducts:nil];
        return;
    }
    else{
        IAPProduct* findProductItem = nil;
        if(self.products != NULL){
            for (int j=0; j< self.products.count; j++) {
                IAPProduct* productItem = [self.products objectAtIndex:j];
                if([productItem.productId isEqual:productID]){
                    findProductItem = productItem;
                    break;
                }
            }
        }
        if(findProductItem == nil){
            [self showDialogConfirm:[TSLanguageManager localizedString:@"Không có sản phẩm"] withAction:nil];
            return;
        }
    }
   
    self.serverId = serverId;
    self.characterId = characterId;
    [[DataUtils sharedInstance] setStringValue:self.serverId forKey:trans_server];
    [[DataUtils sharedInstance] setStringValue:self.characterId forKey:trans_character];
    NSString* accessToken = [[Sdk sharedInstance] accessToken];
    if([Utils isNullOrEmpty:accessToken]){
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:[TSLanguageManager localizedString:@"Thông báo"]
                                     message:[TSLanguageManager localizedString:@"Bạn cần đăng nhập"]
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        //Add Buttons
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:[TSLanguageManager localizedString:@"Đồng ý"]
                                    style:UIAlertActionStyleDefault
                                    handler:nil];
        [alert addAction:yesButton];
        UIViewController *topView = [Utils topViewController];
        [topView presentViewController:alert animated:YES completion:nil];
        return;
    }
    else{
        
        NSArray<IAPProduct*> * listProducts = [[NSArray alloc]initWithArray:self.products];
        
        [self showPaymentUI:listProducts andServerId:serverId andCharacterId:characterId andProductId:productID];
        return;
        
        /*AppInfo* appInfo = [[Sdk sharedInstance] getAppInfo];
        NSDictionary* body = @{
            request_jwt:accessToken,
            request_client_id:appInfo.client_id,
            request_cid:appInfo.client_id,
            request_Os:[appInfo.platformOS lowercaseString],
            request_maker_code :productID,
            request_server_id:serverId,
            request_character_id:characterId
        };
        __weak typeof(self) weakSelf = self;
        [[PaymentApiRequest sharedInstance] callPostMethod:PATH_PAYMENT_CREATE_ORDER_IAP withBody:body withToken:nil completion:^(id  _Nullable result) {
            [Utils logMessage:[NSString stringWithFormat:@"result %@",result]];
            OrderJson* respJson = [[OrderJson alloc] initFromDictionary:result];
            if(respJson != NULL){
                if(respJson.statusCode == CODE_0){
                    //self.paymentOrderId = [NSString stringWithFormat:@"%ld",respJson.data.transId];
                    //[Utils logMessage:[NSString stringWithFormat:@"paymentOrderId %@",self.paymentOrderId]];
                    NSString* paymentOrderId = [NSString stringWithFormat:@"%ld",respJson.data.transId];
                    
                    SKMutablePayment *payment = [[SKMutablePayment alloc] init] ;
                    payment.productIdentifier = productID;
                    //payment.applicationUsername = self.paymentOrderId;
                    payment.applicationUsername = paymentOrderId;
                    //[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
                    [[SKPaymentQueue defaultQueue] addPayment:payment];
                    
                    NSDictionary*  eventParams = @{
                        AFEventParamContentId: productID
                    };
                    [self trackingEvent:EVENT_CLICK_PURCHASE withParams:eventParams];
                }
                else{
                    if(respJson.statusCode == CODE_86){
                        [self doRefreshWithAction:^{
                            [weakSelf payProduct:productID forCharacterId:characterId onServerId:serverId];
                        } andActionFail:^(NSString* errorString) {
                            UIAlertController * alert = [UIAlertController
                                                         alertControllerWithTitle:[TSLanguageManager localizedString:@"Thông báo"]
                                                         message:errorString
                                                         preferredStyle:UIAlertControllerStyleAlert];
                            
                            //Add Buttons
                            UIAlertAction* yesButton = [UIAlertAction
                                                        actionWithTitle:[TSLanguageManager localizedString:@"Đồng ý"]
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                            }];
                            [alert addAction:yesButton];
                            UIViewController *topView = [Utils topViewController];
                            [topView presentViewController:alert animated:YES completion:nil];
                        }];
                    }
                    else{
                        
                        NSString *errorText = [TSLanguageManager localizedString:[NSString stringWithFormat:@"E_CODE_%d",respJson.statusCode]];
                        if([errorText containsString:@"E_CODE_"]){
                            if(![Utils isNullOrEmpty:respJson.message]){
                                errorText = respJson.message;
                            }
                            else{
                                errorText = [TSLanguageManager localizedString:@"Lỗi không xác định"];
                            }
                        }
                        [self showDialogConfirm:errorText withAction:nil];
                    }
                }
            }
        } error:^(NSError * _Nonnull error, id  _Nullable result, int httpCode) {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:[TSLanguageManager localizedString:@"Thông báo"]
                                         message:[TSLanguageManager localizedString:@"Lỗi không xác định"]
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            //Add Buttons
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:[TSLanguageManager localizedString:@"Đồng ý"]
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * _Nonnull action) {
                [[Sdk sharedInstance] forceLogout];
            }];
            [alert addAction:yesButton];
            UIViewController *topView = [Utils topViewController];
            [topView presentViewController:alert animated:YES completion:nil];
        }];*/
    }
}
-(void)listProducts:(GetProductTask) completeTask{
    //get api about product
    AppInfo *appInfo = self.appInfo;
    if(appInfo != NULL){
        NSDictionary* params = @{
            request_app_package:appInfo.packageId,
            request_channel:[appInfo.platformOS lowercaseString]
        };
        NSString* accessToken = [self accessToken];
        if(completeTask != NULL){
            self.getProductTask = completeTask;
        }
        __weak typeof(self) weakSelf = self;
        [[GameApiRequest sharedInstance] callGetMethod:PATH_GAME_LIST_PRODUCTS withParams:params withBody:nil withToken:accessToken completion:^(id  _Nullable result) {
            [Utils logMessage:[NSString stringWithFormat:@"result: %@", result]];
            GetProductJson *resp = [[GetProductJson alloc] initFromDictionary:result];
            if(resp != NULL){
                if(resp.statusCode == CODE_0){
                    weakSelf.products = [[NSMutableArray alloc] initWithArray:resp.data.listProduct];
                    [weakSelf validateProductIdentifiers];
                }
                else{
                    if(resp.statusCode == CODE_86){
                        [self doRefreshWithAction:^{
                            [weakSelf listProducts:self.getProductTask];
                        } andActionFail:^(NSString* errorString) {
                            NSError *error = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:CODE_PAYMENT_ERROR_NO_CONFIG userInfo:@{NSLocalizedDescriptionKey: errorString}];
                            
                            weakSelf.getProductTask(error,weakSelf.products);
                        }];
                    }
                }
            }
        } error:^(NSError * _Nonnull error, id  _Nullable result,int httpCode) {
            
        }];
    }
    else{
        if(completeTask != NULL){
            NSError *error = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:CODE_PAYMENT_ERROR_NO_CONFIG userInfo:@{NSLocalizedDescriptionKey: @"No config appInfo"}];
            completeTask(error,nil);
        }
    }
    
}
// Custom method.
- (void)validateProductIdentifiers
{
    if(self.products.count > 0){
        
        NSMutableArray * productIdentifiers = [[NSMutableArray alloc] init];
        for (int i=0; i<self.products.count; i++) {
            IAPProduct* item = [self.products objectAtIndex:i];
            NSString* productId= [[NSString alloc] initWithString:item.productId];
            [productIdentifiers addObject:productId];
        }
        
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc]
                                              initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
        
        // Keep a strong reference to the request.
        self->request = productsRequest;
        productsRequest.delegate = self;
        [productsRequest start];
    }
    else{
        if(self.getProductTask != NULL){
            NSError *error = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:CODE_PAYMENT_ERROR_NO_CONFIG userInfo:@{NSLocalizedDescriptionKey: @"No product available"}];
            
            self.getProductTask(error,self.products);
        }
    }
    
}

- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response
{
    NSArray<SKProduct *> *products = response.products;
    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
        // Handle any invalid product identifiers.
        NSLog(@"invalidIdentifier: %@",invalidIdentifier);
    }
    for (int i=0; i <products.count; i++) {
        SKProduct *item = [products objectAtIndex:i];
        NSLog(@"item.price: %f",item.price.floatValue);
        NSLog(@"item.localizedTitle: %@",item.localizedTitle);
        NSLog(@"item.localizedPrice: %@",[item localizedPrice]);
        NSLog(@"item.currencyCode: %@",[item currencyCode]);
        NSLog(@"item.productIdentifier: %@",item.productIdentifier);
        NSLog(@"item.localizedDescription: %@",item.localizedDescription);
        for (int j=0; j< self.products.count; j++) {
            IAPProduct* vnptItem = [self.products objectAtIndex:j];
            if([item.productIdentifier isEqual:[vnptItem productId]]){
                vnptItem.price = item.price;
                vnptItem.localizedPrice = [item localizedPrice];
                vnptItem.priceLocale = item.priceLocale;
                vnptItem.currencyCode = [item currencyCode];
            }
        }
    }
    if(self.getProductTask != NULL){
        self.getProductTask(nil,self.products);
    }
}
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    NSLog(@"paymentQueue...");
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
                // Call the appropriate custom method for the transaction state.
            case SKPaymentTransactionStatePurchasing:
                
                break;
            case SKPaymentTransactionStateDeferred:
                
                break;
            case SKPaymentTransactionStateFailed:
                [self fail:transaction];
                break;
            case SKPaymentTransactionStatePurchased:
                [self complete:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restore:transaction];
                break;
            default:
                // For debugging
                NSLog(@"Unexpected transaction state %@", @(transaction.transactionState));
                break;
        }
    }
}

-(void)complete:(SKPaymentTransaction*) transaction{
    NSLog(@"complete...");
    if(transaction.payment != NULL && transaction.payment.applicationUsername != NULL){
        NSLog(@"transaction.payment: %@",transaction.payment.applicationUsername);
    }
    //[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    IAPProduct* findProductItem = nil;
    if(self.products != NULL){
        for (int j=0; j< self.products.count; j++) {
            IAPProduct* productItem = [self.products objectAtIndex:j];
            if([productItem.productId isEqual:transaction.payment.productIdentifier]){
                findProductItem = productItem;
                break;
            }
        }
    }
    NSString * revenue = @"0";
    NSString * currency = @"VND";
    if(findProductItem != nil){
        revenue = [findProductItem.price stringValue];
        currency  = findProductItem.currencyCode;
    }
    NSDictionary*  eventParams = @{
        AFEventParamContentId: transaction.payment.productIdentifier,
        AFEventParamReceiptId: transaction.transactionIdentifier,
        AFEventParamOrderId: transaction.transactionIdentifier,
        AFEventParamQuantity: [[NSNumber numberWithInt:transaction.payment.quantity] stringValue],
        AFEventParamRevenue: revenue,
        AFEventParamCurrency :currency
    };
    [self trackingEvent:EVENT_FINISH_PURCHASE withParams:eventParams];
    
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
    TransactionInfo *trans = [[TransactionInfo alloc] init];
    trans.productId = transaction.payment.productIdentifier;
    trans.transId = transaction.transactionIdentifier;
    AppInfo *appInfo = [self appInfo];
    if(appInfo != NULL){
        if([Utils isNullOrEmpty:appInfo.client_id]){
            [Utils logMessage:@"client_id null"];
            if(self.delegate != NULL){
                [self.delegate didPurchaseFailed:trans purchaseError:@"Error config not available"];
            }
            return;
        }
        if([Utils isNullOrEmpty:appInfo.packageId]){
            [Utils logMessage:@"packageId null"];
            if(self.delegate != NULL){
                [self.delegate didPurchaseFailed:trans purchaseError:@"Error config not available"];
            }
            return;
        }
        if([Utils isNullOrEmpty:appInfo.platformOS]){
            [Utils logMessage:@"platformOS null"];
            if(self.delegate != NULL){
                [self.delegate didPurchaseFailed:trans purchaseError:@"Error config not available"];
            }
            return;
        }
    }
    if (!receipt) {
        NSLog(@"no receipt");
        /* No local receipt -- handle the error. */
    } else {
        /* Get the receipt in encoded format */
        NSString *encodedReceipt = [receipt base64EncodedStringWithOptions:0];
        NSLog(@"receipt: %@",encodedReceipt);
        
        NSString *accessToken = [self accessToken];
        
        trans.purchasedToken = encodedReceipt;
        //NSLog(@"purchasedToken: %@",trans.purchasedToken);
        NSString *keyChar = [NSString stringWithFormat:@"%@_%@",trans_character,trans.purchasedToken];
        NSString *keySer = [NSString stringWithFormat:@"%@_%@",trans_server,trans.purchasedToken];
        //NSString *keyOrder = [NSString stringWithFormat:@"%@_%@",trans_order,trans.orderId];
        
        if(self.characterId != NULL){
            [[DataUtils sharedInstance] setStringValue:self.characterId forKey:keyChar];
        }
        if(self.serverId != NULL){
            [[DataUtils sharedInstance] setStringValue:self.serverId forKey:keySer];
        }
        /*if(self.paymentOrderId != NULL){
            [[DataUtils sharedInstance] setStringValue:self.paymentOrderId forKey:keyOrder];
        }*/
        
        if([Utils isNullOrEmpty:self.characterId]){
            self.characterId = [[DataUtils sharedInstance] getStringValue:keyChar];
        }
        if([Utils isNullOrEmpty:self.serverId]){
            self.serverId = [[DataUtils sharedInstance] getStringValue:keySer];
        }
        /*if([Utils isNullOrEmpty:self.paymentOrderId]){
            self.paymentOrderId = [[DataUtils sharedInstance] getStringValue:keyOrder];
        }*/
        
        if([Utils isNullOrEmpty:self.characterId]){
            self.characterId = [[DataUtils sharedInstance] getStringValue:trans_character];
        }
        if([Utils isNullOrEmpty:self.serverId]){
            self.serverId = [[DataUtils sharedInstance] getStringValue:trans_server];
        }
        /*if([Utils isNullOrEmpty:self.paymentOrderId]){
            self.paymentOrderId = [[DataUtils sharedInstance] getStringValue:trans_order];
        }*/
        
        /*if([Utils isNullOrEmpty:self.characterId] || [Utils isNullOrEmpty:self.serverId] || [Utils isNullOrEmpty:self.paymentOrderId]){
            NSLog(@"Try to finish because nil: %@",trans.orderId);
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            return;
        }*/
        
        //trans.paymentOrderId = self.paymentOrderId;
        NSString* paymentOrderID = @"";
        if(transaction.payment != NULL && ![Utils isNullOrEmpty:transaction.payment.applicationUsername]){
            paymentOrderID = transaction.payment.applicationUsername;
        }
        trans.paymentOrderId = paymentOrderID;
        
        if([Utils isNullOrEmpty:self.characterId] || [Utils isNullOrEmpty:self.serverId] || [Utils isNullOrEmpty:paymentOrderID]){
            NSLog(@"Try to finish because nil: %@",trans.purchasedToken);
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            return;
        }
        
        NSString *packageName = [[NSBundle mainBundle] bundleIdentifier];
        NSDictionary *body = @{
            request_jwt:accessToken,
            request_cid:appInfo.client_id,
            request_client_id:appInfo.client_id,
            request_Os: [appInfo.platformOS lowercaseString],
            @"bank_code" :encodedReceipt,
            @"transId" :trans.paymentOrderId,
            request_maker_code:transaction.payment.productIdentifier,
            request_character_id:self.characterId,
            request_server_id:self.serverId
        };
        [Utils logMessage:@"check receipt"];
        [[PaymentApiRequest sharedInstance] callPostMethod:PATH_PAYMENT_CONFIRM_ORDER_IAP withBody:body withToken:nil completion:^(id  _Nullable result) {
            [Utils logMessage:@"check receipt success"];
            [Utils logMessage:result];
            ResponseJson *resp = [[ResponseJson alloc] initFromDictionary:result];
            if(resp.statusCode == CODE_0){
                [Utils logMessage:@"finish receipt success"];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSString *key1 = [NSString stringWithFormat:@"%@_%@",trans_character,trans.purchasedToken];
                NSString *key2 = [NSString stringWithFormat:@"%@_%@",trans_server,trans.purchasedToken];
                //NSString *key3 = [NSString stringWithFormat:@"%@_%@",trans_order,trans.orderId];
                [[DataUtils sharedInstance] removeStringKey:key1];
                [[DataUtils sharedInstance] removeStringKey:key2];
                //[[DataUtils sharedInstance] removeStringKey:key3];
                [[DataUtils sharedInstance] removeStringKey:trans_character];
                [[DataUtils sharedInstance] removeStringKey:trans_server];
                //[[DataUtils sharedInstance] removeStringKey:trans_order];
                trans.confirmByServer = TRUE;
                self.characterId = nil;
                self.serverId = nil;
                
                NSDictionary*  eventParams = @{
                    AFEventParamContentId: transaction.payment.productIdentifier
                };
                [[Sdk sharedInstance] trackingEvent:EVENT_FINISH_SUCCESS withParams:eventParams];
                if(self.delegate != NULL){
                    [self.delegate didPurchaseSuccess:trans];
                }
            }
            else{
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSString *errorText = [TSLanguageManager localizedString:[NSString stringWithFormat:@"E_CODE_%d",resp.statusCode]];
                if([errorText containsString:@"E_CODE_"]){
                    if(![Utils isNullOrEmpty:resp.message]){
                        errorText = resp.message;
                    }
                    else{
                        errorText = [TSLanguageManager localizedString:@"Lỗi không xác định"];
                    }
                }
                NSDictionary*  eventParams = @{
                    AFEventParamContentId: transaction.payment.productIdentifier
                };
                [[Sdk sharedInstance] trackingEvent:EVENT_ERROR_PURCHASE withParams:eventParams];
                [self showDialogConfirm:errorText withAction:nil];
                
            }
        } error:^(NSError * _Nonnull error, id  _Nullable result,int httpCode) {
            [Utils logMessage:@"check receipt error"];
            NSDictionary*  eventParams = @{
                AFEventParamContentId: transaction.payment.productIdentifier
            };
            [[Sdk sharedInstance] trackingEvent:EVENT_ERROR_PURCHASE withParams:eventParams];
            
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            if(self.delegate != NULL){
                [self.delegate didPurchaseFailed:trans purchaseError:[TSLanguageManager localizedString:@"Lỗi không xác định"]];
            }
        }
        ];
    }
}

-(void)restore:(SKPaymentTransaction*) transaction{
    if(transaction.originalTransaction != NULL){
        NSLog(@"restore...%@",transaction.originalTransaction.payment.productIdentifier);
        
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

-(void)fail:(SKPaymentTransaction*) transaction{
    NSLog(@"fail...");
    if(transaction.error != NULL){
        NSString* localizedDescription =transaction.error.localizedDescription;
        if(transaction.error.code == SKErrorPaymentCancelled){
            NSLog(@"User cancel product");
            NSDictionary*  eventParams = @{
                AFEventParamContentId: transaction.payment.productIdentifier
            };
            [self trackingEvent:EVENT_CANCEL_PURCHASE withParams:eventParams];
        }
        else{
            NSLog(@"Transaction Error: %@",localizedDescription);
            TransactionInfo *trans = [[TransactionInfo alloc] init];
            trans.productId = transaction.payment.productIdentifier;
            trans.transId = NULL;
            if(self.delegate != NULL){
                [self.delegate didPurchaseFailed:trans purchaseError:localizedDescription];
            }
            NSDictionary*  eventParams = @{
                AFEventParamContentId: transaction.payment.productIdentifier
            };
            [self trackingEvent:EVENT_CANCEL_PURCHASE withParams:eventParams];
        }
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

-(void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken{
    [Utils logMessage:[NSString stringWithFormat:@"FCM registration token: %@", fcmToken]];
    [[DataUtils sharedInstance] saveFcmToken:fcmToken];
    [[DataUtils sharedInstance] saveRegisteredFcm:FALSE];
    // Notify about received token.
    /*NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
     [[NSNotificationCenter defaultCenter] postNotificationName:
     @"FCMToken" object:nil userInfo:dataDict];*/
}
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    // [START_EXCLUDE]
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        [Utils logMessage:[NSString stringWithFormat:@"Message ID: %@", userInfo[kGCMMessageIDKey]]];
    }
    // [END_EXCLUDE]
    
    // Print full message.
    [Utils logMessage:[NSString stringWithFormat:@"%@", userInfo]];
    
    // Change this to your preferred presentation option
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionAlert);
}
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        [Utils logMessage:[NSString stringWithFormat:@"Message ID: %@", userInfo[kGCMMessageIDKey]]];
    }
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    // Print full message.
    [Utils logMessage:[NSString stringWithFormat:@"%@", userInfo]];
    
    completionHandler();
}
- (NSString *)accessToken{
    return [[DataUtils sharedInstance] accessToken];
}
- (NSString *)refreshToken{
    return [[DataUtils sharedInstance] refreshToken];
}
-(AppInfo *)getAppInfo{
    return self.appInfo;
}
/*-(void)connectGame:(NSDictionary *)body andComplete:(void (^)(NSString * _Nonnull))handleComplete orError:(void (^)(NSError * _Nullable))handleError{
 NSString* accessToken = [self accessToken];
 if(accessToken == NULL){
 NSError *error = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:CODE_CONNECT_GAME userInfo:@{@"Error reason": @"No AccessToken"}];
 if(handleError != nil){
 handleError(error);
 }
 return;
 }
 
 [[GameApiRequest sharedInstance] callPostMethod:PATH_GAME_AUTH withBody:body withToken:accessToken completion:^(id  _Nullable result) {
 if(handleComplete != NULL){
 handleComplete(result);
 }
 } error:^(NSError * _Nonnull error, id  _Nullable result, int httpCode) {
 if(handleError != NULL){
 handleError(error);
 }
 }];
 //update push id
 NSString* pushId = [[DataUtils sharedInstance] fcmToken];
 UpdatePushIDRepo* updatePushIdRepo = [[UpdatePushIDRepo alloc] init];
 updatePushIdRepo.pushId = pushId;
 updatePushIdRepo.clientId = self.appInfo.client_id;
 updatePushIdRepo.platformOs = [self.appInfo.platformOS lowercaseString];
 updatePushIdRepo.accessToken = [[Sdk sharedInstance] accessToken];
 [updatePushIdRepo execute];
 }*/

-(void)doRefreshWithAction:(void (^)(void))actionSucces andActionFail:(void (^)(NSString*)) actionError{
    AppInfo *appInfo = [[Sdk sharedInstance] getAppInfo];
    NSString * refreshToken = [[Sdk sharedInstance] refreshToken];
    NSDictionary *body = @{
        request_jwt:refreshToken,
        request_cid:appInfo.client_id,
        request_client_id: appInfo.client_id
    };
    [[IdApiRequest sharedInstance] callPostMethod:PATH_REFRESH_TOKEN withBody:body withToken:nil completion:^(id  _Nullable result) {
        [Utils logMessage:[NSString stringWithFormat:@"refresh content %@",result]];
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
                if(actionError != NULL){
                    actionError(errorText);
                }
            }
        }
        else{
            if(actionError != NULL){
                actionError([TSLanguageManager localizedString:@"Lỗi không xác định"]);
            }
            
        }
    } error:^(NSError * _Nonnull error,  id  _Nullable result,int httpCode) {
        [Utils logMessage:[NSString stringWithFormat:@"error %ld",error.code]];
        [Utils logMessage:[NSString stringWithFormat:@"desc %@",error.description]];
        if(actionError != NULL){
            actionError([TSLanguageManager localizedString:@"Lỗi không xác định"]);
        }
    }];
}
-(void)mappingUser:(NSString *)characterName characterId:(NSString *)characterID characterLevel:(NSString *)characterLevel serverName:(NSString *)serverName serverId:(NSString *)serverID{
    NSString* accessToken = [self accessToken];
    if(![Utils isNullOrEmpty:accessToken]){
        AppInfo * appInfo = [[Sdk sharedInstance] getAppInfo];
        NSDictionary *body = @{
            request_app_package:appInfo.packageId,
            @"server":serverID,
            @"serverName":serverName,
            @"characterId":characterID,
            @"characterName":characterName,
            @"characterLevel":characterLevel,
            request_platformOS:[appInfo.platformOS lowercaseString],
            @"device": [[UIDevice currentDevice] name]
        };
        __weak typeof(self) weakSelf = self;
        [[GameApiRequest sharedInstance] callPostMethod:PATH_GAME_MAP_USER withBody:body withToken:accessToken completion:^(id  _Nullable result) {
            [Utils logMessage:[NSString stringWithFormat:@"result:  %@",result]];
            ResponseJson *respJson = [[ResponseJson alloc] initFromDictionary:result];
            if(respJson != NULL){
                if(respJson.statusCode == CODE_0){
                }
                else{
                    if(respJson.statusCode != CODE_86){
                    }
                    else{
                        [self doRefreshWithAction:^{
                            [weakSelf mappingUser:characterName characterId:characterID characterLevel:characterLevel serverName:serverName serverId:serverID];
                        } andActionFail:NULL];
                    }
                }
            }
            
        } error:^(NSError * _Nonnull error, id  _Nullable result, int httpCode) {
            [Utils logMessage:[NSString stringWithFormat:@"error result:  %@",result]];
        }];
    }
    
    [self levelUpUser:characterName characterId:characterID characterLevel:characterLevel serverName:serverName serverId:serverID vip:@"0"];
}
-(void)trackingEvent:(NSString *)eventName withParams:(NSDictionary *)params{
    if(![self isProdEnv]){
        eventName = [NSString stringWithFormat:@"dev_%@",eventName];
    }
    [Utils logMessage:[NSString stringWithFormat:@"LOG TAG: %@",eventName]];
    if(self.enableTrackingFirebase){
        [FIRAnalytics logEventWithName:eventName
                            parameters:params];
    }
    if(self.enableTrackingFacebook){
        [FBSDKAppEvents logEvent:eventName parameters:params];
    }
    if(self.enableTrackingAppsflyer){
        [[AppsFlyerLib shared]  logEvent: eventName withValues: params];
    }
}

-(void)trackingEventGoogleAndFace:(NSString *)eventName withParams:(NSDictionary *)params{
    if(![self isProdEnv]){
        eventName = [NSString stringWithFormat:@"dev_%@",eventName];
    }
    [Utils logMessage:[NSString stringWithFormat:@"LOG GOOGLEFACE TAG: %@",eventName]];
    if(self.enableTrackingFirebase){
        [FIRAnalytics logEventWithName:eventName
                            parameters:params];
    }
    if(self.enableTrackingFacebook){
        [FBSDKAppEvents logEvent:eventName parameters:params];
    }
}

-(void)trackingEventAppsflyer:(NSString *)eventName withParams:(NSDictionary *)params completionHandler:(void (^)(NSDictionary<NSString *,id> * _Nullable, NSError * _Nullable))completionHandler{
    if(![self isProdEnv]){
        eventName = [NSString stringWithFormat:@"dev_%@",eventName];
    }
    [Utils logMessage:[NSString stringWithFormat:@"LOG APPSFLYER TAG: %@",eventName]];
    if(self.enableTrackingAppsflyer){
        [[AppsFlyerLib shared]  logEventWithEventName:eventName eventValues:params completionHandler:completionHandler];
    }
}

-(void)enableTrackingFirebase:(BOOL)enableFirebase{
    self.enableTrackingFirebase = enableFirebase;
}
-(void)enableTrackingFacebook:(BOOL)enableFacebook{
    self.enableTrackingFacebook = enableFacebook;
}
-(void)enableTrackingAppsflyer:(BOOL)enableAppsflyer{
    self.enableTrackingAppsflyer = enableAppsflyer;
}

-(void)onConversionDataSuccess:(NSDictionary*) installData {
    @try{
        // Business logic for Non-organic install scenario is invoked
        id status = [installData objectForKey:@"af_status"];
        if([status isEqualToString:@"Non-organic"]) {
            //your code
            id sourceIDObj = [installData objectForKey:@"media_source"];
            NSString* sourceID = @"";
            if(![Utils isNullOrEmpty:sourceIDObj]){
                if([sourceIDObj isKindOfClass:[NSString class]]){
                    sourceID = (NSString*)sourceIDObj;
                }
            }
            id campaignObj = [installData objectForKey:@"campaign"];
            NSString* campaign = @"";
            if(![Utils isNullOrEmpty:campaignObj]){
                if([campaignObj isKindOfClass:[NSString class]]){
                    campaign = (NSString*)campaignObj;
                }
            }
            id adsetObj = [installData objectForKey:@"adset"];
            NSString* adset = @"";
            if(![Utils isNullOrEmpty:adsetObj]){
                if([adsetObj isKindOfClass:[NSString class]]){
                    adset = (NSString*)adsetObj;
                }
            }
            if([Utils isNullOrEmpty:adset]){
                id afAdsetObj = [installData objectForKey:@"af_adset"];
                if(![Utils isNullOrEmpty:afAdsetObj]){
                    if([afAdsetObj isKindOfClass:[NSString class]]){
                        adset = (NSString*)afAdsetObj;
                    }
                }
            }
            id channelObj = [installData objectForKey:@"channel"];
            NSString* channel = @"";
            if([Utils isNullOrEmpty:channelObj]){
                if([channelObj isKindOfClass:[NSString class]]){
                    channel = (NSString*)channelObj;
                }
            }
            if([Utils isNullOrEmpty:channel]){
                id afChannelObj = [installData objectForKey:@"af_channel"];
                if(![Utils isNullOrEmpty:afChannelObj]){
                    if([afChannelObj isKindOfClass:[NSString class]]){
                        channel = (NSString*)afChannelObj;
                    }
                }
            }
            NSLog(@"This is a Non-organic install. Media source: %@  Campaign: %@",sourceID,campaign);
            [[DataUtils sharedInstance] setStringValue:@"Non-organic" forKey:request_conversion_type];
            [[DataUtils sharedInstance] setStringValue:sourceID forKey:request_media_source];
            [[DataUtils sharedInstance] setStringValue:campaign forKey:request_campaign];
            [[DataUtils sharedInstance] setStringValue:adset forKey:request_adset];
            [[DataUtils sharedInstance] setStringValue:channel forKey:request_ads_channel];
        }
        
        else if([status isEqualToString:@"Organic"]) {
            // Business logic for Organic install scenario is invoked
            NSLog(@"This is an Organic install.");
            [[DataUtils sharedInstance] setStringValue:@"Organic" forKey:request_conversion_type];
        }
    }
    @catch (NSException* exception) {
        NSLog(@"Got exception: %@    Reason: %@", exception.name, exception.reason);
        [[DataUtils sharedInstance] setStringValue:@"None" forKey:request_conversion_type];
    }
    
    
}
-(void)onConversionDataFail:(NSError *) error {
    NSLog(@"%@",error);
}
-(NSString*)getLocalizedString:(NSString *)value{
    return [TSLanguageManager localizedString:value];
}
-(void) enableProdEnv:(BOOL) isProd{
    self.prodEnv = isProd;
}
-(BOOL) isProdEnv{
    return self.prodEnv;
}
-(void)showDialogConfirm:(NSString *)msg withAction:(void (^)(UIAlertAction*))action{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:[TSLanguageManager localizedString:@"Thông báo"]
                                 message:msg
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:[TSLanguageManager localizedString:@"Đồng ý"]
                                style:UIAlertActionStyleDefault
                                handler:action];
    [alert addAction:yesButton];
    UIViewController * rootView = [Utils topViewController];
    [rootView presentViewController:alert animated:YES completion:nil];
}
-(void)levelUpUser:(NSString *)characterName characterId:(NSString *)characterId characterLevel:(NSString *)characterLevel serverName:(NSString *)serverName serverId:(NSString *)serverId vip:(NSString*) vip{
    if([Utils isNullOrEmpty:characterLevel]) return;
    if([Utils isNullOrEmpty:vip]) return;
    
    if(![characterLevel isEqual:lastCharacterLevel]){
        [self trackingEvent:EVENT_LEVEL_ACHIEVEMENT withParams:nil];
    }
    if(![vip isEqual:lastCharacterVip]){
        [self trackingEvent:EVENT_VIP_ACHIEVEMENT withParams:nil];
    }
    if(self.appInfo != NULL && self.appInfo.achievedLevels != NULL){
        for (int i=0; i< self.appInfo.achievedLevels.count; i++) {
            NSString* itemLevel = [self.appInfo.achievedLevels objectAtIndex:i];
            if(![Utils isNullOrEmpty:itemLevel] && [itemLevel isEqual:characterLevel] && ![characterLevel isEqual:lastCharacterLevel]){
                NSString* valueTracking = [NSString stringWithFormat:@"%@_%@",EVENT_LEVEL_ACHIEVED_AT,itemLevel];
                [self trackingEvent:valueTracking withParams:nil];
            }
        }
    }
    if(self.appInfo != NULL && self.appInfo.achievedVips != NULL){
        for (int i=0; i< self.appInfo.achievedVips.count; i++) {
            NSString* itemLevel = [self.appInfo.achievedVips objectAtIndex:i];
            if(![Utils isNullOrEmpty:itemLevel] && [itemLevel isEqual:vip] && ![vip isEqual:lastCharacterVip]){
                NSString* valueTracking = [NSString stringWithFormat:@"%@_%@",EVENT_VIP_ACHIEVED_AT,itemLevel];
                [self trackingEvent:valueTracking withParams:nil];
            }
        }
    }
    lastCharacterLevel = characterLevel;
    lastCharacterVip = vip;
}
-(void)logStartGameScreen{
    [self trackingEvent:EVENT_SHOW_START_GAME withParams:nil];
}
-(void)logEnterGamePlay{
    [self trackingEvent:EVENT_ENTER_GAMEPLAY withParams:nil];
}
-(void)logStartTutorial{
    [self trackingEvent:EVENT_START_TUTORIAL withParams:nil];
}
-(void)logCompleteTutorial{
    [self trackingEvent:EVENT_COMPLETE_TUTORIAL withParams:nil];
}
-(void)logStartedResource{
    [self trackingEvent:EVENT_RESOURCE_STARTED withParams:nil];
}
-(void)logFinishedResource{
    [self trackingEvent:EVENT_RESOURCE_FINISHED withParams:nil];
}
-(void)logStartedExtraction{
    [self trackingEvent:EVENT_EXTRACT_STARTED withParams:nil];
}
-(void)logFinishedExtraction{
    [self trackingEvent:EVENT_EXTRACT_FINISHED withParams:nil];
}
-(void)logStartedCharacterCreation{
    [self trackingEvent:EVENT_CHARACTER_CREATION_STARTED withParams:nil];
}
-(void)logFinishedCharacterCreation{
    [self trackingEvent:EVENT_CHARACTER_CREATION_FINISHED withParams:nil];
}
@end
