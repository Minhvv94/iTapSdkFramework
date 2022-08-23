//
//  LoginView.h
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DashboardView : BaseView

@property (strong, nonatomic) IBOutlet UIView *holderBack;
@property (strong, nonatomic) IBOutlet UIView *holderHeader;
@property (strong, nonatomic) IBOutlet UIView *holderContent;

@end

NS_ASSUME_NONNULL_END
