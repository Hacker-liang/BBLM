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
@property (nonatomic, copy) NSString *publishDate;
@property (nonatomic, copy) NSString *publishDateDesc;
@property (nonatomic, copy) NSString *showImage;

- (id)initWithJson:(id)json;

@end
