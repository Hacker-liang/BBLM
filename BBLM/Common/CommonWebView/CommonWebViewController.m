//
//  CommonWebViewController.m
//  BBLM
//
//  Created by liangpengshuai on 5/9/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "CommonWebViewController.h"

@interface CommonWebViewController ()

@property (nonatomic, strong) NSURLRequest *request;

@end

@implementation CommonWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    [_webView loadRequest:_request];
    NSLog(@"requestUrl: %@", _urlStr);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUrlStr:(NSString *)urlStr
{
    _urlStr = urlStr;
    _request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_urlStr]];
    [_webView loadRequest:_request];
}

- (void)setNaviBarTitle:(NSString *)naviBarTitle
{
    _naviBarTitle = naviBarTitle;
    self.navigationItem.title = _naviBarTitle;
}

@end
