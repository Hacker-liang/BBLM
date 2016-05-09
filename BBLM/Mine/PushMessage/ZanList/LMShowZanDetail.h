//
//  LMShowZanDetail.h
//  BBLM
//
//  Created by liangpengshuai on 5/4/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMShowZanDetail : NSObject

@property (nonatomic, strong) LMUserDetailModel *user;
@property (nonatomic) long long publishDate;
@property (nonatomic, copy) NSString *publishDateDesc;
@property (nonatomic, copy) NSString *showImage;
@property (nonatomic) NSInteger showId;

- (id)initWithJson:(id)json;

@end
