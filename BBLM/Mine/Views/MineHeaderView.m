//
//  MineHeaderView.m
//  BBLM
//
//  Created by liangpengshuai on 4/14/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "MineHeaderView.h"

@interface MineHeaderView ()

@property (nonatomic, strong) UIButton *rankButton;

@property (nonatomic, strong) UILabel *publishCntLabel;
@property (nonatomic, strong) UILabel *followerCntLabel;
@property (nonatomic, strong) UILabel *shareCntLabel;
@property (nonatomic, strong) UIButton *addTagButton;
@property (nonatomic, strong) UIScrollView *tagBgView;

@end

@implementation MineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = APP_PAGE_COLOR;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 140)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        _avatarButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 12, 65, 65)];
        _avatarButton.layer.cornerRadius = 32.5;
        _avatarButton.clipsToBounds = YES;
        _avatarButton.backgroundColor = APP_PAGE_COLOR;
        [self addSubview:_avatarButton];
        
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 40, 20)];
        tempLabel.font = [UIFont systemFontOfSize:17.0];
        tempLabel.text = @"发布";
        tempLabel.textAlignment = NSTextAlignmentCenter;
        tempLabel.textColor = COLOR_TEXT_II;
        [self addSubview:tempLabel];
        
        UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(149, 25, 0.5, 50)];
        spaceView.backgroundColor = COLOR_LINE;
        [self addSubview:spaceView];
        
        UILabel *tempLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(160, 20, 40, 20)];
        tempLabel2.font = [UIFont systemFontOfSize:17.0];
        tempLabel2.text = @"粉丝";
        tempLabel2.textAlignment = NSTextAlignmentCenter;
        tempLabel2.textColor = COLOR_TEXT_II;
        [self addSubview:tempLabel2];
        
        UIView *spaceView2 = [[UIView alloc] initWithFrame:CGRectMake(210, 25, 0.5, 50)];
        spaceView2.backgroundColor = COLOR_LINE;
        [self addSubview:spaceView2];
        
        UILabel *tempLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(220, 20, 40, 20)];
        tempLabel3.font = [UIFont systemFontOfSize:17.0];
        tempLabel3.text = @"分享";
        tempLabel3.textAlignment = NSTextAlignmentCenter;
        tempLabel3.textColor = COLOR_TEXT_II;
        [self addSubview:tempLabel3];
        
        _publishCntLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 40, 20)];
        _publishCntLabel.font = [UIFont systemFontOfSize:16.0];
        _publishCntLabel.textAlignment = NSTextAlignmentCenter;
        _publishCntLabel.textColor = APP_THEME_COLOR;
        [self addSubview:_publishCntLabel];
        
        _followerCntLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 50, 40, 20)];
        _followerCntLabel.font = [UIFont systemFontOfSize:16.0];
        _followerCntLabel.textAlignment = NSTextAlignmentCenter;
        _followerCntLabel.textColor = APP_THEME_COLOR;
        [self addSubview:_followerCntLabel];
        
        _shareCntLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 50, 40, 20)];
        _shareCntLabel.font = [UIFont systemFontOfSize:16.0];
        _shareCntLabel.textAlignment = NSTextAlignmentCenter;
        _shareCntLabel.textColor = APP_THEME_COLOR;
        [self addSubview:_shareCntLabel];
        
        _rankButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 83, 65, 17)];
        [_rankButton setTitleColor:APP_THEME_COLOR forState:UIControlStateNormal];
        _rankButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_rankButton setImage:[UIImage imageNamed:@"icon_mine_rank.png"] forState:UIControlStateNormal];
        _rankButton.userInteractionEnabled = NO;
        [_rankButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [_rankButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [self addSubview:_rankButton];
        
        UIView *buttomSpaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 140, kWindowWidth, 0.5)];
        buttomSpaceView.backgroundColor = COLOR_LINE;
        [self addSubview:buttomSpaceView];
        
        _editUserInfoButton = [[UIButton alloc] initWithFrame:CGRectMake(kWindowWidth-80, 110, 70, 25)];
        _editUserInfoButton.clipsToBounds = YES;
        _editUserInfoButton.layer.cornerRadius = 3.0;
        _editUserInfoButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [_editUserInfoButton setTitle:@"编辑资料" forState:UIControlStateNormal];
        [_editUserInfoButton setBackgroundImage:[ConvertMethods createImageWithColor:APP_THEME_COLOR] forState:UIControlStateNormal];
        [_editUserInfoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_editUserInfoButton];

        _addTagButton = [[UIButton alloc] init];
    }
    return self;
}

- (void)setUserInfo:(LMUserDetailModel *)userInfo
{
    _userInfo = userInfo;
    
    [_rankButton setTitle:[NSString stringWithFormat:@"%ld", _userInfo.heat] forState:UIControlStateNormal];
    _publishCntLabel.text = [NSString stringWithFormat:@"%ld", _userInfo.publishCnt];
    _followerCntLabel.text = [NSString stringWithFormat:@"%ld", _userInfo.fansCnt];
    _shareCntLabel.text = [NSString stringWithFormat:@"%ld", _userInfo.shareCnt];

    [_avatarButton sd_setImageWithURL:[NSURL URLWithString:_userInfo.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    if (_tagBgView) {
        [_tagBgView removeFromSuperview];
        _tagBgView = nil;
    }
    _tagBgView = [[UIScrollView alloc] initWithFrame:CGRectMake(12, 110, kWindowWidth-105, 25)];
    _tagBgView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_tagBgView];
    
    NSInteger i = 0;
    CGFloat offsetX = 0;
    for (NSString *tag in _userInfo.userTags) {
      
        CGFloat width = [tag sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0]}].width;
        UIButton *tagButton = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, 0, width+20, 25)];
        [tagButton setTitle:tag forState:UIControlStateNormal];
        [tagButton setTitleColor:COLOR_TEXT_II forState:UIControlStateNormal];
        tagButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        
        tagButton.layer.borderColor = COLOR_LINE.CGColor;
        tagButton.layer.borderWidth = 0.5;
        tagButton.layer.cornerRadius = 3.0;
        tagButton.clipsToBounds = YES;

        [tagButton addTarget:self action:@selector(tagButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_tagBgView addSubview:tagButton];
        i++;
        offsetX += (width+30);
    }
    _addTagButton.frame = CGRectMake(offsetX, 0, 40, 25);
    _addTagButton.layer.borderColor = COLOR_LINE.CGColor;
    _addTagButton.layer.borderWidth = 0.5;
    _addTagButton.layer.cornerRadius = 3.0;
    [_addTagButton setTitle:@"+" forState:UIControlStateNormal];
    [_addTagButton setTitleColor:COLOR_TEXT_II forState:UIControlStateNormal];
    [_addTagButton addTarget:self action:@selector(tagButtonAction) forControlEvents:UIControlEventTouchUpInside];

    [_tagBgView addSubview:_addTagButton];
    _tagBgView.contentSize = CGSizeMake(offsetX+50, 25);
    if (offsetX>_tagBgView.bounds.size.width) {
        [_tagBgView setContentOffset:CGPointMake(offsetX+25+15-_tagBgView.bounds.size.width, 0)];
    }
}

- (void)tagButtonAction
{
    if (_delegate) {
        [_delegate touchUserTag];
    }
}
@end






