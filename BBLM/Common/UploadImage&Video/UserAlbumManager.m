//
//  UserAlbumManager.m
//  PeachTravel
//
//  Created by liangpengshuai on 9/19/15.
//  Copyright © 2015 com.aizou.www. All rights reserved.
//

#import "QiniuSDK.h"

#import "UserAlbumManager.h"

@implementation UserAlbumManager

+ (void)uploadUserAlbumPhoto:(UIImage *)photo withPhotoDesc:(NSString *)desc progress:(void (^)(CGFloat))progressBlock completion:(void (^)(BOOL isSuccess, UploadShowImageModel *albumImage))completionBlock
{
    [UserAlbumManager requestUploadTokeAndUploadPhoto:photo photoDesc:desc progress:^(CGFloat progress) {
        progressBlock(progress);
        
    } completion:^(BOOL isSuccess, UploadShowImageModel *image) {
        completionBlock(isSuccess, image);
    }];
}

/**
 *  获取上传七牛服务器所需要的 token，key
 *
 *  @param image
 */
+ (void)requestUploadTokeAndUploadPhoto:(UIImage *)image photoDesc:(NSString *)desc progress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL isSuccess, UploadShowImageModel *image))completionBlock
{
    NSString *url = [NSString stringWithFormat:@"%@qiniu/auth", BASE_API];
    progressBlock(0.0);
    NSDictionary *params;
    if (desc) {
        params = @{@"memberId": [NSNumber numberWithInteger: [LMAccountManager shareInstance].account.userId]};
    }
    
    [LMNetworking GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 0) {
            [self uploadPhotoToQINIUServer:image withToken:[[responseObject objectForKey:@"data"]  objectForKey:@"auth"] andKey:nil progress:^(CGFloat progress) {
                progressBlock(progress);
                
            } completion:^(BOOL isSuccess, UploadShowImageModel *image) {
                completionBlock(isSuccess, image);
            }];
            
        } else {
            completionBlock(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(NO, nil);

    }];
}

/**
 *  将图片上传至七牛服务器
 *
 *  @param image       上传的图片
 *  @param uploadToken 上传的 token
 *  @param key         上传的 key
 */
+ (void)uploadPhotoToQINIUServer:(UIImage *)image withToken:(NSString *)uploadToken andKey:(NSString *)key progress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL isSuccess, UploadShowImageModel *image))completionBlock
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    
    typedef void (^QNUpProgressHandler)(NSString *key, float percent);
    
    QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:@"text/plain"
                                               progressHandler:^(NSString *key, float percent) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       progressBlock(percent);
                                                   });
                                                                  }
                                                        params:@{ @"x:foo":@"fooval" }
                                                      checkCrc:YES
                                            cancellationSignal:nil];
    
    [upManager putData:data key:key token:uploadToken
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  if (resp) {
                      UploadShowImageModel *image = [[UploadShowImageModel alloc] init];
                      image.imageId = [resp objectForKey:@"key"];
                      dispatch_async(dispatch_get_main_queue(), ^{
                          completionBlock(YES, image);
                      });
                  } else {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          completionBlock(NO, nil);
                      });
                  }
              } option:opt];
    
}

@end
