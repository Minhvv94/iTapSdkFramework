//
//  DevicesUtil.h
//  iTapSdk
//
//  Created by TranCong on 07/12/2021.
//

#import <Foundation/Foundation.h>
#import <AdSupport/ASIdentifierManager.h> 
NS_ASSUME_NONNULL_BEGIN

@interface DevicesUtil : NSObject
+ (NSString*) getDeviceModel;

+ (NSString*) getIdfa;

+ (NSString*) getIdfv;
@end
NS_ASSUME_NONNULL_END
