//
//  LoginView.h
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import <QuartzCore/QuartzCore.h>
NS_ASSUME_NONNULL_BEGIN

@interface NewsView : BaseView<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) IBOutlet UITableView* tbNews;
@end

NS_ASSUME_NONNULL_END
