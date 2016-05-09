//
//  MyZanTableViewCell.h
//  BBLM
//
//  Created by liangpengshuai on 5/4/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMShowZanDetail.h"

@interface MyZanTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property (nonatomic, strong) LMShowZanDetail *zanDetail;


@end
