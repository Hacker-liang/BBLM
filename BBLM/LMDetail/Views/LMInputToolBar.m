//
//  LMInputToolBar.m
//  BBLM
//
//  Created by liangpengshuai on 4/21/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMInputToolBar.h"

@interface LMInputToolBar ()

@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIButton *emojiButton;
@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation LMInputToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 8, kWindowWidth-100, 35)];
        _inputTextField.borderStyle = UITextBorderStyleNone;
        _inputTextField.backgroundColor = APP_PAGE_COLOR;
        _inputTextField.layer.cornerRadius = 5.0;
        _inputTextField.clipsToBounds = YES;
        [self addSubview:_inputTextField];
        
        _emojiButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_emojiButton setBackgroundColor:[UIColor blackColor]];
        [_emojiButton addTarget:self action:@selector(inputEmoji:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_emojiButton];
    }
    return self;
}

- (void)inputEmoji:(UIButton *)button
{
    
}

@end
