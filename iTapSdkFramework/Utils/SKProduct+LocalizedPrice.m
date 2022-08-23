//
//  SKProduct+LocalizedPrice.m
//  testgame
//
//  Created by TranCong on 20/08/2021.
//

#import "SKProduct+LocalizedPrice.h"

@implementation SKProduct(LocalizedPrice)

-(NSString *)localizedPrice{
    
    NSNumberFormatter *formater = [[NSNumberFormatter alloc] init];
    formater.numberStyle = NSNumberFormatterCurrencyStyle;
    formater.locale = self.priceLocale;
    return [formater stringFromNumber:self.price];
}
-(NSString*)currencyCode{
    NSString *code = [self.priceLocale objectForKey:NSLocaleCurrencyCode];
    return code;
}
@end
