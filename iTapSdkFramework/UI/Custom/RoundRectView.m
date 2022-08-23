//
//  RoundRectView.m
//  testgame
//
//  Created by Tran Trong Cong on 8/10/21.
//

#import "RoundRectView.h"

@interface RoundRectView()
@property UIColor *customBackgroundColor;
@end

@implementation RoundRectView

-(void)setup{
    //self.layer.shadowColor = [UIColor blackColor].CGColor;
    //self.layer.shadowOffset = CGSizeZero;
    //self.layer.shadowRadius = 5.0;
    //self.layer.shadowOpacity = 0.5;
    [super setBackgroundColor:[UIColor clearColor]];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor{
    self.customBackgroundColor = backgroundColor;
    super.backgroundColor = [UIColor clearColor];
}

-(void)drawRect:(CGRect)rect{
    [self.customBackgroundColor setFill];
    [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius] fill];

    CGFloat borderInset = self.borderWidth/2;
    CGRect borderRect = CGRectInset(self.bounds, borderInset, borderInset);
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:borderRect cornerRadius:self.cornerRadius - borderInset];
    [self.borderColor setStroke];
    borderPath.lineWidth = self.borderWidth;
    [borderPath stroke];

    // whatever else you need drawn
}
-(void)refresh{
    [self setNeedsDisplay];
}
@end
