//
//  LMUserPorfileHeaderView.m
//  BBLM
//
//  Created by liangpengshuai on 4/18/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMUserPorfileHeaderView.h"
#import "TEAChart.h"
#import "LMUserManager.h"

@interface LMUserPorfileHeaderView ()

@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UIButton *rankButton;
@property (nonatomic, strong) UILabel *rankingLabel;
@property (nonatomic, strong) UIButton *floowButton;

@property (nonatomic, strong) UILabel *publishCntLabel;
@property (nonatomic, strong) UILabel *followerCntLabel;
@property (nonatomic, strong) UILabel *shareCntLabel;

@property (nonatomic, strong) UILabel *noRankLabel;

@property (nonatomic, strong) UIScrollView *tagBgView;
@property (nonatomic, strong) UIView *conentBgView;
@property (nonatomic, strong) TEABarChart *userRankChart;

@property (nonatomic) BOOL isMyselfInfo;   //是否是我自己的信息

@end

@implementation LMUserPorfileHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = APP_PAGE_COLOR;
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth,210+64)];
        bgView.image = [UIImage imageNamed:@"icon_user_bgView"];
        bgView.userInteractionEnabled = YES;
        [self addSubview:bgView];
        
        UIView *rankingBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth,210)];
        [bgView addSubview:rankingBgView];

        if (kWindowWidth==320) {
            _userRankChart = [[TEABarChart alloc] initWithFrame:CGRectMake(12, 10, kWindowWidth-24, 165)];
        } else {
            _userRankChart = [[TEABarChart alloc] initWithFrame:CGRectMake(20, 10, kWindowWidth-40, 165)];

        }
        _userRankChart.barColor = [UIColor whiteColor];
        _userRankChart.backgroundColor = [UIColor clearColor];
        _userRankChart.textColor = [UIColor whiteColor];
        _userRankChart.cornerRadius = 6;
        [rankingBgView addSubview:_userRankChart];
        
        _noRankLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, _userRankChart.center.y-30, kWindowWidth-24, 20)];
        _noRankLabel.textAlignment = NSTextAlignmentCenter;
        _noRankLabel.textColor = [UIColor whiteColor];
        _noRankLabel.font = [UIFont systemFontOfSize:14.0];
        [rankingBgView addSubview:_noRankLabel];
        
        _rankingLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 190, kWindowWidth-24, 20)];
        _rankingLabel.textAlignment = NSTextAlignmentRight;
        _rankingLabel.textColor = [UIColor whiteColor];
        _rankingLabel.font = [UIFont systemFontOfSize:13.0];
        [rankingBgView addSubview:_rankingLabel];
        
        _conentBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 210+64, kWindowWidth, 140)];
        _conentBgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_conentBgView];
        
        _avatarButton = [[UIButton alloc] initWithFrame:CGRectMake(12, -12, 80, 80)];
        _avatarButton.layer.cornerRadius = 40;
        _avatarButton.clipsToBounds = YES;
        _avatarButton.backgroundColor = APP_PAGE_COLOR;
        [_conentBgView addSubview:_avatarButton];
        
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 40, 20)];
        tempLabel.font = [UIFont systemFontOfSize:17.0];
        tempLabel.text = @"发布";
        tempLabel.textAlignment = NSTextAlignmentCenter;
        tempLabel.textColor = COLOR_TEXT_II;
        [_conentBgView addSubview:tempLabel];
        
        UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(155, 25, 0.5, 50)];
        spaceView.backgroundColor = COLOR_LINE;
        [_conentBgView addSubview:spaceView];
        
        UILabel *tempLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(170, 20, 40, 20)];
        tempLabel2.font = [UIFont systemFontOfSize:17.0];
        tempLabel2.text = @"粉丝";
        tempLabel2.textAlignment = NSTextAlignmentCenter;
        tempLabel2.textColor = COLOR_TEXT_II;
        [_conentBgView addSubview:tempLabel2];
        
        UIView *spaceView2 = [[UIView alloc] initWithFrame:CGRectMake(225, 25, 0.5, 50)];
        spaceView2.backgroundColor = COLOR_LINE;
        [_conentBgView addSubview:spaceView2];
        
        UILabel *tempLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(240, 20, 40, 20)];
        tempLabel3.font = [UIFont systemFontOfSize:17.0];
        tempLabel3.text = @"分享";
        tempLabel3.textAlignment = NSTextAlignmentCenter;
        tempLabel3.textColor = COLOR_TEXT_II;
        [_conentBgView addSubview:tempLabel3];

        
        _publishCntLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 40, 20)];
        _publishCntLabel.font = [UIFont systemFontOfSize:16.0];
        _publishCntLabel.textAlignment = NSTextAlignmentCenter;
        _publishCntLabel.textColor = APP_THEME_COLOR;
        [_conentBgView addSubview:_publishCntLabel];
        
        _followerCntLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 50, 40, 20)];
        _followerCntLabel.font = [UIFont systemFontOfSize:16.0];
        _followerCntLabel.textAlignment = NSTextAlignmentCenter;
        _followerCntLabel.textColor = APP_THEME_COLOR;
        [_conentBgView addSubview:_followerCntLabel];
        
        _shareCntLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 50, 40, 20)];
        _shareCntLabel.font = [UIFont systemFontOfSize:16.0];
        _shareCntLabel.textAlignment = NSTextAlignmentCenter;
        _shareCntLabel.textColor = APP_THEME_COLOR;
        [_conentBgView addSubview:_shareCntLabel];

        _rankButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 83, 80, 17)];
        [_rankButton setTitleColor:APP_THEME_COLOR forState:UIControlStateNormal];
        _rankButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_rankButton setImage:[UIImage imageNamed:@"icon_mine_rank.png"] forState:UIControlStateNormal];
        _rankButton.userInteractionEnabled = NO;
        [_rankButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [_rankButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [_conentBgView addSubview:_rankButton];
        
        UIView *buttomSpaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 139.5, kWindowWidth, 0.5)];
        buttomSpaceView.backgroundColor = COLOR_LINE;
        [_conentBgView addSubview:buttomSpaceView];
        
        _floowButton = [[UIButton alloc] initWithFrame:CGRectMake(kWindowWidth-80, 110, 70, 25)];
        _floowButton.clipsToBounds = YES;
        _floowButton.layer.cornerRadius = 3.0;
        _floowButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [_floowButton setTitle:@"关注" forState:UIControlStateNormal];
        [_floowButton setTitle:@"已关注" forState:UIControlStateSelected];
        [_floowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_floowButton setTitleColor:COLOR_TEXT_II forState:UIControlStateSelected];
        
        [_floowButton addTarget:self action:@selector(focuseUserAction:) forControlEvents:UIControlEventTouchUpInside];
        [_floowButton setBackgroundImage:[ConvertMethods createImageWithColor:APP_THEME_COLOR] forState:UIControlStateNormal];
        [_floowButton setBackgroundImage:[ConvertMethods createImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateSelected];

        [_floowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_conentBgView addSubview:_floowButton];
    }
    return self;
}

