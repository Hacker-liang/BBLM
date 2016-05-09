//
//  LMShowManager.m
//  BBLM
//
//  Created by liangpengshuai on 4/25/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMShowManager.h"

@implementation LMShowManager

+ (void)asyncLoadRecommendShowWithPage:(NSInteger)page pageSize:(NSInteger)pageSize completionBlock:(void (^) (BOOL isSuccess, NSArray<LMShowDetailModel *>* showList))completion
{
    NSString *url = [NSString stringWithFormat:@"%@dynamic/mainPage", BASE_API];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [dic setObject:[NSNumber numberWithInteger:pageSize] forKey:@"pageSize"];
    if ([[LMAccountManager shareInstance] isLogin]) {
        [dic setObject:[NSNumber numberWithInteger:[LMAccountManager shareInstance].account.userId] forKey:@"memberId"];
    }

    [LMNetworking GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            NSMutableArray *retList = [[NSMutableArray alloc] init];
            NSArray *data = [responseObject objectForKey:@"data"];
            for (NSDictionary *dic in data) {
                LMShowDetailModel *show = [[LMShowDetailModel alloc] initWithJson:dic];
                [retList addObject:show];
            }
            completion(YES, retList);
            
        } else {
            completion(NO, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO, nil);
    }];
}

+ (void)asyncLoadHotShowWithPage:(NSInteger)page pageSize:(NSInteger)pageSize completionBlock:(void (^) (BOOL isSuccess, NSArray<LMShowDetailModel *>* showList))completion
{
    NSString *url = [NSString stringWithFormat:@"%@dynamic/heatRank", BASE_API];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [dic setObject:[NSNumber numberWithInteger:pageSize] forKey:@"pageSize"];
    if ([[LMAccountManager shareInstance] isLogin]) {
        [dic setObject:[NSNumber numberWithInteger:[LMAccountManager shareInstance].account.userId] forKey:@"memberId"];
    }
    
    [LMNetworking GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            NSMutableArray *retList = [[NSMutableArray alloc] init];
            NSArray *data = [responseObject objectForKey:@"data"];
            for (NSDictionary *dic in data) {
                LMShowDetailModel *show = [[LMShowDetailModel alloc] initWithJson:dic];
                [retList addObject:show];
            }
            completion(YES, retList);
            
        } else {
            completion(NO, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO, nil);
        
    }];
}

+ (void)asyncLoadUserCollectionShowWithUserId:(NSInteger)userId page:(NSInteger)page pageSize:(NSInteger)pageSize completionBlock:(void (^) (BOOL isSuccess, NSArray<LMShowDetailModel *>* showList))completion
{
    NSString *url = [NSString stringWithFormat:@"%@dynamic/collect/list", BASE_API];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:userId] forKey:@"memberId"];
    [dic setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [dic setObject:[NSNumber numberWithInteger:pageSize] forKey:@"pageSize"];
    
    [LMNetworking GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            NSMutableArray *retList = [[NSMutableArray alloc] init];
            NSArray *data = [responseObject objectForKey:@"data"];
            for (NSDictionary *dic in data) {
                LMShowDetailModel *show = [[LMShowDetailModel alloc] initWithJson:dic];
                [retList addObject:show];
            }
            completion(YES, retList);
            
        } else {
            completion(NO, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO, nil);
        
    }];
}

+ (void)asyncCollectionShowWithItemId:(NSInteger)showId completionBlock:(void (^)(BOOL))completion
{
    NSString *url = [NSString stringWithFormat:@"%@dynamic/collect", BASE_API];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:[LMAccountManager shareInstance].account.userId] forKey:@"memberId"];
    [dic setObject:[NSNumber numberWithInteger:showId] forKey:@"dynamicId"];
    
    [LMNetworking GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            completion(YES);
            
        } else {
            completion(NO);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO);
        
    }];
}

+ (void)asyncCancelCollectionShowWithItemId:(NSInteger)showId completionBlock:(void (^)(BOOL))completion
{
    NSString *url = [NSString stringWithFormat:@"%@dynamic/collect/cancel", BASE_API];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:[LMAccountManager shareInstance].account.userId] forKey:@"memberId"];
    [dic setObject:[NSNumber numberWithInteger:showId] forKey:@"dynamicId"];
    
    [LMNetworking GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            completion(YES);
            
        } else {
            completion(NO);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO);
        
    }];
}

+ (void)asyncLoadUserShowWithUserId:(NSInteger)userId page:(NSInteger)page pageSize:(NSInteger)pageSize completionBlock:(void (^) (BOOL isSuccess, NSArray<LMShowDetailModel *>* showList))completion
{
    NSString *url = [NSString stringWithFormat:@"%@dynamic/barbie", BASE_API];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:userId] forKey:@"memberId"];
    [dic setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [dic setObject:[NSNumber numberWithInteger:pageSize] forKey:@"pageSize"];
    if ([[LMAccountManager shareInstance] isLogin]) {
        [dic setObject:[NSNumber numberWithInteger:[LMAccountManager shareInstance].account.userId] forKey:@"fromId"];
    }
    [LMNetworking GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            NSMutableArray *retList = [[NSMutableArray alloc] init];
            NSArray *data = [responseObject objectForKey:@"data"];
            for (NSDictionary *dic in data) {
                LMShowDetailModel *show = [[LMShowDetailModel alloc] initWithJson:dic];
                [retList addObject:show];
            }
            completion(YES, retList);
            
        } else {
            completion(NO, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO, nil);
        
    }];
}

