//
//  UserAlbumManager.h
//  PeachTravel
//
//  Created by liangpengshuai on 9/19/15.
//  Copyright © 2015 com.aizou.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadShowImageModel.h"

@interface UserAlbumManager : NSObject

/**
 *  上传用户图片
 *
 *  @param photo
 *  @param desc
 *  @param progressBlock
 *  @param completionBlock 
 */
+ (void)uploadUserAlbumPhoto:(UIImage *)photo withPhotoDesc:(NSString *)desc progress:(void (^) (CGFloat progressValue))progressBlock completion:(void(^)(BOOL isSuccess, UploadShowImageModel *albumImage))completionBlock;

/**
 *  上传用户视频
 *
 *  @param videoPath       视频路径
 *  @param coverPath       视频封面路径
 *  @param desc            描述
 *  @param progressBlock
 *  @param completionBlock
 */
+ (void)uploadUserVideo:(NSString *)videoPath coverImagePath:(NSString *)coverPath withDesc:(NSString *)desc progress:(void (^)(CGFloat))progressBlock completion:(void (^)(BOOL isSuccess, NSString *videoKey, NSString *coverImageKey))completionBlock;

@end
