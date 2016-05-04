//
//  LMShowCommentDetail.m
//  BBLM
//
//  Created by liangpengshuai on 4/21/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMShowCommentDetail.h"
#import "LMShowDetailModel.h"

@implementation LMShowCommentDetail

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithJson:(id)json
{
    if (self = [super init]) {
        _commentId = [[json objectForKey:@"id"] integerValue];
        _content = [json objectForKey:@"content"];
        _user = [[LMUserDetailModel alloc] init];
        _user.userId = [[json objectForKey:@"fromId"] integerValue];
        _user.nickname = [json objectForKey:@"nickname"];
        _user.avatar = [json objectForKey:@"portrait"];
        _isMine = _user.userId == [LMAccountManager shareInstance].account.userId;
        
        _show = [[LMShowDetailModel alloc] init];
        _show.itemId = [[json objectForKey:@"id"] integerValue];
        _show.imageList = [[json objectForKey:@"imgs"] componentsSeparatedByString:@","];

    }
    return self;
}
@end
