//
//  ListNewsWrapper.h
//  iTapSdk
//
//  Created by TranCong on 09/11/2021.
//

#import <Foundation/Foundation.h>
#import "DataWrapper.h"
#import "ListNews.h"
NS_ASSUME_NONNULL_BEGIN

@interface ListNewsWrapper : DataWrapper
@property NSArray *listPostInPage;
@property NSInteger totalPost;
@end

NS_ASSUME_NONNULL_END
