//
//  LoginView.h
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "RoundRectView.h"
#import "TrackingEventRepo.h"
NS_ASSUME_NONNULL_BEGIN

@interface RegistrationView : BaseView<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutBottomContainer;
@property (strong, nonatomic) IBOutlet UITextField *txtUsrname;
@property (strong, nonatomic) IBOutlet UITextField *txtPwd;
@property (strong, nonatomic) IBOutlet UILabel *lbError;
@property (strong, nonatomic) IBOutlet UILabel *lbNote;
@property (strong, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackViewRegistration;

@property (strong, nonatomic) IBOutlet RoundRectView *holderUsrname;
@property (strong, nonatomic) IBOutlet RoundRectView *holderPwd;

@property (strong, nonatomic) IBOutlet UIButton *btnRegister;
@property (strong, nonatomic) IBOutlet UIImageView *checkbox;
-(IBAction)btnRegisteClick:(id)sender;
@end

NS_ASSUME_NONNULL_END
