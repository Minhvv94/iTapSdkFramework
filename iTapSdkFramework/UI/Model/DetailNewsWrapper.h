//
//  DetailNewsWrapper.h
//  iTapSdk
//
//  Created by TranCong on 10/11/2021.
//

#import <Foundation/Foundation.h>
#import "DataWrapper.h"
NS_ASSUME_NONNULL_BEGIN

@interface DetailNewsWrapper : DataWrapper

@property NSDate *publishedAt;
@property NSString *titleNews;
@property NSString *contentNews;
@property NSURL *thumbUrlNews;
@end

NS_ASSUME_NONNULL_END
