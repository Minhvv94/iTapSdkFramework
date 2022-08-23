//
//  PaymentView.m
//  iTapSdk
//
//  Created by TranCong on 09/03/2022.
//

#import "PaymentView.h"
#import <AppsFlyerLib/AppsFlyerLib.h>
#import "PaymentApiRequest.h"
#import "OrderJson.h"
@implementation PaymentView
@synthesize products;
@synthesize serverId;
@synthesize characterId;
@synthesize productId;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)confirmTransaction:(TransactionInfo*) trans andSKTransaction:(SKPaymentTransaction*) transaction{
    NSString *accessToken = [[Sdk sharedInstance] accessToken];
    AppInfo *appInfo = [[Sdk sharedInstance] getAppInfo];
    NSDictionary *body = @{
        request_jwt:accessToken,
        request_cid:appInfo.client_id,
        request_client_id:appInfo.client_id,
        request_Os: [appInfo.platformOS lowercaseString],
        @"bank_code" :trans.purchasedToken,
        @"transId" :trans.paymentOrderId,
        request_maker_code:trans.productId,
        request_character_id:self.characterId,
        request_server_id:self.serverId
    };
    [Utils logMessage:@"check receipt"];
    [[PaymentApiRequest sharedInstance] callPostMethod:PATH_PAYMENT_CONFIRM_ORDER_IAP withBody:body withToken:nil completion:^(id  _Nullable result) {
        [Utils logMessage:@"check receipt success"];
        [Utils logMessage:result];
        ResponseJson *resp = [[ResponseJson alloc] initFromDictionary:result];
        if(resp.statusCode == CODE_0){
            [Utils logMessage:@"finish receipt success"];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            trans.confirmByServer = TRUE;
            if(self.delegate != NULL){
                [self.delegate didPurchaseSuccess:trans];
            }
            IAPProduct* findProductItem = nil;
            if(self.products != NULL){
                for (int j=0; j< self.products.count; j++) {
                    IAPProduct* productItem = [self.products objectAtIndex:j];
                    if([productItem.productId isEqual:transaction.payment.productIdentifier]){
                        findProductItem = productItem;
                        break;
                    }
                }
            }
            NSString * revenue = @"0";
            NSString * currency = @"VND";
            if(findProductItem != nil){
                revenue = [findProductItem.price stringValue];
                currency  = findProductItem.currencyCode;
            }
            NSDictionary*  eventParams = @{
                AFEventParamContentId: transaction.payment.productIdentifier,
                AFEventParamReceiptId: transaction.transactionIdentifier,
                AFEventParamOrderId: transaction.transactionIdentifier,
                AFEventParamQuantity: [[NSNumber numberWithInt:transaction.payment.quantity] stringValue],
                AFEventParamRevenue: revenue,
                AFEventParamCurrency :currency
            };
            [[Sdk sharedInstance] trackingEvent:EVENT_FINISH_PURCHASE withParams:eventParams];
            
            NSDictionary*  eventParams1 = @{
                AFEventParamContentId: transaction.payment.productIdentifier
            };
            [[Sdk sharedInstance] trackingEvent:EVENT_FINISH_SUCCESS withParams:eventParams1];
            
            [self showAlert:NULL withContent:[NSString stringWithFormat:@"Ghi nhận thanh toán %@ với sản phẩm %@",trans.paymentOrderId, trans.productId] withAction:^(UIAlertAction * _Nonnull) {
                [self btnClose:NULL];
            }];
            //[self btnClose:NULL];
        }
        else{
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            NSString *errorText = [TSLanguageManager localizedString:[NSString stringWithFormat:@"E_CODE_%d",resp.statusCode]];
            if([errorText containsString:@"E_CODE_"]){
                if(![Utils isNullOrEmpty:resp.message]){
                    errorText = resp.message;
                }
                else{
                    errorText = [TSLanguageManager localizedString:@"Lỗi không xác định"];
                }
            }
            [self showAlert:NULL withContent:errorText withAction:^(UIAlertAction * _Nonnull) {
                [self btnClose:NULL];
            }];
        }
    } error:^(NSError * _Nonnull error, id  _Nullable result,int httpCode) {
        [Utils logMessage:@"check receipt error"];
        NSString* errorText = [NSString stringWithFormat:@"Có lỗi trong quá trình xác thực giao dịch %@ cho sản phẩm %@.\nVui lòng kiểm tra kết nối mạng và thử lại !",trans.paymentOrderId,trans.productId];
        [self showAlertWith2Action:[TSLanguageManager localizedString:@"Thông báo"] withContent:errorText withOkTitle:[TSLanguageManager localizedString:@"Thử lại"] withOkAction:^(UIAlertAction * _Nonnull) {
            [self confirmTransaction:trans andSKTransaction:transaction];
        } andCancelAction:^(UIAlertAction * _Nonnull) {
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            [self btnClose:NULL];
            if(self.delegate != NULL){
                [self.delegate didPurchaseFailed:trans purchaseError:[TSLanguageManager localizedString:@"Hủy xác thực giao dịch"]];
            }
        }];
    }
    ];
}
-(void)initTransaction{
    NSString* accessToken = [[Sdk sharedInstance] accessToken];
    AppInfo* appInfo = [[Sdk sharedInstance] getAppInfo];
    NSDictionary* body = @{
        request_jwt:accessToken,
        request_client_id:appInfo.client_id,
        request_cid:appInfo.client_id,
        request_Os:[appInfo.platformOS lowercaseString],
        request_maker_code : productId,
        request_server_id:serverId,
        request_character_id:characterId
    };
    [[PaymentApiRequest sharedInstance] callPostMethod:PATH_PAYMENT_CREATE_ORDER_IAP withBody:body withToken:nil completion:^(id  _Nullable result) {
        [Utils logMessage:[NSString stringWithFormat:@"result %@",result]];
        OrderJson* respJson = [[OrderJson alloc] initFromDictionary:result];
        if(respJson != NULL){
            if(respJson.statusCode == CODE_0){
                /*self.paymentOrderId = [NSString stringWithFormat:@"%ld",respJson.data.transId];
                [Utils logMessage:[NSString stringWithFormat:@"paymentOrderId %@",self.paymentOrderId]];*/
                NSString* paymentOrderId = [NSString stringWithFormat:@"%ld",respJson.data.transId];
                
                SKMutablePayment *payment = [[SKMutablePayment alloc] init] ;
                payment.productIdentifier = productId;
                //payment.applicationUsername = self.paymentOrderId;
                payment.applicationUsername = paymentOrderId;
                //[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
                [[SKPaymentQueue defaultQueue] addPayment:payment];
                
                NSDictionary*  eventParams = @{
                    AFEventParamContentId: productId
                };
                [[Sdk sharedInstance] trackingEvent:EVENT_OPEN_PURCHASE_SCREEN withParams:eventParams];
            }
            else{
                if(respJson.statusCode == CODE_86){
                    [self doRefreshWithAction:^{
                        
                    } andSuccess:^{
                        [self initTransaction];
                    } andActionFail:^(NSString* errorString) {
                        
                        [self showAlert:[TSLanguageManager localizedString:@"Thông báo"] withContent:errorString withAction:^(UIAlertAction * _Nonnull) {
                            [self btnClose:NULL];
                        }];
                    }];
                }
                else{
                    
                    NSString *errorText = [TSLanguageManager localizedString:[NSString stringWithFormat:@"E_CODE_%d",respJson.statusCode]];
                    if([errorText containsString:@"E_CODE_"]){
                        if(![Utils isNullOrEmpty:respJson.message]){
                            errorText = respJson.message;
                        }
                        else{
                            errorText = [TSLanguageManager localizedString:@"Lỗi không xác định"];
                        }
                    }
                    [self showAlert:NULL withContent:errorText withAction:^(UIAlertAction * _Nonnull) {
                        [self btnClose:NULL];
                    }];
                }
            }
        }
    } error:^(NSError * _Nonnull error, id  _Nullable result, int httpCode) {
        [self showAlert:NULL withContent:[TSLanguageManager localizedString:@"Lỗi không xác định"] withAction:^(UIAlertAction * _Nonnull) {
            [self btnClose:NULL];
        }];
    }];
}
-(void)configUI:(UIView *)parentView{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [self showLoading:[TSLanguageManager localizedString:@"Đang khởi tạo giao dịch"]];
    [self initTransaction];
}
- (void)removeFromSuperview{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [super removeFromSuperview];
}
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    NSLog(@"paymentQueue...");
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
                // Call the appropriate custom method for the transaction state.
            case SKPaymentTransactionStatePurchasing:
                
                break;
            case SKPaymentTransactionStateDeferred:
                
                break;
            case SKPaymentTransactionStateFailed:
                [self fail:transaction];
                break;
            case SKPaymentTransactionStatePurchased:
                [self complete:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restore:transaction];
                break;
            default:
                // For debugging
                NSLog(@"Unexpected transaction state %@", @(transaction.transactionState));
                break;
        }
    }
}

