//
//  LMHomeViewController.m
//  BBLM
//
//  Created by liangpengshuai on 4/13/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

#import "LMHomeViewController.h"
#import "constants.h"
#import "iCarousel.h"
#import "LMHomeShowView.h"
#import "LMShowDetailModel.h"
#import "AutoSlideScrollView.h"
#import "LMPushMessageViewController.h"
#import "LMShowDetailViewController.h"
#import "MineViewController.h"
#import "LMLoginViewController.h"
#import "LMShowManager.h"
#import "ShareActivity.h"

@interface LMHomeViewController () <iCarouselDataSource, iCarouselDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) iCarousel *carousel;

@property (nonatomic, strong) NSMutableArray<LMShowDetailModel *> *dataSource;
@property (nonatomic, strong) NSArray *adDataSource;  //头顶广告

@property (nonatomic, strong) UIImageView *galleryImageView;

@property (nonatomic, strong) AutoSlideScrollView *galleryView;
@property (nonatomic) NSInteger page;
@property (nonatomic) BOOL isLoading;
@property (nonatomic, strong) MPMoviePlayerController *playerController;


@end

@implementation LMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"芭比辣妈";

    self.automaticallyAdjustsScrollViewInsets = NO;
    _page = 1;
    _dataSource = [NSMutableArray array];
  
    _bgScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _bgScrollView.backgroundColor = APP_PAGE_COLOR;
    [self.view addSubview:_bgScrollView];
    
    if (kWindowHeight == 568) {
        _galleryView = [[AutoSlideScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 100) animationDuration:10];
    } else if (kWindowHeight == 480) {
        _galleryView = [[AutoSlideScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 80) animationDuration:10];
    } else {
        _galleryView = [[AutoSlideScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 120) animationDuration:10];
    }
    _galleryView.backgroundColor = [UIColor clearColor];
    [self.bgScrollView addSubview:_galleryView];
    
    CGFloat y = CGRectGetMaxY(_galleryView.frame)+10;
    _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, y, kWindowWidth, kWindowHeight-y-49)];
    _carousel.delegate = self;
    _carousel.dataSource = self;
    _carousel.type = iCarouselTypeRotary;
    [_bgScrollView addSubview:_carousel];
    
   
    
    UIButton *showPushMessageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [showPushMessageBtn setImage:[UIImage imageNamed:@"icon_pushMessage"] forState:UIControlStateNormal];
    [showPushMessageBtn addTarget:self action:@selector(gotoPushMessage:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:showPushMessageBtn];
    
    UIButton *showMineBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [showMineBtn setImage:[UIImage imageNamed:@"icon_home_mine"] forState:UIControlStateNormal];
    [showMineBtn addTarget:self action:@selector(gotoMine:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:showMineBtn];
    
    _isLoading = YES;
    [LMShowManager asyncLoadRecommendShowWithPage:_page pageSize:10 completionBlock:^(BOOL isSuccess, NSArray<LMShowDetailModel *> *showList) {
        _isLoading = NO;
        if (isSuccess) {
            [_dataSource addObjectsFromArray:showList];
            [_carousel reloadData];
        }
    }];
    [LMShowManager asyncLoadHomeAdWithCompletionBlock:^(BOOL isSuccess, NSArray<NSDictionary *> *adList) {
        if (isSuccess) {
            _adDataSource = adList;
            _galleryView.totalPagesCount = ^NSInteger(void){
                return adList.count;
            };
            
            NSMutableArray *viewsArray = [[NSMutableArray alloc] init];

            for (NSDictionary *dic in _adDataSource) {
                NSString *imageUrl = [dic objectForKey:@"imgUrl"];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"banner_default.png"]];
                [viewsArray addObject:imageView];
            }
            
            _galleryView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
                return viewsArray[pageIndex];
            };


        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_galleryView.scrollView setContentOffset:CGPointZero];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopPlayVideo];
}

- (UIImageView *)galleryImageView
{
    if (!_galleryImageView) {
        _galleryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 150)];
    }
    return _galleryImageView;
}

#pragma mark - 懒加载代码
- (MPMoviePlayerController *)playerController
{
    if (_playerController == nil) {
        _playerController = [[MPMoviePlayerController alloc] init];
        _playerController.movieSourceType = MPMovieSourceTypeUnknown;
    }
    return _playerController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showMoreAction:(UIButton *)sender
{
    LMShowDetailModel *show = [_dataSource objectAtIndex:sender.tag];
    NSString *colletcionStr = show.hasCollection ? @"取消收藏":@"收藏";
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:colletcionStr, @"分享", nil];
    sheet.tintColor = APP_THEME_COLOR;
    sheet.tag = sender.tag;
    [sheet showInView:self.view];
}

- (void)gotoPushMessage:(UIButton *)sender
{
    if (![[LMAccountManager shareInstance] isLogin]) {
        LMLoginViewController *ctl = [[LMLoginViewController alloc] initWithCompletionBlock:^(BOOL isLogin, NSString *errorStr) {
            if (isLogin) {
                LMPushMessageViewController *ctl = [[LMPushMessageViewController alloc] init];
                ctl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:ctl animated:YES];
            }
        }];
        [self presentViewController:ctl animated:YES completion:nil];
    } else {
        LMPushMessageViewController *ctl = [[LMPushMessageViewController alloc] init];
        ctl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctl animated:YES];

    }
}

