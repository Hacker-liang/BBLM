//
//  LMAboutViewController.m
//  BBLM
//
//  Created by liangpengshuai on 5/12/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMAboutViewController.h"

@interface LMAboutViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation LMAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于芭比辣妈";
    NSDictionary *infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString *versionNum =[infoDict objectForKey:@"CFBundleShortVersionString"];
    NSString *text =[NSString stringWithFormat:@"%@",versionNum];

    _versionLabel.text = [NSString stringWithFormat:@"版本号 V%@", text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
