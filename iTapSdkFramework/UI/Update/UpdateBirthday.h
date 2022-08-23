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

@interface UpdateBirthday : BaseView<UITextFieldDelegate>

@property NSString* userBirthDay;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutBottomContainer;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutHeightStack;
@property (strong, nonatomic) IBOutlet UITextField *txtBirthday;
@property (strong, nonatomic) IBOutlet UILabel *lbError;
@property (strong, nonatomic) IBOutlet UILabel *lbTitle;

@property (strong, nonatomic) IBOutlet RoundRectView *holderBirthday;

@property (strong, nonatomic) IBOutlet UIButton *btnUpdate;

-(IBAction)btnUpdateClick:(id)sender;

@end

NS_ASSUME_NONNULL_END
