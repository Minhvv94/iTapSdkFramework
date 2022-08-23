//
//  Utils.m
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import "Utils.h"
#import "Constant.h"
#import "Keychain.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>
#import "Sdk.h"
#import "AppInfo.h"
#import "DataUtils.h"
#import <JWT/JWT.h>
#import "IdApiRequest.h"
#import "ApiConfig.h"
#import <AFNetworking/AFNetworking.h>
#define SERVICE_NAME @"SECRET_AUTH"
#define CC_MD5_DIGEST_LENGTH    16          /* digest length in bytes */
#define CC_MD5_BLOCK_BYTES      64          /* block size in bytes */
#define CC_MD5_BLOCK_LONG       (CC_MD5_BLOCK_BYTES / sizeof(CC_LONG))
@implementation Utils
+(UIViewController *)topViewController{
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    }

+(UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
        if ([rootViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController* tabBarController = (UITabBarController*)rootViewController;
            return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
        } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController* navigationController = (UINavigationController*)rootViewController;
            return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
        } else if (rootViewController.presentedViewController) {
            UIViewController* presentedViewController = rootViewController.presentedViewController;
            return [self topViewControllerWithRootViewController:presentedViewController];
        } else {
            return rootViewController;
        }
}
+(NSString *)getDeviceId{
    /*NSString *appIdentifierPrefix =
        [[NSBundle mainBundle] objectForInfoDictionaryKey:AppIdentifierPrefix];
    NSString *keychainGroup =
        [[NSBundle mainBundle] objectForInfoDictionaryKey:KeychainGroup];
    
    NSString *shareGroup = [NSString stringWithFormat:@"%@%@",appIdentifierPrefix,keychainGroup];
    
    NSBundle *myBundle = [NSBundle bundleForClass:self.class];
    NSString *shareGroup = [myBundle objectForInfoDictionaryKey:KeychainGroup ];
    
    [self logMessage:[NSString stringWithFormat:@"shareGroup: %@",shareGroup]];
    
    Keychain *keychain = [[Keychain alloc] initWithService:SERVICE_NAME withGroup:shareGroup]; */
    
    Keychain *keychain = [[Keychain alloc] initWithService:SERVICE_NAME withGroup:nil];
    
    NSString *deviceId = nil;
    if(keychain != NULL){
        
        NSData * data =[keychain find:KEY_DEVICE_ID];
        if(data == nil)
        {
            [self logMessage:@"deviceID not found. Now, It's create new one"];
            deviceId =[[[[UIDevice currentDevice] identifierForVendor] UUIDString] lowercaseString];
            NSData *value = [deviceId dataUsingEncoding:NSUTF8StringEncoding];
             
            if([keychain insert:KEY_DEVICE_ID :value])
             {
                 [self logMessage:@"Successfully added data"];
             }
             else
                 [self logMessage:@"Failed to add data"];
        }
        else
        {
            deviceId = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            deviceId = [self md5str:deviceId];
        }
    }
    [self logMessage:[NSString stringWithFormat:@"deviceID : %@",deviceId]];
    return deviceId;
}
+ (BOOL)screenInPortrait{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
    {
        return TRUE;
    }
    return FALSE;
}
+ (UIView *)loadViewFromNibFile:(Class)aClass withNib:(NSString *)name{
    BOOL isPortrait = [self screenInPortrait];
    NSBundle *myBundle = [NSBundle bundleForClass:aClass];
    UIView *customView = nil;
    if(isPortrait){
        customView = [[myBundle loadNibNamed:name owner:self options:nil] objectAtIndex:0];
    }
    else{
        customView = [[myBundle loadNibNamed:[NSString stringWithFormat:@"%@-landscape",name] owner:self options:nil] objectAtIndex:0];
    }
    return customView;
}
+(UIView *)loadViewFromNibFile:(Class)aClass universalWithNib:(NSString *)name{
    UIView *customView = nil;
    NSBundle *myBundle = [NSBundle bundleForClass:aClass];
    customView = [[myBundle loadNibNamed:name owner:self options:nil] objectAtIndex:0];
    return customView;
}
//https://developer.apple.com/library/archive/documentation/DeviceInformation/Reference/iOSDeviceCompatibility/Displays/Displays.html
+(float)ratioScreen{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float maxWidth = MAX(screenRect.size.width* [[UIScreen mainScreen] scale],screenRect.size.height*[[UIScreen mainScreen] scale]);

    float maxHeight = MIN(screenRect.size.width*[[UIScreen mainScreen] scale],screenRect.size.height*[[UIScreen mainScreen] scale]);
    
    NSLog(@"Screen in width %f and height %f",maxWidth,maxHeight);
    return maxWidth*1.0/maxHeight;
}
+(float)heightScreen{
    return [[UIScreen mainScreen] bounds].size.height * [[UIScreen mainScreen] scale];
}
+(float)widthScreen{
    return [[UIScreen mainScreen] bounds].size.width * [[UIScreen mainScreen] scale];
}
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
+(void)addConstraintForChild:(UIView *)parent andChild:(UIView *)child withLeft:(float)left withTop:(float)top andRight:(float)right withBottom:(float)bottom{
    [parent addConstraints:@[
        //algin with bottom
        [NSLayoutConstraint constraintWithItem:parent
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:child //self.bottomLayoutGuide
                                     attribute:NSLayoutAttributeBottom //NSLayoutAttributeTop
                                    multiplier:1
                                      constant:bottom],
        //align leading
        [NSLayoutConstraint constraintWithItem:child
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:parent
                                     attribute:NSLayoutAttributeLeading
                                    multiplier:1
                                      constant:left],
        //align trailing
        [NSLayoutConstraint constraintWithItem:child
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:parent
                                     attribute:NSLayoutAttributeTrailing
                                    multiplier:1
                                      constant:right],
        //align top
        [NSLayoutConstraint constraintWithItem:child
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:parent
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1
                                      constant:top]
    ]];
}
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+(void)logMessage:(NSString *)msg{
//#ifdef DEBUG
// Something to log your sensitive data here
    NSLog(@"%@",msg);
//#else
//
//#endif
}
+(void)delayAction:(void (^)(void))action withTime:(float) time{
    NSTimeInterval delayInSeconds = time;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), action);
}
+(Class)getClassofProperty:(Class)aClass withProperty:(NSString *) nameProperty{
    //https://useyourloaf.com/blog/objective-c-class-properties/
    //https://developer.apple.com/forums/thread/653916
    //https://stackoverflow.com/questions/16861204/property-type-or-class-using-reflection
    const char *cName=[nameProperty UTF8String];
    objc_property_t property = class_getProperty(aClass, cName);
    const char * name = property_getName(property);
    NSString *propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    const char * type = property_getAttributes(property);
    NSString *attr = [NSString stringWithCString:type encoding:NSUTF8StringEncoding];

    NSString * typeString = [NSString stringWithUTF8String:type];
    NSArray * attributes = [typeString componentsSeparatedByString:@","];
    NSString * typeAttribute = [attributes objectAtIndex:0];
    NSString * propertyType = [typeAttribute substringFromIndex:1];
    const char * rawPropertyType = [propertyType UTF8String];

    if (strcmp(rawPropertyType, @encode(float)) == 0) {
        //it's a float
    } else if (strcmp(rawPropertyType, @encode(int)) == 0) {
        //it's an int
    } else if (strcmp(rawPropertyType, @encode(id)) == 0) {
        //it's some sort of object
    } else {
        // According to Apples Documentation you can determine the corresponding encoding values
    }

    if ([typeAttribute hasPrefix:@"T@"]) {
        NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];  //turns @"NSDate" into NSDate
        Class typeClass = NSClassFromString(typeClassName);
        if (typeClass != nil) {
            // Here is the corresponding class even for nil values
            return typeClass;
        }
    }
    return nil;
}

