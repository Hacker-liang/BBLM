//
//  LMLoginViewController.m
//  BBLM
//
//  Created by liangpengshuai on 4/13/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMLoginViewController.h"

@interface LMLoginViewController () <UITextFieldDelegate>
{
    NSTimer *timer;
    NSInteger count;
}

@property (weak, nonatomic) IBOutlet UITextField *telTextField;
@property (weak, nonatomic) IBOutlet UITextField *captchaTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *getCatchaButton;

@property (nonatomic, copy) void (^loginCompletionBlock) (BOOL isLogin, NSString *errorStr);

@end

@implementation LMLoginViewController

- (id)initWithCompletionBlock:(void (^)(BOOL isLogin, NSString *errorStr))completion
{
    if (self = [super initWithNibName:@"LMLoginViewController" bundle:nil]) {
        _loginCompletionBlock = completion;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = APP_PAGE_COLOR;
    _getCatchaButton.layer.borderColor = COLOR_LINE.CGColor;
    _getCatchaButton.layer.borderWidth = 0.5;
    _getCatchaButton.layer.cornerRadius = 15;
    
    _loginButton.layer.cornerRadius = 20;
    [_loginButton setBackgroundImage:[ConvertMethods createImageWithColor:APP_THEME_COLOR] forState:UIControlStateNormal];
    _loginButton.clipsToBounds = YES;
    
    _telTextField.delegate = self;
    _captchaTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)dismiss:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)loginAction:(id)sender {
    [[LMAccountManager shareInstance] asyncLoginWithTel:self.telTextField.text captcha:self.captchaTextField.text completionBlock:^(BOOL isSuccess, NSString *errorStr) {
        if (_loginCompletionBlock) {
            _loginCompletionBlock(isSuccess, errorStr);
        }
        if (isSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
            [LMUserManager asyncLoadUserInfoWithUserId:[LMAccountManager shareInstance].account.userId completionBlock:^(BOOL isSuccess, LMUserDetailModel *userInfo) {
                
            }]; //登录成功去取一遍自己的信息
        }
    }];
    
}

- (IBAction)getCaptcha:(id)sender {
    if ([self.telTextField.text isEqual:@""] || ![LMLoginViewController isValidateMobile:self.telTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    [self.view endEditing:YES];
    [SVProgressHUD showWithStatus:@"正在获取验证吗"];
    NSString *url = [NSString stringWithFormat:@"%@sms/sendCode", BASE_API];
    [LMNetworking GET:url parameters:@{@"mobile": self.telTextField.text} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            [self startTimer];
            [SVProgressHUD showSuccessWithStatus:@"验证码获取成功"];
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"验证码获取失败"];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"验证码获取失败"];
        
    }];
}

- (IBAction)aboutAction:(id)sender {
}

#pragma mark - Private Methods

- (void)startTimer
{
    count = 59;
    if (timer != nil) {
        [self stopTimer];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(calculateTime) userInfo:nil repeats:YES];
    _getCatchaButton.enabled = NO;
}

- (void)stopTimer
{
    if (timer) {
        if ([timer isValid]) {
            [timer invalidate];
            timer = nil;
        }
        count = 0;
    }
}

- (void)calculateTime
{
    if (count <= 1) {
        [self stopTimer];
        _getCatchaButton.enabled = YES;
    } else {
        count--;
        [_getCatchaButton setTitle:[NSString stringWithFormat:@"%lds后重发",(long)count] forState:UIControlStateDisabled];
    }
}

+ (BOOL)isValidateMobile:(NSString *)mobile
{
    NSString *regex = @"^1\\d{10}";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([regextestmobile evaluateWithObject:mobile] == YES) {
        return YES;
    }
    return NO;
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        
        return NO;
    }
    return YES;
}

@end








