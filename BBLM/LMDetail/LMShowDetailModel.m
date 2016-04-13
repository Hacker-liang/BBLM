//
//  LMShowDetailModel.m
//  BBLM
//
//  Created by liangpengshuai on 4/13/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMShowDetailModel.h"

@implementation LMShowDetailModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _publishUser = [[LMUserDetailModel alloc] init];
        _publishDateDesc = @"2014-04-16";
        
    }
    return self;
}


@end
