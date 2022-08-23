//
//  CellLoadingMore.h
//  iTapSdk
//
//  Created by TranCong on 09/11/2021.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CellLoadingMore : UITableViewCell

@property (weak,nonatomic) IBOutlet UIActivityIndicatorView *loadingMore;
@property (weak,nonatomic) IBOutlet UILabel *lbIndicator;
@end

NS_ASSUME_NONNULL_END