+ (void)asyncLoadZanUserOfShowWithShowId:(NSInteger)showId page:(NSInteger)page pageSize:(NSInteger)pageSize completionBlock:(void (^) (BOOL isSuccess, NSArray<LMUserDetailModel *>* userList))completion
{
    NSString *url = [NSString stringWithFormat:@"%@dynamic/praise/list", BASE_API];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:showId] forKey:@"dynamicId"];
    [dic setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [dic setObject:[NSNumber numberWithInteger:pageSize] forKey:@"pageSize"];
    if ([[LMAccountManager shareInstance] isLogin]) {
        [dic setObject:[NSNumber numberWithInteger:[LMAccountManager shareInstance].account.userId] forKey:@"memberId"];
    }
    [LMNetworking GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            NSMutableArray *retList = [[NSMutableArray alloc] init];
            NSArray *data = [responseObject objectForKey:@"data"];
            for (NSDictionary *dic in data) {
                LMUserDetailModel *show = [[LMUserDetailModel alloc] initWithJson:dic];
                [retList addObject:show];
            }
            completion(YES, retList);
            
        } else {
            completion(NO, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO, nil);
        
    }];

}

+ (void)asyncLoadShowDetialWithShowId:(NSInteger)showId completionBlock:(void (^) (BOOL isSuccess, LMShowDetailModel *showDetail))completion
{
    NSString *url = [NSString stringWithFormat:@"%@dynamic/detail", BASE_API];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:showId] forKey:@"dynamicId"];
    if ([[LMAccountManager shareInstance] isLogin]) {
        [dic setObject:[NSNumber numberWithInteger:[LMAccountManager shareInstance].account.userId] forKey:@"fromId"];
    }
    [LMNetworking GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            LMShowDetailModel *show = [[LMShowDetailModel alloc] initWithJson:[responseObject objectForKey:@"data"]];
            show.itemId = showId;
            completion(YES, show);
            
        } else {
            completion(NO, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO, nil);
        
    }];
}
+ (void)asyncZanShowWithItemId:(NSInteger)showId completionBlock:(void (^) (BOOL isSuccess))completion
{
    NSString *url = [NSString stringWithFormat:@"%@dynamic/praise", BASE_API];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:[LMAccountManager shareInstance].account.userId] forKey:@"memberId"];
    [dic setObject:[NSNumber numberWithInteger:showId] forKey:@"dynamicId"];

    [LMNetworking GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            completion(YES);
            
        } else {
            completion(NO);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO);
        
    }];
}

+ (void)asyncCancelZanShowWithItemId:(NSInteger)showId completionBlock:(void (^) (BOOL isSuccess))completion
{
    NSString *url = [NSString stringWithFormat:@"%@dynamic/praise/cancel", BASE_API];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:[LMAccountManager shareInstance].account.userId] forKey:@"memberId"];
    [dic setObject:[NSNumber numberWithInteger:showId] forKey:@"dynamicId"];
    
    [LMNetworking GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            completion(YES);
            
        } else {
            completion(NO);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO);
        
    }];
}


+ (void)asyncLoadHomeAdWithCompletionBlock:(void (^) (BOOL isSuccess, NSArray<NSDictionary *>* adList))completion
{
    NSString *url = [NSString stringWithFormat:@"%@advertisement", BASE_API];
    
    [LMNetworking GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            completion(YES, [responseObject objectForKey:@"data"]);

        } else {
            completion(NO, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO, nil);
        
    }];
}

+ (void)asyncPublishImageWithImageList:(NSArray <UploadShowImageModel *> *)imageList desc:(NSString *)desc completionBlock:(void (^) (BOOL isSuccess, NSInteger showId))completion
{
    NSString *url = [NSString stringWithFormat:@"%@dynamic/publish", BASE_API];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:[LMAccountManager shareInstance].account.userId] forKey:@"memberId"];
    [dic setObject:desc forKey:@"words"];
    NSMutableString *key = [[NSMutableString alloc] init];
    for (UploadShowImageModel *model in imageList) {
        if (![model isEqual:[imageList lastObject]]) {
            [key appendFormat:@"%@,", model.imageId];
        } else {
            [key appendFormat:@"%@", model.imageId];
        }
    }
    [dic setObject:key forKey:@"pictureUrl"];
    
    [LMNetworking GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            completion(YES, [[[responseObject objectForKey:@"data"] objectForKey:@"id"] integerValue]);
            
        } else {
            completion(NO, 0);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO, 0);
        
    }];
}

+ (void)asyncPublishVidwoWithCoverImageKey:(NSString *)coverKey videoKey:(NSString *)videoKey desc:(NSString *)desc completionBlock:(void (^) (BOOL isSuccess, NSInteger showId))completion
{
    NSString *url = [NSString stringWithFormat:@"%@dynamic/publish", BASE_API];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:[LMAccountManager shareInstance].account.userId] forKey:@"memberId"];
    [dic safeSetObject:desc forKey:@"words"];
    [dic safeSetObject:coverKey forKey:@"videoPictureUrl"];
    [dic safeSetObject:videoKey forKey:@"videoUrl"];

    [LMNetworking GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            completion(YES, [[[responseObject objectForKey:@"data"] objectForKey:@"id"] integerValue]);
            
        } else {
            completion(NO, 0);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO, 0);
        
    }];
}
@end
