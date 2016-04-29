//
//  LMInputToolBar.m
//  BBLM
//
//  Created by liangpengshuai on 4/21/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMInputToolBar.h"
#import "AGEmojiKeyboardView.h"

@interface LMInputToolBar () <UITextFieldDelegate, AGEmojiKeyboardViewDataSource, AGEmojiKeyboardViewDelegate>

@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIButton *emojiButton;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) AGEmojiKeyboardView *emojiInputView;


@end

@implementation LMInputToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
         _emojiInputView = [[AGEmojiKeyboardView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 216) dataSource:self];
        _emojiInputView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _emojiInputView.delegate = self;
        
        _emojiButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, frame.size.height)];
        [_emojiButton setImage:[UIImage imageNamed:@"icon_input_switchEmoji"] forState:UIControlStateNormal];
        [_emojiButton setImage:[UIImage imageNamed:@"icon_input_switchKeyboard"] forState:UIControlStateSelected];

        [_emojiButton addTarget:self action:@selector(inputEmoji:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_emojiButton];
        
        _inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_emojiButton.frame), (frame.size.height-35)/2, frame.size.width-60-CGRectGetMaxX(_emojiButton.frame), 35)];
        _inputTextField.borderStyle = UITextBorderStyleNone;
        _inputTextField.backgroundColor = APP_PAGE_COLOR;
        _inputTextField.layer.cornerRadius = 5.0;
        _inputTextField.clipsToBounds = YES;
        _inputTextField.returnKeyType = UIReturnKeyDone;
        _inputTextField.font = [UIFont systemFontOfSize:15.0];
        _inputTextField.textColor = COLOR_TEXT_II;
        _inputTextField.delegate = self;
        _inputTextField.placeholder = @" 说点什么吧";
        
        [self addSubview:_inputTextField];
        
        _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-60, 0, 60, frame.size.height)];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:COLOR_TEXT_II forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [_sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sendButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)inputEmoji:(UIButton *)button
{
    self.alpha = 0;
    if (button.selected) {
        [_inputTextField resignFirstResponder];
        _inputTextField.inputView = nil;
        [self performSelector:@selector(becomeActivity) withObject:nil afterDelay:0.2];
        
    } else {
        [_inputTextField resignFirstResponder];
        _inputTextField.inputView = _emojiInputView;
        [self performSelector:@selector(becomeActivity) withObject:nil afterDelay:0.2];
    }
    button.selected = !button.selected;
    self.alpha = 1;
}

- (void)becomeActivity
{
    [_inputTextField becomeFirstResponder];
}

- (void)sendButtonAction:(UIButton *)button
{
    [self endEditing:YES];
}

- (void)keyboardFrameDidChange:(NSNotification *)noti
{
    
    NSValue *keyboardBoundsValue = [[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];

    CGRect keyboardEndRect = [keyboardBoundsValue CGRectValue];
    
    NSLog(@"当前y 为: %lf", keyboardEndRect.origin.y-self.bounds.size.height);
    self.frame = CGRectMake(0, keyboardEndRect.origin.y-self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [_inputTextField resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)emojiKeyBoardView:(AGEmojiKeyboardView *)emojiKeyBoardView didUseEmoji:(NSString *)emoji {
    self.inputTextField.text = [self.inputTextField.text stringByAppendingString:emoji];
}

- (void)emojiKeyBoardViewDidPressBackSpace:(AGEmojiKeyboardView *)emojiKeyBoardView {
    
    [self.inputTextField deleteBackward];
    
}

- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category {
    UIImage *img = [UIImage imageNamed:@"icon_input_switchEmoji"];
    return img;
}

- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForNonSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category {
    UIImage *img = [UIImage imageNamed:@"icon_input_switchEmoji"];
    
    return img;
}

- (UIImage *)backSpaceButtonImageForEmojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView {
    UIImage *img = [UIImage imageNamed:@"icon_input_switchEmoji"];
    return img;
}


@end
