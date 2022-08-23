//
//  CellNewsView.h
//  testgame
//
//  Created by Tran Trong Cong on 8/13/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CellNewsView : UITableViewCell

@property (weak,nonatomic) IBOutlet UIImageView *thumbNews;
@property (weak,nonatomic) IBOutlet UILabel *titleNews;
@property (weak,nonatomic) IBOutlet UILabel *publishedDate;

@property (weak,nonatomic) IBOutlet UILabel *status;

@end

NS_ASSUME_NONNULL_END
