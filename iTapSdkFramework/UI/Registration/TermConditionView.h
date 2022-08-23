//
//  LoginView.h
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "RoundRectView.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TermConditionView : BaseView<WKUIDelegate>
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *lbTitle;
@end

NS_ASSUME_NONNULL_END
