//
//  ResponeJson.h
//  VnptSdk
//
//  Created by TranCong on 01/09/2021.
//

#import <Foundation/Foundation.h>
#import "BaseJson.h"
#import "DataWrapper.h"
NS_ASSUME_NONNULL_BEGIN

@interface ResponseJson<T: DataWrapper*> : BaseJson
@property BOOL success;
@property int statusCode;
@property NSString *message;
@property T data;
-(Class) dataClass;
@end

NS_ASSUME_NONNULL_END
