//
//  LMShowDetailModel.h
//  BBLM
//
//  Created by liangpengshuai on 4/13/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMUserDetailModel.h"
#import "LMShowCommentDetail.h"

@interface LMShowDetailModel : NSObject

@property (nonatomic, strong) LMUserDetailModel *publishUser;
@property (nonatomic) NSInteger itemId;
@property (nonatomic, copy) NSString *showDesc;
@property (nonatomic, copy) NSString *publishDateDesc;
@property (nonatomic, copy, readonly) NSString *coverImage;   //封面图，如果是图片选择图片的第一张，如果是视频，选择视频的图片
@property (nonatomic, copy) NSString *videoImage;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, strong) NSArray *imageList;
@property (nonatomic, readonly) BOOL isVideo;
@property (nonatomic) BOOL hasZan;
@property (nonatomic) NSInteger zanCount;
@property (nonatomic) NSInteger commentCount;
@property (nonatomic, strong) NSArray *zanUserList;
@property (nonatomic) NSInteger heat;  //热度
@property (nonatomic, strong) LMShowCommentDetail *firstComment;

- (id)initWithJson:(id)json;

@end
