//
//  GameConfigWrapper.h
//  iTapSdk
//
//  Created by TranCong on 26/10/2021.
//

#import <Foundation/Foundation.h>
#import "DataWrapper.h"
NS_ASSUME_NONNULL_BEGIN

@interface GameConfigWrapper : DataWrapper
@property NSString *hotLinkHomepage;
@property NSString *hotLinkFanpage;
@property NSString *hotLinkGroup;
@property NSString *hotLinkChat;
@property NSString *hotline;
@end

NS_ASSUME_NONNULL_END
