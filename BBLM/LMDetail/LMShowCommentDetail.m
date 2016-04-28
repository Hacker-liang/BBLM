//
//  LMShowCommentDetail.m
//  BBLM
//
//  Created by liangpengshuai on 4/21/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMShowCommentDetail.h"

@implementation LMShowCommentDetail

- (instancetype)init
{
    self = [super init];
    if (self) {
        _user = [[LMUserDetailModel alloc] init];
//        _content = @"好棒啊！继续努力";
        _isMine = YES;
        _content = @"色调分离收快递房间少的可怜房间收快递房间收到了开发建设都看到了";

        _publishDateDesc = @"2分钟前";
    }
    return self;
}

@end
