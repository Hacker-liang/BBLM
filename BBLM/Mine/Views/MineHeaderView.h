//
//  MineHeaderView.h
//  BBLM
//
//  Created by liangpengshuai on 4/14/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineHeaderView : UIView

@property (nonatomic, strong) LMUserDetailModel *userInfo;

@property (nonatomic, strong) UIButton *addTagButton;
@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UIButton *editUserInfoButton;

@end
