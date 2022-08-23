//
//  Welcome.h
//  iTapSdk
//
//  Created by TranCong on 27/06/2022.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WelcomeView : BaseView
@property (strong, nonatomic) IBOutlet UILabel *lbWelcomUser;
@property (strong, nonatomic) IBOutlet UIView *vBackground;

-(void) waitAndHide:(float) delayTime durationTime:(float)value;
-(void) sayHi:(NSString*) userName;

@end

NS_ASSUME_NONNULL_END
