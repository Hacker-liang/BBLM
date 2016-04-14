//
//  MineHeaderView.m
//  BBLM
//
//  Created by liangpengshuai on 4/14/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "MineHeaderView.h"

@interface MineHeaderView ()

@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UIButton *rankButton;

@property (nonatomic, strong) UILabel *publishCntLabel;
@property (nonatomic, strong) UILabel *followerCntLabel;
@property (nonatomic, strong) UIScrollView *tagBgView;


@property (nonatomic, strong) LMUserDetailModel *userInfo;


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
        
        UILabel *tempLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(170, 20, 40, 20)];
        tempLabel2.font = [UIFont systemFontOfSize:17.0];
        tempLabel2.text = @"粉丝";
        tempLabel2.textAlignment = NSTextAlignmentCenter;
        tempLabel2.textColor = COLOR_TEXT_II;
        [self addSubview:tempLabel2];
        
        _publishCntLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 40, 20)];
        _publishCntLabel.font = [UIFont systemFontOfSize:16.0];
        _publishCntLabel.text = @"58";
        _publishCntLabel.textAlignment = NSTextAlignmentCenter;
        _publishCntLabel.textColor = APP_THEME_COLOR;
        [self addSubview:_publishCntLabel];
        
        _followerCntLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 50, 40, 20)];
        _followerCntLabel.font = [UIFont systemFontOfSize:16.0];
        _followerCntLabel.text = @"58";
        _followerCntLabel.textAlignment = NSTextAlignmentCenter;
        _followerCntLabel.textColor = APP_THEME_COLOR;
        [self addSubview:_followerCntLabel];
        
        _rankButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 83, 65, 17)];
        [_rankButton setTitleColor:APP_THEME_COLOR forState:UIControlStateNormal];
        _rankButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_rankButton setImage:[UIImage imageNamed:@"icon_mine_rank.png"] forState:UIControlStateNormal];
        _rankButton.userInteractionEnabled = NO;
        [_rankButton setTitle:@"121" forState:UIControlStateNormal];
        [_rankButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [_rankButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [self addSubview:_rankButton];
        
        UIView *buttomSpaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 140, kWindowWidth, 0.5)];
        buttomSpaceView.backgroundColor = COLOR_LINE;
        [self addSubview:buttomSpaceView];
        
        UIButton *editUserInfoButton = [[UIButton alloc] initWithFrame:CGRectMake(kWindowWidth-80, 110, 70, 25)];
        editUserInfoButton.clipsToBounds = YES;
        editUserInfoButton.layer.cornerRadius = 3.0;
        editUserInfoButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [editUserInfoButton setTitle:@"编辑资料" forState:UIControlStateNormal];
        [editUserInfoButton setBackgroundImage:[ConvertMethods createImageWithColor:APP_THEME_COLOR] forState:UIControlStateNormal];
        [editUserInfoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:editUserInfoButton];

        self.userInfo = [[LMUserDetailModel alloc] init];
        
    }
    return self;
}

- (void)setUserInfo:(LMUserDetailModel *)userInfo
{
    _userInfo = userInfo;
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
        if (i>2) {
            break;
        }
        
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
    UIButton *addTagButton = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, 0, 40, 25)];
    addTagButton.layer.borderColor = COLOR_LINE.CGColor;
    addTagButton.layer.borderWidth = 0.5;
    addTagButton.layer.cornerRadius = 3.0;
    [addTagButton setTitle:@"+" forState:UIControlStateNormal];
    [addTagButton setTitleColor:COLOR_TEXT_II forState:UIControlStateNormal];
    [_tagBgView addSubview:addTagButton];
    _tagBgView.contentSize = CGSizeMake(offsetX+50, 25);
}

@end






