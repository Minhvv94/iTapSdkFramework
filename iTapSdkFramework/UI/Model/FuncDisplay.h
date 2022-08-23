//
//  FuncsDisplay.h
//  testgame
//
//  Created by Tran Trong Cong on 8/13/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : int {
    OpenLink,
    NeedVerify,
    Edit,
    Display,
    Call,
    Exit
}FuncType;

@interface FuncDisplay : NSObject
@property NSInteger id;
@property FuncType funcsType;
@property NSString* image;
@property NSString* value;
@property NSString* extValue;
@end

NS_ASSUME_NONNULL_END
