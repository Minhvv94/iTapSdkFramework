//
//  RegistrationView.m
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import "UpdateBirthday.h"
#import "Utils.h"
#import "NSLayoutConstraint+Multiplier.h"
#import "LoginJson.h"
@implementation UpdateBirthday
{
    float offset;
}
@synthesize lbError;
@synthesize lbTitle;
@synthesize txtBirthday;

@synthesize holderBirthday;
@synthesize btnUpdate;
@synthesize layoutHeightStack;
@synthesize layoutBottomContainer;
@synthesize userBirthDay;
-(void) initInternals{
    [super initInternals];
    offset = 0;
}

- (void) setupLabel{
    self.txtBirthday.placeholder = [TSLanguageManager localizedString:@"Nhập ngày sinh"];
    
    self.lbTitle.text = [TSLanguageManager localizedString:@"CẬP NHẬT NGÀY SINH"];
    [self.btnUpdate setTitle:[TSLanguageManager localizedString:@"Cập nhật"] forState:UIControlStateNormal];
    
    [self.btnUpdate setTintColor:[Utils colorFromHexString:color_main_orange]];
}
-(void)configUI:(UIView *)parentView{
    
    UIDatePicker* datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    if (@available(iOS 13.4, *)) {
        [datePicker setPreferredDatePickerStyle:UIDatePickerStyleWheels];
    }
    /*if (@available(iOS 14.0, *)) {
        [datePicker setPreferredDatePickerStyle:UIDatePickerStyleCompact];
    }*/
    
    [datePicker addTarget:self action:@selector(dateChangedValue:)
forControlEvents:UIControlEventValueChanged];
    
    NSDateFormatter *formatter;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    /*if(![Utils isNullOrEmpty:user.birthday]){
        NSDate *date=[formatter dateFromString:user.birthday];
        [datePicker setDate:date];

    }*/
    
    NSDate *birthDayDate = [Utils getLocalDate:userBirthDay withFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [datePicker setDate:birthDayDate];
    
    NSDate *dateMax=[formatter dateFromString:@"01/01/2014"];
    NSDate *dateMin=[formatter dateFromString:@"01/01/1950"];
    [datePicker setMaximumDate:dateMax];
    [datePicker setMinimumDate:dateMin];
    
    [super configUI:parentView];
    //self.txtBirthday.delegate = self;
    
    if(![Utils isNullOrEmpty:userBirthDay]){
        self.txtBirthday.text = [Utils getLocaleFormatDate:birthDayDate];
    }
    
    self.txtBirthday.inputView = datePicker;
    [self setupLabel];
    [self configScale];
    
    [self configFontByScreen];
    [self configKeyboard:50.0];
}
-(void)dateChangedValue:(UIDatePicker*) datePicker{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:datePicker.date];
    self.txtBirthday.text = dateString;
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

-(void)btnUpdateClick:(id)sender{
    
    NSString* birthday = self.txtBirthday.text;
    
    self.lbError.text = @"";
    self.holderBirthday.borderColor = UIColor.lightGrayColor;
    if(birthday.length <=0){
        self.holderBirthday.borderColor = UIColor.redColor;
        [self.holderBirthday refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Nhập ngày sinh"];
        return;
    }
    
    NSString *patternRegex = @"^(\\d{1,2})\/(\\d{1,2})\/(\\d{4})$";
    if(![Utils validateString:birthday withPattern:patternRegex caseSensitive:NO]){
        self.holderBirthday.borderColor = UIColor.redColor;
        [self.holderBirthday refresh];
        self.lbError.text = [TSLanguageManager localizedString:@"Định dạng không đúng, vui lòng thử lại"];
        return;
    }
    [self.holderBirthday refresh];
    
    [self showLoading];
    __weak typeof(self) weakSelf = self;
    [Utils delayAction:^{
        NSDate* date = [Utils getLocalDate:birthday withFormat:@"dd/MM/yyyy"];
        NSString * dateString = [Utils getFormatDate:date withFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        //User* currentUer = [[Sdk sharedInstance] currentUser];
        NSString* accessToken = [[Sdk sharedInstance] accessToken];
        AppInfo* appInfo = [[Sdk sharedInstance] getAppInfo];
        NSDictionary *body = @{
                                request_jwt:accessToken,
                                request_mkc2:@"sdk",
                                request_cid:appInfo.client_id,
                                request_client_id: appInfo.client_id,
                                @"birthDay":dateString
        };
        [[IdApiRequest sharedInstance] callPostMethod:PATH_UPDATE_INFO withBody:body withToken:nil completion:^(id  _Nullable result) {
            [Utils logMessage:[NSString stringWithFormat:@"content %@",result]];
            
            LoginJson *loginJson = [[LoginJson alloc] initFromDictionary:result];
            if(loginJson != NULL){
                if(loginJson.statusCode == CODE_0){
                    [self hideLoading];
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
                            [weakSelf btnUpdateClick:nil];
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
    } withTime:0.5f];;
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
    if([self.txtBirthday isEqual:textField] && textField.returnKeyType == UIReturnKeyDone){
        [self.txtBirthday resignFirstResponder];
    }
    return NO;
}
@end
