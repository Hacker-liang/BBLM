//
//  LMShowTableViewCell.h
//  BBLM
//
//  Created by liangpengshuai on 4/27/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMShowDetailModel.h"

@interface LMShowTableViewCell : UITableViewCell

+ (CGFloat)heightOfShowListCellWithShowDetail:(LMShowDetailModel *)show;
@property (weak, nonatomic) IBOutlet UIButton *showUserInfoButton;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImagView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *showDescLabel;
@property (weak, nonatomic) IBOutlet UIButton *playVideoButton;
@property (weak, nonatomic) IBOutlet UIImageView *rankBgImageView;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (nonatomic, strong) LMShowDetailModel *showDetail;



@end
