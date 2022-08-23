//
//  APIRequest.m
//  Connection
//
//  Created by Kcatta on 6/5/19.
//  Copyright © 2019 SHB. All rights reserved.
//

#import "APIRequest.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "Utils.h"
#import "Constant.h"
#define INTERVAL_REQUEST_TIME_OUT           60
@interface APIRequest()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) AFNetworkActivityIndicatorManager *activityIndicatorManager;
@property (nonatomic, strong) NSMutableURLRequest *urlRequest;
@property (nonatomic, strong) NSString *baseUrl;

@end

@implementation APIRequest
{
    NSURLSessionDataTask *currentTask;
}
-(void)cancelCurrentTask{
    if(currentTask != nil)
    {
        [currentTask cancel];
        currentTask = nil;
    }
}
-(void)initBaseUrl:(NSString *)url{
    self.baseUrl = url;
}
- (instancetype)init {
    if (self = [super init]) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.requestCachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
        [config setTimeoutIntervalForRequest:INTERVAL_REQUEST_TIME_OUT];
        [config setTimeoutIntervalForResource:INTERVAL_REQUEST_TIME_OUT];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
        
        //[self.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:RESPONSE_CONTENT_TYPE];
        //[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        self.activityIndicatorManager = [AFNetworkActivityIndicatorManager sharedManager];
        [self.sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [self.sessionManager.requestSerializer setTimeoutInterval:INTERVAL_REQUEST_TIME_OUT];
    }
    return self;
}

/*-(void)callGetMethod:(NSString *)path withParams:(NSDictionary *)params withToken:(NSString *)token completion:(SuccessBlock)handleComplete error:(ErrorBlock)handleError{
 
 NSString *fullPath =[NSString stringWithFormat:@"%@%@",BASE_URL,path];
 
 [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
 
 [self.sessionManager GET:fullPath parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
 handleComplete(YES, responseObject);
 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
 NSString *errorMessage = @"";
 switch (error.code) {
 case 404:
 case -1011:
 errorMessage = @"Lỗi kết nối";
 break;
 
 default:
 break;
 }
 handleError(error,errorMessage);
 }];
 }*/

-(void)callGetMethod:(NSString *)path withParams:(NSDictionary *)params withBody:(NSDictionary *)body withToken:(NSString *)token completion:(SuccessBlock)handleComplete error:(ErrorBlock)handleError{
    [self callMethod:GET withPath:path withParams:params withBody:body withToken:token andHeader:nil completion:handleComplete  error:handleError];
}

-(void)callPostMethod:(NSString *)path withBody:(NSDictionary *)body withToken:(NSString *)token completion:(SuccessBlock)handleComplete error:(ErrorBlock)handleError{
    [self callMethod:POST withPath:path withParams:nil withBody:body withToken:token andHeader:nil completion:handleComplete error:handleError];
}
-(void)callPutMethod:(NSString *)path withBody:(NSDictionary *)params withToken:(NSString *)token completion:(SuccessBlock)handleComplete error:(ErrorBlock)handleError{
    [self callMethod:PUT withPath:path withParams:nil withBody:params withToken:token andHeader:nil completion:handleComplete error:handleError];
}
-(void)callPatchMethod:(NSString *)path withBody:(NSDictionary *)params withToken:(NSString *)token completion:(SuccessBlock)handleComplete error:(ErrorBlock)handleError{
    [self callMethod:PATCH withPath:path withParams:nil withBody:params withToken:token andHeader:nil completion:handleComplete error:handleError];
}
-(void)callMethod:(NSString*) methodName withPath:(NSString *)path withParams:(NSDictionary *)params withBody:(NSDictionary *)body withToken:(NSString *)token andHeader:(NSDictionary*) header completion:(SuccessBlock)handleComplete error:(ErrorBlock)handleError{
    //NSString *fullPath = [NSString stringWithFormat:@"%@%@",self.baseUrl,path];
    NSURL *fullPath = NULL;
    if([path containsString:@"http"] || [path containsString:@"https"]){
        fullPath = [NSURL URLWithString:path];
    }
    else{
        NSURL *baseURL = [NSURL URLWithString:self.baseUrl];
        fullPath = [NSURL URLWithString:path relativeToURL:baseURL];
    }
    if(params != NULL){
        self.urlRequest = [[AFJSONRequestSerializer serializer] requestWithMethod:methodName URLString:[fullPath absoluteString] parameters:params error:nil];
    }
    else{
        self.urlRequest = [[AFJSONRequestSerializer serializer] requestWithMethod:methodName URLString:[fullPath absoluteString] parameters:nil error:nil];
    }
    [Utils logMessage:[NSString stringWithFormat:@"full path: %@",[fullPath absoluteString]]];
    if(token != NULL){
        [self.urlRequest setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    }
    /*if(header == NULL)
    {*/
        [self.urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [self.urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    /*}
    else{
        NSArray* aryHeader = [header allKeys];
        if([aryHeader count] > 0){
            for (int i=0; i<[aryHeader count]; i++) {
                NSString* key = aryHeader[i];
                NSString* value = [header objectForKey:key];
                [self.urlRequest setValue:value forHTTPHeaderField:key];
            }
        }
    }*/
    if(body != NULL){
        NSData *postData = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
        [self.urlRequest setHTTPBody:postData];
    }
    
    
    if([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable){
        currentTask =
        [self.sessionManager dataTaskWithRequest:self.urlRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            /*[Utils logMessage:[NSString stringWithFormat:@"responseObject: %@",responseObject]];
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            [Utils logMessage:[NSString stringWithFormat:@"response code: %ld",[httpResponse statusCode]]];*/
            
            if (!error) {
                handleComplete(responseObject);
            } else {
                int httpCode = -1;
                NSString* errResponse = NULL;
                NSDictionary *dict = error.userInfo;
                
                NSHTTPURLResponse *response = dict[AFNetworkingOperationFailingURLResponseErrorKey];
                if(response != NULL){
                    httpCode = response.statusCode;
                }
                NSData *data = dict[AFNetworkingOperationFailingURLResponseDataErrorKey];
                if(data != NULL){
                    errResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                }
                
                [Utils logMessage:[NSString stringWithFormat:@"error response: %@",errResponse]];
                
                handleError(error,errResponse,httpCode);
            }
        }];
        [currentTask resume];
    }
    else{
        NSError *error = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:CODE_NO_INTERNET userInfo:@{@"Error reason": @"Client is without internet connection"}];
        NSLog(@"%@",error);
        handleError(error,nil,CODE_NO_INTERNET);
    }
}

@end