+(NSString *)typeForProperty:(NSString *)property andClass:(Class)class
{
    const char *type = property_getAttributes(class_getProperty(class, [property UTF8String]));
    NSString *typeString = [NSString stringWithUTF8String:type];
    NSArray *attributes = [typeString componentsSeparatedByString:@","];
    NSString *typeAttribute = [attributes objectAtIndex:0];
    NSString *className = [[[typeAttribute substringFromIndex:1]
                            stringByReplacingOccurrencesOfString:@"@" withString:@""]
                           stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    
    return className;
}
+ (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern caseSensitive:(BOOL)caseSensitive
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:((caseSensitive) ? 0 : NSRegularExpressionCaseInsensitive) error:&error];
    
    NSAssert(regex, @"Unable to create regular expression");
    
    NSRange textRange = NSMakeRange(0, string.length);
    NSRange matchRange = [regex rangeOfFirstMatchInString:string options:NSMatchingReportProgress range:textRange];
    
    BOOL didValidate = 0;
    
    // Did we find a matching range
    if (matchRange.location != NSNotFound)
        didValidate = 1;
    
    return didValidate;
}
+ (NSString *) md5str: ( NSString *) str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    NSString* temp = [NSString  stringWithFormat:
                      @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                      result[0], result[1], result[2], result[3], result[4],
                      result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11], result[12],
                      result[13], result[14], result[15]
                      ];
    //  temp = [temp substringToIndex:16];
    return [temp lowercaseString];
    
}
+(NSURL*) getUrl:(NSString*) key{
    NSBundle *myBundle = [NSBundle bundleForClass:self.class];
    NSString *baseUrl =
        [myBundle objectForInfoDictionaryKey:key];
    
    //NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@",baseUrl]];
    NSURL* url = [NSURL URLWithString:baseUrl];
    return url;
}
+(NSString *)getUTCFormatDate:(NSDate *)date withFormat:(NSString *)formateDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:formateDate];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}
+(NSString *)getUTCFormatDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}
+(NSString *)getFormatDate:(NSDate *)date withFormat:(NSString*) formatDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:formatDate]; //yyyy-MM-dd'T'HH:mm:ss'Z'
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}
+(NSString *)getLocaleFormatDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}
+(NSDate*) getLocalDate:(NSString*)dateString withFormat:(NSString*) formatDate{
      NSDateFormatter *df = [[NSDateFormatter alloc] init];
      NSTimeZone *timeZone = [NSTimeZone localTimeZone];
      [df setTimeZone:timeZone];
      [df setDateFormat:formatDate];// yyyy-MM-dd'T'HH:mm:ssZZZZZ
     NSDate *date = [df dateFromString:dateString];
     return date;
}
+(NSString *)calculateChecksum:(NSString *)message withSecretKey:(NSString *)secretKey{
    const char *cKey = [secretKey cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [message cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *hash = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];

    NSLog(@"%@", hash);

    NSString* s = [self base64forData:hash];
    return s;
}
+(NSString *)base64forData:(NSData *)theData{
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];

    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;

    NSInteger i;
    for (i=0; i < length; i += 3) {
    NSInteger value = 0;
    NSInteger j;
    for (j = i; j < (i + 3); j++) {
    value <<= 8;

    if (j < length) {  value |= (0xFF & input[j]);  }  }  NSInteger theIndex = (i / 3) * 4;  output[theIndex + 0] = table[(value >> 18) & 0x3F];
    output[theIndex + 1] = table[(value >> 12) & 0x3F];
    output[theIndex + 2] = (i + 1) < length ? table[(value >> 6) & 0x3F] : '=';
    output[theIndex + 3] = (i + 2) < length ? table[(value >> 0) & 0x3F] : '=';
    }

    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+(BOOL)isNullOrEmpty:(id) thing {
    return thing == nil
    || ([thing respondsToSelector:@selector(length)]
    && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
    && [(NSArray *)thing count] == 0);
}
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}
+(NSString *)maskLastofString:(NSString *)str withNum:(NSInteger)num{
    NSInteger len = str.length;
    if(len < num ) return str;
    
    NSString *subStr = [str substringWithRange:NSMakeRange(0, len-num)];
    
    NSMutableString *mask = [subStr mutableCopy];
    
    for (int i=0; i<num; i++) {
        [mask appendString:@"*"];
    }
    return [NSString stringWithString:mask];
}
+(NSString *)maskFirstofString:(NSString *)str withNum:(NSInteger)num{
    NSInteger len = str.length;
    if(len < num ) return str;
    
    NSString *subStr = [str substringWithRange:NSMakeRange(num, len-num)];
    
    NSMutableString *mask = [@"" mutableCopy];
    
    for (int i=0; i<num; i++) {
        [mask appendString:@"*"];
    }
    return [NSString stringWithFormat:@"%@%@",mask,subStr];
}

