//
//  LMAccountManager.h
//  BBLM
//
//  Created by liangpengshuai on 4/25/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMUserDetailModel.h"

@interface LMAccountManager : NSObject

@property (nonatomic, strong) LMUserDetailModel *account;

+ (LMAccountManager *)shareInstance;

/**
 *  用户是否登录
 *
 *  @return
 */
- (BOOL)isLogin;

/**
 *  将用户信息存到本地
 *
 */
- (void)updateAccountInfo2Cache;

/**
 *  异步登录
 *
 *  @param tel        电话
 *  @param captcha    验证码
 *  @param completion 登录结束的回掉
 */
- (void)asyncLoginWithTel:(NSString *)tel captcha:(NSString *)captcha completionBlock:(void (^) (BOOL isSuccess, NSString *errorStr))completion;

- (void)asyncLogoutWichCompletionBlock:(void (^) (BOOL isSuccess, NSString *errorStr))completion;

/**
 *  修改用户信息
 *
 *  @param typeKey    修改的 key
 *  @param content    修改的内容
 *  @param completion 
 */
- (void)asyncChangeUserInfoWithChangeType:(NSString *)typeKey andChangeContent:(id)content completionBlock:(void (^) (BOOL isSuccess))completion;

/**
 *  添加一个标签
 *
 *  @param tag
 *  @param completion
 */
- (void)asyncAddUserTag:(NSString *)tag completionBlock:(void (^) (BOOL isSuccess, NSString *errorStr))completion;

/**
 *  删除一个标签
 *
 *  @param tag
 *  @param completion
 */
- (void)asyncDeleteUserTag:(NSString *)tag completionBlock:(void (^) (BOOL isSuccess, NSString *errorStr))completion;


@end
