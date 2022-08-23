//
//  RegistrationView.m
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import "UpdateID.h"
#import "Utils.h"
#import "NSLayoutConstraint+Multiplier.h"
#import "LoginJson.h"
@implementation UpdateID
{
    float offset;
}
@synthesize lbError;
@synthesize lbTitle;
@synthesize txtNumIdentifier;

@synthesize holderNumIdentifier;
@synthesize btnUpdate;
@synthesize layoutHeightStack;
@synthesize layoutBottomContainer;
@synthesize userNationalId;
-(void) initInternals{
    [super initInternals];
    offset = 0;
}

- (void) setupLabel{
    self.txtNumIdentifier.placeholder = [TSLanguageManager localizedString:@"Nhập số CCCD"];
    if(![Utils isNullOrEmpty:userNationalId]){
        self.txtNumIdentifier.text = userNationalId;
    }
    self.lbTitle.text = [TSLanguageManager localizedString:@"CẬP NHẬT CCCD"];
    [self.btnUpdate setTitle:[TSLanguageManager localizedString:@"Cập nhật"] forState:UIControlStateNormal];
    
    [self.btnUpdate setTintColor:[Utils colorFromHexString:color_main_orange]];
    
}
-(void)configUI:(UIView *)parentView{
    
    [super configUI:parentView];
    self.txtNumIdentifier.delegate = self;

    [self setupLabel];
    [self configScale];
    
    [self configFontByScreen];
    [self configKeyboard:50.0];
}

-(void) configScale{
    float heigh = [Utils heightScreen];
    [Utils logMessage:[NSString stringWithFormat:@"heigh: %f",heigh]];
    if(heigh < 1335){
        if([Utils screenInPortrait]){
            //self.layoutHeightStack = [self.layoutHeightStack updateMultiplier:0.3];
        }
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

-(void)btnUpdateIdClick:(id)sender{
    
    NSString *deviceId =[Utils getDeviceId];
    NSLog(@"btnLogin: %@",deviceId);
    
    NSString* numerId = self.txtNumIdentifier.text;
    
    self.lbError.text = @"";
    self.holderNumIdentifier.borderColor = UIColor.lightGrayColor;
    if(numerId.length <=0){
        self.holderNumIdentifier.borderColor = UIColor.redColor;
        [self.holderNumIdentifier refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Nhập số CCCD"];
        return;
    }
    
    //NSString *patternRegex = @"^[0-9]{9,12}$";
    NSString *patternRegex = @"^(?=[0-9]*$)(?:.{9}|.{12})$";
    if(![Utils validateString:numerId withPattern:patternRegex caseSensitive:NO]){
        self.holderNumIdentifier.borderColor = UIColor.redColor;
        [self.holderNumIdentifier refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Số CCCD không đúng, vui lòng thử lại"];
        return;
    }
    [self.holderNumIdentifier refresh];
    
    [self showLoading];
    __weak typeof(self) weakSelf = self;
    
    [Utils delayAction:^{
        
        //User* currentUer = [[Sdk sharedInstance] currentUser];
        AppInfo* appInfo = [[Sdk sharedInstance] getAppInfo];
        NSString* accessToken = [[Sdk sharedInstance] accessToken];
        NSDictionary *body = @{
                                request_jwt:accessToken,
                                request_cid:appInfo.client_id,
                                request_client_id: appInfo.client_id,
                                request_mkc2:@"sdk",
                                @"passport": numerId
        };
        [[IdApiRequest sharedInstance] callPostMethod:PATH_UPDATE_PASSPORT withBody:body withToken:nil completion:^(id  _Nullable result) {
            [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
            
            ResponseJson *loginJson = [[ResponseJson alloc] initFromDictionary:result];
            if(loginJson != NULL){
                if(loginJson.statusCode == CODE_0){
                    [self hideLoading];
                    //[Utils logMessage:[NSString stringWithFormat:@"userName %@",loginJson.data.user.userName]];
                    //[[DataUtils sharedInstance] saveUser:loginJson.data.user];
                    [self showAlert:nil withContent:[TSLanguageManager localizedString:@"Cập nhật thành công"] withAction:^(UIAlertAction * _Nonnull) {
                        if(self.callback != NULL){
                            //callback to refresh data
                            self.callback(CallbackSuccess);
                        }
                        [self removeFromSuperview];
                    }];
                }
                else{
                    if(loginJson.statusCode != CODE_86){
                        [self hideLoading];
                        [self handleErrorCode:loginJson.statusCode andMessage:loginJson.message andAction:nil];
                        //[self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:errorText withAction:nil];
                    }
                    else{
                        [self doRefreshWithAction:^{
                            [weakSelf btnUpdateIdClick:nil];
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
-(void)btnClose:(id)sender{
    [super btnClose:sender];
    NSLog(@"btnClose");
    [self removeFromSuperview];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([self.txtNumIdentifier isEqual:textField] && textField.returnKeyType == UIReturnKeyDone){
        [self.txtNumIdentifier resignFirstResponder];
    }
    return NO;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    int maxLen = 12;
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSString* s = [[string componentsSeparatedByCharactersInSet:myCharSet.invertedSet] componentsJoinedByString:@""];
    // manually replace the range in the textView
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:s];
    if([textField.text length] > maxLen){
        textField.text =[textField.text substringWithRange:NSMakeRange(0, maxLen)];
    }
    return NO;
}

@end
