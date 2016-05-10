//
//  LMUserManager.h
//  BBLM
//
//  Created by liangpengshuai on 4/27/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyCommentModel.h"
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
+ (void)asyncLoadUserCommentsListInfoWithUserId:(NSInteger)userId page:(NSInteger)page pageSize:(NSInteger)size completionBlock:(void (^) (BOOL isSuccess, NSArray<MyCommentModel *> *commentList))completion;

/**
 *  加载用户被赞的列表
 *
 *  @param userId
 *  @param page
 *  @param size
 *  @param completion 
 */
+ (void)asyncLoadUserZanListInfoWithUserId:(NSInteger)userId page:(NSInteger)page pageSize:(NSInteger)size completionBlock:(void (^) (BOOL isSuccess, NSArray<LMShowZanDetail *> *zanList))completion;

/**
 *  删除用户的一条 show
 *
 *  @param userId
 *  @param showId
 *  @param completion
 */
+ (void)asyncDeleteUserShowWithUserId:(NSInteger)userId showId:(NSInteger)showId completionBlock:(void (^) (BOOL isSuccess))completion;

/**
 *  关注一个人
 *
 *  @param userId
 *  @param completion
 */
+ (void)asyncFocuseUserWithUserId:(NSInteger)userId completionBlock:(void (^) (BOOL isSuccess))completion;

/**
 *  取消关注一个人
 *
 *  @param userId
 *  @param completion 
 */
+ (void)asyncCancelFocuseUserWithUserId:(NSInteger)userId completionBlock:(void (^) (BOOL isSuccess))completion;

/**
 *  用户的消息已读
 *
 *  @param userId
 *  @param type       消息类型 1评论 ，2赞 ，3系统消息  必填
 *  @param messageId  消息 ID
 *  @param completion
 */
+ (void)asyncMakeMessageReadWithUserId:(NSInteger)userId andMessageType:(NSInteger)type messageId:(NSInteger)messageId completionBlock:(void (^) (BOOL isSuccess))completion;



@end
