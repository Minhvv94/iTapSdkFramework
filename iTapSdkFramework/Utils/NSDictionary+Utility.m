//
//  NSDictionary+Utility.m
//  VnptSdk
//
//  Created by TranCong on 01/09/2021.
//

#import "NSDictionary+Utility.h"


@implementation NSDictionary (Utility)

- (id)objectForKeyNotNull:(NSString *)key {
   id object = [self objectForKey:key];
    if ((NSNull *)object == [NSNull null] || (__bridge CFNullRef)object == kCFNull)
      return nil;

   return object;
}

@end
