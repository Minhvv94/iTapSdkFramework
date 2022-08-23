//
//  FloatingButton.h
//  testgame
//
//  Created by Tran Trong Cong on 8/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FloatingButtonOnClick)(void);
typedef void(^FloatingButtonOnRemove)(void);

@interface FloatingButton : UIImageView
@property (nonatomic, copy, nullable) FloatingButtonOnClick onClick;
@property (nonatomic, copy, nullable) FloatingButtonOnRemove onRemove;

-(void) setOffSetX:(float) value;
@end

NS_ASSUME_NONNULL_END
