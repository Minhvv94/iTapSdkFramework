//
//  VnptProduct.h
//  VnptSdk
//
//  Created by TranCong on 06/09/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IAPProduct : NSObject

@property (nonatomic,strong) NSString *productId;
@property (nonatomic,strong) NSString *productDescription;
@property (nonatomic,strong) NSString *flatformOS;
@property (nonatomic,strong) NSDecimalNumber *price;
@property (nonatomic,strong) NSString *localizedPrice;
@property (nonatomic,strong) NSString *currencyCode;
@property (nonatomic, strong) NSLocale *priceLocale;
@property int appAmount;
@property int amount; //vXu
@end

NS_ASSUME_NONNULL_END
