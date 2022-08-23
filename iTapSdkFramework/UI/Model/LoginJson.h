//
//  LoginJson.h
//  VnptSdk
//
//  Created by TranCong on 04/09/2021.
//

#import <Foundation/Foundation.h>
#import "ResponseJson.h"
#import "LoginWrapper.h"
NS_ASSUME_NONNULL_BEGIN

@interface LoginJson : ResponseJson<LoginWrapper *>

@end
/*
 {
    "code":0,
    "message":"Thực hiện thành công",
    "data":{
       "access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3Z0dmxpdmUudm4iLCJzdWIiOiIwY2ZlM2Y4MzViMDU0YjUwIiwiYXVkIjoiYWNjZXNzX3Rva2VuIiwiZXhwIjoxNjQxMzczODg2LCJzaWQiOjMzMDAxMywiYXRrIjoiNjM3NzY5OTIyODU2MzA0NzcxLmNlYTJhZGI2NDkxYzI3MjYzYTdkNzU5NTE2OTUzM2U4IiwiYXR5IjoxLCJ1aWQiOjI2ODQxNzUzMjIsIm5hbWUiOiJ0dGNvbmcxOTQiLCJkdklkIjoiYjEyMDA1ZGU2ZGY0MWIyODg5NDYwMDgzZTJmMDA2NDUiLCJvcyI6IndlYiIsImlwIjoiMTQuMTc3LjIyMC44MyIsIklzQXV0aGVudGljYXRlZCI6dHJ1ZX0.5M5dptTF9-bgcV9vwXLLq0I2ajG_deJgXIIc3ErzsCY",
       "expires_in":1641373886,
       "refresh_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3Z0dmxpdmUudm4iLCJzdWIiOiIwY2ZlM2Y4MzViMDU0YjUwIiwiYXVkIjoicmVmcmVzaF90b2tlbiIsImV4cCI6MTY0MTk3NTA4Niwic2lkIjozMzAwMTMsImF0ayI6IjYzNzc2OTkyMjg1NjMwNDc3MS5jZWEyYWRiNjQ5MWMyNzI2M2E3ZDc1OTUxNjk1MzNlOCIsImF0eSI6MSwidWlkIjoyNjg0MTc1MzIyLCJuYW1lIjoidHRjb25nMTk0IiwiZHZJZCI6ImIxMjAwNWRlNmRmNDFiMjg4OTQ2MDA4M2UyZjAwNjQ1Iiwib3MiOiJ3ZWIiLCJpcCI6IjE0LjE3Ny4yMjAuODMiLCJJc0F1dGhlbnRpY2F0ZWQiOnRydWV9.9sbKxh4VfRg_jquCLUVsNqJUFVR2DOdX_1jh81Slm9M"
    },
    "IsSuccessed":true,
    "HaveError":false,
    "redirectUrl":null,
    "token_expired":false
 }
 */
NS_ASSUME_NONNULL_END
