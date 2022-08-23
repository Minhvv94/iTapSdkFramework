//
//  DetailNewsView.m
//  iTapSdk
//
//  Created by TranCong on 10/11/2021.
//

#import "DetailNewsView.h"
#import "UIImageView+AFNetworking.h"
@implementation DetailNewsView
{
    WKWebView* webview;
}
@synthesize contentView;
@synthesize loadingIndicator;
@synthesize lbTitleNews;
@synthesize lbPublishedDateNews;
@synthesize thumbUrl;
-(void)configUI:(UIView *)parentView{
    [super configUI:parentView];
    
    WKWebViewConfiguration* config = [[WKWebViewConfiguration alloc] init];
    webview = [[WKWebView alloc] initWithFrame:self.contentView.bounds configuration:config];
    webview.UIDelegate = self;
    
    webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:webview];
    [self.contentView layoutIfNeeded];
    [self loadData];
    
}
//load image with AFNetworking
-(void) loadData{
    [loadingIndicator startAnimating];
    //Load data
    NSString *url = [NSString stringWithFormat:@"%@/%@",PATH_GAME_DETAIL_NEWS,_idNews];
    NSString *accessToken = [[Sdk sharedInstance] accessToken];
    [[GameApiRequest sharedInstance] callGetMethod:url withParams:nil withBody:nil withToken:accessToken completion:^(id  _Nullable result) {
            DetailNewsJson *resp = [[DetailNewsJson alloc] initFromDictionary:result];
            if(resp.statusCode == CODE_0){
                [self->webview loadHTMLString:resp.data.contentNews baseURL: nil];
                self.lbTitleNews.text = resp.data.titleNews;
                
                self.lbPublishedDateNews.text = [Utils getLocaleFormatDate:resp.data.publishedAt];
                
                UIImage *placeholderImage = [UIImage imageNamed:@"imgNewsSample"
                                                                  inBundle:[NSBundle bundleForClass:self.class]
                                             compatibleWithTraitCollection:nil];
                
                [self.thumbUrl setImageWithURL:resp.data.thumbUrlNews
                          placeholderImage:placeholderImage];
            }
            [loadingIndicator stopAnimating];
        } error:^(NSError * _Nonnull error, id  _Nullable result, int httpCode) {
            
        }];
}
-(void)btnClose:(id)sender{
    [super btnClose:sender];
    NSLog(@"btnClose");
    [self removeFromSuperview];
}
@end
