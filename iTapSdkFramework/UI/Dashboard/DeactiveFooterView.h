//
//  DeactiveFooterView.h
//  iTapSdk
//
//  Created by TranCong on 21/06/2022.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeactiveFooterView : BaseView

@property (strong,nonatomic) IBOutlet UIButton *btnDeactive;

-(void)underlineButton;
@end

NS_ASSUME_NONNULL_END
