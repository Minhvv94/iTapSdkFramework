//
//  PersonalDisplay.h
//  testgame
//
//  Created by Tran Trong Cong on 8/13/21.
//

#import <Foundation/Foundation.h>
#import "FuncDisplay.h"
NS_ASSUME_NONNULL_BEGIN

@interface PersonalDisplay : NSObject
@property NSString *userName;
@property NSString *avatarUrl;
@property NSArray<FuncDisplay*> *supportUrls;
@property NSArray<FuncDisplay*> *funcList;
@end

NS_ASSUME_NONNULL_END
