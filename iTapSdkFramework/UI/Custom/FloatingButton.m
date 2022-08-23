//
//  FloatingButton.m
//  testgame
//
//  Created by Tran Trong Cong on 8/12/21.
//

#import "FloatingButton.h"
#import <AudioToolbox/AudioToolbox.h>
@implementation FloatingButton
{
    CGPoint originalCenter;
    UIImageView *btnRemove;
    BOOL isConflicted;
    float offsetX;
    float alpha;
}
@synthesize onClick;
@synthesize onRemove;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //init from frame
        [self initInternals];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //init from xib or storyboard
        [self initInternals];
    }
    return self;
}
-(void)setOffSetX:(float)value{
    offsetX = value;
}
-(void) initInternals{
    offsetX = 0;
    alpha = 0.6;
    btnRemove = [[UIImageView alloc] initWithFrame:CGRectZero];
    btnRemove.translatesAutoresizingMaskIntoConstraints = NO;
    UIImage *icon = [UIImage imageNamed:@"BtnClose"
                                             inBundle:[NSBundle bundleForClass:self.class]
          compatibleWithTraitCollection:nil];
    [btnRemove setImage:icon];
    
    
    originalCenter = CGPointZero;
    //self.layer.cornerRadius = self.frame.size.height / 2;
    //Các vùng của child sẽ chỉ hiển thị trong clip của parent
    self.clipsToBounds = FALSE;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    singleTap.numberOfTapsRequired = 1;
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:singleTap];
    
    UIPanGestureRecognizer *panRecognizer;
        panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                action:@selector(panDetected:)];
    
    [self addGestureRecognizer:panRecognizer];
    [self setAlpha:0.6];
}

- (void) tapDetected: (UITapGestureRecognizer *)recognizer
{
    //Code to handle the gesture
    if(self.onClick){
        self.onClick();
    }
}

- (void) panDetected: (UIPanGestureRecognizer *)recognizer
{
    //Code to handle the gesture
    UIView *clickedView = recognizer.view;
    UIView *parentView = self.superview;
    UIEdgeInsets safeAreaInsets = parentView.safeAreaInsets;
    
    if(clickedView != NULL && parentView != NULL){
        
        if(recognizer.state == UIGestureRecognizerStateBegan){
            isConflicted = NO;
            //NSLog(@"begin");
            [self setAlpha:1.0];
            originalCenter = clickedView.center;
            self->btnRemove.alpha = 0;
            [parentView addSubview:self->btnRemove];
            
            [btnRemove.centerXAnchor constraintEqualToAnchor:parentView.centerXAnchor].active = YES;
            [btnRemove.topAnchor constraintEqualToAnchor:parentView.safeAreaLayoutGuide.topAnchor constant:10].active = YES;
            [btnRemove.heightAnchor constraintEqualToConstant:40].active = YES;
            [btnRemove.widthAnchor constraintEqualToConstant:40].active = YES;
            [parentView bringSubviewToFront:clickedView];
            [UIView animateWithDuration:0.3 animations:^{
                            self -> btnRemove.alpha = 1;
                
    
                        }];
        }
        else if(recognizer.state == UIGestureRecognizerStateChanged){
            CGPoint translation = [recognizer translationInView:parentView];
            
            float newCenterX = originalCenter.x + translation.x;
            float newCenterY = originalCenter.y + translation.y;
            
            if(newCenterX <= safeAreaInsets.left + clickedView.frame.size.width / 2){
                newCenterX = safeAreaInsets.left + clickedView.frame.size.width / 2;
            }
            
            if(newCenterX >= parentView.frame.size.width - safeAreaInsets.right - clickedView.frame.size.width / 2){
                newCenterX = parentView.frame.size.width - safeAreaInsets.right - clickedView.frame.size.width / 2;
            }
            
            if(newCenterY <= safeAreaInsets.top){
                newCenterY = safeAreaInsets.top;
            }
            
            if(newCenterY >= parentView.frame.size.height - safeAreaInsets.bottom){
                newCenterY = parentView.frame.size.height - safeAreaInsets.bottom;
            }
            
            clickedView.center = CGPointMake(newCenterX, newCenterY);
            if(CGRectIntersectsRect(clickedView.frame,btnRemove.frame)){
                if(!isConflicted){
                    isConflicted = YES;
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                }
            }
            else{
                if(isConflicted){
                    isConflicted = NO;
                }
            }
        }
        else if(recognizer.state == UIGestureRecognizerStateEnded){
            if(CGRectIntersectsRect(clickedView.frame,btnRemove.frame)){
                if(onRemove){
                    onRemove();
                }
                [self setAlpha:alpha];
                [clickedView removeFromSuperview];
                [btnRemove removeFromSuperview];
            }
            else{
                float newCenterX  = safeAreaInsets.left + clickedView.frame.size.width / 2 - offsetX;
            float newCenterY  = clickedView.center.y;
            if(clickedView.center.x > parentView.frame.size.width / 2){
                newCenterX = parentView.frame.size.width - safeAreaInsets.right - clickedView.frame.size.width / 2 + offsetX;
            }
            
            [UIView animateWithDuration:0.3 animations:^
             {
                clickedView.center = CGPointMake(newCenterX, newCenterY);
                self->btnRemove.alpha = 0 ;
                [self setAlpha:0.6];

             }completion:^(BOOL finished)
             {
                self->originalCenter = CGPointZero;
                [self->btnRemove removeFromSuperview];
             }];
            }
        }
    }
}

@end
