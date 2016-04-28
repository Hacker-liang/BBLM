//
//  LMCommentsTableViewCell.h
//  BBLM
//
//  Created by liangpengshuai on 4/21/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMShowCommentDetail.h"

@interface LMCommentsTableViewCell : UITableViewCell

@property (nonatomic, strong) LMShowCommentDetail *commentDetail;

+ (CGFloat)heightWithCommentDetail:(LMShowCommentDetail *)commentDetail;

@end
