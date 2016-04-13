//
//  LMTabBar.h
//  SinaWeibo
//
//  Created by user on 15/10/16.
//  Copyright © 2015年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMTabBar;

@protocol LMTabBarDelegate <UITabBarDelegate>

@optional

- (void)tabBarDidClickPlusButton:(LMTabBar *)tabBar;

@end

@interface LMTabBar : UITabBar

@property (nonatomic, weak) id<LMTabBarDelegate> myDelegate;

@end
