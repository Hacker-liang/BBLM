//
//  LMCommentsTableViewCell.m
//  BBLM
//
//  Created by liangpengshuai on 4/21/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMCommentsTableViewCell.h"

@interface LMCommentsTableViewCell ()

@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *contentBgView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation LMCommentsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self firstRender];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self firstRender];
    }
    return self;
}

- (void)firstRender
{
    self.backgroundColor = APP_PAGE_COLOR;
    _nicknameLabel = [[UILabel alloc] init];
    _nicknameLabel.textColor = COLOR_TEXT_II;
    _nicknameLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:_nicknameLabel];
    _avatarImageView = [[UIImageView alloc] init];
    _avatarImageView.layer.cornerRadius = 3.0;
    _avatarImageView.clipsToBounds = YES;
    _avatarImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_avatarImageView];
    
    _contentBgView = [[UIImageView alloc] init];
    [self addSubview:_contentBgView];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:15.0];
    [_contentBgView addSubview:_contentLabel];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.textColor = COLOR_TEXT_III;
    _dateLabel.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:_dateLabel];
}

- (void)setCommentDetail:(LMShowCommentDetail *)commentDetail
{
    _commentDetail = commentDetail;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_commentDetail.user.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    _nicknameLabel.text = _commentDetail.user.nickname;
    _contentLabel.text = _commentDetail.content;
    _dateLabel.text = _commentDetail.publishDateDesc;

    [self layoutIfNeeded];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
   
    BOOL isMine = _commentDetail.isMine;
    if (!isMine) {
        _contentLabel.textColor = COLOR_TEXT_I;
        _avatarImageView.frame = CGRectMake(12, 10, 35, 35);
        _nicknameLabel.frame = CGRectMake(CGRectGetMaxX(_avatarImageView.frame)+8, 10, kWindowWidth-150, 18);
        _nicknameLabel.textAlignment = NSTextAlignmentLeft;
        _dateLabel.frame = CGRectMake(kWindowWidth-90, 10, 80, 18);
        _dateLabel.textAlignment = NSTextAlignmentRight;
        if (_commentDetail.content) {
            CGFloat maxWidth = kWindowWidth-70-80;
            NSAttributedString *attrstr = [[NSAttributedString alloc] initWithString:_commentDetail.content attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
            CGRect rect = [attrstr boundingRectWithSize:(CGSize){maxWidth, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            _contentLabel.frame = CGRectMake(20, 10, rect.size.width, rect.size.height);
            _contentBgView.frame = CGRectMake(_nicknameLabel.frame.origin.x, 30, rect.size.width+35, rect.size.height+20);
            _contentBgView.image = [[UIImage imageNamed:@"icon_comments_bg_other"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 20)];
        }
    } else {
        _contentLabel.textColor = [UIColor whiteColor];
        _avatarImageView.frame = CGRectMake(kWindowWidth-12-35, 10, 35, 35);
        _nicknameLabel.frame = CGRectMake(80, 10, kWindowWidth-90-35-20, 18);
        _nicknameLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.frame = CGRectMake(12, 10, 80, 18);
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        if (_commentDetail.content) {
            CGFloat maxWidth = kWindowWidth-70-80;
            NSAttributedString *attrstr = [[NSAttributedString alloc] initWithString:_commentDetail.content attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
            CGRect rect = [attrstr boundingRectWithSize:(CGSize){maxWidth, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            _contentLabel.frame = CGRectMake(15, 10, rect.size.width, rect.size.height);
            _contentBgView.frame = CGRectMake(kWindowWidth-rect.size.width-35-20-35, 30, rect.size.width+35, rect.size.height+20);
            _contentBgView.image = [[UIImage imageNamed:@"icon_comments_bg_mine"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 20)];
        }
    }
}

+ (CGFloat)heightWithCommentDetail:(LMShowCommentDetail *)commentDetail
{
    CGFloat maxWidth = kWindowWidth-70-80;
    NSAttributedString *attrstr = [[NSAttributedString alloc] initWithString:commentDetail.content attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
    CGRect rect = [attrstr boundingRectWithSize:(CGSize){maxWidth, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return rect.size.height+65;
}














@end
