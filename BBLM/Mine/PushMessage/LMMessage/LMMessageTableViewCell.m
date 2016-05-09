//
//  LMMessageTableViewCell.m
//  BBLM
//
//  Created by liangpengshuai on 5/4/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMMessageTableViewCell.h"

@implementation LMMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setPushMessage:(LMPushMessageDetail *)pushMessage
{
    _pushMessage = pushMessage;
    [_avatarButton sd_setImageWithURL:[NSURL URLWithString:_pushMessage.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    _nicknameLabel.text = _pushMessage.title;
    [_showImageView sd_setImageWithURL:[NSURL URLWithString:_pushMessage.coverImage] placeholderImage:nil];
    _dateLabel.text = _pushMessage.publishDateDesc;
}

@end
