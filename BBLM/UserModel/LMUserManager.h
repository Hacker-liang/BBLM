//
//  LMUserManager.h
//  BBLM
//
//  Created by liangpengshuai on 4/27/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@end
