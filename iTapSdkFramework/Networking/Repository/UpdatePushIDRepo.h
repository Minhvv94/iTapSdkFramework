//
//  UpdatePushIDRepo.h
//  VnptSdk
//
//  Created by TranCong on 11/10/2021.
//

#import <Foundation/Foundation.h>
#import "BaseRepo.h"
NS_ASSUME_NONNULL_BEGIN

@interface UpdatePushIDRepo : BaseRepo
@property NSString* pushId;
@property NSString* accessToken;
@property NSString* packageId;
@property NSString* platformOs;
@end

NS_ASSUME_NONNULL_END
