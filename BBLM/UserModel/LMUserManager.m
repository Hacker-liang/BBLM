//
//  LMUserManager.m
//  BBLM
//
//  Created by liangpengshuai on 4/27/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMUserManager.h"
#import "LMShowZanDetail.h"
#import "MyCommentModel.h"

@implementation LMUserManager

+ (void)asyncLoadUserInfoWithUserId:(NSInteger)userId completionBlock:(void (^) (BOOL isSuccess, LMUserDetailModel *userInfo))completion
{
    NSString *url = [NSString stringWithFormat:@"%@barbie/info", BASE_API];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if ([[LMAccountManager shareInstance] isLogin]) {
        [params setObject:[NSNumber numberWithInteger:[LMAccountManager shareInstance].account.userId] forKey:@"fromId"];
    }
    [params setObject:[NSNumber numberWithInteger:userId] forKey:@"memberId"];

    [LMNetworking GET:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            NSDictionary *userInfoDic = [responseObject objectForKey:@"data"];
            LMUserDetailModel *user = [[LMUserDetailModel alloc] initWithJson: userInfoDic];
            if (user.userId == [LMAccountManager shareInstance].account.userId) {   //如果是获取自己的用户信息,那么将用户信息存到本地
                [LMAccountManager shareInstance].account = user;
                [[LMAccountManager shareInstance] updateAccountInfo2Cache];
            }
            completion(YES, user);
        } else {
            completion(NO, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO, nil);

    }];
}

+ (void)asyncLoadUserRankInfoWithUserId:(NSInteger)userId completionBlock:(void (^) (BOOL isSuccess, NSDictionary *rankInfo))completion
{
    NSString *url = [NSString stringWithFormat:@"%@barbie/rank", BASE_API];
    [LMNetworking GET:url parameters:@{@"memberId": [NSNumber numberWithInteger:userId]} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            completion(YES, [responseObject objectForKey:@"data"]);
        } else {
            completion(NO, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO, nil);
        
    }];
}

+ (void)asyncLoadUserCommentsListInfoWithUserId:(NSInteger)userId page:(NSInteger)page pageSize:(NSInteger)size completionBlock:(void (^) (BOOL isSuccess, NSArray<MyCommentModel *> *commentList))completion
{
    NSString *url = [NSString stringWithFormat:@"%@message/comment", BASE_API];
    [LMNetworking GET:url parameters:@{@"memberId": [NSNumber numberWithInteger:userId],
                                       @"page": [NSNumber numberWithInteger:page],
                                       @"pageSize": [NSNumber numberWithInteger:size]
                                       } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            NSMutableArray *retList = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
                MyCommentModel *comment = [[MyCommentModel alloc] initWithJson:dic];
                [retList addObject:comment];
            }
            completion(YES, retList);
        } else {
            completion(NO, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO, nil);
        
    }];
}

+ (void)asyncLoadUserZanListInfoWithUserId:(NSInteger)userId page:(NSInteger)page pageSize:(NSInteger)size completionBlock:(void (^) (BOOL isSuccess, NSArray<LMShowZanDetail *> *zanList))completion
{
    NSString *url = [NSString stringWithFormat:@"%@message/praise", BASE_API];
    [LMNetworking GET:url parameters:@{@"memberId": [NSNumber numberWithInteger:userId],
                                       @"page": [NSNumber numberWithInteger:page],
                                       @"pageSize": [NSNumber numberWithInteger:size]
                                       } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                           if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
                                               NSMutableArray *retList = [[NSMutableArray alloc] init];
                                               for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
                                                   LMShowZanDetail *zan = [[LMShowZanDetail alloc] initWithJson:dic];
                                                   [retList addObject:zan];
                                               }
                                               completion(YES, retList);
                                           } else {
                                               completion(NO, nil);
                                           }
                                           
                                       } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                                           completion(NO, nil);
                                           
                                       }];
}


+ (void)asyncDeleteUserShowWithUserId:(NSInteger)userId showId:(NSInteger)showId completionBlock:(void (^) (BOOL isSuccess))completion
{
    NSString *url = [NSString stringWithFormat:@"%@dynamic/delete", BASE_API];
    [LMNetworking GET:url parameters:@{@"memberId": [NSNumber numberWithInteger:userId],
                                       @"dynamicId": [NSNumber numberWithInteger:showId],
                                       } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                           if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
                                               completion(YES);
                                           } else {
                                               completion(NO);
                                           }
                                           
                                       } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                                           completion(NO);
                                           
                                       }];

}

+ (void)asyncFocuseUserWithUserId:(NSInteger)userId completionBlock:(void (^)(BOOL))completion
{
    NSString *url = [NSString stringWithFormat:@"%@barbie/focus", BASE_API];
    [LMNetworking GET:url parameters:@{@"targetId": [NSNumber numberWithInteger:userId],
                                       @"memberId": [NSNumber numberWithInteger:[LMAccountManager shareInstance].account.userId],
                                    
                                       } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                           if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
                                               completion(YES);
                                           } else {
                                               completion(NO);
                                           }
                                           
                                       } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                                           completion(NO);
                                           
                                       }];

}

+ (void)asyncCancelFocuseUserWithUserId:(NSInteger)userId completionBlock:(void (^)(BOOL))completion
{
    NSString *url = [NSString stringWithFormat:@"%@barbie/focus/cancel", BASE_API];
    [LMNetworking GET:url parameters:@{@"targetId": [NSNumber numberWithInteger:userId],
                                       @"memberId": [NSNumber numberWithInteger:[LMAccountManager shareInstance].account.userId],
                                       
                                       } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                           if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
                                               completion(YES);
                                           } else {
                                               completion(NO);
                                           }
                                           
                                       } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                                           completion(NO);
                                           
                                       }];


}

+ (void)asyncMakeMessageReadWithUserId:(NSInteger)userId andMessageType:(NSInteger)type completionBlock:(void (^) (BOOL isSuccess))completion
{
    NSString *url = [NSString stringWithFormat:@"%@message/read", BASE_API];
    [LMNetworking GET:url parameters:@{@"type": [NSNumber numberWithInteger:type],
                                       @"memberId": [NSNumber numberWithInteger:userId],
                                       
                                       } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
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
