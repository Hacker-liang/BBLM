//
//  LMLoginViewController.h
//  BBLM
//
//  Created by liangpengshuai on 4/13/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMLoginViewController : UIViewController

- (id)initWithCompletionBlock:(void (^) (BOOL isLogin, NSString *errorStr))completion;


@end
