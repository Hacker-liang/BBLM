//
//  LMShowManager.h
//  BBLM
//
//  Created by liangpengshuai on 4/25/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMShowDetailModel.h"
#import "UploadShowImageModel.h"

@interface LMShowManager : NSObject

/**
 *  加载首页推荐的数据
 *
 *  @param page       第几页
 *  @param pageSize   每页多少个
 *  @param completion 
 */
+ (void)asyncLoadRecommendShowWithPage:(NSInteger)page pageSize:(NSInteger)pageSize completionBlock:(void (^) (BOOL isSuccess, NSArray<LMShowDetailModel *>* showList))completion;

/**
 *  加载每周热度 show 列表
 *
 *  @param page
 *  @param pageSize
 *  @param completion 
 */
+ (void)asyncLoadHotShowWithPage:(NSInteger)page pageSize:(NSInteger)pageSize completionBlock:(void (^) (BOOL isSuccess, NSArray<LMShowDetailModel *>* showList))completion;

/**
 *  加载用户的 show 列表
 *
 *  @param userId
 *  @param page
 *  @param pageSize
 *  @param completion
 */
+ (void)asyncLoadUserShowWithUserId:(NSInteger)userId page:(NSInteger)page pageSize:(NSInteger)pageSize completionBlock:(void (^) (BOOL isSuccess, NSArray<LMShowDetailModel *>* showList))completion;

/**
 *  加载一个 show 的详情
 *
 *  @param showId
 *  @param completion
 */
+ (void)asyncLoadShowDetialWithShowId:(NSInteger)showId completionBlock:(void (^) (BOOL isSuccess, LMShowDetailModel *showDetail))completion;

/**
 *  点赞
 *
 *  @param showId
 *  @param completion
 */
+ (void)asyncZanShowWithItemId:(NSInteger)showId completionBlock:(void (^) (BOOL isSuccess))completion;

/**
 *  取消赞
 *
 *  @param showId
 *  @param completion
 */
+ (void)asyncCancelZanShowWithItemId:(NSInteger)showId completionBlock:(void (^) (BOOL isSuccess))completion;


/**
 *  加载首页广告图
 *
 *  @param completion
 */
+ (void)asyncLoadHomeAdWithCompletionBlock:(void (^) (BOOL isSuccess, NSArray<NSDictionary *>* adList))completion;

/**
 *  发布一组图片
 *
 *  @param imageList  已经上传到七牛的图片
 *  @param desc       图片的描述
 *  @param completion 完成的回掉
 */
+ (void)asyncPublishImageWithImageList:(NSArray <UploadShowImageModel *> *)imageList desc:(NSString *)desc completionBlock:(void (^) (BOOL isSuccess, NSInteger showId))completion;


@end