+(NSString *)maskEmail:(NSString *)str{
    if([str containsString:@"@"]){
        NSArray *arrayOfComponents = [str componentsSeparatedByString:@"@"];
        if([arrayOfComponents count] == 2){
            NSString* v1 = [arrayOfComponents objectAtIndex:0];
            NSString *comp1 = [self maskLastofString:v1 withNum:2];
            NSString* v2 = [arrayOfComponents objectAtIndex:1];
            NSString *comp2 = [self maskFirstofString:v2 withNum:2];
            return [NSString stringWithFormat:@"%@@%@",comp1,comp2];
        }
        
        return str;
    }
    else{
        return str;
    }
}
+(NSString *)maskPhone:(NSString *)str withNum:(NSInteger)num{
    int len = str.length;
    if(len < 2*num + 1){
        return str;
    }
    
    NSString* sub1 = [str substringWithRange:NSMakeRange(0, num)];
    NSString* sub2 = [str substringWithRange:NSMakeRange(len-num,num)];
    NSMutableString *mask = [@"" mutableCopy];
    for (int i=0; i<len - 2*num; i++) {
        [mask appendString:@"*"];
    }
    return [NSString stringWithFormat:@"%@%@%@",sub1,mask,sub2];
}
+(NSString*)base64EncodeString:(NSString*) data{
    NSData *plainData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    return  base64String;
}
+(NSString*)base64DecodeString:(NSString*) encryptedData{
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:encryptedData options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return decodedString;
}
+(NSString*)base64EncodeData:(NSData*) data{
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    return base64String;
}
+(NSData*)base64DecodeData:(NSString*) encryptedData{
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:encryptedData options:0];
    return decodedData;
}
+(NSDictionary *)createJwtFromJdt:(NSDictionary *)jdt withTime:(long) time{
    long nbf = time;
    long jti = time*1000L;
    NSLog(@"nbf: %ld",nbf);
    long exp = nbf + 60;
    NSString* clientId = [[Sdk sharedInstance] getAppInfo].client_id;
    NSString* clientSecret = [[Sdk sharedInstance] getAppInfo].client_secret;
    
    NSDictionary *payload = @{
        @"jti" : [NSString stringWithFormat:@"%ld", jti],
        @"nbf" : [NSString stringWithFormat:@"%ld", nbf],
        @"exp" : [NSString stringWithFormat:@"%ld", exp],
        @"iss" : clientId,
        @"jdt" : jdt
    };
    id<JWTAlgorithm> algorithm = [JWTAlgorithmFactory algorithmByName:@"HS256"];
    
    NSString* token = [JWTBuilder encodePayload:payload].secret(clientSecret).algorithm(algorithm).encode;
    //NSLog(@"jwt: %@",token);
    NSDictionary *body = @{
        @"jwt" : token
    };
    return body;
}
+(NSDictionary *)createJwtFromJdt:(NSDictionary *)jdt{
    long nbf = ([[NSDate date] timeIntervalSince1970]);
    NSLog(@"nbf: %ld",nbf);
    long jti = nbf * 1000L;
    long exp = nbf + 60;
    NSString* clientId = [[Sdk sharedInstance] getAppInfo].client_id;
    NSString* clientSecret = [[Sdk sharedInstance] getAppInfo].client_secret;
    
    NSDictionary *payload = @{
        @"jti" : [NSString stringWithFormat:@"%ld", jti],
        @"nbf" : [NSString stringWithFormat:@"%ld", nbf],
        @"exp" : [NSString stringWithFormat:@"%ld", exp],
        @"iss" : clientId,
        @"jdt" : jdt
    };
    id<JWTAlgorithm> algorithm = [JWTAlgorithmFactory algorithmByName:@"HS256"];
    
    NSString* token = [JWTBuilder encodePayload:payload].secret(clientSecret).algorithm(algorithm).encode;
    //NSLog(@"jwt: %@",token);
    NSDictionary *body = @{
        @"jwt" : token
    };
    return body;
}
+(NSNumber *)getAccountIdInPayload:(NSString *)jwtToken usingCache:(NSDictionary *)cache{
    
    NSDictionary *payload = NULL;
    if(cache == NULL){
        payload = cache;
    }
    else{
        payload = [Utils getPayloadInToken:jwtToken];
    }
    if (payload != NULL){
        if ([payload objectForKey:@"uid"]) {
            NSNumber* uid = (NSNumber*)[payload objectForKey:@"uid"];
            return uid;
        }
    }
    return  nil;
}
+(NSString *)getAccountNameInPayload:(NSString *)jwtToken usingCache:(NSDictionary *)cache{
    NSDictionary *payload = NULL;
    if(cache == NULL){
        payload = cache;
    }
    else{
        payload = [Utils getPayloadInToken:jwtToken];
    }
    if (payload != NULL){
        if ([payload objectForKey:@"name"]) {
            NSString* name = (NSString*)[payload objectForKey:@"name"];
            return name;
        }
    }
    return  nil;
}
+(NSString *)getEmailInPayload:(NSString *)jwtToken usingCache:(NSDictionary *)cache{
    NSDictionary *payload = NULL;
    if(cache == NULL){
        payload = cache;
    }
    else{
        payload = [Utils getPayloadInToken:jwtToken];
    }
    if (payload != NULL){
        if ([payload objectForKey:@"email"]) {
            NSString* email = (NSString*)[payload objectForKey:@"email"];
            return email;
        }
    }
    return  nil;
}
+(NSDictionary *)getPayloadInToken:(NSString *)jwtToken{
    NSArray *arrayOfComponents = [jwtToken componentsSeparatedByString:@"."];
    if(arrayOfComponents.count != 3){
        return nil;
    }
    
    NSString* encodedBase64Payload = [arrayOfComponents objectAtIndex:1];
    NSData* payloadData = [JWTBase64Coder dataWithBase64UrlEncodedString:encodedBase64Payload];
    
    NSError *errorParse;
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData:payloadData
                                                       options:NSJSONReadingAllowFragments
                                                         error:&errorParse];

    if (!errorParse){
        return payload;
    }
    return  nil;
}
+(void)doGetServerTime:(void (^)(long))doneAction andFail:(void (^)(void))failAction{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer =  [AFHTTPResponseSerializer serializer];
    BOOL isProdEnv = [[Sdk sharedInstance] isProdEnv];
    NSString* baseUrl = PROD_BASE_ID;
    if(!isProdEnv){
        baseUrl = DEV_BASE_ID;
    }
    
    NSURL* fullPath = [NSURL URLWithString:PATH_TIME_SERVER relativeToURL:[NSURL URLWithString:baseUrl]];
    [manager GET:fullPath.absoluteString parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Result: %@", result);
            long time = [result longLongValue];
            if(doneAction != NULL){
                doneAction(time);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(failAction != NULL){
                failAction();
            }
        }];
}
+ (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
     NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
     return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
 }
+ (CGFloat)heightForString:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxWidth {
    if (![text isKindOfClass:[NSString class]] || !text.length) {
        // no text means no height
        return 0;
    }
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attributes = @{ NSFontAttributeName : font };
    CGSize size = [text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:options attributes:attributes context:nil].size;
    CGFloat height = ceilf(size.height) + 1; // add 1 point as padding
    
    return height;
}
@end
