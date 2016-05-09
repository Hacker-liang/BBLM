//
//  MyZanTableViewCell.m
//  BBLM
//
//  Created by liangpengshuai on 5/4/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "MyZanTableViewCell.h"

@implementation MyZanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setZanDetail:(LMShowZanDetail *)zanDetail
{
    _zanDetail = zanDetail;
    [_avatarButton sd_setImageWithURL:[NSURL URLWithString:_zanDetail.user.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    _nicknameLabel.text = _zanDetail.user.nickname;
    [_showImageView sd_setImageWithURL:[NSURL URLWithString:_zanDetail.showImage] placeholderImage:nil];
    _dateLabel.text = _zanDetail.publishDateDesc;
}

@end
