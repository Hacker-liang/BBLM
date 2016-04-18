//
//  LMUserPorfileHeaderView.m
//  BBLM
//
//  Created by liangpengshuai on 4/18/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMUserPorfileHeaderView.h"
#import "TEAChart.h"

@interface LMUserPorfileHeaderView ()

@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UIButton *rankButton;
@property (nonatomic, strong) UILabel *rankingLabel;
@property (nonatomic, strong) UIButton *floowButton;

@property (nonatomic, strong) UILabel *publishCntLabel;
@property (nonatomic, strong) UILabel *followerCntLabel;
@property (nonatomic, strong) UILabel *shareCntLabel;

@property (nonatomic, strong) UIScrollView *tagBgView;
@property (nonatomic, strong) UIView *conentBgView;

@end

@implementation LMUserPorfileHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = APP_PAGE_COLOR;
        
        UIView *naviBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowWidth, 64)];
        naviBar.backgroundColor = APP_THEME_COLOR;
        [self addSubview:naviBar];
        
        UIView *rankingBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth,210)];
        rankingBgView.backgroundColor = APP_THEME_COLOR;
        [self addSubview:rankingBgView];

        TEABarChart *secondBarChart = [[TEABarChart alloc] initWithFrame:CGRectMake(40, 10, kWindowWidth-80, 165)];
        secondBarChart.barColor = [UIColor whiteColor];
        secondBarChart.backgroundColor = [UIColor clearColor];
        secondBarChart.barSpacing = (kWindowWidth-80-12*7)/6;
        secondBarChart.data = @[@2, @7, @1, @8, @2, @8, @8];
        secondBarChart.xLabels = @[@"一", @"二", @"三", @"四", @"五", @"六", @"日"];
        secondBarChart.textColor = [UIColor whiteColor];
        secondBarChart.cornerRadius = 5;
        [rankingBgView addSubview:secondBarChart];
    
        _rankingLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 190, kWindowWidth-24, 20)];
        _rankingLabel.textAlignment = NSTextAlignmentRight;
        _rankingLabel.textColor = [UIColor whiteColor];
        _rankingLabel.font = [UIFont systemFontOfSize:13.0];
        _rankingLabel.text = @"本周您的辣妈排榜在第25名";
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
        _publishCntLabel.text = @"58";
        _publishCntLabel.textAlignment = NSTextAlignmentCenter;
        _publishCntLabel.textColor = APP_THEME_COLOR;
        [_conentBgView addSubview:_publishCntLabel];
        
        _followerCntLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 50, 40, 20)];
        _followerCntLabel.font = [UIFont systemFontOfSize:16.0];
        _followerCntLabel.text = @"58";
        _followerCntLabel.textAlignment = NSTextAlignmentCenter;
        _followerCntLabel.textColor = APP_THEME_COLOR;
        [_conentBgView addSubview:_followerCntLabel];
        
        _shareCntLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 50, 40, 20)];
        _shareCntLabel.font = [UIFont systemFontOfSize:16.0];
        _shareCntLabel.text = @"58";
        _shareCntLabel.textAlignment = NSTextAlignmentCenter;
        _shareCntLabel.textColor = APP_THEME_COLOR;
        [_conentBgView addSubview:_shareCntLabel];

        
        _rankButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 83, 65, 17)];
        [_rankButton setTitleColor:APP_THEME_COLOR forState:UIControlStateNormal];
        _rankButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_rankButton setImage:[UIImage imageNamed:@"icon_mine_rank.png"] forState:UIControlStateNormal];
        _rankButton.userInteractionEnabled = NO;
        [_rankButton setTitle:@"121" forState:UIControlStateNormal];
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
        [_floowButton setBackgroundImage:[ConvertMethods createImageWithColor:APP_THEME_COLOR] forState:UIControlStateNormal];
        [_floowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_conentBgView addSubview:_floowButton];
        
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
    [_conentBgView addSubview:_tagBgView];
    
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
    _tagBgView.contentSize = CGSizeMake(offsetX, 25);
}


@end
