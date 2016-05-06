//
//  LMNetworking.m
//  PeachTravel
//
//  Created by liangpengshuai on 1/7/16.
//  Copyright © 2016 com.aizou.www. All rights reserved.
//

#import "LMNetworking.h"

@implementation LMNetworking

+ (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))tsuccess
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))tfailure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *type = @"text/html";
    NSMutableSet *set = [[NSMutableSet alloc] initWithObjects:type, nil];
    manager.responseSerializer.acceptableContentTypes =  set;
    
    [self setOtherHeaderValue:manager andUrl:URLString parameters:parameters];
    return [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        tsuccess(operation, responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
        tfailure(operation, error);
        [self handleHttpError:error andOperation:operation];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    }];
}

+ (nullable AFHTTPRequestOperation *)DELETE:(NSString *)URLString
                                 parameters:(nullable id)parameters
                                    success:(nullable void (^)(AFHTTPRequestOperation *operation, id responseObject))tsuccess
                                    failure:(nullable void (^)(AFHTTPRequestOperation *operation, NSError *error))tfailure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [self setOtherHeaderValue:manager andUrl:URLString parameters:parameters];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    return [manager DELETE:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        tsuccess(operation, responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        tfailure(operation, error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    }];
}

+ (nullable AFHTTPRequestOperation *)PATCH:(NSString *)URLString
                                parameters:(nullable id)parameters
                                   success:(nullable void (^)(AFHTTPRequestOperation *operation, id responseObject))tsuccess
                                   failure:(nullable void (^)(AFHTTPRequestOperation *operation, NSError *error))tfailure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [self setHeaderValueForPXMethods:manager andUrl:URLString parameters:parameters];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    return [manager PATCH:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        tsuccess(operation, responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        tfailure(operation, error);
        [self handleHttpError:error andOperation:operation];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    }];
}

+ (nullable AFHTTPRequestOperation *)PUT:(NSString *)URLString
                              parameters:(nullable id)parameters
                                 success:(nullable void (^)(AFHTTPRequestOperation *operation, id responseObject))tsuccess
                                 failure:(nullable void (^)(AFHTTPRequestOperation *operation, NSError *error))tfailure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [self setHeaderValueForPXMethods:manager andUrl:URLString parameters:parameters];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    return [manager PUT:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        tsuccess(operation, responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        tfailure(operation, error);
        [self handleHttpError:error andOperation:operation];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}


+ (nullable AFHTTPRequestOperation *)POST:(NSString *)URLString
                               parameters:(nullable id)parameters
                                  success:(nullable void (^)(AFHTTPRequestOperation *operation, id responseObject))tsuccess
                                  failure:(nullable void (^)(AFHTTPRequestOperation *operation, NSError *error))tfailure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self setHeaderValueForPXMethods:manager andUrl:URLString parameters:parameters];

    return [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        tsuccess(operation, responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        tfailure(operation, error);
        NSLog(@"error: %@", error);
        [self handleHttpError:error andOperation:operation];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    }];
}

//POST PUT PATCH
+ (void)setHeaderValueForPXMethods:(AFHTTPRequestOperationManager *)manager andUrl:(NSString *)URLString parameters:parameters
{
   
}

//GET DELETE
+ (void)setOtherHeaderValue:(AFHTTPRequestOperationManager *)manager andUrl:(NSString *)URLString parameters:parameters
{
   
}

//处理 http 错误信息
+ (void)handleHttpError:(NSError *)error andOperation:(AFHTTPRequestOperation *)operation
{
    
}


@end
