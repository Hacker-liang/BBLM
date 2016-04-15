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

@interface LMHomeViewController () <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) iCarousel *carousel;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIImageView *galleryImageView;

@property (nonatomic, strong) AutoSlideScrollView *galleryView;


@end

@implementation LMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [NSMutableArray array];
    for (int i = 0; i < 10; i++)
    {
        [_dataSource addObject:[[LMShowDetailModel alloc] init]];
    }
    _bgScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _bgScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgScrollView];
    _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 130, kWindowWidth, kWindowHeight-130)];
    _carousel.delegate = self;
    _carousel.dataSource = self;
    _carousel.type = iCarouselTypeRotary;
    [_bgScrollView addSubview:_carousel];
    
    _galleryView = [[AutoSlideScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 130-64) animationDuration:10];
    [self.bgScrollView addSubview:_galleryView];
    _galleryView.totalPagesCount = ^NSInteger(void){
        return 4;
    };
    __weak typeof(self)weakSelf = self;

    _galleryView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, weakSelf.galleryView.bounds.size.width, weakSelf.galleryView.bounds.size.width)];
    };
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_pushMessage"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoPushMessage:)];
    
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

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return (NSInteger)[self.dataSource count];
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        view = [[LMHomeShowView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth-60, carousel.bounds.size.height)];
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
    NSNumber *dataSource = (self.dataSource)[(NSUInteger)index];
    NSLog(@"Tapped view number: %@", dataSource);
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    NSLog(@"Index: %@", @(self.carousel.currentItemIndex));
}
@end
