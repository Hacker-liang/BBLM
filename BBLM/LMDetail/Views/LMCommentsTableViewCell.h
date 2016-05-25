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

@property (nonatomic, strong) UIButton *avatarImageButton;

+ (CGFloat)heightWithCommentDetail:(LMShowCommentDetail *)commentDetail hideNickName:(BOOL)hide;

@property (nonatomic) BOOL hideNickName;   //是否隐藏用户名


@end
