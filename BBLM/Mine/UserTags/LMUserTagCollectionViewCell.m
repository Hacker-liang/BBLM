//
//  LMUserTagCollectionViewCell
//  IDo
//
//  Created by liangpengshuai on 10/5/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "LMUserTagCollectionViewCell.h"

@implementation LMUserTagCollectionViewCell

- (void)awakeFromNib {
    [_grabTagBtn setTitleEdgeInsets:UIEdgeInsetsMake(7, 0, 0, 8)];
}

- (void)setTabBkgImage:(NSString *)tabBkgImage
{
    _tabBkgImage = tabBkgImage;
    [_grabTagBtn setBackgroundImage:[[UIImage imageNamed:_tabBkgImage] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 5, 5, 30)] forState:UIControlStateNormal];
}

@end
