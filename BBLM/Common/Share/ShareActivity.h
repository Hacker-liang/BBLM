//
//  ShareActivity.h
//  lvxingpai
//
//  Created by liangpengshuai on 14-8-4.
//  Copyright (c) 2014年 aizou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareActivity : UIView

- (id)initWithShareTitle:(NSString *)title andShareContent:(NSString *)content shareUrl:(NSString *)url shareImage:(UIImage *)image shareImageUrl:(NSString *)imageUrl;
- (void)showInViewController:(UIViewController *)viewController;

@end

