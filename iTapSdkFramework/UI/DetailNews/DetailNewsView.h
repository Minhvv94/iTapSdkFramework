//
//  DetailNewsView.h
//  iTapSdk
//
//  Created by TranCong on 10/11/2021.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "RoundRectView.h"
#import <WebKit/WebKit.h>
#import "GameApiRequest.h"
#import "DetailNewsJson.h"
NS_ASSUME_NONNULL_BEGIN

@interface DetailNewsView : BaseView<WKUIDelegate>

@property (weak,nonatomic) NSString *idNews;
@property (weak, nonatomic) IBOutlet UILabel *lbTitleNews;
@property (weak, nonatomic) IBOutlet UILabel *lbPublishedDateNews;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbUrl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@end

NS_ASSUME_NONNULL_END
