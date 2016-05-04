//
//  MyCommentTableViewCell.m
//  BBLM
//
//  Created by liangpengshuai on 5/4/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "MyCommentTableViewCell.h"

@implementation MyCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _contentLabel.textColor = APP_THEME_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCommentDetail:(LMShowCommentDetail *)commentDetail
{
    _commentDetail = commentDetail;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_commentDetail.user.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    _nicknameLabel.text = _commentDetail.user.nickname;
    _contentLabel.text = _commentDetail.content;
    _dateLabel.text = _commentDetail.publishDateDesc;
}

@end
