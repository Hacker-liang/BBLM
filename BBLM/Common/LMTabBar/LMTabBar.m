//
//  LMTabBar.m
//  SinaWeibo
//
//  Created by user on 15/10/16.
//  Copyright © 2015年 ZT. All rights reserved.
//

#import "LMTabBar.h"

@interface LMTabBar ()

@property (nonatomic, weak) UIButton *plusBtn;

@end

@implementation LMTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *plusBtn = [[UIButton alloc] init];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];

        plusBtn.frame = CGRectMake(plusBtn.frame.origin.x, plusBtn.frame.origin.y, plusBtn.currentBackgroundImage.size.width, plusBtn.currentBackgroundImage.size.height);
        [plusBtn addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
    }
    return self;
}

/**
 *  加号按钮点击
 */
- (void)plusBtnClick
{
    // 通知代理
    if ([self.myDelegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.myDelegate tabBarDidClickPlusButton:self];
    }
}

/**
 *  想要重新排布系统控件subview的布局，推荐重写layoutSubviews，在调用父类布局后重新排布。
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.plusBtn.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
    
    // 2.设置其他tabbarButton的frame
    CGFloat tabBarButtonW = self.frame.size.width / 3;
    CGFloat tabBarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置x
            child.frame = CGRectMake(tabBarButtonIndex * tabBarButtonW, child.frame.origin.y, tabBarButtonW, child.frame.size.height);
            // 设置宽度
            tabBarButtonIndex++;
            if (tabBarButtonIndex == 1) {
                tabBarButtonIndex++;
            }
        }
    }
}

@end
