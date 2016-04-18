//
//  LMEditUserAvatarTableViewCell.m
//  BBLM
//
//  Created by liangpengshuai on 4/18/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMEditUserAvatarTableViewCell.h"

@implementation LMEditUserAvatarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _headerImageButton.backgroundColor = APP_PAGE_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
