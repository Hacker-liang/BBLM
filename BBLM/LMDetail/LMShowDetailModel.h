//
//  LMShowDetailModel.h
//  BBLM
//
//  Created by liangpengshuai on 4/13/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMUserDetailModel.h"

@interface LMShowDetailModel : NSObject

@property (nonatomic, strong) LMUserDetailModel *publishUser;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *publishDateDesc;
@property (nonatomic, copy) NSString *coverImage;
@property (nonatomic) BOOL isVideo;

@end
