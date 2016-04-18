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
#import "MineViewController.h"

@interface LMRootViewController () <LMTabBarDelegate, QupaiSDKDelegate>

@property (nonatomic, strong) UIView *publishBgView;
@property (nonatomic, strong) UIView *publishContentView;
@property (nonatomic, strong) id <ALBBQuPaiService> qupaiSDK;

@end

@implementation LMRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LMTabBar *tabBar = [[LMTabBar alloc] init];
    tabBar.myDelegate = self;
    [self setValue:tabBar forKey:@"tabBar"];
    
    [self addChildVc:[[LMHomeViewController alloc] init] title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    [self addChildVc:[[MineViewController alloc] init] title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];

}

- (id <ALBBQuPaiService>)qupaiSDK
{
    if (!_qupaiSDK) {
       _qupaiSDK  = [[ALBBSDK sharedInstance] getService:@protocol(ALBBQuPaiService)];
        [_qupaiSDK setDelegte:self];
    }
    return _qupaiSDK;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字(可以设置tabBar和navigationBar的文字)
    childVc.title = title;
    
    // 设置子控制器的tabBarItem图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
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
    
}

- (void)publishVideo
{
    UIViewController *ctl = [_qupaiSDK createRecordViewControllerWithMinDuration:10 maxDuration:60 bitRate:600*1200];
    [self presentViewController:ctl animated:YES completion:^{
        
    }];
}

#pragma LMTabBarDelegate
/**
 *  加号按钮点击
 */
- (void)tabBarDidClickPlusButton:(LMTabBar *)tabBar
{
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
    title1.text = @"视频";
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
}








@end




