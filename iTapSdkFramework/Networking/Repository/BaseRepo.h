//
//  BaseRepo.h
//  iTapSdk
//
//  Created by TranCong on 10/11/2021.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
#import "GameApiRequest.h"
#import "DataUtils.h"
#import "ResponseJson.h"
#import "Sdk.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseRepo : NSObject
-(void)execute;
@end

NS_ASSUME_NONNULL_END
