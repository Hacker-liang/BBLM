//
//  LMShowCommentDetail.h
//  BBLM
//
//  Created by liangpengshuai on 4/21/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMShowCommentDetail : NSObject

@property (nonatomic) NSInteger commentId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic) BOOL isMine;
@property (nonatomic, strong) LMUserDetailModel *user;
@property (nonatomic, copy, readonly) NSString *publishDateDesc;
@property (nonatomic) long publishDate;

- (id)initWithJson:(id)json;

@end
