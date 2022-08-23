//
//  RoundRectView.h
//  testgame
//
//  Created by Tran Trong Cong on 8/10/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RoundRectView : UIView
@property IBInspectable CGFloat cornerRadius;
@property IBInspectable UIColor *borderColor;
@property IBInspectable CGFloat borderWidth;

-(void) refresh;
@end

NS_ASSUME_NONNULL_END
