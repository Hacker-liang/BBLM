//
//  LMUserDetailModel.m
//  BBLM
//
//  Created by liangpengshuai on 4/13/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMUserDetailModel.h"

@implementation LMUserDetailModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _nickName = @"世界第一喇嘛";
        _userTags = @[@"爱做服饰", @"汤达人", @"一条测试数据", @"哈哈"];

    }
    return self;
}


@end
