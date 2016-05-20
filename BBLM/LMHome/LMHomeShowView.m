//
//  LMHomeShowView.m
//  BBLM
//
//  Created by liangpengshuai on 4/13/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMHomeShowView.h"
#import "LMShowManager.h"
#import "LMCommentsTableView.h"
#import "LMShowDetailViewController.h"
#import "LMHomeViewController.h"

@interface LMHomeShowView() <LMCommentsTableViewDelegate>

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) LMCommentsTableView *tableView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIButton *rankButton;
@property (nonatomic, strong) UIButton *zanButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *detailActionButton;


@end

@implementation LMHomeShowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = COLOR_LINE.CGColor;
        self.layer.borderWidth = 0.5;
        CGFloat width = self.bounds.size.width;
        
        _tableView = [[LMCommentsTableView alloc] initWithFrame:self.bounds];
        _tableView.backgroundColor = APP_PAGE_COLOR;
        _tableView.myDelegate = self;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, frame.size.height-70, width, 70)];
        [_tableView addSubview:button];
        [button addTarget:self action:@selector(gotoShowDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_tableView];
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, frame.size.height-70)];
        headerView.backgroundColor = APP_PAGE_COLOR;
        
        UIView *nickBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 56)];
        nickBgView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:nickBgView];
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 35, 35)];
        [headerView addSubview:_headerImageView];
        _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) + 10, 8, width, 20)];
        _nicknameLabel.font = [UIFont systemFontOfSize:15.0];
        _nicknameLabel.textColor = COLOR_TEXT_I;
        [headerView addSubview:_nicknameLabel];
        
        _moreActionButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-50,0, 50, 50)];
        [_moreActionButton setImage:[UIImage imageNamed:@"icon_showList_more"] forState:UIControlStateNormal];
        
        _rankButton = [[UIButton alloc] init];
        [headerView addSubview:_rankButton];
        
        if (kWindowHeight == 480) {
            _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) + 10, 25, width, 20)];
            
        } else {
            _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) + 10, 30, width, 20)];
            
        }
    
        _dateLabel.font = [UIFont systemFontOfSize:13.0];
        _dateLabel.textColor = COLOR_TEXT_II;
        [headerView addSubview:_dateLabel];
        
        if (kWindowHeight == 480) {
            _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 46, width, headerView.bounds.size.height-46-40-25)];

        } else {
            _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 56, width, headerView.bounds.size.height-56-50-25)];
        }
        
        _contentImageView.backgroundColor = APP_PAGE_COLOR;
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImageView.clipsToBounds = YES;
        _contentImageView.userInteractionEnabled = YES;
        [headerView addSubview:_contentImageView];
        
        _detailActionButton = [[UIButton alloc] initWithFrame:headerView.bounds];
        [_detailActionButton addTarget:self action:@selector(gotoShowDetailAction:) forControlEvents:UIControlEventTouchUpInside];

        [headerView addSubview:_detailActionButton];

        
        [headerView addSubview:_moreActionButton];

        _playVideoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _playVideoButton.center = CGPointMake(_contentImageView.bounds.size.width/2, _contentImageView.bounds.size.height/2+_contentImageView.frame.origin.y);
        [_playVideoButton setImage:[UIImage imageNamed:@"icon_playVideo"] forState:UIControlStateNormal];
        [headerView addSubview:_playVideoButton];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentImageView.frame), width, 25)];
        _contentLabel.backgroundColor = [UIColor whiteColor];
        _contentLabel.textColor = COLOR_TEXT_I;
        _contentLabel.font = [UIFont systemFontOfSize:13.0];
        [headerView addSubview:_contentLabel];
        
        if (kWindowHeight == 480) {
            _zanButton = [[UIButton alloc] initWithFrame:CGRectMake(15, headerView.frame.size.height-35, (width-30-30)/2, 30)];
            
        } else {
            _zanButton = [[UIButton alloc] initWithFrame:CGRectMake(15, headerView.frame.size.height-40, (width-30-30)/2, 30)];
            
        }
        [_zanButton setTitleColor:COLOR_TEXT_II forState:UIControlStateNormal];
        [_zanButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 10, 0, 0)];
        _zanButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        _zanButton.backgroundColor = [UIColor whiteColor];
        [_zanButton setTitleColor:APP_THEME_COLOR forState:UIControlStateSelected];
        [_zanButton setImage:[UIImage imageNamed:@"icon_showList_zan_normal"] forState:UIControlStateNormal];
        [_zanButton setImage:[UIImage imageNamed:@"icon_showList_zan_selected"] forState:UIControlStateSelected];
        _zanButton.selected = _showDetail.hasZan;
        [_zanButton addTarget:self action:@selector(zanShowAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:_zanButton];
        
        if (kWindowHeight == 480) {
            _commentButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_zanButton.frame) + 30, headerView.bounds.size.height-35, (width-30-30)/2, 30)];
            
        } else {
            _commentButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_zanButton.frame) + 30, headerView.bounds.size.height-40, (width-30-30)/2, 30)];
            
        }
        [_commentButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        _commentButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [_commentButton setTitleColor:COLOR_TEXT_II forState:UIControlStateNormal];
        _commentButton.backgroundColor = [UIColor whiteColor];
        _commentButton.userInteractionEnabled = NO;
        [_commentButton setImage:[UIImage imageNamed:@"icon_showList_comment"] forState:UIControlStateNormal];
        [headerView addSubview:_commentButton];

        _tableView.tableHeaderView = headerView;
    }
    return self;
}

