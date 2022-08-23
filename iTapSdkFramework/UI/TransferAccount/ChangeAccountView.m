//
//  RegistrationView.m
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import "ChangeAccountView.h"
#import "Utils.h"
#import "TermConditionView.h"
#import "APIRequest.h"
#import "ApiConfig.h"
#import "DataUtils.h"
#import "LoginJson.h"
@implementation ChangeAccountView
{
    UIImage *checked;
    UIImage *unchecked;
    BOOL isCheck;
    float offset;
}
@synthesize lbNote;
@synthesize lbError;
@synthesize lbTitle;

@synthesize holderPwd;
@synthesize holderUsrname;
@synthesize holderConfirmPwd;

@synthesize btnRegister;
@synthesize checkbox;
@synthesize layoutBottomContainer;

-(void) initInternals{
    [super initInternals];
    offset = 0;
    isCheck = TRUE;
    checked = [UIImage imageNamed:@"checked" inBundle:[NSBundle bundleForClass:self.class]
    compatibleWithTraitCollection:nil];
    unchecked = [UIImage imageNamed:@"unchecked" inBundle:[NSBundle bundleForClass:self.class]
      compatibleWithTraitCollection:nil];
}

- (void) setupLabelAndColor{
    NSString * iAgree = [TSLanguageManager localizedString:@"Tôi đã đọc và đồng ý"];
    NSString * term = [TSLanguageManager localizedString:@"Điều khoản"];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:iAgree attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)}];
    
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:term attributes:@{
        NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
        NSForegroundColorAttributeName: UIColor.blueColor
    }]];
    
    [lbNote setAttributedText:attrString];
    self.lbTitle.text = [TSLanguageManager localizedString:@"CHUYỂN ĐỔI TÀI KHOẢN"];
    self.txtUsrname.placeholder = [TSLanguageManager localizedString:@"Tên đăng nhập"];
    self.txtPwd.placeholder = [TSLanguageManager localizedString:@"Mật khẩu"];
    self.txtConfirmPwd.placeholder = [TSLanguageManager localizedString:@"Nhập lại mật khẩu"];
    
    [self.btnRegister setTintColor:[Utils colorFromHexString:color_main_orange]];
    
}
-(void)configUI:(UIView *)parentView{
    
    [super configUI:parentView];
    self.txtUsrname.delegate = self;
    self.txtPwd.delegate = self;
    self.txtConfirmPwd.delegate = self;
    
    [self setupLabelAndColor];
    
    [self configFontByScreen];
    [self configKeyboard:50.0];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    singleTap.numberOfTapsRequired = 1;
    [checkbox setUserInteractionEnabled:YES];
    [checkbox addGestureRecognizer:singleTap];
    
    
    UITapGestureRecognizer *singleTapCondition = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCondition:)];
    singleTapCondition.numberOfTapsRequired = 1;
    [lbNote setUserInteractionEnabled:YES];
    [lbNote addGestureRecognizer:singleTapCondition];
    
    if(isCheck){
        [checkbox setImage:checked];
    }
    else{
        [checkbox setImage:unchecked];
    }
}

-(void)tapCondition:(id)sender{
    NSLog(@"tapCondition");
    TermConditionView *customView =(TermConditionView*) [Utils loadViewFromNibFile:[self class] universalWithNib:@"TermConditionView"];
    customView.delegate = self.delegate;
    customView.callback = ^(NSString* identifier) {
        NSLog(@"Hide %@",identifier );
    };
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    customView.tag = 202;
    [self addSubview:customView];
    [Utils addConstraintForChild:self andChild:customView withLeft:0 withTop:0 andRight:0 withBottom:0];
    
}

-(void)tapDetected:(id)sender{
    NSLog(@"tapDetected");
    isCheck = !isCheck;
    if(isCheck){
        [checkbox setImage:checked];
    }
    else{
        [checkbox setImage:unchecked];
    }
}