- (void)setUserInfo:(LMUserDetailModel *)userInfo
{
    _userInfo = userInfo;
    _isMyselfInfo = [LMAccountManager shareInstance].account.userId == _userInfo.userId;
    
    if (_isMyselfInfo) {
        _noRankLabel.text = @"您近周的辣度为0,要加油了!";
    } else {
        _noRankLabel.text = @"ta近周的辣度为0";

    }
    
    _floowButton.hidden = _isMyselfInfo;
    _floowButton.selected = _userInfo.hasFocused;
    [_rankButton setTitle:[NSString stringWithFormat:@"%ld", _userInfo.heat] forState:UIControlStateNormal];
    _shareCntLabel.text = [NSString stringWithFormat:@"%ld", _userInfo.shareCnt];
    _publishCntLabel.text = [NSString stringWithFormat:@"%ld", _userInfo.publishCnt];
    _followerCntLabel.text = [NSString stringWithFormat:@"%ld", _userInfo.fansCnt];
    [_avatarButton sd_setImageWithURL:[NSURL URLWithString:_userInfo.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    if (_tagBgView) {
        [_tagBgView removeFromSuperview];
        _tagBgView = nil;
    }
    _tagBgView = [[UIScrollView alloc] initWithFrame:CGRectMake(12, 110, kWindowWidth-105, 25)];
    _tagBgView.showsHorizontalScrollIndicator = NO;
    [_conentBgView addSubview:_tagBgView];
    
    NSInteger i = 0;
    CGFloat offsetX = 0;
    for (NSString *tag in _userInfo.userTags) {
        CGFloat width = [tag sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0]}].width;
        UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 0, width+20, 25)];
        tagLabel.text = tag;
        tagLabel.textColor = COLOR_TEXT_II;
        tagLabel.layer.borderColor = COLOR_LINE.CGColor;
        tagLabel.layer.borderWidth = 0.5;
        tagLabel.layer.cornerRadius = 3.0;
        tagLabel.clipsToBounds = YES;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.font = [UIFont systemFontOfSize:13.0];
        [_tagBgView addSubview:tagLabel];
        i++;
        offsetX += (width+30);
    }
    _tagBgView.contentSize = CGSizeMake(offsetX, 25);
}

