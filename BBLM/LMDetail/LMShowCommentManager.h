//
//  LMShowCommentManager.h
//  BBLM
//
//  Created by liangpengshuai on 4/28/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMShowCommentDetail.h"

@interface LMShowCommentManager : NSObject

/**
 *  加载一个 show 的评论列表
 *
 *  @param showId
 *  @param page
 *  @param pageSize
 *  @param completion
 */
+ (void)asyncLoadShowCommentsListWithShowId:(NSInteger)showId page:(NSInteger)page pageSize:(NSInteger)pageSize completionBlock:(void (^) (BOOL isSuccess, NSArray<LMShowCommentDetail *> *commentList))completion;

/**
 *  针对一条 show 发表一个评论
 *
 *  @param showId
 *  @param content
 *  @param completion
 */
+ (void)asyncMakeComment2ShowWithShowId:(NSInteger)showId commentContent:(NSString *)content completionBlock:(void (^) (BOOL isSuccess, LMShowCommentDetail *comment))completion;

/**
 *  删除一条 show 的评论
 *
 *  @param showId
 *  @param completion
 */
+ (void)asyncDeleteComment2ShowWithCommentId:(NSInteger)commentId completionBlock:(void (^) (BOOL isSuccess))completion;


@end
