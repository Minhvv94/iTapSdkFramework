//
//  RegistrationView.m
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import "DashboardView.h"
#import "Utils.h"
#import "HMSegmentedControl.h"
#import "NewsView.h"
#import "PersonalView.h"
@implementation DashboardView
{
    HMSegmentedControl* segmentControl;
    NewsView *newsView;
    PersonalView *personalView;
}
@synthesize holderHeader;
@synthesize holderContent;
@synthesize holderBack;
-(void)configUI:(UIView *)parentView{
    [super configUI:parentView];
    //init segment control
    // Segmented control with images
    [holderHeader setBackgroundColor:[Utils colorFromHexString:color_main_orange]];
    UIImage *imgPersonal = [UIImage imageNamed:@"IconPersonal"
                                                      inBundle:[NSBundle bundleForClass:self.class]
                                 compatibleWithTraitCollection:nil];
    
    UIImage *imgNews = [UIImage imageNamed:@"IconNews"
                                                      inBundle:[NSBundle bundleForClass:self.class]
                                 compatibleWithTraitCollection:nil];
    
    NSArray<UIImage *> *images = @[imgPersonal,
                                   imgNews];
    
    NSArray<UIImage *> *selectedImages = @[imgPersonal,
                                           imgNews];
    NSArray<NSString *> *titles = @[@"Cá nhân", @"Tin tức"];
    
    segmentControl = [[HMSegmentedControl alloc] initWithSectionImages:images sectionSelectedImages:selectedImages titlesForSections:titles];
    segmentControl.imagePosition = HMSegmentedControlImagePositionLeftOfText; // put icon on left of text
    segmentControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin  | UIViewAutoresizingFlexibleHeight;
    segmentControl.frame = CGRectMake(0, 0, self.holderHeader.bounds.size.width*0.7f, self.holderHeader.bounds.size.height);
    
    //segmentControl.segmentEdgeInset = UIEdgeInsetsMake(20, 20, 20, 20);
    
    segmentControl.backgroundColor = [UIColor clearColor];
    segmentControl.textImageSpacing = 10;
    segmentControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:16]};
    //setting indicator
    segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationTop;
    segmentControl.selectionIndicatorHeight = 4.0f;
    segmentControl.selectionIndicatorColor = [UIColor whiteColor];
    
    //setting for box
    segmentControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    segmentControl.selectionIndicatorBoxColor = [Utils colorFromHexString:color_main_tab_orange];//f7aa6b
    segmentControl.selectionIndicatorBoxOpacity = 1.0;
    
    segmentControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    segmentControl.selectedSegmentIndex = 0;
    [segmentControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.holderHeader addSubview:segmentControl];
    [self.holderHeader layoutIfNeeded];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    singleTap.numberOfTapsRequired = 1;
    [holderBack setUserInteractionEnabled:YES];
    [holderBack addGestureRecognizer:singleTap];
    
    [self segmentedControlChangedValue:segmentControl];
    
}
-(void)tapDetected:(UITapGestureRecognizer *)singleTap{
    NSLog(@"tapDetected");
    [self btnClose:nil];
    
    
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %tu (via UIControlEventValueChanged)", segmentedControl.selectedSegmentIndex);
    if(segmentedControl.selectedSegmentIndex == 0){
        if(newsView !=NULL && newsView.superview != NULL){
            [newsView removeFromSuperview];
        }
        if(personalView == NULL){
            personalView = (PersonalView*)[Utils loadViewFromNibFile:[self class] universalWithNib:@"PersonalView-landscape"];
        personalView.callback = ^(NSString* identifier) {
            NSLog(@"Hide %@",identifier );
            if([identifier isEqual:CallbackHide]){
                [self btnClose:nil];
                //[[Sdk sharedInstance] showOrHideFloatingButton];
            }
        };
        }
        personalView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.holderContent addSubview:personalView];
        [Utils addConstraintForChild:self.holderContent andChild:personalView withLeft:0 withTop:0 andRight:0 withBottom:0];
    }
    else {
        if(personalView !=NULL && personalView.superview != NULL){
            [personalView removeFromSuperview];
        }
        if(newsView == NULL)
        {
            newsView = (NewsView*)[Utils loadViewFromNibFile:[self class] universalWithNib:@"NewsView-landscape"];
            newsView.callback = ^(NSString* identifier) {
                NSLog(@"Hide %@",identifier );
            };
        }
        newsView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.holderContent addSubview:newsView];
        [Utils addConstraintForChild:self.holderContent andChild:newsView withLeft:0 withTop:0 andRight:0 withBottom:0];
    }
}

-(void)btnClose:(id)sender{
    [super btnClose:sender];
    [self removeFromSuperview];
}
@end
