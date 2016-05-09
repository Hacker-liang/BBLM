//
//  LMShowTableViewCell.m
//  BBLM
//
//  Created by liangpengshuai on 4/27/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMShowTableViewCell.h"
#import "LMShowManager.h"

@interface LMShowTableViewCell ()


@end

@implementation LMShowTableViewCell

+ (CGFloat)heightOfShowListCell
{
    return kWindowWidth*3/4 + 50 + 50;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _coverImageView.backgroundColor = APP_PAGE_COLOR;
    _coverImageView.clipsToBounds = YES;
    _commentButton.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setShowDetail:(LMShowDetailModel *)showDetail
{
    _showDetail = showDetail;
    [_avatarImagView sd_setImageWithURL:[NSURL URLWithString:_showDetail.publishUser.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    NSMutableAttributedString *titleAttr = [[NSMutableAttributedString alloc] init];
    
    NSAttributedString *nicknameAttr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@    ", _showDetail.publishUser.nickname] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName: COLOR_TEXT_I}];
    [titleAttr appendAttributedString:nicknameAttr];
    
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:@"icon_mine_rank"];
    attch.bounds = CGRectMake(0, 0, 16, 11);
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [titleAttr appendAttributedString:string];
    
    NSAttributedString *rankAttr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %ld", _showDetail.heat] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName: APP_THEME_COLOR}];
    [titleAttr appendAttributedString:rankAttr];
    _nicknameLabel.attributedText = titleAttr;
    
    _dateLabel.text = _showDetail.publishDateDesc;
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:_showDetail.coverImage] placeholderImage:nil];
    _playVideoButton.hidden = !showDetail.isVideo;
    _showDescLabel.text = _showDetail.showDesc;
    [_zanButton setTitleColor:COLOR_TEXT_II forState:UIControlStateNormal];
    [_zanButton setTitleColor:APP_THEME_COLOR forState:UIControlStateSelected];
    [_zanButton setImage:[UIImage imageNamed:@"icon_showList_zan_normal"] forState:UIControlStateNormal];
    [_zanButton setImage:[UIImage imageNamed:@"icon_showList_zan_selected"] forState:UIControlStateSelected];
    _zanButton.selected = _showDetail.hasZan;
    [_zanButton addTarget:self action:@selector(zanShowAction:) forControlEvents:UIControlEventTouchUpInside];

    [_zanButton setTitle:[NSString stringWithFormat:@"%ld", _showDetail.zanCount] forState:UIControlStateNormal];
    
    [_commentButton setImage:[UIImage imageNamed:@"icon_showList_comment"] forState:UIControlStateNormal];
    [_commentButton setTitle:[NSString stringWithFormat:@"%ld", _showDetail.commentCount] forState:UIControlStateNormal];
}


- (void)zanShowAction:(UIButton *)sender
{
    if (![[LMAccountManager shareInstance] isLogin]) {
        LMLoginViewController *ctl = [[LMLoginViewController alloc] initWithCompletionBlock:^(BOOL isLogin, NSString *errorStr) {
            if (isLogin) {
                
            } else {
            }
        }];
        [[self findContainerViewController] presentViewController:ctl animated:YES completion:nil];
        
        return;
    }
    if (!sender.selected) {
        [LMShowManager asyncZanShowWithItemId:_showDetail.itemId completionBlock:^(BOOL isSuccess) {
            if (isSuccess) {
                _showDetail.hasZan = YES;
                _showDetail.zanCount++;
                sender.selected = !sender.selected;
                [sender setTitle:[NSString stringWithFormat:@"%ld", _showDetail.zanCount] forState:UIControlStateNormal];

            }
        }];
    } else {
        [LMShowManager asyncCancelZanShowWithItemId:_showDetail.itemId completionBlock:^(BOOL isSuccess) {
            if (isSuccess) {
                _showDetail.hasZan = NO;
                sender.selected = !sender.selected;
                _showDetail.zanCount--;
                [sender setTitle:[NSString stringWithFormat:@"%ld", _showDetail.zanCount] forState:UIControlStateNormal];
            }
        }];
    }
}


@end




