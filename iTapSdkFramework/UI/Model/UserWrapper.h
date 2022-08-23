//
//  UserWrapper.h
//  iTapSdk
//
//  Created by TranCong on 07/01/2022.
//

#import <Foundation/Foundation.h>
#import "DataWrapper.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserWrapper : DataWrapper
@property long accountID;
@property NSString *accountName;
@property NSString *fullname;
@property NSString *email;
@property NSString *mobile;
@property NSString *address;
@property NSString *passport;
@property NSString *birthday;
@property int gender;
//1 Vtvlive, 21 FastAccount
@property int status;
//0 Chưa kích hoạt, 1 kích hoạt email, 2 kích hoạt điện thoại, 5 kích hoạt cả email và điện thoại
@property int confirmCode;
@end
/*
 {
     "code": 0,
     "message": "Thực hiện thành công",
     "data": {
         "AccountID": 2684175322,
         "AccountName": "ttcong194",
         "Fullname": "",
         "JoinedTime": "2021-12-29T16:16:49.887",
         "Email": "",
         "Mobile": "",
         "Address": "",
         "Birthday": "2000-01-01T00:00:00",
         "Passport": "",
         "Gender": 0,
         "Status": 1,
         "ConfirmCode": 0,
         "lastGetTime": "0001-01-01T00:00:00",
         "relates": [
             {
                 "RelateId": 7188312,
                 "AccountID": 2684175322,
                 "relation": 0,
                 "Fullname": "",
                 "Gender": 0,
                 "Birthday": "2000-01-01T00:00:00",
                 "Address": "",
                 "Email": "",
                 "Mobile": "",
                 "Passport": "",
                 "PassportDate": "0001-01-01T00:00:00",
                 "PassportPlateofIssue": "",
                 "facebook": "",
                 "LastChange": "2021-12-29T16:16:49.887"
             }
         ],
         "securities": [],
         "vipinfo": null
     },
     "IsSuccessed": true,
     "HaveError": false,
     "redirectUrl": null,
     "token_expired": false
 }
 */
NS_ASSUME_NONNULL_END
