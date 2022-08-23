//
//  BaseView.h
//  testgame
//
//  Created by Tran Trong Cong on 8/10/21.
//

#import <UIKit/UIKit.h>
#import "Sdk.h"
#import "TSLanguageManager.h"
#import "Utils.h"
#import "IdApiRequest.h"
#import "DataUtils.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ViewHideCallback)(NSString* identifier);

@interface BaseView : UIView
@property (nonatomic, readwrite, copy) ViewHideCallback callback;
@property (nonatomic, assign) id<SdkDelegate> delegate;
//close view
-(IBAction)btnClose:(id)sender;
-(void)sayHi:(NSString*)userName;
-(void) initInternals;
-(void) configUI:(UIView*)parentView;
-(void)showLoading;
-(void)showLoading:(NSString*)note;
-(void)hideLoading;
-(void)showAlert:(NSString*)title withContent:(NSString*) content withAction:(void (^)(UIAlertAction*))action;
-(void)showAlertWith2Action:(NSString*)title withContent:(NSString*) content withOkAction:(void (^)(UIAlertAction*))okAction andCancelAction:(void (^)(UIAlertAction*))cancelAction;
-(void)showAlertWith2Action:(NSString *)title withContent:(NSString *)content withOkTitle:(NSString*) okTitle withOkAction:(void (^)(UIAlertAction * _Nonnull))okAction andCancelAction:(void (^)(UIAlertAction * _Nonnull))cancelAction;
-(void)updatePushId;
-(void)handleError:(NSError*) error withResult:(id _Nullable) result andHttpCode:(int) httpCode;
-(void)doRefreshWithAction:(void (^)(void))action;
-(void)doRefreshWithAction:(void (^)(void))preLoad andSuccess:(void (^)(void))actionSucces andActionFail:(void (^)(NSString*)) actionError;
-(void)handleErrorCode:(int) errorCode andMessage:(NSString*)msg andAction:(void (^)(UIAlertAction*))action;
@end

NS_ASSUME_NONNULL_END
