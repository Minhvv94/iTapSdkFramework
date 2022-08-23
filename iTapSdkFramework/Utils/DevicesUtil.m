//
//  DevicesUtil.m
//  iTapSdk
//
//  Created by TranCong on 07/12/2021.
//

#import "DevicesUtil.h"
#import "Utils.h"
#include <sys/utsname.h>

@implementation DevicesUtil
+ (NSString*) getDeviceModel{
struct utsname systemInfo;
uname(&systemInfo);
NSString* code = [NSString stringWithCString:systemInfo.machine
encoding:NSUTF8StringEncoding];
static NSDictionary* deviceNamesByCode = nil;
if (!deviceNamesByCode) {
deviceNamesByCode = [self getDeviceNamesByCode];
}
NSString* deviceName = deviceNamesByCode[code];
if (deviceName)
return deviceName;
// Not found on database. At least guess main device type from string contents:
if ([code rangeOfString:@"iPod"].location == NSNotFound) {
deviceName = @"Unknown";
}else {
deviceName = @"iPod Touch";
return deviceName;
}
if([code rangeOfString:@"iPad"].location == NSNotFound) {
deviceName = @"Unknown";
}else {
deviceName = @"iPad";
return deviceName;
}
if([code rangeOfString:@"iPhone"].location == NSNotFound){
deviceName = @"Unknown";
}else {
deviceName = @"iPhone";
}
return deviceName;
}
+ (NSDictionary *) getDeviceNamesByCode {
return @{@"i386" : @"Simulator",
@"x86_64" : @"Simulator",
@"iPod1,1" : @"iPod Touch", // (Original)
@"iPod2,1" : @"iPod Touch", // (Second Generation)
@"iPod3,1" : @"iPod Touch", // (Third Generation)
@"iPod4,1" : @"iPod Touch", // (Fourth Generation)
@"iPod7,1" : @"iPod Touch", // (6th Generation)
@"iPhone1,1" : @"iPhone", // (Original)
@"iPhone1,2" : @"iPhone", // (3G)
@"iPhone2,1" : @"iPhone", // (3GS)
@"iPad1,1" : @"iPad", // (Original)
@"iPad2,1" : @"iPad 2", //
@"iPad3,1" : @"iPad", // (3rd Generation)
@"iPhone3,1" : @"iPhone 4", // (GSM)
@"iPhone3,3" : @"iPhone 4", // (CDMA/Verizon/Sprint)
@"iPhone4,1" : @"iPhone 4S", //
@"iPhone5,1" : @"iPhone 5", // (model A1428, AT&T/Canada)
@"iPhone5,2" : @"iPhone 5", // (model A1429, everything else)
@"iPad3,4" : @"iPad", // (4th Generation)
@"iPad2,5" : @"iPad Mini", // (Original)
@"iPhone5,3" : @"iPhone 5c", // (model A1456, A1532 | GSM)
@"iPhone5,4" : @"iPhone 5c", // (model A1507, A1516, A1526 (China), A1529 | Global)
@"iPhone6,1" : @"iPhone 5s", // (model A1433, A1533 | GSM)
@"iPhone6,2" : @"iPhone 5s", // (model A1457, A1518, A1528 (China), A1530 | Global)
@"iPhone7,1" : @"iPhone 6 Plus", //
@"iPhone7,2" : @"iPhone 6", //
@"iPhone8,1" : @"iPhone 6S", //
@"iPhone8,2" : @"iPhone 6S Plus", //
@"iPhone8,4" : @"iPhone SE", //
@"iPhone9,1" : @"iPhone 7", //
@"iPhone9,3" : @"iPhone 7", //
@"iPhone9,2" : @"iPhone 7 Plus", //
@"iPhone9,4" : @"iPhone 7 Plus", //
@"iPhone10,1": @"iPhone 8", // CDMA
@"iPhone10,4": @"iPhone 8", // GSM
@"iPhone10,2": @"iPhone 8 Plus", // CDMA
@"iPhone10,5": @"iPhone 8 Plus", // GSM
@"iPhone10,3": @"iPhone X", // CDMA
@"iPhone10,6": @"iPhone X", // GSM
@"iPad4,1" : @"iPad Air", // 5th Generation iPad (iPad Air) — Wifi
@"iPad4,2" : @"iPad Air", // 5th Generation iPad (iPad Air) — Cellular
@"iPad4,4" : @"iPad Mini", // (2nd Generation iPad Mini — Wifi)
@"iPad4,5" : @"iPad Mini", // (2nd Generation iPad Mini — Cellular)
@"iPad4,7" : @"iPad Mini", // (3rd Generation iPad Mini — Wifi (model A1599))
@"iPad6,7" : @"iPad Pro (12.9\")", // iPad Pro 12.9 inches — (model A1584)
@"iPad6,8" : @"iPad Pro (12.9\")", // iPad Pro 12.9 inches — (model A1652)
@"iPad6,3" : @"iPad Pro (9.7\")", // iPad Pro 9.7 inches — (model A1673)
@"iPad6,4" : @"iPad Pro (9.7\")" }; // iPad Pro 9.7 inches — (models A1674 and A1675)
}

+(NSString *)getIdfa{
    NSString *idfaString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    if([Utils isNullOrEmpty:idfaString]){
        return @"";
    }
    return idfaString;
}
+(NSString *)getIdfv{
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    if([Utils isNullOrEmpty:idfv]){
        return @"";
    }
    return idfv;
}
@end