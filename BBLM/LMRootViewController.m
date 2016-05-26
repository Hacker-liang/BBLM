//
//  LMRootViewController.m
//  BBLM
//
//  Created by liangpengshuai on 4/13/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <ALBBSDK/ALBBSDK.h>
#import <ALBBQuPai/ALBBQuPaiService.h>
#import <ALBBQuPai/QPEffectMusic.h>

#import "LMRootViewController.h"
#import "LMTabBar.h"
#import "LMHomeViewController.h"
#import "LMHotShowListViewController.h"
#import "UserAlbumOverViewTableViewController.h"
#import "UploadUserAlbumViewController.h"
#import "LMLoginViewController.h"
#import "UploadUserVideoViewController.h"
#import "AutoSlideScrollView.h"

@interface LMRootViewController () <LMTabBarDelegate, QupaiSDKDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIView *publishBgView;
@property (nonatomic, strong) UIView *publishContentView;
@property (nonatomic, strong) id <ALBBQuPaiService> qupaiSDK;

@property (nonatomic, strong) LMHomeViewController *homeCtl;
@property (nonatomic, strong) LMHotShowListViewController *hotShowListCtl;

@property (nonatomic, strong) UIScrollView *introView;
@property (nonatomic, strong) UIPageControl *pageControl;


@property (nonatomic, strong) UIImageView *splashImageView;  //闪屏页面


@end

@implementation LMRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LMTabBar *tabBar = [[LMTabBar alloc] init];
    tabBar.myDelegate = self;
    [self setValue:tabBar forKey:@"tabBar"];
    
    _homeCtl = [[LMHomeViewController alloc] init];
    _hotShowListCtl = [[LMHotShowListViewController alloc] init];
    [self addChildVc:_homeCtl title:nil image:@"icon_tabbar_home_normal" selectedImage:@"icon_tabbar_home_selected"];
    [self addChildVc:_hotShowListCtl title:nil image:@"icon_tabbar_hot_normal" selectedImage:@"icon_tabbar_hot_selected"];

    [self setupConverView];
    [self.qupaiSDK setDelegte:self];
    
}

- (id <ALBBQuPaiService>)qupaiSDK
{
    if (!_qupaiSDK) {
       _qupaiSDK  = [[ALBBSDK sharedInstance] getService:@protocol(ALBBQuPaiService)];
        _qupaiSDK.enableMoreMusic = NO;
    }
    return _qupaiSDK;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupConverView
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDic objectForKey:@"CFBundleShortVersionString"];
    BOOL shouldSkipLoadIntro = [[[NSUserDefaults standardUserDefaults] objectForKey:version] boolValue];
    if (!shouldSkipLoadIntro) {
        [self setupSplashImage];
        [self performSelector:@selector(dismissSplashImage) withObject:nil afterDelay:2];
        [self performSelector:@selector(beginIntroduce) withObject:nil afterDelay:2];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:version];
        
    } else {
        [self setupSplashImage];
        [self performSelector:@selector(dismissSplashImage) withObject:nil afterDelay:2];
    }
}

- (void)setupSplashImage
{
    _splashImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_splashImageView];
    NSString *imageName;
    
    NSLog(@"%lf", self.view.frame.size.height);
    if (self.view.frame.size.height == 480) {
        imageName =  @"icon_splashImage_4.png";
    } else if (self.view.frame.size.height == 667) {
        imageName = @"icon_splashImage_6.png";
    }
    else {
        imageName = @"icon_splashImage_6p.png";
    }
    _splashImageView.image = [UIImage imageNamed:imageName];
}

- (void)dismissSplashImage
{
    [UIView animateWithDuration:0.3 animations:^{
        _splashImageView.alpha = 0;
    } completion:^(BOOL finished) {
        [_splashImageView removeFromSuperview];
    }];
}

#pragma mark - help

