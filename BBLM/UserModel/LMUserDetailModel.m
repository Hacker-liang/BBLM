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
        
    }
    return self;
}

- (id)initWithJson:(id)json
{
    if (self = [super init]) {
        _userId = [[json objectForKey:@"id"] integerValue];
        _nickname = [json objectForKey:@"nickname"];
        _backgroundImage = [json objectForKey:@"background"];
        _locationCity = [json objectForKey:@"city"];
        _xingzuo = [json objectForKey:@"constellation"];
        if ([[json objectForKey:@"labels"] length]) {
            _userTags = [[json objectForKey:@"labels"] componentsSeparatedByString:@","];
        }
        _tel = [json objectForKey:@"mobile"];
        _avatar = [json objectForKey:@"portrait"];
        _publishCnt = [[json objectForKey:@"publish"] integerValue];
        _shareCnt = [[json objectForKey:@"share"] integerValue];
        _fansCnt = [[json objectForKey:@"fans"] integerValue];
        _heat = [[json objectForKey:@"heat"] integerValue];
        if ([[json objectForKey:@"sex"] integerValue] == 1) {
            _gender = kMale;
        } else if ([[json objectForKey:@"sex"] integerValue] == 2) {
            _gender = kFemale;
        } else {
            _gender = kUnknow;
        }
    }
    return self;
}


- (NSString *)genderDesc
{
    if (_gender == kMale) {
        return @"男";
    }
    if (_gender == kFemale) {
        return @"女";
    }
    return @"未知";
}

@end
