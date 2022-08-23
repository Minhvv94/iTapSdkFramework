//
//  LoginWrapper.h
//  VnptSdk
//
//  Created by TranCong on 04/09/2021.
//

#import <Foundation/Foundation.h>
#import "DataWrapper.h"
#import "User.h"
NS_ASSUME_NONNULL_BEGIN

@interface LoginWrapper : DataWrapper
@property NSString *accessToken;
@property NSString *refreshToken;
@property User* user;
@end

NS_ASSUME_NONNULL_END
