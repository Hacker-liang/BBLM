//
//  LMUserDetailModel.h
//  BBLM
//
//  Created by liangpengshuai on 4/13/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMUserDetailModel : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *locationCity;
@property (nonatomic, copy) NSString *xingzuo;
@property (nonatomic) NSInteger babyAge;

@property (nonatomic, copy) NSString *s_avatar;

@property (nonatomic, strong) NSArray <NSString *> *userTags;

@end
