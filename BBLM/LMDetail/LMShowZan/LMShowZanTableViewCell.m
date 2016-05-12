//
//  LMShowZanTableViewCell.m
//  BBLM
//
//  Created by liangpengshuai on 5/5/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMShowZanTableViewCell.h"
#import "LMUserManager.h"

@implementation LMShowZanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _avatarImageView.clipsToBounds = YES;
    _avatarImageView.layer.cornerRadius = 3.0;
    _focusButton.layer.cornerRadius = 3.0;
    _focusButton.clipsToBounds = YES;
    [_focusButton setTitle:@"关注" forState:UIControlStateNormal];
    [_focusButton setTitle:@"已关注" forState:UIControlStateSelected];
    [_focusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_focusButton setTitleColor:COLOR_TEXT_II forState:UIControlStateSelected];
    [_focusButton setBackgroundImage:[ConvertMethods createImageWithColor:APP_THEME_COLOR] forState:UIControlStateNormal];
    [_focusButton setBackgroundImage:[ConvertMethods createImageWithColor:APP_THEME_COLOR] forState:UIControlStateSelected];

    [_focusButton addTarget:self action:@selector(focuseUserAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)setUserModel:(LMUserDetailModel *)userModel
{
    _userModel = userModel;
    self.nicknameLabel.text = _userModel.nickname;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_userModel.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default.png"]];
    [_heatButton setImage:[UIImage imageNamed:@"icon_mine_rank"] forState:UIControlStateNormal];
    [_heatButton setTitle:[NSString stringWithFormat:@"%ld", _userModel.heat] forState:UIControlStateNormal];
    _focusButton.selected = _userModel.hasFocused;
    _focusButton.hidden = (_userModel.userId == [LMAccountManager shareInstance].account.userId);
}

- (void)focuseUserAction:(UIButton *)sender
{
    if (_userModel.userId == [LMAccountManager shareInstance].account.userId) {
        [SVProgressHUD showInfoWithStatus:@"您自己无需关注您自己"];
        return;
    }
    if (!sender.selected) {
        [LMUserManager asyncFocuseUserWithUserId:_userModel.userId completionBlock:^(BOOL isSuccess) {
            if (isSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"关注成功"];
                _userModel.hasFocused = YES;
                sender.selected = !sender.selected;
            } else {
                [SVProgressHUD showErrorWithStatus:@"关注失败"];
            }
        }];
    } else {
        [LMUserManager asyncCancelFocuseUserWithUserId:_userModel.userId completionBlock:^(BOOL isSuccess) {
            if (isSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
                _userModel.hasFocused = NO;
                sender.selected = !sender.selected;
            } else {
                [SVProgressHUD showErrorWithStatus:@"取消关注失败"];
            }
        }];
    }
}
@end
