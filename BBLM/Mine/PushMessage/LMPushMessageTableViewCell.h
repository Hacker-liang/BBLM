//
//  LMPushMessageTableViewCell.h
//  BBLM
//
//  Created by liangpengshuai on 4/15/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMPushMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *unReadCntLabel;

@end
