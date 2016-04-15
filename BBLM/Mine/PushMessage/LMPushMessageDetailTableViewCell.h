//
//  LMPushMessageDetailTableViewCell.h
//  BBLM
//
//  Created by liangpengshuai on 4/15/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMPushMessageDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end
