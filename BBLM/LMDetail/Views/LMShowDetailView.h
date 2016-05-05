//
//  LMShowDetailView.h
//  BBLM
//
//  Created by liangpengshuai on 4/13/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMShowDetailModel.h"

@interface LMShowDetailView : UIView

@property (nonatomic, strong) LMShowDetailModel *showDetail;

@property (nonatomic, weak) UIViewController *containerCtl;

@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UIButton *playVideoButton;
@property (nonatomic, strong) UIButton *zanButton;
@property (nonatomic, strong) UIButton *headerImageButton;

@end
