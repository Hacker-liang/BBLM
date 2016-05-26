//
//  LMHomeShowView.h
//  BBLM
//
//  Created by liangpengshuai on 4/13/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMShowDetailModel.h"

@class LMHomeViewController;

@interface LMHomeShowView : UIView

@property (nonatomic, strong) LMShowDetailModel *showDetail;
@property (nonatomic, strong) UIButton *playVideoButton;
@property (nonatomic, strong) UIButton *moreActionButton;
@property (nonatomic, strong) UIImageView *contentImageView;

@property (nonatomic, weak) LMHomeViewController *containerCtl;

@end
