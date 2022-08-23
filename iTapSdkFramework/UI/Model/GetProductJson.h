//
//  GetProductJson.h
//  VnptSdk
//
//  Created by TranCong on 07/09/2021.
//

#import <Foundation/Foundation.h>
#import "ResponseJson.h"
#import "GetProductWrapper.h"

NS_ASSUME_NONNULL_BEGIN

@interface GetProductJson : ResponseJson<GetProductWrapper*>

@end
/*
 {
     "success": true,
     "statusCode": 200,
     "data": [
         {
             "productId": "product.item1",
             "platform": "ios",
             "appAmount": 1000,
             "description": "\bMô tả gói vàng 1",
             "channel": null,
             "amount": 0
         }
     ],
     "message": "."
 }
 */
NS_ASSUME_NONNULL_END