-(void)complete:(SKPaymentTransaction*) transaction{
    NSLog(@"complete...");
    if(transaction.payment != NULL && transaction.payment.applicationUsername != NULL){
        NSLog(@"transaction.payment: %@",transaction.payment.applicationUsername);
    }
    [self showLoading:[TSLanguageManager localizedString:@"Đang xác thực giao dịch"]];
    
    
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
    TransactionInfo *trans = [[TransactionInfo alloc] init];
    trans.productId = transaction.payment.productIdentifier;
    trans.transId = transaction.transactionIdentifier;
    
    if (!receipt) {
        NSLog(@"no receipt");
        /* No local receipt -- handle the error. */
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        [self showAlert:NULL withContent:[TSLanguageManager localizedString:@"Không tìm thấy hóa đơn"] withAction:^(UIAlertAction * _Nonnull) {
            [self btnClose:NULL];
        }];
    } else {
        /* Get the receipt in encoded format */
        NSString *encodedReceipt = [receipt base64EncodedStringWithOptions:0];
        NSLog(@"receipt: %@",encodedReceipt);
        
        trans.purchasedToken = encodedReceipt;
        
        NSString* paymentOrderID = @"";
        if(transaction.payment != NULL && ![Utils isNullOrEmpty:transaction.payment.applicationUsername]){
            paymentOrderID = transaction.payment.applicationUsername;
        }
        trans.paymentOrderId = paymentOrderID;
        if([Utils isNullOrEmpty:self.characterId] || [Utils isNullOrEmpty:self.serverId] || [Utils isNullOrEmpty:paymentOrderID]){
            NSLog(@"Try to finish because nil of transaction: %@",trans.transId);
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            [self showAlert:NULL withContent:[TSLanguageManager localizedString:@"Có lỗi trong quá trình xác nhận thanh toán"] withAction:^(UIAlertAction * _Nonnull) {
                [self btnClose:NULL];
            }];
            return;
        }
        [self confirmTransaction:trans andSKTransaction:transaction];
        
    }
    
}

