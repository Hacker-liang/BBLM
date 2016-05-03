//
//  LMInputToolBar.h
//  BBLM
//
//  Created by liangpengshuai on 4/21/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LMInputToolBarDelegate <NSObject>

- (void)toolbarSendComment:(NSString *)comment;

@end

@interface LMInputToolBar : UIView

@property (nonatomic, strong) UITextField *inputTextField;

@property (nonatomic, weak) id<LMInputToolBarDelegate> delegate;

@end
