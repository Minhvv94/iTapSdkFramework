//
//  BaseJson.h
//  VnptSdk
//
//  Created by TranCong on 04/09/2021.
//

#import <Foundation/Foundation.h>
#import "KZPropertyMapper.h"
#import "Constant.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseJson : NSObject
-(instancetype) initFromDictionary:(NSDictionary*) dict;
-(instancetype) initFromArray:(NSArray*)array;
-(instancetype) initFromId:(id)value;
-(id)passArray:(NSArray *)array forPropertyName:(NSString *)propertyName;
-(id)passDictionary:(NSDictionary *)dictionary forPropertyName:(NSString *)propertyName;
-(id)passId:(id)data forPropertyName:(NSString *)propertyName;
@end

NS_ASSUME_NONNULL_END
