//
//  RegistrationView.m
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import "Utils.h"
#import "HMSegmentedControl.h"
#import "PersonalView.h"
#import "CellFuncView.h"
#import "PersonalDisplay.h"
#import "FuncDisplay.h"
#import "PersonalHeaderView.h"
#import "UpdateID.h"
#import "VerifyEmail.h"
#import "VerifyPhone.h"
#import "UpdateBirthday.h"
#import "UIButton+VerticalLayout.h"
#import "ChangeAccountView.h"
#import "IdApiRequest.h"
#import "LoginJson.h"
#import "UserJson.h"
#import "DeactiveFooterView.h"
#import "DeactiveAccountView.h"
@implementation PersonalView
{
    PersonalDisplay *person;
    HMSegmentedControl* segmentControl;
    UserWrapper* userWrapper;
}
@synthesize tbPersonal;
@synthesize loadingIndicator;
-(void)configUI:(UIView *)parentView{
    [super configUI:parentView];
    [loadingIndicator startAnimating];
    [loadingIndicator setHidden:NO];
    NSTimeInterval delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self getUserInfo];
        
    });
    //[tbPersonal reloadData];
}
-(void)doRefreshToken{
    AppInfo *appInfo = [[Sdk sharedInstance] getAppInfo];
    NSString * refreshToken = [[Sdk sharedInstance] refreshToken];
    [Utils logMessage:[NSString stringWithFormat:@"refreshToken %@",refreshToken]];
    NSDictionary *body = @{
        request_jwt:refreshToken,
        request_cid:appInfo.client_id,
        request_client_id: appInfo.client_id,
    };
    __weak typeof(self) weakSelf = self;
    [[IdApiRequest sharedInstance] callPostMethod:PATH_REFRESH_TOKEN withBody:body withToken:nil completion:^(id  _Nullable result) {
        [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
        
        LoginJson *loginJson = [[LoginJson alloc] initFromDictionary:result];
        if(loginJson != NULL){
            if(loginJson.statusCode == CODE_0){
                //success
                [[DataUtils sharedInstance] saveAccessToken:loginJson.data.accessToken];
                [self getUserInfo];
            }
            else{
                
                NSString *errorText = [TSLanguageManager localizedString:[NSString stringWithFormat:@"E_CODE_%d",loginJson.statusCode]];
                if([errorText containsString:@"E_CODE_"]){
                    if(![Utils isNullOrEmpty:loginJson.message]){
                        errorText = loginJson.message;
                    }
                    else{
                        errorText = [TSLanguageManager localizedString:@"Lỗi không xác định"];
                    }
                }
                [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:errorText withAction:^(UIAlertAction * _Nonnull) {
                    if(loginJson.statusCode == CODE_86 || loginJson.statusCode == CODE_85 || loginJson.statusCode == CODE_98){
                        if(self.callback !=NULL){
                            self.callback(CallbackHide);
                        }
                        [[Sdk sharedInstance] forceLogout];
                    }
                }];
            }
        }
    } error:^(NSError * _Nonnull error,  id  _Nullable result,int httpCode) {
        [Utils logMessage:[NSString stringWithFormat:@"error %ld",error.code]];
        [Utils logMessage:[NSString stringWithFormat:@"desc %@",error.description]];
        //[self hideLoading];
        [self->loadingIndicator stopAnimating];
        [self->loadingIndicator setHidden:YES];
        [self showAlert:nil withContent:[TSLanguageManager localizedString:@"Lỗi không xác định"] withAction:nil];
    }];
}
-(void)getUserInfo{
    
    AppInfo *appInfo = [[Sdk sharedInstance] getAppInfo];
    NSString * accessToken = [[Sdk sharedInstance] accessToken];
    NSString * refreshToken = [[Sdk sharedInstance] refreshToken];
    [Utils logMessage:[NSString stringWithFormat:@"accessToken %@",accessToken]];
    [Utils logMessage:[NSString stringWithFormat:@"refreshToken %@",refreshToken]];
    NSDictionary *body = @{
        request_jwt:accessToken,
        request_cid:appInfo.client_id,
        request_client_id: appInfo.client_id,
    };
    
    
    [Utils delayAction:^{
        [[IdApiRequest sharedInstance] callPostMethod:PATH_USER_INFO withBody:body withToken:nil completion:^(id  _Nullable result) {
            [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
            
            UserJson *userJson = [[UserJson alloc] initFromDictionary:result];
            if(userJson != NULL){
                if(userJson.statusCode == CODE_0){
                    //success
                    self->userWrapper = userJson.data;
                    [self setupTable];
                    [self->loadingIndicator stopAnimating];
                    [self->loadingIndicator setHidden:YES];
                }
                else{
                    NSString *errorText = [TSLanguageManager localizedString:[NSString stringWithFormat:@"E_CODE_%d",userJson.statusCode]];
                    
                    if(userJson.statusCode == CODE_86){
                        [self doRefreshToken];
                    }
                     else{
                         [self handleErrorCode:userJson.statusCode andMessage:userJson.message andAction:nil];
                    }
                }
            }
        } error:^(NSError * _Nonnull error,  id  _Nullable result,int httpCode) {
            [Utils logMessage:[NSString stringWithFormat:@"error %ld",error.code]];
            [Utils logMessage:[NSString stringWithFormat:@"desc %@",error.description]];
            //[self hideLoading];
            [self->loadingIndicator stopAnimating];
            [self->loadingIndicator setHidden:YES];
            [self showAlert:nil withContent:[TSLanguageManager localizedString:@"Lỗi không xác định"] withAction:nil];
        }];
    } withTime:0.5f];
}
-(void) setupTable{
    NSBundle *myBundle = [NSBundle bundleForClass:[self class]];
    UINib *cellNib = [UINib nibWithNibName:@"CellFuncView" bundle:myBundle];
    [tbPersonal registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    tbPersonal.rowHeight = UITableViewAutomaticDimension;
    tbPersonal.estimatedRowHeight = 40;
    
    [self fakeData];
    PersonalHeaderView *view =(PersonalHeaderView*) tbPersonal.tableHeaderView;
    if(view == nil){
        view = (PersonalHeaderView*)[Utils loadViewFromNibFile:[self class] universalWithNib:@"PersonalHeaderView"];
    view.userWrapper = self->userWrapper;
    view.guestCheckerDelegate = self;
    if(userWrapper.status == 1){
        [view.btnChangePwd setTitle:[TSLanguageManager localizedString:@"txt_ChangePwd"] forState: UIControlStateNormal];
    }
    if(userWrapper.status == ACCOUNT_FASTLOGIN || userWrapper.status == ACCOUNT_GOOGLE  || userWrapper.status == ACCOUNT_FACEBOOK || userWrapper.status == ACCOUNT_APPLE){
        
        [view.btnChangePwd setTitle:[TSLanguageManager localizedString:@"txt_ConvertAcct"] forState: UIControlStateNormal];
    }
    float height = [Utils heightScreen];
    NSLog(@"height: %f",height);
    float h = height*0.18;
    NSLog(@"h: %f",h);
    if(height > 1000 && height < 1300){
        h = height*0.12;
    }
    else if(height > 1300){
        h = height*0.1;
    }
    view.translatesAutoresizingMaskIntoConstraints = YES;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.frame = CGRectMake(0, 0, tbPersonal.frame.size.width, h);
    tbPersonal.tableHeaderView = view;
    
    [view layoutIfNeeded];
    float floatSize =h*0.5*0.3;
    NSLog(@"floatSize: %f",floatSize);
    CGSize newSize =CGSizeMake(floatSize,floatSize);
    
    UIImage* imageHome = [UIImage imageNamed:@"IconHome" inBundle:[NSBundle bundleForClass:self.class]
               compatibleWithTraitCollection:nil];
    imageHome = [Utils imageWithImage:imageHome scaledToSize:newSize];
    [view.btnHomePage setImage:imageHome forState:UIControlStateNormal];
    [view.btnHomePage centerVertically];
    //view.btnHomePage.showsTouchWhenHighlighted = YES;
    [view.btnHomePage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[view.btnHomePage setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    //[view.btnHomePage setTitleColor:[UIColor blueColor] forState:UIControlStateFocused];
    //[view.btnHomePage setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    
    UIImage* imageFanpage = [UIImage imageNamed:@"IconFanpage" inBundle:[NSBundle bundleForClass:self.class]
                  compatibleWithTraitCollection:nil];
    imageFanpage = [Utils imageWithImage:imageFanpage scaledToSize:newSize];
    [view.btnfanPage setImage:imageFanpage forState:UIControlStateNormal];
    [view.btnfanPage centerVertically];
    
    UIImage* imageGroup = [UIImage imageNamed:@"IconGroup" inBundle:[NSBundle bundleForClass:self.class]
                compatibleWithTraitCollection:nil];
    imageGroup = [Utils imageWithImage:imageGroup scaledToSize:newSize];
    [view.btnGroup setImage:imageGroup forState:UIControlStateNormal];
    [view.btnGroup centerVertically];
    UIImage* imageChat = [UIImage imageNamed:@"IconChat" inBundle:[NSBundle bundleForClass:self.class]
               compatibleWithTraitCollection:nil];
    imageChat = [Utils imageWithImage:imageChat scaledToSize:newSize];
    [view.btnChat setImage:imageChat forState:UIControlStateNormal];
    [view.btnChat centerVertically];
    UIImage* imageHotline = [UIImage imageNamed:@"IconHotline" inBundle:[NSBundle bundleForClass:self.class]
                  compatibleWithTraitCollection:nil];
    imageHotline = [Utils imageWithImage:imageHotline scaledToSize:newSize];
    [view.btnHotline setImage:imageHotline forState:UIControlStateNormal];
    [view.btnHotline centerVertically];
    [tbPersonal.tableHeaderView setNeedsLayout];
    [tbPersonal.tableHeaderView layoutIfNeeded];
    view.userName.text = person.userName;
    tbPersonal.dataSource = self;
    tbPersonal.delegate = self;
    }
    else{
        view.userWrapper = self->userWrapper;
        if(userWrapper.status == 1){
            [view.btnChangePwd setTitle:[TSLanguageManager localizedString:@"txt_ChangePwd"] forState: UIControlStateNormal];
        }
        if(userWrapper.status == ACCOUNT_FASTLOGIN || userWrapper.status == ACCOUNT_FACEBOOK || userWrapper.status == ACCOUNT_GOOGLE|| userWrapper.status == ACCOUNT_APPLE){
            
            [view.btnChangePwd setTitle:[TSLanguageManager localizedString:@"txt_ConvertAcct"] forState: UIControlStateNormal];
        }
        view.userName.text = person.userName;
        [tbPersonal reloadData];
    }
    DeactiveFooterView *footerView =(DeactiveFooterView*) tbPersonal.tableFooterView;
    if(footerView == nil){
        footerView = (DeactiveFooterView*)[Utils loadViewFromNibFile:[self class] universalWithNib:@"DeactiveFooterView"];
        //setup onclick button
        [footerView.btnDeactive addTarget:self action:@selector(deactiveOnclick:) forControlEvents:UIControlEventTouchUpInside];
        [footerView underlineButton];
        footerView.translatesAutoresizingMaskIntoConstraints = YES;
        footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        footerView.frame = CGRectMake(0, 0, tbPersonal.frame.size.width, 60);
        tbPersonal.tableFooterView = footerView;
        [footerView layoutIfNeeded];
    }
    
}
- (void)deactiveOnclick:(UIButton *)sender {
    if(userWrapper.status == ACCOUNT_FASTLOGIN || userWrapper.status == ACCOUNT_FACEBOOK || userWrapper.status == ACCOUNT_GOOGLE){
        [self showTranferGuest:0];
        return;
    }
    //then show deactve view
    UIViewController *topView = [Utils topViewController];
    DeactiveAccountView *customView =(DeactiveAccountView*) [Utils loadViewFromNibFile:[self class] withNib:@"DeactiveAccountView"];
    customView.callback = ^(NSString* identifier) {
        NSLog(@"Hide %@",identifier );
        if(self.callback !=NULL){
            self.callback(CallbackHide);
        }
        if([identifier isEqual:CallbackSuccess]){
            [[Sdk sharedInstance] forceLogout];
        }
    };
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    customView.tag = 202;
    [topView.view addSubview:customView];
    [Utils addConstraintForChild:topView.view andChild:customView withLeft:0 withTop:0 andRight:0 withBottom:0];
}
-(void)refreshDisplay{
    /*[self fakeData];
    PersonalHeaderView *view =(PersonalHeaderView*) tbPersonal.tableHeaderView;
    view.userName.text = person.userName;
    [tbPersonal reloadData];*/
    [self configUI:nil];
}
-(void)fakeData{
    if(userWrapper == nil) return;
    person = [[PersonalDisplay alloc] init];
    person.userName = userWrapper.accountName;
    NSMutableArray *funcList = [NSMutableArray array];
    NSMutableArray *urlList = [NSMutableArray array];
    
    FuncDisplay *emailFunc = [[FuncDisplay alloc] init];
    emailFunc.id = 1;
    emailFunc.image = @"IconEmail";
    emailFunc.funcsType = NeedVerify;
    if(![Utils isNullOrEmpty:userWrapper.email]){
        //0 Chưa kích hoạt, 1 kích hoạt email, 2 kích hoạt điện thoại, 5 kích hoạt cả email và điện thoại
        if(userWrapper.confirmCode == 1 || userWrapper.confirmCode == 5){
            NSString* emailMask = [Utils maskEmail:userWrapper.email];
            emailFunc.value = emailMask;//[NSString stringWithFormat:@"%@ %@",,[TSLanguageManager localizedString:@"Chưa xác minh"]];
            emailFunc.funcsType = Display;
        }
        else{
            emailFunc.value = [Utils maskEmail:userWrapper.email];
            
        }
    }
    else{
        emailFunc.value = [TSLanguageManager localizedString:@"(trống)"];
    }
    
    [funcList addObject:emailFunc];
    
    FuncDisplay *phoneFunc = [[FuncDisplay alloc] init];
    phoneFunc.id = 2;
    phoneFunc.image = @"IconPhone";
    phoneFunc.funcsType = Edit;
    if(![Utils isNullOrEmpty:userWrapper.mobile]){
        if(userWrapper.confirmCode == 2 || userWrapper.confirmCode == 5){
            phoneFunc.value = [Utils maskPhone:userWrapper.mobile withNum:3];
            phoneFunc.funcsType = Display;
        }
        else{
            phoneFunc.value = [Utils maskPhone:userWrapper.mobile withNum:3];
            phoneFunc.funcsType = NeedVerify;
        }
    }
    else{
        phoneFunc.value = [TSLanguageManager localizedString:@"(trống)"];
        phoneFunc.funcsType = NeedVerify;
    }
    
    [funcList addObject:phoneFunc];
    
    FuncDisplay *idFunc = [[FuncDisplay alloc] init];
    idFunc.id = 3;
    idFunc.image = @"IconId";
    idFunc.funcsType = Edit;
    if(![Utils isNullOrEmpty:userWrapper.passport]){
        idFunc.value = [Utils maskPhone:userWrapper.passport withNum:3];
        //idFunc.funcsType = Display;
    }
    else{
        idFunc.value = [TSLanguageManager localizedString:@"(trống)"];
    }
    [funcList addObject:idFunc];
    
    FuncDisplay *birthdayFunc = [[FuncDisplay alloc] init];
    birthdayFunc.id = 4;
    birthdayFunc.image = @"IconBirthday";
    birthdayFunc.funcsType = Edit;
    if(![Utils isNullOrEmpty:userWrapper.birthday]){
        NSDate *birthDayDate = [Utils getLocalDate:userWrapper.birthday withFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSString* birthdayStr = [Utils getLocaleFormatDate:birthDayDate];
        birthdayFunc.value = [Utils maskLastofString:birthdayStr withNum:2];
    }
    else{
        birthdayFunc.value = [TSLanguageManager localizedString:@"(trống)"];
    }
    [funcList addObject:birthdayFunc];
    
    FuncDisplay *signoutFunc = [[FuncDisplay alloc] init];
    signoutFunc.id = 100;
    signoutFunc.image = @"IconSignout";
    signoutFunc.funcsType = Exit;
    signoutFunc.value = [TSLanguageManager localizedString:@"Đăng xuất"];
    [funcList addObject:signoutFunc];
    
    person.funcList =[NSArray arrayWithArray:funcList];
    
    FuncDisplay *homeFunc = [[FuncDisplay alloc] init];
    homeFunc.id = 1;
    homeFunc.image = @"IconHome";
    homeFunc.funcsType = OpenLink;
    homeFunc.value = [TSLanguageManager localizedString:@"Trang chủ"];
    [urlList addObject:homeFunc];
    
    FuncDisplay *fanpageFunc = [[FuncDisplay alloc] init];
    fanpageFunc.id = 2;
    fanpageFunc.image = @"IconFanpage";
    fanpageFunc.funcsType = OpenLink;
    fanpageFunc.value = [TSLanguageManager localizedString:@"Fanpage"];
    [urlList addObject:fanpageFunc];
    
    FuncDisplay *groupFunc = [[FuncDisplay alloc] init];
    groupFunc.id = 3;
    groupFunc.image = @"IconGroup";
    groupFunc.funcsType = OpenLink;
    groupFunc.value = [TSLanguageManager localizedString:@"Group"];
    [urlList addObject:groupFunc];
    
    FuncDisplay *chatFunc = [[FuncDisplay alloc] init];
    chatFunc.id = 4;
    chatFunc.image = @"IconChat";
    chatFunc.funcsType = OpenLink;
    chatFunc.value = [TSLanguageManager localizedString:@"Chat"];
    [urlList addObject:chatFunc];
    
    FuncDisplay *hotlineFunc = [[FuncDisplay alloc] init];
    hotlineFunc.id = 5;
    hotlineFunc.image = @"IconHotline";
    hotlineFunc.funcsType = Call;
    hotlineFunc.value = [TSLanguageManager localizedString:@"Hotline"];
    [urlList addObject:hotlineFunc];
    
    person.supportUrls = [NSArray arrayWithArray:urlList];
    
}
-(void)btnClose:(id)sender{
    [super btnClose:sender];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return person.funcList.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FuncDisplay* funcDisplay = person.funcList[indexPath.row];
    if((userWrapper.status == ACCOUNT_FASTLOGIN || userWrapper.status == ACCOUNT_FACEBOOK || userWrapper.status == ACCOUNT_GOOGLE|| userWrapper.status == ACCOUNT_APPLE) && funcDisplay.funcsType != Exit){
        [self showTranferGuest:0];
        return;
    }
    if(funcDisplay.funcsType == Exit){
        [self showSignOut];
        return;
    }
    if(funcDisplay.funcsType == NeedVerify){
        if(funcDisplay.id == 1){
            UIViewController *topView = [Utils topViewController];
            VerifyEmail *customView =(VerifyEmail*) [Utils loadViewFromNibFile:[self class] withNib:@"VerifyEmail"];
            customView.userEmail = userWrapper.email;
            customView.callback = ^(NSString* identifier) {
                NSLog(@"Hide %@",identifier );
                
                if([identifier isEqual:CallbackSuccess]){
                    [self refreshDisplay];
                }
            };
            customView.translatesAutoresizingMaskIntoConstraints = NO;
            customView.tag = 202;
            [topView.view addSubview:customView];
            [Utils addConstraintForChild:topView.view andChild:customView withLeft:0 withTop:0 andRight:0 withBottom:0];
        }
        if(funcDisplay.id == 2){
            UIViewController *topView = [Utils topViewController];
            VerifyPhone *customView =(VerifyPhone*) [Utils loadViewFromNibFile:[self class] withNib:@"VerifyPhone"];
            customView.phoneNum = userWrapper.mobile;
            customView.callback = ^(NSString* identifier) {
                NSLog(@"Hide %@",identifier );
                
                if([identifier isEqual:CallbackSuccess]){
                    [self refreshDisplay];
                }
            };
            customView.translatesAutoresizingMaskIntoConstraints = NO;
            customView.tag = 202;
            [topView.view addSubview:customView];
            [Utils addConstraintForChild:topView.view andChild:customView withLeft:0 withTop:0 andRight:0 withBottom:0];
        }
    }
    if(funcDisplay.funcsType == Edit){
        if(funcDisplay.id == 3){
            UIViewController *topView = [Utils topViewController];
            UpdateID *customView =(UpdateID*) [Utils loadViewFromNibFile:[self class] withNib:@"UpdateID"];
            customView.userNationalId = userWrapper.passport;
            customView.callback = ^(NSString* identifier) {
                NSLog(@"Hide %@",identifier );
                
                if([identifier isEqual:CallbackSuccess]){
                    [self refreshDisplay];
                }
            };
            customView.translatesAutoresizingMaskIntoConstraints = NO;
            customView.tag = 202;
            [topView.view addSubview:customView];
            [Utils addConstraintForChild:topView.view andChild:customView withLeft:0 withTop:0 andRight:0 withBottom:0];
        }
        if(funcDisplay.id == 4){
            UIViewController *topView = [Utils topViewController];
            UpdateBirthday *customView =(UpdateBirthday*) [Utils loadViewFromNibFile:[self class] withNib:@"UpdateBirthday"];
            customView.userBirthDay = userWrapper.birthday;
            customView.callback = ^(NSString* identifier) {
                NSLog(@"Hide %@",identifier );
                if([identifier isEqual:CallbackSuccess]){
                    [self refreshDisplay];
                }
            };
            customView.translatesAutoresizingMaskIntoConstraints = NO;
            customView.tag = 202;
            [topView.view addSubview:customView];
            [Utils addConstraintForChild:topView.view andChild:customView withLeft:0 withTop:0 andRight:0 withBottom:0];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    CellFuncView *cell = (CellFuncView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    FuncDisplay* funcDisplay = person.funcList[indexPath.row];
    [cell.icon setImage:[UIImage imageNamed:funcDisplay.image inBundle:[NSBundle bundleForClass:self.class]
              compatibleWithTraitCollection:nil]];
    cell.text.text = funcDisplay.value;
    cell.text2.text = @"";
    if(funcDisplay.id == 1 || funcDisplay.id == 2){
        if(funcDisplay.funcsType == NeedVerify && ![funcDisplay.value isEqual:[TSLanguageManager localizedString:@"(trống)"]]){
            cell.text2.textColor = UIColor.redColor;
            cell.text2.text = [TSLanguageManager localizedString:@"Chưa xác minh"];
        }
        if(funcDisplay.funcsType == Display){
            cell.text2.textColor = UIColor.greenColor;
            cell.text2.text = [TSLanguageManager localizedString:@"Đã xác minh"];
        }
    }
    if(funcDisplay.funcsType == Display){
        cell.arrow.hidden = true;
    }
    return cell;
}
-(void) gotoChangeAccountView{
    UIViewController *topView = [Utils topViewController];
    ChangeAccountView *customView =(ChangeAccountView*) [Utils loadViewFromNibFile:[self class] withNib:@"ChangeAccountView"];
    
    customView.callback = ^(NSString* identifier) {
        NSLog(@"Hide %@",identifier );
        if([identifier isEqual:CallbackSuccess]){
            [self refreshDisplay];
        }
    };
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    customView.tag = 202;
    [topView.view addSubview:customView];
    [Utils addConstraintForChild:topView.view andChild:customView withLeft:0 withTop:0 andRight:0 withBottom:0];
}
-(void)showTranferGuest:(int)state{
    if(state == 0){
        [self showAlertWith2Action:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"Bạn đang sử dụng tài khoản khách, hãy chuyển sang tài khoản VtvLive ID"] withOkAction:^(UIAlertAction * _Nonnull) {
            [self gotoChangeAccountView];
        } andCancelAction:^(UIAlertAction * _Nonnull) {
            
        }];
    }
    if(state == 1){
        [self gotoChangeAccountView];
    }
}
-(void) showSignOut{
    [self showAlertWith2Action:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"Bạn có muốn đăng xuất ?"] withOkAction:^(UIAlertAction * _Nonnull) {
        [self doSignOut];
    } andCancelAction:^(UIAlertAction * _Nonnull) {
        
    }];
}
-(void) doSignOut{
    if(self.callback !=NULL){
        self.callback(CallbackHide);
    }
    [[Sdk sharedInstance] logout];
}
-(void)onTransfer:(NSString *)data{
    if(data != NULL && [data isEqual:DATA_TRANSFER_DEACTIVE]){
        
    }
}
@end
