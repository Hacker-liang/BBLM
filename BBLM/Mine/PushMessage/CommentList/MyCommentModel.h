//
//  MyCommentModel.h
//  BBLM
//
//  Created by liangpengshuai on 5/9/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMShowDetailModel.h"

@interface MyCommentModel : NSObject

@property (nonatomic) NSInteger commentId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic) BOOL isMine;
@property (nonatomic, strong) LMUserDetailModel *user;
@property (nonatomic, copy, readonly) NSString *publishDateDesc;
@property (nonatomic) long publishDate;

@property (nonatomic) LMShowDetailModel *show;

- (id)initWithJson:(id)json;

@end
