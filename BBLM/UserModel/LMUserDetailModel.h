//
//  LMUserDetailModel.h
//  BBLM
//
//  Created by liangpengshuai on 4/13/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kMale = 1,
    kFemale,
    kUnknow,
} LMUserGender;

@interface LMUserDetailModel : NSObject

@property (nonatomic) NSInteger userId;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic) LMUserGender gender;
@property (nonatomic, copy, readonly) NSString *genderDesc;  //男 or 女

@property (nonatomic, copy) NSString *locationCity;
@property (nonatomic, copy) NSString *tel;

@property (nonatomic, copy) NSString *backgroundImage;

@property (nonatomic, copy) NSString *xingzuo;
@property (nonatomic) NSInteger babyAge;

@property (nonatomic, strong) NSArray <NSString *> *userTags;

@property (nonatomic) NSInteger fansCnt;
@property (nonatomic) NSInteger heat;
@property (nonatomic) NSInteger shareCnt;
@property (nonatomic) NSInteger publishCnt;

- (id)initWithJson:(id)json;

@end