- (void)playVideo:(UIButton *)sender
{
    [self stopPlayVideo];
    LMShowDetailModel *show = [_dataSource objectAtIndex:sender.tag];
    
    NSURL *url = [NSURL URLWithString:show.videoUrl];
    
    self.playerController.contentURL = url;
    
    LMHomeShowView *view = (LMHomeShowView *)[_carousel itemViewAtIndex: sender.tag];
//    CGPoint point = [view.contentImageView convertPoint:CGPointZero toView:self.view];
//    self.playerController.view.frame = CGRectMake(point.x, point.y, view.contentImageView.bounds.size.width, view.contentImageView.bounds.size.height);
    self.playerController.view.frame = view.contentImageView.bounds;
    [view.contentImageView addSubview:self.playerController.view];
    [self.playerController play];
}

- (void)stopPlayVideo
{
    if (self.playerController.view.superview) {
        [self.playerController.view removeFromSuperview];
        [self.playerController stop];
    }
}

- (void)gotoMine:(UIButton *)sender
{
    if (![[LMAccountManager shareInstance] isLogin]) {
        LMLoginViewController *ctl = [[LMLoginViewController alloc] initWithCompletionBlock:^(BOOL isLogin, NSString *errorStr) {
            if (isLogin) {
                MineViewController *ctl = [[MineViewController alloc] init];
                ctl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:ctl animated:YES];
            }
        }];
        [self presentViewController:ctl animated:YES completion:nil];
    } else {
        MineViewController *ctl = [[MineViewController alloc] init];
        ctl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }
    
}

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return (NSInteger)[self.dataSource count];
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        view = [[LMHomeShowView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth-40, carousel.bounds.size.height)];
        [((LMHomeShowView *)view).moreActionButton addTarget:self action:@selector(showMoreAction:) forControlEvents:UIControlEventTouchUpInside];
         [((LMHomeShowView *)view).playVideoButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    }
    ((LMHomeShowView *)view).showDetail = [_dataSource objectAtIndex:index];
    ((LMHomeShowView *)view).moreActionButton.tag = index;
     ((LMHomeShowView *)view).playVideoButton.tag = index;
    return view;
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel dataSourceTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * self.carousel.itemWidth);
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the dataSource views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

#pragma mark iCarousel taps

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    LMShowDetailViewController *ctl = [[LMShowDetailViewController alloc] init];
    ctl.hidesBottomBarWhenPushed = YES;
    ctl.showId = [_dataSource objectAtIndex:index].itemId;
    [self.navigationController pushViewController:ctl animated:YES];
    
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    if (self.carousel.currentItemIndex >= _dataSource.count-3 && !_isLoading) {
        
        [LMShowManager asyncLoadRecommendShowWithPage:_page pageSize:10 completionBlock:^(BOOL isSuccess, NSArray<LMShowDetailModel *> *showList) {
            _isLoading = NO;
            if (isSuccess) {
                [_dataSource addObjectsFromArray:showList];
                [_carousel reloadData];
            }
        }];
    }
    [self stopPlayVideo];
    NSLog(@"首页第 %ld", carousel.currentItemIndex);
    
}

#pragma mark - UIActionSheetDelegate

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    SEL selector = NSSelectorFromString(@"_alertController");
    if ([actionSheet respondsToSelector:selector])//ios8
    {
        UIAlertController *alertController = [actionSheet valueForKey:@"_alertController"];
        if ([alertController isKindOfClass:[UIAlertController class]])
        {
            alertController.view.tintColor = APP_THEME_COLOR;
        }
    } else { //ios7
        for( UIView * subView in actionSheet.subviews )
        {
            if( [subView isKindOfClass:[UIButton class]] )
            {
                UIButton * btn = (UIButton*)subView;
                [btn setTitleColor:APP_THEME_COLOR forState:UIControlStateNormal];
                [btn setTitleColor:APP_THEME_COLOR forState:UIControlStateHighlighted];
                
            }
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    LMShowDetailModel *show = [_dataSource objectAtIndex:actionSheet.tag];
    if (buttonIndex == 0) {
        if (![[LMAccountManager shareInstance] isLogin]) {
            LMLoginViewController *ctl = [[LMLoginViewController alloc] initWithCompletionBlock:^(BOOL isLogin, NSString *errorStr) {
                if (isLogin) {
                    
                } else {
                }
            }];
            [self presentViewController:ctl animated:YES completion:nil];
            
            return;
        }
        if (show.hasCollection) {
            [LMShowManager asyncCancelCollectionShowWithItemId:show.itemId completionBlock:^(BOOL isSuccess) {
                if (isSuccess) {
                    [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
                    show.hasCollection = NO;
                } else {
                    [SVProgressHUD showErrorWithStatus:@"取消收藏失败"];
                }
            }];
        } else {
            [LMShowManager asyncCollectionShowWithItemId:show.itemId completionBlock:^(BOOL isSuccess) {
                if (isSuccess) {
                    [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                    show.hasCollection = YES;
                } else {
                    [SVProgressHUD showErrorWithStatus:@"收藏失败"];
                }
            }];
        }
    } else if (buttonIndex == 1) {
        NSString *content;
        if (show.isVideo) {
            content = [NSString stringWithFormat:@"我分享了一张\"%@\"的短视频，速来围观", show.publishUser.nickname];
        } else {
            content = [NSString stringWithFormat:@"我分享了一张\"%@\"的照片，速来围观", show.publishUser.nickname];
            
        }
        ShareActivity *shareView = [[ShareActivity alloc] initWithShareTitle:@"芭比辣妈,看全球辣妈的分享" andShareContent:content shareUrl:@"www.baidu.com" shareImage:nil shareImageUrl:show.coverImage];
        [shareView showInViewController:self];
    }
}

@end
