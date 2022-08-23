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

@interface UpdateID : BaseView<UITextFieldDelegate>

@property NSString* userNationalId;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutBottomContainer;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutHeightStack;
@property (strong, nonatomic) IBOutlet UITextField *txtNumIdentifier;
@property (strong, nonatomic) IBOutlet UILabel *lbError;
@property (strong, nonatomic) IBOutlet UILabel *lbTitle;

@property (strong, nonatomic) IBOutlet RoundRectView *holderNumIdentifier;

@property (strong, nonatomic) IBOutlet UIButton *btnUpdate;

-(IBAction)btnUpdateIdClick:(id)sender;

@end

NS_ASSUME_NONNULL_END