- (void)setUserRankInfo:(NSDictionary *)userRankInfo
{
    _userRankInfo = userRankInfo;
    NSMutableArray *labels = [[NSMutableArray alloc] init];
    NSMutableArray *tempvalues = [[NSMutableArray alloc] init];
    NSInteger maxValue = 0;
    BOOL isNotRank = YES;
    for (NSDictionary *dic in [_userRankInfo objectForKey:@"countList"]) {
        [labels addObject:[dic.allKeys firstObject]];
        [tempvalues addObject:[dic.allValues firstObject]];
        if ([[dic.allValues firstObject] integerValue] > maxValue) {
            maxValue = [[dic.allValues firstObject] integerValue];
        }
        if ([[dic.allValues firstObject] integerValue] > 0) {
            isNotRank = NO;
        }
    }
    
    _userRankChart.data = tempvalues;
    _userRankChart.max = maxValue+10;
    _userRankChart.xLabels = labels;
    if (_isMyselfInfo) {
        _rankingLabel.text = [NSString stringWithFormat:@"本周您的辣妈排榜在第%ld名", [[_userRankInfo objectForKey:@"rank"] integerValue]];
    } else {
        _rankingLabel.text = [NSString stringWithFormat:@"本周ta的辣妈排榜在第%ld名", [[_userRankInfo objectForKey:@"rank"] integerValue]];

    }
    _noRankLabel.hidden = !isNotRank;
}

- (void)focuseUserAction:(UIButton *)sender
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
        [LMUserManager asyncFocuseUserWithUserId:_userInfo.userId completionBlock:^(BOOL isSuccess) {
            if (isSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"关注成功"];
                _userInfo.hasFocused = YES;
                _userInfo.fansCnt++;
                _followerCntLabel.text = [NSString stringWithFormat:@"%ld", _userInfo.fansCnt];
                sender.selected = !sender.selected;
            } else {
                [SVProgressHUD showErrorWithStatus:@"关注失败"];
            }
        }];
    } else {
        [LMUserManager asyncCancelFocuseUserWithUserId:_userInfo.userId completionBlock:^(BOOL isSuccess) {
            if (isSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
                _userInfo.hasFocused = NO;
                
                _userInfo.fansCnt--;
                if (_userInfo.fansCnt<0) {
                    _userInfo.fansCnt = 0;
                }
                _followerCntLabel.text = [NSString stringWithFormat:@"%ld", _userInfo.fansCnt];
                sender.selected = !sender.selected;
            } else {
                [SVProgressHUD showErrorWithStatus:@"取消关注失败"];
            }
        }];
    }
}

@end
