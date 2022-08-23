//
//  LoginView.h
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "RoundRectView.h"
#import "MaitainCheckerJson.h"
#import "TrackingEventRepo.h"
NS_ASSUME_NONNULL_BEGIN

@interface LoginView : BaseView<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutBottomContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackFastLogin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutBgRoundCorner;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutArrange;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutOpenId;
@property (strong, nonatomic) IBOutlet UITextField *txtUsrname;
@property (strong, nonatomic) IBOutlet UITextField *txtPwd;
@property (strong, nonatomic) IBOutlet UILabel *lbError;
@property (strong, nonatomic) IBOutlet UILabel *lbNote;
@property (strong, nonatomic) IBOutlet UILabel *lbTitleLoginBy;

@property (strong, nonatomic) IBOutlet RoundRectView *holderUsrname;
@property (strong, nonatomic) IBOutlet RoundRectView *holderPwd;

@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnForget;
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;
@property (strong, nonatomic) IBOutlet UIButton *btnFacebook;
@property (strong, nonatomic) IBOutlet UIButton *btnGoogle;
@property (strong, nonatomic) IBOutlet UIButton *btnPlayNow;
@property (strong, nonatomic) IBOutlet UIButton *btnApple;

@property (strong, nonatomic) IBOutlet UIView *holerSavePass;
@property (strong, nonatomic) IBOutlet UIImageView *cbSavePass;
@property (strong, nonatomic) IBOutlet UILabel *lbSavePass;

@property (weak, nonatomic) IBOutlet UIView *layoutFacebook;
@property (weak, nonatomic) IBOutlet UIView *layoutGoogle;
@property (weak, nonatomic) IBOutlet UIView *layoutApple;
@property (weak, nonatomic) IBOutlet UIView *layoutHolder;
@property (weak, nonatomic) IBOutlet UIImageView *bgRoundCorner;


@property MaitainCheckerJson* maitainCheckerJson;
-(IBAction)btnLoginClick:(id)sender;
-(IBAction)btnRegisterClick:(id)sender;
-(IBAction)btnForgetPwdClick:(id)sender;
-(IBAction)btnPlayNowClick:(id)sender;
-(IBAction)btnGoogleClick:(id)sender;
-(IBAction)btnFacebookClick:(id)sender;
-(IBAction)btnAppleClick:(id)sender;
@end

NS_ASSUME_NONNULL_END
