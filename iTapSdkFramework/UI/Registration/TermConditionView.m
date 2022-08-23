//
//  TermConditionView.m
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import "TermConditionView.h"
#import "Utils.h"
@implementation TermConditionView
{
    WKWebView* webview;
}
@synthesize contentView;

-(void) initInternals{
    [super initInternals];
}
-(void)configUI:(UIView *)parentView{
    
    [super configUI:parentView];
    [self configFontByScreen];
    [self configKeyboard:50.0];
    NSString * title = [TSLanguageManager localizedString:@"Điều khoản sử dụng"];
    self.lbTitle.text = title;
    
    WKWebViewConfiguration* config = [[WKWebViewConfiguration alloc] init];
    webview = [[WKWebView alloc] initWithFrame:self.contentView.bounds configuration:config];
    webview.UIDelegate = self;
    
    webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:webview];
    [self.contentView layoutIfNeeded];
    NSBundle *myBundle = [NSBundle bundleForClass:[self class]];
    NSString *htmlFile = [myBundle pathForResource:@"TermCondition" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self->webview loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
}

-(void)configFontByScreen{
    float heightScreen = [Utils heightScreen];
    if(heightScreen <=375){
        
    }
}

-(void)configKeyboard:(CGFloat) newOffset{
}

-(void)btnClose:(id)sender{
    [super btnClose:sender];
    NSLog(@"btnClose");
    [self removeFromSuperview];
}

@end
