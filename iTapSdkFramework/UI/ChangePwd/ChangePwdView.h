//
//  LoginView.h
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "RoundRectView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangePwdView : BaseView<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutBottomContainer;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutHeightStack;
@property (strong, nonatomic) IBOutlet UITextField *txtConfirmNewPwd;
@property (strong, nonatomic) IBOutlet UITextField *txtNewPwd;
@property (strong, nonatomic) IBOutlet UITextField *txtPwd;
@property (strong, nonatomic) IBOutlet UILabel *lbError;
@property (strong, nonatomic) IBOutlet UILabel *lbTitle;

@property (strong, nonatomic) IBOutlet RoundRectView *holderNewPwd;
@property (strong, nonatomic) IBOutlet RoundRectView *holderConfirmNewPwd;
@property (strong, nonatomic) IBOutlet RoundRectView *holderPwd;

@property (strong, nonatomic) IBOutlet UIButton *btnChangePwd;

-(IBAction)btnChangePwdClick:(id)sender;

@end

NS_ASSUME_NONNULL_END
