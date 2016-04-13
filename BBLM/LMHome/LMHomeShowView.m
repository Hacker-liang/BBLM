//
//  LMHomeShowView.m
//  BBLM
//
//  Created by liangpengshuai on 4/13/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMHomeShowView.h"

@interface LMHomeShowView()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIButton *rankButton;
@property (nonatomic, strong) UIButton *playVideoButton;

@end

@implementation LMHomeShowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = COLOR_LINE.CGColor;
        self.layer.borderWidth = 0.5;
        CGFloat width = self.bounds.size.width;
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 35, 35)];
        [self addSubview:_headerImageView];
        _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) + 10, 8, width, 20)];
        _nicknameLabel.font = [UIFont systemFontOfSize:15.0];
        _nicknameLabel.textColor = COLOR_TEXT_I;
        [self addSubview:_nicknameLabel];
        
        _rankButton = [[UIButton alloc] init];
        [self addSubview:_rankButton];
    
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) + 10, 30, width, 20)];
        _dateLabel.font = [UIFont systemFontOfSize:13.0];
        _dateLabel.textColor = COLOR_TEXT_II;
        [self addSubview:_dateLabel];
        
        _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 56, width, 300)];
        _contentImageView.backgroundColor = APP_PAGE_COLOR;
        [self addSubview:_contentImageView];
        
        _playVideoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _playVideoButton.center = CGPointMake(_contentImageView.bounds.size.width/2, _contentImageView.bounds.size.height/2);
        [_playVideoButton setImage:[UIImage imageNamed:@"icon_playVideo"] forState:UIControlStateNormal];
        [_contentImageView addSubview:_playVideoButton];
    }
    return self;
}

- (void)setShowDetail:(LMShowDetailModel *)showDetail
{
    _showDetail = showDetail;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_showDetail.publishUser.s_avatar] placeholderImage:nil];
    [_contentImageView sd_setImageWithURL:[NSURL URLWithString:_showDetail.coverImage] placeholderImage:nil];
    _nicknameLabel.text = _showDetail.publishUser.nickName;
    _dateLabel.text = _showDetail.publishDateDesc;
    _playVideoButton.hidden = !_showDetail.isVideo;
}

@end
