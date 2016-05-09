//
//  MyCommentModel.m
//  BBLM
//
//  Created by liangpengshuai on 5/9/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "MyCommentModel.h"

@implementation MyCommentModel

- (id)initWithJson:(id)json
{
    if (self = [super init]) {
        _commentId = [[json objectForKey:@"id"] integerValue];
        _content = [json objectForKey:@"content"];
        _user = [[LMUserDetailModel alloc] init];
        _user.userId = [[json objectForKey:@"id"] integerValue];
        _user.nickname = [json objectForKey:@"nickname"];
        _user.avatar = [json objectForKey:@"portrait"];
        _isMine = _user.userId == [LMAccountManager shareInstance].account.userId;
        _publishDate = [[json objectForKey:@"time"] longLongValue]/1000;
        
        _show = [[LMShowDetailModel alloc] init];
        _show.itemId = [[json objectForKey:@"dynamicId"] integerValue];
        _show.imageList = [[json objectForKey:@"imgs"] componentsSeparatedByString:@","];
        
    }
    return self;
}

- (NSString *)publishDateDesc
{
    long long nowTime = [[NSDate date] timeIntervalSince1970];
    long space = nowTime - _publishDate;
    if (space < 60*60) {
        if (space/60 == 0) {
            return @"刚刚";
        }
        return [[NSString alloc] initWithFormat:@"%ld分钟前", (NSInteger)(space/60)];
    } else if (space < 60*60*24) {
        
        return [[NSString alloc] initWithFormat:@"%ld小时前", (NSInteger)(space/3600)];
    } else if (space < 60*60*24*15) {
        
        return [[NSString alloc] initWithFormat:@"%ld天前", (NSInteger)(space/3600/24)];
    } else {
        return [ConvertMethods dateToString:[NSDate dateWithTimeIntervalSince1970:_publishDate] withFormat:@"yyyy-MM-dd" withTimeZone:[NSTimeZone systemTimeZone]];
        
    }
}

@end
