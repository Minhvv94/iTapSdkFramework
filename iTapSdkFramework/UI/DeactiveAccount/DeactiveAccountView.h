//
//  DeactiveAccountView.h
//  iTapSdk
//
//  Created by TranCong on 22/06/2022.
//

#import "BaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface DeactiveAccountView : BaseView
@property (strong, nonatomic) IBOutlet UILabel *lbNote1;
@property (strong, nonatomic) IBOutlet UILabel *lbNote2;
@property (strong, nonatomic) IBOutlet UILabel *lbNote3;
-(IBAction)btnDeactiveClick:(id)sender;

@end

NS_ASSUME_NONNULL_END
