//
//  PersonalHeaderView.m
//  testgame
//
//  Created by Tran Trong Cong on 8/14/21.
//

#import "PersonalHeaderView.h"
#import "ChangePwdView.h"
@implementation PersonalHeaderView
@synthesize userWrapper;
-(void)btnChangePwdClick:(id)sender{
    if(userWrapper.status == ACCOUNT_FASTLOGIN || userWrapper.status == ACCOUNT_FACEBOOK || userWrapper.status == ACCOUNT_GOOGLE|| userWrapper.status == ACCOUNT_APPLE){
        if(self.guestCheckerDelegate != NULL){
            [self.guestCheckerDelegate showTranferGuest:1];
        }
        return;
    }
    UIViewController *topView = [Utils topViewController];
    ChangePwdView *customView =(ChangePwdView*) [Utils loadViewFromNibFile:[self class] withNib:@"ChangePwdView"];
    
    customView.callback = ^(NSString* identifier) {
        NSLog(@"Hide %@",identifier );
    };
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    customView.tag = 202;
    [topView.view addSubview:customView];
    [Utils addConstraintForChild:topView.view andChild:customView withLeft:0 withTop:0 andRight:0 withBottom:0];
}
-(void)btnHomePageClick:(UIButton*)sender{
    NSLog(@"btnHomePageClick");
    NSString *pURL = [[Sdk sharedInstance] getAppInfo].hotLinkHomepage;
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pURL]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pURL] options:@{} completionHandler:^(BOOL success) {
            
        }];
}
-(void)btnChatClick:(id)sender{
    NSLog(@"btnChatClick");
    NSString *pURL = [[Sdk sharedInstance] getAppInfo].hotLinkChat;
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pURL]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pURL] options:@{} completionHandler:^(BOOL success) {
            
        }];
}
-(void)btnHotlineClick:(id)sender{
    NSLog(@"btnHotlineClick");
    NSString *phone = [[Sdk sharedInstance] getAppInfo].hotline;
    NSString *phoneStr = [NSString stringWithFormat:@"tel:%@",phone];
    NSURL *phoneURL = [NSURL URLWithString:phoneStr];
    [[UIApplication sharedApplication] openURL:phoneURL];
}
-(void)btnFanPageClick:(id)sender{
    NSLog(@"btnFanPageClick");
    NSString *pURL = [[Sdk sharedInstance] getAppInfo].hotLinkFanpage;
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pURL]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pURL] options:@{} completionHandler:^(BOOL success) {
            
        }];
}
-(void)btnGroupClick:(id)sender{
    NSLog(@"btnGroupClick");
    NSString *pURL = [[Sdk sharedInstance] getAppInfo].hotLinkGroup;
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pURL]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pURL] options:@{} completionHandler:^(BOOL success) {
            
        }];
}
@end
