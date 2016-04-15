//
//  LMRootViewController.m
//  BBLM
//
//  Created by liangpengshuai on 4/13/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMRootViewController.h"
#import "LMTabBar.h"
#import "LMHomeViewController.h"
#import "MineViewController.h"

@interface LMRootViewController () <LMTabBarDelegate>

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

#pragma LMTabBarDelegate
/**
 *  加号按钮点击
 */
- (void)tabBarDidClickPlusButton:(LMTabBar *)tabBar
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:vc animated:YES completion:nil];
}

@end