- (void)showPlusNoti:(CGPoint)startPoint
{
    UILabel *plusLabel = [[UILabel alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y-20, 30, 20)];
    plusLabel.text = @"+1";
    plusLabel.textColor = APP_THEME_COLOR;
    plusLabel.font  =[UIFont systemFontOfSize:14.0];
    [self addSubview:plusLabel];
    [UIView animateWithDuration:1 animations:^{
        plusLabel.frame = CGRectMake(startPoint.x, startPoint.y-80, 30, 20);
        plusLabel.alpha = 0;
        
    } completion:^(BOOL finished) {
        [plusLabel removeFromSuperview];
    }];
}

- (void)setShowDetail:(LMShowDetailModel *)showDetail
{
    _showDetail = showDetail;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_showDetail.publishUser.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    [_contentImageView sd_setImageWithURL:[NSURL URLWithString:_showDetail.coverImage] placeholderImage:nil];
    
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
    _playVideoButton.hidden = !_showDetail.isVideo;
    _zanButton.selected = _showDetail.hasZan;
    [_zanButton setTitle:[NSString stringWithFormat:@"%ld", _showDetail.zanCount] forState:UIControlStateNormal];
    [_commentButton setTitle:[NSString stringWithFormat:@"%ld", _showDetail.commentCount] forState:UIControlStateNormal];
    if (_showDetail.firstComment) {
        _tableView.commentsList = [@[_showDetail.firstComment] mutableCopy];
        [_tableView reloadData];
    }
    _contentLabel.text = [NSString stringWithFormat:@"  %@", _showDetail.showDesc];

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
        _showDetail.hasZan = YES;
        _showDetail.zanCount++;
        sender.selected = !sender.selected;
        [sender setTitle:[NSString stringWithFormat:@"%ld", _showDetail.zanCount] forState:UIControlStateNormal];
        [self showPlusNoti:sender.center];

        [LMShowManager asyncZanShowWithItemId:_showDetail.itemId completionBlock:^(BOOL isSuccess) {
            if (!isSuccess) {
                _showDetail.hasZan = NO;
                sender.selected = !sender.selected;
                _showDetail.zanCount--;
                [sender setTitle:[NSString stringWithFormat:@"%ld", _showDetail.zanCount] forState:UIControlStateNormal];
            }
        }];
    } else {
        _showDetail.hasZan = NO;
        sender.selected = !sender.selected;
        _showDetail.zanCount--;
        [sender setTitle:[NSString stringWithFormat:@"%ld", _showDetail.zanCount] forState:UIControlStateNormal];
        
        [LMShowManager asyncCancelZanShowWithItemId:_showDetail.itemId completionBlock:^(BOOL isSuccess) {
            if (!isSuccess) {
                _showDetail.hasZan = YES;
                _showDetail.zanCount++;
                sender.selected = !sender.selected;
                [sender setTitle:[NSString stringWithFormat:@"%ld", _showDetail.zanCount] forState:UIControlStateNormal];
                [self showPlusNoti:sender.center];

            }
        }];
    }
}

- (void)gotoShowDetailAction:(UIButton *)sender
{
    [self.containerCtl gotoShowDetail:_showDetail.itemId];

}

- (void)commentTableViewDidScroll:(CGPoint)offset
{
    if (offset.y>5) {
        _tableView.contentOffset = CGPointZero;
        [self.containerCtl gotoShowDetail:_showDetail.itemId];
    }
    if (offset.y < 0) {
        _tableView.contentOffset = CGPointZero;

    }
}



@end
