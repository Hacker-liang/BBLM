//
//  MineHeaderView.h
//  BBLM
//
//  Created by liangpengshuai on 4/14/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MineHeaderViewDelegate <NSObject>

- (void)touchUserTag;

@end

@interface MineHeaderView : UIView

@property (nonatomic, strong) LMUserDetailModel *userInfo;

@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UIButton *editUserInfoButton;

@property (nonatomic, weak) id<MineHeaderViewDelegate> delegate;

@end
