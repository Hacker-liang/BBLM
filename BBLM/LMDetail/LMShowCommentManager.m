//
//  LMShowCommentManager.m
//  BBLM
//
//  Created by liangpengshuai on 4/28/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMShowCommentManager.h"

@implementation LMShowCommentManager

+ (void)asyncLoadShowCommentsListWithShowId:(NSInteger)showId page:(NSInteger)page pageSize:(NSInteger)pageSize completionBlock:(void (^) (BOOL isSuccess, NSArray<LMShowCommentDetail *> *commentList))completion
{
    
    NSString *url = [NSString stringWithFormat:@"%@dynamic/comment/list", BASE_API];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:showId] forKey:@"dynamicId"];
    [dic setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [dic setObject:[NSNumber numberWithInteger:pageSize] forKey:@"pageSize"];
    
    [LMNetworking GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            NSMutableArray *retList = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
                [retList addObject:[[LMShowCommentDetail alloc] initWithJson:dic]];
            }
            completion(YES, retList);
            
        } else {
            completion(NO, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO, nil);
        
    }];
}

+ (void)asyncMakeComment2ShowWithShowId:(NSInteger)showId commentContent:(NSString *)content completionBlock:(void (^) (BOOL isSuccess, LMShowCommentDetail *comment))completion
{
    NSString *url = [NSString stringWithFormat:@"%@dynamic/comment", BASE_API];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:showId] forKey:@"dynamicId"];
    [dic setObject:[NSNumber numberWithInteger:[LMAccountManager shareInstance].account.userId] forKey:@"memberId"];
    [dic setObject:content forKey:@"content"];
    
    [LMNetworking GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            LMShowCommentDetail *comment = [[LMShowCommentDetail alloc] init];
            comment.commentId = [[[responseObject objectForKey:@"data"] objectForKey:@"commentId"] integerValue];
            comment.content = content;
            comment.isMine = YES;
            comment.publishDate = [[NSDate date] timeIntervalSince1970];
            comment.user = [LMAccountManager shareInstance].account;
            completion(YES, comment);
            
        } else {
            completion(NO, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO, nil);
        
    }];
}

+ (void)asyncDeleteComment2ShowWithCommentId:(NSInteger)commentId completionBlock:(void (^) (BOOL isSuccess))completion
{
    NSString *url = [NSString stringWithFormat:@"%@dynamic/comment/cancel", BASE_API];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:commentId] forKey:@"commentId"];
    [dic setObject:[NSNumber numberWithInteger:[LMAccountManager shareInstance].account.userId] forKey:@"memberId"];
    
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


@end
