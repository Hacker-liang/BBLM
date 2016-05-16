//
//  LMPushMessageTableViewCell.m
//  BBLM
//
//  Created by liangpengshuai on 4/15/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMPushMessageTableViewCell.h"

@implementation LMPushMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _unReadCntLabel.clipsToBounds = YES;
    _unReadCntLabel.layer.cornerRadius = 7.5;
    _unReadCntLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
