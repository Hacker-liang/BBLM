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

+ (void)uploadUserVideo:(NSString *)videoPath coverImagePath:(NSString *)coverPath withDesc:(NSString *)desc progress:(void (^)(CGFloat))progressBlock completion:(void (^)(BOOL isSuccess, NSString *videoKey, NSString *coverImageKey))completionBlock
{
    __block NSString *coverImageKey;
    __block NSString *videoKey;

    [self requestUploadTokeAndUploadData:[NSData dataWithContentsOfFile:coverPath] andKey:nil progress:^(CGFloat progress) {
        
    } completion:^(BOOL isSuccess, NSString *key) {
        if (isSuccess) {
            coverImageKey = key;
            NSURL *fileUrl = [NSURL URLWithString:videoPath];
            NSString *fileName = fileUrl.lastPathComponent;
            [self requestUploadTokeAndUploadData:[NSData dataWithContentsOfFile:videoPath] andKey:fileName progress:progressBlock completion:^(BOOL isSuccess, NSString *key) {
                if (isSuccess) {
                    videoKey = key;
                    completionBlock(isSuccess, videoKey, coverImageKey);
                } else {
                    completionBlock(NO, nil, nil);
                }
                
            }];
        } else {
            completionBlock(NO, nil, nil);
        }
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


+ (void)requestUploadTokeAndUploadData:(NSData *)data andKey:(NSString *)key progress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL isSuccess, NSString *key))completionBlock
{
    NSString *url = [NSString stringWithFormat:@"%@qiniu/auth", BASE_API];
    progressBlock(0.0);
    NSDictionary *params;
    params = @{@"memberId": [NSNumber numberWithInteger: [LMAccountManager shareInstance].account.userId]};
    
    [LMNetworking GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 0) {
            [self uploadDataToQINIUServer:data withToken:[[responseObject objectForKey:@"data"]  objectForKey:@"auth"] andKey:key progress:progressBlock completion:completionBlock];
        } else {
            completionBlock(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(NO, nil);
        
    }];
}

/**
 *  将二进制文件上传到七牛服务器
 */
+ (void)uploadDataToQINIUServer:(NSData *)data withToken:(NSString *)uploadToken andKey:(NSString *)key progress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL isSuccess, NSString *key))completionBlock
{
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    
    typedef void (^QNUpProgressHandler)(NSString *key, float percent);
    
    QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:@"text/plain"
                                               progressHandler:^(NSString *key, float percent) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       if (progressBlock) {
                                                           progressBlock(percent);
                                                       }
                                                   });
                                               }
                                                        params:@{ @"x:foo":@"fooval" }
                                                      checkCrc:YES
                                            cancellationSignal:nil];
    
    [upManager putData:data key:key token:uploadToken
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  if (resp) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          completionBlock(YES, [resp objectForKey:@"key"]);
                      });
                  } else {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          completionBlock(NO, nil);
                      });
                  }
              } option:opt];
}

@end
