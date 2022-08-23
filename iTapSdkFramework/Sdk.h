//
//  Sdk.h
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"
#import "TransactionInfo.h"
#import "AppInfo.h"
#import "IAPProduct.h"

typedef void (^GetProductTask)(NSError* error,NSArray<IAPProduct*>* _Nullable result);

@protocol SdkDelegate <NSObject,UIApplicationDelegate>
- (void)logout:(User *_Nonnull)user;

- (void)loginSuccess:(User *_Nonnull)user withAccessToken:(NSString*) accessToken andRefreshToken:(NSString*) refreshToken;

- (void)didPurchaseSuccess:(TransactionInfo *_Nonnull)transaction;

- (void)didPurchaseFailed:(TransactionInfo *_Nonnull)transaction purchaseError:(NSString*_Nullable)error;

@end

@interface Sdk : NSObject
+(Sdk*_Nonnull) sharedInstance;
-(void)initWithDelegate:(id<SdkDelegate>_Nullable)delegate
                appInfo:(AppInfo*_Nonnull)appInfo
            application:(UIApplication *_Nonnull)application
          launchOptions:(NSDictionary *_Nonnull)launchOptions language:(NSString*) lang;
-(id) getDelegate;
-(BOOL)application:(UIApplication *)application
           openURL:(NSURL *)url
           options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;
-(AppInfo*) getAppInfo;
-(void) login;
-(void) logout;
-(void) forceLogout;
-(NSString*_Nullable) accessToken;
-(NSString*_Nullable) refreshToken;
-(User*_Nullable) currentUser:(NSString*) key;
//-(void) testFunction;
-(void) showOrHideFloatingButton;
-(void) listProducts:(GetProductTask _Nonnull ) completeTask;
-(void) payProduct:(NSString* _Nonnull)productID forCharacterId:(NSString*) characterId onServerId:(NSString*) serverId;
/*-(void) connectGame:(NSDictionary*) body andComplete:(void(^_Nonnull)(NSString*_Nonnull)) handleComplete orError:(void(^_Nonnull)(NSError*_Nullable)) handleError;*/
-(void) mappingUser:(NSString*)characterName
        characterId:(NSString*)characterId
     characterLevel:(NSString*)characterLevel
        serverName:(NSString*)serverName
          serverId:(NSString*)serverId;

-(void) levelUpUser:(NSString*)characterName
        characterId:(NSString*)characterId
     characterLevel:(NSString*)characterLevel
        serverName:(NSString*)serverName
          serverId:(NSString*)serverId
                vip:(NSString*) vip;

-(void) trackingEvent:(NSString*) eventName withParams:(NSDictionary*) params;

-(void) trackingEventGoogleAndFace:(NSString*) eventName withParams:(NSDictionary*) params;

-(void) trackingEventAppsflyer:(NSString*) eventName withParams:(NSDictionary*) params completionHandler:(void (^ _Nullable)(NSDictionary<NSString *, id> * _Nullable dictionary, NSError * _Nullable error))completionHandler;

-(void) enableTrackingFirebase:(BOOL) enableFirebase;
-(void) enableTrackingFacebook:(BOOL) enableFacebook;
-(void) enableTrackingAppsflyer:(BOOL) enableAppsflyer;
-(void) enableProdEnv:(BOOL) isProd;
-(BOOL) isProdEnv;
-(NSString*) getLocalizedString:(NSString*) value;
-(void) showDialogConfirm:(NSString*) msg withAction:(void (^)(UIAlertAction*))action;
-(void) logStartGameScreen;
-(void) logEnterGamePlay;
-(void) logStartTutorial;
-(void) logCompleteTutorial;
-(void) logStartedResource;
-(void) logFinishedResource;
-(void) logStartedExtraction;
-(void) logFinishedExtraction;
-(void) logStartedCharacterCreation;
-(void) logFinishedCharacterCreation;
@end
