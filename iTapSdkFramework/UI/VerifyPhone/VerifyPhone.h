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

@interface VerifyPhone: BaseView<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutBottomContainer;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutHeightStack;
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;
@property (strong, nonatomic) IBOutlet UITextField *txtOtp;
@property (strong, nonatomic) IBOutlet UILabel *lbError;
@property (strong, nonatomic) IBOutlet UILabel *lbTitle;

@property (strong, nonatomic) IBOutlet RoundRectView *holderOtp;
@property (strong, nonatomic) IBOutlet RoundRectView *holderPhone;

@property (strong, nonatomic) IBOutlet UIButton *btnReceiveOtp;
@property (strong, nonatomic) IBOutlet UIButton *btnUpdate;
@property NSString *phoneNum;
-(IBAction)btnUpdateClick:(id)sender;
-(IBAction)btnReceiveOtpClick:(id)sender;
@end

NS_ASSUME_NONNULL_END
