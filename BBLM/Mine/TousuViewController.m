//
//  TousuViewController.m
//  BBLM
//
//  Created by liangpengshuai on 5/31/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "TousuViewController.h"

@interface TousuViewController ()

@end

@implementation TousuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提交投诉";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(confirmCommit)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   

}

- (void)confirmCommit
{
    [SVProgressHUD showSuccessWithStatus:@"提交成功"];
    [self.navigationController popViewControllerAnimated:YES];
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
