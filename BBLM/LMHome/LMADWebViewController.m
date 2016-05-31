//
//  LMADWebViewController.m
//  BBLM
//
//  Created by liangpengshuai on 5/28/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMADWebViewController.h"
#import "ShareActivity.h"

@interface LMADWebViewController ()

@end

@implementation LMADWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareAction)];
    self.navigationItem.rightBarButtonItem = bar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shareAction
{
    NSString *shareUrl = self.webView.request.URL.absoluteString;
    UIImage *shareImage = [UIImage imageNamed:@"icon_login_header"];
    ShareActivity *shareView = [[ShareActivity alloc] initWithShareTitle:@"芭比辣妈,看全球辣妈的分享" andShareContent:@"芭比辣妈,看全球辣妈的分享" shareUrl:shareUrl shareImage:shareImage shareImageUrl:nil];
    [shareView showInViewController:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
