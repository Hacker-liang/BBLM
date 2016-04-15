//
//  LMUserTagCollectionViewCell.m
//  IDo
//
//  Created by liangpengshuai on 10/5/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "LMUserTagCollectionViewCell.h"

@implementation LMUserTagCollectionViewCell

- (void)awakeFromNib {
}

- (void)setTabBkgImage:(NSString *)tabBkgImage
{
    _tabBkgImage = tabBkgImage;
    [_grabTagBtn setBackgroundImage:[[UIImage imageNamed:_tabBkgImage] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 5, 20)] forState:UIControlStateNormal];
}

@end
