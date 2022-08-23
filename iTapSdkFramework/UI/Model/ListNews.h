//
//  ListNews.h
//  iTapSdk
//
//  Created by TranCong on 09/11/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListNews : NSObject

@property NSInteger newsId;
@property NSString *titleNews;
@property NSString *categoryName;
@property NSDate *createdAt;
@property NSDate *publishedAt;
@property NSURL* thumbUrl;

@end

NS_ASSUME_NONNULL_END
