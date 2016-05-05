//
//  LMUserManager.h
//  BBLM
//
//  Created by liangpengshuai on 4/27/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMShowCommentDetail.h"
#import "LMShowZanDetail.h"

@interface LMUserManager : NSObject

/**
 *  获取用户信息
 *
 *  @param userId
 *  @param completion
 */
+ (void)asyncLoadUserInfoWithUserId:(NSInteger)userId completionBlock:(void (^) (BOOL isSuccess, LMUserDetailModel *userInfo))completion;

/**
 *  获取用户的排名信息
 *
 *  @param userId
 *  @param completion 
 */
+ (void)asyncLoadUserRankInfoWithUserId:(NSInteger)userId completionBlock:(void (^) (BOOL isSuccess, NSDictionary *rankInfo))completion;

/**
 *  加载用户的被评论列表
 *
 *  @param userId
 *  @param completion
 */
+ (void)asyncLoadUserCommentsListInfoWithUserId:(NSInteger)userId page:(NSInteger)page pageSize:(NSInteger)size completionBlock:(void (^) (BOOL isSuccess, NSArray<LMShowCommentDetail *> *commentList))completion;

/**
 *  加载用户被赞的列表
 *
 *  @param userId
 *  @param page
 *  @param size
 *  @param completion 
 */
+ (void)asyncLoadUserZanListInfoWithUserId:(NSInteger)userId page:(NSInteger)page pageSize:(NSInteger)size completionBlock:(void (^) (BOOL isSuccess, NSArray<LMShowZanDetail *> *zanList))completion;



@end