-(void)configFontByScreen{
    float heightScreen = [Utils heightScreen];
    if(heightScreen <=375){
        
    }
}

-(void)configKeyboard:(CGFloat) newOffset{
    self->offset = newOffset;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

    }
- (void)keyboardWillShow:(NSNotification*)aNotification {
        [UIView animateWithDuration:0.25 animations:^
         {
             /*CGRect newFrame = [self frame];
            newFrame.origin.y -=  self->offset; // tweak here to adjust the moving position
             [self setFrame:newFrame];*/
            self.layoutBottomContainer.constant = - self->offset;
            [self layoutIfNeeded];
            
         }completion:^(BOOL finished)
         {
         }];
    }
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
        [UIView animateWithDuration:0.25 animations:^
         {
             /*CGRect newFrame = [self frame];
            newFrame.origin.y +=  self->offset; // tweak here to adjust the moving position
             [self setFrame:newFrame];*/
            self.layoutBottomContainer.constant = 0;
            [self layoutIfNeeded];

         }completion:^(BOOL finished)
         {

         }];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
-(void)btnRegisteClick:(id)sender{
    
    NSString *deviceId =[Utils getDeviceId];
    NSLog(@"btnLogin: %@",deviceId);
    
    NSString* ursName = [self.txtUsrname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* pwd = [self.txtPwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* pwdConfirm = [self.txtConfirmPwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    self.lbError.text = @"";
    self.holderUsrname.borderColor = UIColor.lightGrayColor;
    if(ursName.length <=0){
        self.holderUsrname.borderColor = UIColor.redColor;
        [self.holderUsrname refresh];
        [self.holderPwd refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Hãy nhập username!"];
        return;
    }
    
    self.holderPwd.borderColor = UIColor.lightGrayColor;
    if(pwd.length <=0){
        self.holderPwd.borderColor = UIColor.redColor;
        [self.holderUsrname refresh];
        [self.holderPwd refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Hãy nhập mật khẩu!"];
        return;
    }
    if(ursName.length > 0 && ursName.length < 6){
        self.holderUsrname.borderColor = UIColor.redColor;
        [self.holderUsrname refresh];
        [self.holderPwd refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Tên đăng nhập quá ngắn!"];
        return;
    }
    if(pwd.length > 0 && pwd.length < 6){
        self.holderPwd.borderColor = UIColor.redColor;
        [self.holderUsrname refresh];
        [self.holderPwd refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Mật khẩu quá ngắn!"];
        return;
    }
    NSString *patternRegex = REGEX_CHECK_USERNAME;
    if(![Utils validateString:ursName withPattern:patternRegex caseSensitive:NO]){
        self.holderUsrname.borderColor = UIColor.redColor;
        [self.holderUsrname refresh];
        [self.holderPwd refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Tên đăng nhập phải từ 6 đến 30 ký không bao gồm ký tự đặc biệt!"];
        return;
    }
    NSString *patternPassRegex = REGEX_CHECK_PASS_WORD;
    if(![Utils validateString:pwd withPattern:patternPassRegex caseSensitive:NO]){
        self.holderPwd.borderColor = UIColor.redColor;
        [self.holderUsrname refresh];
        [self.holderPwd refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Mật khẩu không hợp lệ"];
        return;
    }
    [self.holderUsrname refresh];
    [self.holderPwd refresh];
    
    if(![pwd isEqual:pwdConfirm]){
        self.lbError.text = [TSLanguageManager localizedString:@"Mật khẩu không khớp"];
        [self.holderUsrname refresh];
        [self.holderPwd refresh];
        return;
    }
    
    if(!isCheck){
        [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"Vui lòng chọn đồng ý điều khoản và điều kiện"] withAction:^(UIAlertAction * _Nonnull) {
            
        }];
        return;
    }
    [self showLoading];
    AppInfo* appInfo = [[Sdk sharedInstance] getAppInfo];
    NSString* accessToken = [[Sdk sharedInstance] accessToken];
    [Utils logMessage:[NSString stringWithFormat:@"access token: %@",accessToken]];
    NSString* pwdMd5 = [Utils md5str:pwd];
    //NSString *deviceID = [Utils getDeviceId];
    //NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString * oldAccountName = nil;
    NSDictionary* payloadAccessToken = [Utils getPayloadInToken:accessToken];
    if(payloadAccessToken != NULL && [payloadAccessToken objectForKey:@"name"]){
        oldAccountName = (NSString*)[payloadAccessToken objectForKey:@"name"];
    }
    NSDictionary *body = @{
                            request_jwt: accessToken,
                            request_cid: appInfo.client_id,
                            request_client_id: appInfo.client_id,
                            @"newAccountName" : ursName,
                            @"oldAccountName" : oldAccountName,
                            @"dvId":deviceId,
                            request_Os: [appInfo.platformOS lowercaseString],
                            request_passwordMd5 : pwdMd5
    };
    __weak typeof(self) weakSelf = self;
    [Utils delayAction:^{
       
        [[IdApiRequest sharedInstance] callPostMethod:PATH_SWITCH_ACCOUNT withBody:body withToken:nil completion:^(id  _Nullable result) {
            [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
            
            LoginJson *loginJson = [[LoginJson alloc] initFromDictionary:result];
            if(loginJson != NULL){
                if(loginJson.statusCode == CODE_0){
                    [self hideLoading];
                    //[Utils logMessage:[NSString stringWithFormat:@"userName %@",loginJson.data.user.userName]];
                    if(loginJson.data != NULL && ![Utils isNullOrEmpty:loginJson.data.accessToken]){
                        [[DataUtils sharedInstance] saveAccessToken:loginJson.data.accessToken];
                    }
                    if(loginJson.data != NULL && ![Utils isNullOrEmpty:loginJson.data.refreshToken]){
                        [[DataUtils sharedInstance] saveRefreshToken:loginJson.data.refreshToken];
                    }
                    [self showAlert:nil withContent:[TSLanguageManager localizedString:@"Thao tác thành công"] withAction:^(UIAlertAction * _Nonnull) {
                        if(self.callback != NULL){
                            //callback to refresh data
                            self.callback(CallbackSuccess);
                        }
                        [self removeFromSuperview];
                    }];
                }
                //httpCode=200 but code is 400 or 401
                else{
                    if(loginJson.statusCode != CODE_86){
                        [self hideLoading];
                        [self handleErrorCode:loginJson.statusCode andMessage:loginJson.message andAction:nil];
                        //[self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:errorText withAction:nil];
                    }
                    else{
                        [self doRefreshWithAction:^{
                            [weakSelf btnRegisteClick:nil];
                        }];
                    }
                }
            }
            else{
                [self hideLoading];
                [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:[TSLanguageManager localizedString:@"Lỗi không xác định"] withAction:nil];
            }
            } error:^(NSError * _Nonnull error,  id  _Nullable result,int httpCode) {
                [self hideLoading];
                [self handleError:error withResult:result andHttpCode:httpCode];
                [Utils logMessage:[NSString stringWithFormat:@"error %ld",error.code]];
                [Utils logMessage:[NSString stringWithFormat:@"desc %@",error.description]];
                
            }];
    } withTime:0.5f];
    
}

-(void)btnClose:(id)sender{
    [super btnClose:sender];
    NSLog(@"btnClose");
    [self removeFromSuperview];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if([self.txtUsrname isEqual:textField] && textField.returnKeyType == UIReturnKeyNext){
        [self.txtPwd becomeFirstResponder];
    }
    if([self.txtPwd isEqual:textField] && textField.returnKeyType == UIReturnKeyNext){
        [self.txtConfirmPwd becomeFirstResponder];
    }
    if([self.txtConfirmPwd  isEqual:textField] && textField.returnKeyType == UIReturnKeyDone){
        [self.txtConfirmPwd  resignFirstResponder];
    }    
    return NO;
}
@end
