//
//  MaitainCheckerWrapper.h
//  iTapSdk
//
//  Created by TranCong on 03/12/2021.
//

#import <Foundation/Foundation.h>
#import "DataWrapper.h"

@interface MaitainCheckerWrapper : DataWrapper
@property BOOL isMaintained;
@property NSString *messageMaintain;

@property BOOL enableGoogleLogin;
@property BOOL enableFacebookLogin;
@property BOOL enableAppleLogin;
@end
