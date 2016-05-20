//
//  LMAccountManager.m
//  BBLM
//
//  Created by liangpengshuai on 4/25/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMAccountManager.h"

#define kAccountInfoCacheKey   @"kAccountInfoCacheKey"

@implementation LMAccountManager

+ (LMAccountManager *)shareInstance
{
    static LMAccountManager *accountManager;
    static dispatch_once_t token;
    dispatch_once(&token,^{
        //这里调用私有的initSingle方法
        accountManager = [[LMAccountManager alloc] init];
    });
    return accountManager;
}

- (LMUserDetailModel *)account {
    if (!_account) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSDictionary *userInfoDic = [ud objectForKey:kAccountInfoCacheKey];
        if (userInfoDic) {
            _account = [[LMUserDetailModel alloc] initWithJson:userInfoDic];
        }
    }
    
    return _account;
}

- (BOOL)isLogin
{
    return self.account != nil;
}

- (void)updateAccountInfo2Cache
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic safeSetObject:[NSNumber numberWithInteger: _account.userId] forKey:@"id"];
    [dic safeSetObject:_account.nickname forKey:@"nickname"];
    [dic safeSetObject:_account.avatar forKey:@"portrait"];

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:dic forKey:kAccountInfoCacheKey];
    [ud synchronize];
}

- (void)asyncLoginWithTel:(NSString *)tel captcha:(NSString *)captcha completionBlock:(void (^) (BOOL isSuccess, NSString *errorStr))completion;
{
    NSString *url = [NSString stringWithFormat:@"%@login", BASE_API];
    [LMNetworking GET:url parameters:@{@"phone": tel, @"code": captcha} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            _account = [[LMUserDetailModel alloc] init];
            _account.userId = [[[responseObject objectForKey:@"data"] objectForKey:@"id"] integerValue];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[NSNumber numberWithInteger:_account.userId] forKey:@"memberId"];
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:dic forKey:kAccountInfoCacheKey];
            [ud synchronize];
            completion(YES, nil);
        } else {
            completion(NO, [responseObject objectForKey:@"message"]);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO, nil);
    }];
}

- (void)asyncLogoutWichCompletionBlock:(void (^)(BOOL, NSString *))completion
{
    NSString *url = [NSString stringWithFormat:@"%@logout", BASE_API];
    [LMNetworking GET:url parameters:@{@"memberId": [NSNumber numberWithInteger:_account.userId]} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            _account = nil;
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud removeObjectForKey:kAccountInfoCacheKey];
            [ud synchronize];
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO, nil);
        
    }];
}

- (void)asyncChangeUserInfoWithChangeType:(NSString *)typeKey andChangeContent:(id)content completionBlock:(void (^) (BOOL isSuccess))completion
{
    [SVProgressHUD showWithStatus:@"正在修改"];
    NSString *url = [NSString stringWithFormat:@"%@barbie/edit", BASE_API];
    [LMNetworking GET:url parameters:@{typeKey: content, @"id": [NSNumber numberWithInteger:_account.userId]} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            if ([typeKey isEqualToString:@"nickname"]) {
                _account.nickname = content;
                [self updateAccountInfo2Cache];
            } else if ([typeKey isEqualToString:@"portrait"]) {
                _account.avatar = content;
                [self updateAccountInfo2Cache];
            }
            completion(YES);
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        } else {
            completion(NO);
            [SVProgressHUD showErrorWithStatus:@"修改失败"];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO);
        [SVProgressHUD showErrorWithStatus:@"修改失败"];
    }];
}

- (void)asyncAddUserTag:(NSString *)tag completionBlock:(void (^) (BOOL isSuccess, NSString *errorStr))completion
{
    NSString *url = [NSString stringWithFormat:@"%@barbie/addLabel", BASE_API];
    [LMNetworking GET:url parameters:@{@"label": tag, @"memberId": [NSNumber numberWithInteger:_account.userId]} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            completion(YES, nil);
            
        } else {
            if ([[responseObject objectForKey:@"code"] integerValue] == 2301) {
                completion(NO, @"标签已存在");
            } else {
                completion(NO, @"添加失败");
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO, @"添加失败");
    }];
}

- (void)asyncDeleteUserTag:(NSString *)tag completionBlock:(void (^) (BOOL isSuccess, NSString *errorStr))completion
{
    NSString *url = [NSString stringWithFormat:@"%@barbie/delLabel", BASE_API];
    [LMNetworking GET:url parameters:@{@"label": tag, @"memberId": [NSNumber numberWithInteger:_account.userId]} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            completion(YES, nil);
            
        } else {
            completion(NO, @"删除失败");
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO, @"删除失败");
    }];
}

- (void)asyncUploadJPushRegId:(NSString *)registerId completionBlock:(void (^) (BOOL isSuccess))completion
{
    NSString *url = [NSString stringWithFormat:@"%@barbie/device", BASE_API];
    [LMNetworking GET:url parameters:@{@"deviceNo": registerId, @"memberId": [NSNumber numberWithInteger:_account.userId], @"deviceType": [NSNumber numberWithInteger:2]} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            completion(YES);
            
        } else {
            completion(NO);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO);
    }];

}

@end
