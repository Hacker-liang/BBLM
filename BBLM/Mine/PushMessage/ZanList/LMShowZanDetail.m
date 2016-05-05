//
//  LMShowZanDetail.m
//  BBLM
//
//  Created by liangpengshuai on 5/4/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMShowZanDetail.h"

@implementation LMShowZanDetail

- (id)initWithJson:(id)json
{
    if (self = [super init]) {
        _user = [[LMUserDetailModel alloc] init];
        _user.nickname = [json objectForKey:@"nickname"];
        _user.avatar = [json objectForKey:@"portrait"];
        _publishDate = [json objectForKey:@"time"];
        _showImage = [[[json objectForKey:@"imgs"] componentsSeparatedByString:@","] firstObject];

        
    }
    return self;
}

@end
