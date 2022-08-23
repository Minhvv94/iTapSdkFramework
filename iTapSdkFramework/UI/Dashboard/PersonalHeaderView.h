//
//  PersonalHeaderView.h
//  testgame
//
//  Created by Tran Trong Cong on 8/14/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PersonalView.h"
NS_ASSUME_NONNULL_BEGIN

@interface PersonalHeaderView : UIView

@property (nonatomic, assign) id<GuestCheckerDelegate> guestCheckerDelegate;

@property (strong,nonatomic) UserWrapper *userWrapper;
@property (strong,nonatomic) IBOutlet UILabel *userName;
@property (strong,nonatomic) IBOutlet UIImageView *avatar;
//@property (strong,nonatomic) IBOutlet UIView *holderUrls;
@property (strong,nonatomic) IBOutlet UIButton *btnHomePage;
@property (strong,nonatomic) IBOutlet UIButton *btnfanPage;
@property (strong,nonatomic) IBOutlet UIButton *btnGroup;
@property (strong,nonatomic) IBOutlet UIButton *btnChat;
@property (strong,nonatomic) IBOutlet UIButton *btnHotline;

@property (strong,nonatomic) IBOutlet UIButton *btnChangePwd;

-(IBAction)btnChangePwdClick:(id)sender;

-(IBAction)btnHomePageClick:(id)sender;

-(IBAction)btnFanPageClick:(id)sender;

-(IBAction)btnGroupClick:(id)sender;

-(IBAction)btnChatClick:(id)sender;

-(IBAction)btnHotlineClick:(id)sender;
@end

NS_ASSUME_NONNULL_END
