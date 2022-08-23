//
//  LoginView.h
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "UserJson.h"
#import "DeactiveFooterView.h"
NS_ASSUME_NONNULL_BEGIN
@protocol GuestCheckerDelegate
- (void) showTranferGuest:(int)state;
@end

@interface PersonalView : BaseView<UITableViewDataSource,UITableViewDelegate,GuestCheckerDelegate>
@property (weak,nonatomic) IBOutlet UITableView* tbPersonal;
@property (weak,nonatomic) IBOutlet UIActivityIndicatorView* loadingIndicator;
@end

NS_ASSUME_NONNULL_END
