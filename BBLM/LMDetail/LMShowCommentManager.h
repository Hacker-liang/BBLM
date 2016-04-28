//
//  LMShowCommentManager.h
//  BBLM
//
//  Created by liangpengshuai on 4/28/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMShowCommentDetail.h"

@interface LMShowCommentManager : NSObject

+ (void)asyncLoadShowCommentsListWithShowId:(NSInteger)showId page:(NSInteger)page pageSize:(NSInteger)pageSize completionBlock:(void (^) (BOOL isSuccess, NSArray<LMShowCommentDetail *> *commentList))completion;

@end
