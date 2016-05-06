//
//  LMShowZanTableViewCell.h
//  BBLM
//
//  Created by liangpengshuai on 5/5/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMUserDetailModel.h"

@interface LMShowZanTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIButton *heatButton;
@property (weak, nonatomic) IBOutlet UIButton *focusButton;


@property (nonatomic, strong) LMUserDetailModel *userModel;


@end
