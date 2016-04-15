//
//  LMUserTagsAddViewController.m
//  BBLM
//
//  Created by liangpengshuai on 4/15/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMUserTagsAddViewController.h"

@interface LMUserTagsAddViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LMUserTagsAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = COLOR_LINE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.textColor = COLOR_TEXT_I;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    return cell;
}

@end
