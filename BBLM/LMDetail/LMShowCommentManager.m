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
    
    NSString *url = [NSString stringWithFormat:@"%@dynamic/barbie", BASE_API];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:showId] forKey:@"dynamicId"];
    [dic setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [dic setObject:[NSNumber numberWithInteger:pageSize] forKey:@"pageSize"];
    
    [LMNetworking GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            completion(YES, [responseObject objectForKey:@"data"]);
            
        } else {
            completion(NO, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(NO, nil);
        
    }];
}

@end
