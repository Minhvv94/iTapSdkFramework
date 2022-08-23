//
//  Welcome.m
//  iTapSdk
//
//  Created by TranCong on 27/06/2022.
//

#import "WelcomeView.h"

@implementation WelcomeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize lbWelcomUser;
-(void)sayHi:(NSString *)userName{
    NSString * preHi = [TSLanguageManager localizedString:@"Chào mừng"];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:preHi attributes:@{
            NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone),
            NSForegroundColorAttributeName: [Utils colorFromHexString:@"#151515"]
    }];
    
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:userName attributes:@{
        NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone),
        NSForegroundColorAttributeName:[Utils colorFromHexString:@"2f3484"]
    }]];
    lbWelcomUser.attributedText = attrString;
}
-(void)waitAndHide:(float)delayTime durationTime:(float)value{
    [UIView animateWithDuration:value delay:delayTime options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        if(finished){
            [self btnClose:nil];
        }
    }];
}
-(void)btnClose:(id)sender{
    [super btnClose:sender];
    NSLog(@"btnClose");
    [self removeFromSuperview];
}
@end