- (void)beginIntroduce
{
    _introView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _introView.backgroundColor = [UIColor whiteColor];
    _introView.delegate = self;
    [self.view addSubview:_introView];

    NSMutableArray *viewsArray = [[NSMutableArray alloc] init];
    {
        NSString *imageName;
        
        NSLog(@"%lf", self.view.frame.size.height);
        if (self.view.frame.size.height == 480) {
            imageName =  @"introduce_4_1.png";
        } else if (self.view.frame.size.height == 667) {
            imageName = @"introduce_6_1.png";
        }
        else {
            imageName = @"introduce_6p_1.png";
        }
        UIImageView *image = [[UIImageView alloc] initWithFrame:self.view.bounds];
        image.image = [UIImage imageNamed:imageName];
        [viewsArray addObject:image];
    }
    {
        NSString *imageName;
        if (self.view.frame.size.height == 480) {
            imageName =  @"introduce_4_2.png";
        } else if (self.view.frame.size.height == 667) {
            imageName = @"introduce_6_2.png";
        }
        else {
            imageName = @"introduce_6p_2.png";
        }
        UIImageView *image = [[UIImageView alloc] initWithFrame:self.view.bounds];
        image.image = [UIImage imageNamed:imageName];
        [viewsArray addObject:image];
    }
    {
        NSString *imageName;
        if (self.view.frame.size.height == 480) {
            imageName =  @"introduce_4_3.png";
        } else if (self.view.frame.size.height == 667) {
            imageName = @"introduce_6_3.png";
        }
        else {
            imageName = @"introduce_6p_3.png";
        }
        UIImageView *image = [[UIImageView alloc] initWithFrame:self.view.bounds];
        image.image = [UIImage imageNamed:imageName];
        [viewsArray addObject:image];
    }
    {
        NSString *imageName;
        if (self.view.frame.size.height == 480) {
            imageName =  @"introduce_4_4.png";
        } else if (self.view.frame.size.height == 667) {
            imageName = @"introduce_6_4.png";
        }
        else {
            imageName = @"introduce_6p_4.png";
        }
        UIImageView *image = [[UIImageView alloc] initWithFrame:self.view.bounds];
        image.image = [UIImage imageNamed:imageName];
        [viewsArray addObject:image];
        UIButton *skipButton = [[UIButton alloc] initWithFrame:CGRectMake(12, image.bounds.size.height-70, image.bounds.size.width-24, 40)];
        [skipButton addTarget:self action:@selector(skipIntro) forControlEvents:UIControlEventTouchUpInside];
        [skipButton setImage:[UIImage imageNamed:@"icon_intro_skip.png"] forState:UIControlStateNormal];
        image.userInteractionEnabled = YES;
        [image addSubview:skipButton];
    }
    _introView.contentSize = CGSizeMake(viewsArray.count*self.view.bounds.size.width, self.view.bounds.size.height);
    _introView.pagingEnabled = YES;
    _introView.showsHorizontalScrollIndicator = NO;
    NSInteger index = 0;
    for (UIView *view in viewsArray) {
        view.frame = CGRectMake(index*self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        [_introView addSubview:view];
        index++;
    }
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((kWindowWidth-80)/2, kWindowHeight-40, 80, 20)];
    _pageControl.numberOfPages = viewsArray.count;
    _pageControl.pageIndicatorTintColor = APP_THEME_COLOR;
    [self.view addSubview:_pageControl];
}

- (void)skipIntro
{
    if (_introView) {
        [_introView removeFromSuperview];
        _introView = nil;
        [_pageControl removeFromSuperview];
        _pageControl = nil;
    }
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字(可以设置tabBar和navigationBar的文字)
    childVc.title = title;
    
    // 设置子控制器的tabBarItem图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    // 禁用图片渲染
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 为子控制器包装导航控制器
    TZNavigationViewController *navigationVc = [[TZNavigationViewController alloc] initWithRootViewController:childVc];
    // 添加子控制器
    [self addChildViewController:navigationVc];
}

- (void)closePublishView
{
    if (_publishBgView) {
        [_publishBgView removeFromSuperview];
        _publishBgView = nil;
        _publishContentView = nil;
    }
}

- (void)publishImage
{
    [self closePublishView];
    UploadUserAlbumViewController *ctl = [[UploadUserAlbumViewController alloc] init];
    ctl.selectedPhotos = [[NSMutableArray alloc] init];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:ctl] animated:YES completion:nil];
}

