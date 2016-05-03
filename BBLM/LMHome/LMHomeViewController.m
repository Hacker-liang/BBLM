//
//  LMHomeViewController.m
//  BBLM
//
//  Created by liangpengshuai on 4/13/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

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

@interface LMHomeViewController () <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) iCarousel *carousel;

@property (nonatomic, strong) NSMutableArray<LMShowDetailModel *> *dataSource;
@property (nonatomic, strong) NSArray *adDataSource;  //头顶广告

@property (nonatomic, strong) UIImageView *galleryImageView;

@property (nonatomic, strong) AutoSlideScrollView *galleryView;
@property (nonatomic) NSInteger page;
@property (nonatomic) BOOL isLoading;

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
    _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 200, kWindowWidth, kWindowHeight-200)];
    _carousel.delegate = self;
    _carousel.dataSource = self;
    _carousel.type = iCarouselTypeRotary;
    [_bgScrollView addSubview:_carousel];
    
    _galleryView = [[AutoSlideScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 120) animationDuration:10];
    _galleryView.backgroundColor = [UIColor clearColor];
    [self.bgScrollView addSubview:_galleryView];
    
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


- (UIImageView *)galleryImageView
{
    if (!_galleryImageView) {
        _galleryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 150)];
    }
    return _galleryImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)gotoPushMessage:(UIButton *)sender
{
    LMPushMessageViewController *ctl = [[LMPushMessageViewController alloc] init];
    ctl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctl animated:YES];
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
    }
    ((LMHomeShowView *)view).showDetail = [_dataSource objectAtIndex:index];
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
    NSLog(@"首页第 %ld", carousel.currentItemIndex);
    
}
@end
