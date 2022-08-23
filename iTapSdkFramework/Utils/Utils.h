//
//  Utils.h
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Utils : NSObject
+ (UIViewController*) topViewController;
+ (NSString*) getDeviceId;
+ (BOOL) screenInPortrait;
+ (UIView*) loadViewFromNibFile:(Class) aClass withNib:(NSString*) name;
+ (UIView*) loadViewFromNibFile:(Class) aClass universalWithNib:(NSString*) name;
+ (float) ratioScreen;
+ (float) heightScreen;
+ (float) widthScreen;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (void) addConstraintForChild:(UIView*)parent andChild:(UIView*) child withLeft:(float) left withTop:(float) left andRight:(float) right withBottom:(float) bottom;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (void) logMessage:(NSString*) msg;
+(void) delayAction:(void (^)(void))action withTime:(float) time;
+(Class) getClassofProperty:(Class) aClass withProperty:(NSString*) nameProperty;
+(NSString *)typeForProperty:(NSString *)property andClass:(Class) aClass;
+ (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern caseSensitive:(BOOL)caseSensitive;
+ (NSString *) md5str: ( NSString *) str;
+ (NSURL*) getUrl:(NSString*) key;
+(NSString *)getUTCFormatDate:(NSDate *)date withFormat:(NSString*) formatDate;
+(NSString *)getUTCFormatDate:(NSDate *)date;
+(NSString *)getFormatDate:(NSDate *)date withFormat:(NSString*) formatDate;
+(NSString *)getLocaleFormatDate:(NSDate *)date;
+(NSDate*) getLocalDate:(NSString*)dateString withFormat:(NSString*) formatDate;
+(NSString*)base64forData:(NSData*)theData;
+(NSString*)calculateChecksum:(NSString*)message withSecretKey:(NSString*) secretKey;
+(BOOL)isNullOrEmpty:(id)thing;
+(UIImage *)imageWithColor:(UIColor *)color;
+(NSString*)maskLastofString:(NSString*) str withNum:(NSInteger) num;
+(NSString*)maskEmail:(NSString*) str;
+(NSString*)maskPhone:(NSString*) str withNum:(NSInteger) num;
+(NSString*)base64EncodeString:(NSString*) data;
+(NSString*)base64DecodeString:(NSString*) encryptedData;
+(NSString*)base64EncodeData:(NSData*)data;
+(NSData*)base64DecodeData:(NSString*) encryptedData;
+(NSDictionary*) createJwtFromJdt:(NSDictionary*) data;
+(NSDictionary *)createJwtFromJdt:(NSDictionary *)jdt withTime:(long) time;
+(NSNumber*) getAccountIdInPayload:(NSString*) token usingCache:(NSDictionary*) cache;
+(NSString*) getAccountNameInPayload:(NSString*) token usingCache:(NSDictionary*) cache;
+(NSString*) getEmailInPayload:(NSString*) token usingCache:(NSDictionary*) cache;
+(NSDictionary*) getPayloadInToken:(NSString*) token;
+(void) doGetServerTime:(void(^)(long)) doneAction andFail:(void(^)(void)) failAction;

+ (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font;
+ (CGFloat)heightForString:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxWidth;
@end
