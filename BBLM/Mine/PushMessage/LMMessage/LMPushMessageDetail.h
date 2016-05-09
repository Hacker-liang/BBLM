//
//  LMPushMessageDetail.h
//  BBLM
//
//  Created by liangpengshuai on 5/4/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMPushMessageDetail : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *coverImage;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *contentUrl;

@property (nonatomic, copy, readonly) NSString *publishDateDesc;
@property (nonatomic) long publishDate;

- (id)initWithJson:(id)json;

@end
