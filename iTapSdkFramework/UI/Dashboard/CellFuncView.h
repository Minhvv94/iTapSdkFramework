//
//  CellNewsView.h
//  testgame
//
//  Created by Tran Trong Cong on 8/13/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CellFuncView : UITableViewCell
@property (strong,nonatomic) IBOutlet UIImageView *icon;
@property (strong,nonatomic) IBOutlet UIImageView *arrow;
@property (strong,nonatomic) IBOutlet UILabel *text;
@property (strong,nonatomic) IBOutlet UILabel *text2;
@end

NS_ASSUME_NONNULL_END
