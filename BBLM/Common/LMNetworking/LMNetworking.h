//
//  LMNetworking.h
//  PeachTravel
//
//  Created by liangpengshuai on 1/7/16.
//  Copyright © 2016 com.aizou.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "AFNetWorking.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMNetworking : NSObject

+ (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(nullable id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


+ (nullable AFHTTPRequestOperation *)DELETE:(NSString *)URLString
                                 parameters:(nullable id)parameters
                                    success:(nullable void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(nullable void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (nullable AFHTTPRequestOperation *)PATCH:(NSString *)URLString
                                parameters:(nullable id)parameters
                                   success:(nullable void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(nullable void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (nullable AFHTTPRequestOperation *)PUT:(NSString *)URLString
                              parameters:(nullable id)parameters
                                 success:(nullable void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(nullable void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


+ (nullable AFHTTPRequestOperation *)POST:(NSString *)URLString
                               parameters:(nullable id)parameters
                                  success:(nullable void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(nullable void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)setHeaderValueForPXMethods:(AFHTTPRequestOperationManager *)manager andUrl:(NSString *)URLString parameters:parameters;
+ (void)setOtherHeaderValue:(AFHTTPRequestOperationManager *)manager andUrl:(NSString *)URLString parameters:parameters;


NS_ASSUME_NONNULL_END

@end