- (void)publishVideo
{
    [self closePublishView];
    UIViewController *ctl = [self.qupaiSDK createRecordViewControllerWithMinDuration:3 maxDuration:300 bitRate:800*600];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:ctl];
    navigation.navigationBarHidden = YES;
    
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
}

#pragma LMTabBarDelegate
/**
 *  加号按钮点击
 */
- (void)tabBarDidClickPlusButton:(LMTabBar *)tabBar
{
    if (![[LMAccountManager shareInstance] isLogin]) {
        LMLoginViewController *ctl = [[LMLoginViewController alloc] initWithCompletionBlock:^(BOOL isLogin, NSString *errorStr) {
            if (isLogin) {
               
            }
        }];
        [self presentViewController:ctl animated:YES completion:nil];
        return;
    }
    if (_publishBgView) {
        [_publishBgView removeFromSuperview];
        _publishBgView = nil;
    }
    _publishBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
    _publishBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self.view addSubview:_publishBgView];
    
    _publishContentView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight, kWindowWidth, 240)];
    _publishContentView.backgroundColor = [UIColor whiteColor];
    [_publishBgView addSubview:_publishContentView];
    
    UIButton *dismissButton = [[UIButton alloc] initWithFrame:CGRectMake((kWindowWidth-60)/2, 180, 60, 60)];
    [dismissButton setImage:[UIImage imageNamed:@"icon_home_publish_close"] forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(closePublishView) forControlEvents:UIControlEventTouchUpInside];
    [_publishContentView addSubview:dismissButton];
    
    CGFloat space = (kWindowWidth-120)/4;
    UIButton *pictureButton = [[UIButton alloc] initWithFrame:CGRectMake(space, 60, 60, 60)];
    [pictureButton setImage:[UIImage imageNamed:@"icon_home_publish_image"] forState:UIControlStateNormal];
    [pictureButton addTarget:self action:@selector(publishImage) forControlEvents:UIControlEventTouchUpInside];
    [_publishContentView addSubview:pictureButton];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(space, 120, 60, 60)];
    title.text = @"图片";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:16];
    title.textColor = COLOR_TEXT_I;
    [_publishContentView addSubview:title];
    
    UIButton *videoButton = [[UIButton alloc] initWithFrame:CGRectMake(space*3+60, 60, 60, 60)];
    [videoButton setImage:[UIImage imageNamed:@"icon_home_publish_video"] forState:UIControlStateNormal];
    [videoButton addTarget:self action:@selector(publishVideo) forControlEvents:UIControlEventTouchUpInside];
    [_publishContentView addSubview:videoButton];
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(space*3+60, 120, 60, 60)];
    title1.text = @"小视频";
    title1.textAlignment = NSTextAlignmentCenter;
    title1.font = [UIFont systemFontOfSize:16];
    title1.textColor = COLOR_TEXT_I;
    [_publishContentView addSubview:title1];
    
    [UIView animateWithDuration:0.2 animations:^{
        _publishContentView.frame = CGRectMake(0, kWindowHeight-240, kWindowWidth, 240);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - QupaiSDKDelegate

- (void)qupaiSDK:(id<ALBBQuPaiService>)sdk compeleteVideoPath:(NSString *)videoPath thumbnailPath:(NSString *)thumbnailPath
{
    NSLog(@"Qupai SDK compelete %@",videoPath);
    [self dismissViewControllerAnimated:YES completion:nil];
    if (videoPath.length > 0) {
        UploadUserVideoViewController *ctl = [[UploadUserVideoViewController alloc] init];
        ctl.selectedVideoPath = videoPath;
        ctl.selectedVideoCoverPath = thumbnailPath;
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:ctl] animated:YES completion:nil];

    }
   
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item;
{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (index == 0) {
        if (_hotShowListCtl) {
            [_hotShowListCtl stopPlayVideo];
        }
    }
    if (index == 1) {
        if (_homeCtl) {
            [_homeCtl stopPlayVideo];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger pageIndx = scrollView.contentOffset.x/scrollView.bounds.size.width;
    _pageControl.currentPage = pageIndx;
}

@end




