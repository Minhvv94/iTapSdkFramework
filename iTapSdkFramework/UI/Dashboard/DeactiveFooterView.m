//
//  DeactiveFooterView.m
//  iTapSdk
//
//  Created by TranCong on 21/06/2022.
//

#import "DeactiveFooterView.h"

@implementation DeactiveFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize btnDeactive;

-(void)underlineButton{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[TSLanguageManager localizedString:@"Vô hiệu hóa TK"] attributes:@{
        NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
        NSForegroundColorAttributeName: UIColor.blueColor
    }];
    
    if(self.btnDeactive != NULL){
        [self.btnDeactive setAttributedTitle:attrString forState:UIControlStateNormal];
    }
}
@end
