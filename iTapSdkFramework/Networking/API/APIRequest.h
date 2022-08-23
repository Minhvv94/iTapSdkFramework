//
//  APIRequest.h
//  Connection
//
//  Created by Kcatta on 6/5/19.
//  Copyright © 2019 SHB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiConfig.h"
#import "Utils.h"
@interface APIRequest : NSObject
//+ (APIRequest *)sharedInstance;

//-(void) initEnv:(BaseURL) env;
-(void) initBaseUrl:(NSString*) url;
-(void) cancelCurrentTask;
-(void) callGetMethod:(NSString*) path withParams:(NSDictionary*)params withBody:(NSDictionary *)body withToken:(NSString*)token completion:(SuccessBlock)handleComplete error:(ErrorBlock)handleError;

-(void) callPostMethod:(NSString*) path withBody:(NSDictionary*)params withToken:(NSString*)token completion:(SuccessBlock)handleComplete error:(ErrorBlock)handleError;

-(void) callPutMethod:(NSString*) path withBody:(NSDictionary*)params withToken:(NSString*)token completion:(SuccessBlock)handleComplete error:(ErrorBlock)handleError;
-(void) callPatchMethod:(NSString*) path withBody:(NSDictionary*)params withToken:(NSString*)token completion:(SuccessBlock)handleComplete error:(ErrorBlock)handleError;
@end
