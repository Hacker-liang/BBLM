//
//  LMShowDetailView.m
//  BBLM
//
//  Created by liangpengshuai on 4/13/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMShowDetailView.h"
#import "LMUserProfileViewController.h"
#import "LMShowManager.h"
#import "AutoSlideScrollView.h"

@interface LMShowDetailView()

@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) NSArray<LMUserDetailModel *> *zanUserList;

@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIView *zanUserBgView;
@property (nonatomic, strong) AutoSlideScrollView *galleryView;


@end

@implementation LMShowDetailView

+ (CGFloat)heithWithShowDetail:(LMShowDetailModel *)show
{
    if ([show.showDesc stringByReplacingOccurrencesOfString:@" " withString:@""].length>0) {
        NSAttributedString *attrstr = [[NSAttributedString alloc] initWithString:show.showDesc attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
        CGRect rect = [attrstr boundingRectWithSize:(CGSize){kWindowWidth-24, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        return 450+rect.size.height-20;
    } else {
        return 430;
    }
   

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = COLOR_LINE.CGColor;
        self.layer.borderWidth = 0.5;
        CGFloat width = self.bounds.size.width;
        _headerImageButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 8, 35, 35)];
        [self addSubview:_headerImageButton];
        _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageButton.frame) + 10, 8, width, 20)];
        _nicknameLabel.font = [UIFont systemFontOfSize:15.0];
        _nicknameLabel.textColor = COLOR_TEXT_I;
        [self addSubview:_nicknameLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageButton.frame) + 10, 30, width, 20)];
        _dateLabel.font = [UIFont systemFontOfSize:13.0];
        _dateLabel.textColor = COLOR_TEXT_II;
        [self addSubview:_dateLabel];
        
        _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 56, width, 300)];
        _contentImageView.backgroundColor = APP_PAGE_COLOR;
        _contentImageView.userInteractionEnabled = YES;
        _contentImageView.clipsToBounds = YES;
        [self addSubview:_contentImageView];
        
        _galleryView = [[AutoSlideScrollView alloc] initWithFrame:CGRectMake(0, 56, width, 300)];
        _galleryView.backgroundColor = APP_PAGE_COLOR;
        [self addSubview:_galleryView];
        _galleryView.showPageControl = YES;
        _galleryView.hidden = YES;
        
        
        _playVideoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _playVideoButton.center = CGPointMake(_contentImageView.bounds.size.width/2, _contentImageView.bounds.size.height/2);
        [_playVideoButton setImage:[UIImage imageNamed:@"icon_playVideo"] forState:UIControlStateNormal];
        [_contentImageView addSubview:_playVideoButton];
        
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 300+60, kWindowWidth-24, frame.size.height-CGRectGetMaxY(_contentImageView.frame)-50)];
        _descLabel.textColor = COLOR_TEXT_I;
        _descLabel.numberOfLines = 0;
        _descLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:_descLabel];
        
        _zanButton = [[UIButton alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(_descLabel.frame)+5, 60, 35)];
        [_zanButton setImage:[UIImage imageNamed:@"icon_showDetail_zan_normal"] forState:UIControlStateNormal];
        [_zanButton setImage:[UIImage imageNamed:@"icon_showDetail_zan_selected"] forState:UIControlStateSelected];
        [self addSubview:_zanButton];
        
        _zanUserBgView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_zanButton.frame)+10, _zanButton.frame.origin.y, kWindowWidth-120, 35)];
        [self addSubview:_zanUserBgView];
        
        _moreActionButton = [[UIButton alloc] initWithFrame:CGRectMake(kWindowWidth-50,_zanButton.frame.origin.y, 50, 35)];
        [_moreActionButton setImage:[UIImage imageNamed:@"icon_showList_more"] forState:UIControlStateNormal];
        [self addSubview:_moreActionButton];
        
        _zanUserCntButton = [[UIButton alloc] init];
    }
    return self;
}

- (void)setShowDetail:(LMShowDetailModel *)showDetail
{
    _showDetail = showDetail;
    _zanUserList = _showDetail.zanUserList;
    [_headerImageButton sd_setImageWithURL:[NSURL URLWithString:_showDetail.publishUser.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    if (_showDetail.isVideo) {
        [_contentImageView sd_setImageWithURL:[NSURL URLWithString:_showDetail.coverImage] placeholderImage:nil];
        _contentImageView.hidden = NO;
        _galleryView.hidden = YES;
        
    } else {
        _contentImageView.hidden = YES;
        _galleryView.hidden = NO;
        _galleryView.totalPagesCount = ^NSInteger(void){
            return showDetail.imageList.count;
        };
        
        NSMutableArray *viewsArray = [[NSMutableArray alloc] init];
        for (NSString *image in showDetail.imageList) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.galleryView.bounds.size.width, self.galleryView.bounds.size.height)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.clipsToBounds = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage: nil];
            [viewsArray addObject:imageView];
        }
        
        _galleryView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            return viewsArray[pageIndex];
        };
        _galleryView.TapActionBlock = ^(NSInteger pageIndex) {
            
        };

    }
    
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
    _descLabel.text = _showDetail.showDesc;
    _zanButton.selected = _showDetail.hasZan;
    
    for (UIView *userButton in _zanUserBgView.subviews) {
        [userButton removeFromSuperview];
    }
    CGFloat offsetX = 0;
    NSInteger count = 0;
    for (int i=0; i<_zanUserList.count; i++) {
        if (_zanUserBgView.bounds.size.width-offsetX < 100) {
            break;
        }
        UIButton *zanUserButton = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, 0, 35, 35)];
        zanUserButton.layer.cornerRadius = 2.0;
        zanUserButton.clipsToBounds = YES;
        [zanUserButton sd_setImageWithURL:[NSURL URLWithString:[_zanUserList objectAtIndex:i].avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar_default"]];
        zanUserButton.tag = i;
        [zanUserButton addTarget:self action:@selector(showUserProfile:) forControlEvents:UIControlEventTouchUpInside];
        [_zanUserBgView addSubview:zanUserButton];
        offsetX += 40;
        count = i+1;
    }
    if (_zanUserList.count > count) {
        _zanUserCntButton.frame = CGRectMake(offsetX+5, 5, 35, 25);
        _zanUserCntButton.layer.cornerRadius = 2.0;
        _zanUserCntButton.clipsToBounds = YES;
        [_zanUserCntButton setTitle:[NSString stringWithFormat:@"%ld", _zanUserList.count] forState:UIControlStateNormal];
        _zanUserCntButton.backgroundColor = [UIColor lightGrayColor];
        _zanUserCntButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_zanUserCntButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_zanUserBgView addSubview:_zanUserCntButton];
    }
}

- (void)showUserProfile:(UIButton *)sender
{
    LMUserProfileViewController *ctl = [[LMUserProfileViewController alloc] init];
    ctl.userId = [_zanUserList objectAtIndex:sender.tag].userId;
    [self.containerCtl.navigationController pushViewController:ctl animated:YES];
}



@end
