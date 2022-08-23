//
//  VnptApp.h
//  VnptSdk
//
//  Created by Tran Trong Cong on 8/5/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppInfo : NSObject
@property (nonatomic,strong) NSString *firebaseConfigFile;

@property (nonatomic,strong) NSString *client_id;
@property (nonatomic,strong) NSString *client_secret;
@property (nonatomic,strong) NSString *platformOS;
@property (nonatomic,strong) NSString *packageId;
@property (nonatomic,strong) NSString *version;
/*Information about appsflyer */
@property (nonatomic,strong) NSString *afDevKey;
@property (nonatomic,strong) NSString *afAppId;
@property (nonatomic,strong) NSString *googleWebClient;

@property (nonatomic,strong) NSString *locale;//localization for app

@property (nonatomic,strong) NSString *hotLinkHomepage;
@property (nonatomic,strong) NSString *hotLinkFanpage;
@property (nonatomic,strong) NSString *hotLinkGroup;
@property (nonatomic,strong) NSString *hotLinkChat;
@property (nonatomic,strong) NSString *hotline;

@property (nonatomic,strong) NSArray *achievedLevels;
@property (nonatomic,strong) NSArray *achievedVips;
@end

NS_ASSUME_NONNULL_END