-(void)restore:(SKPaymentTransaction*) transaction{
    if(transaction.originalTransaction != NULL){
        NSLog(@"restore...%@",transaction.originalTransaction.payment.productIdentifier);
        
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [self btnClose:NULL];
}

-(void)fail:(SKPaymentTransaction*) transaction{
    NSLog(@"fail...");
    if(transaction.error != NULL){
        NSString* localizedDescription =transaction.error.localizedDescription;
        if(transaction.error.code == SKErrorPaymentCancelled){
            NSLog(@"User cancel product");
            NSDictionary*  eventParams = @{
                AFEventParamContentId: transaction.payment.productIdentifier
            };
            [[Sdk sharedInstance] trackingEvent:EVENT_CANCEL_PURCHASE withParams:eventParams];
        }
        else{
            NSLog(@"Transaction Error: %@",localizedDescription);
            TransactionInfo *trans = [[TransactionInfo alloc] init];
            trans.productId = transaction.payment.productIdentifier;
            trans.transId = NULL;
            if(self.delegate != NULL){
                [self.delegate didPurchaseFailed:trans purchaseError:localizedDescription];
            }
            NSDictionary*  eventParams = @{
                AFEventParamContentId: transaction.payment.productIdentifier
            };
            [[Sdk sharedInstance] trackingEvent:EVENT_CANCEL_PURCHASE withParams:eventParams];
        }
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [self btnClose:NULL];
}
-(void)btnClose:(id)sender{
    [super btnClose:sender];
    NSLog(@"btnClose");
    [self removeFromSuperview];
}
@end
