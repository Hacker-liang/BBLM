//
//  LMUserProfileViewController.m
//  BBLM
//
//  Created by liangpengshuai on 4/18/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMUserProfileViewController.h"
#import "LMUserPorfileHeaderView.h"

@interface LMUserProfileViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation LMUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    LMUserPorfileHeaderView *headerView = [[LMUserPorfileHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 414)];
    _tableView.tableHeaderView = headerView;
    
    UIView *naviBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowWidth, 64)];
    naviBar.backgroundColor = APP_THEME_COLOR;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:16.0];
    [naviBar addSubview:_titleLabel];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 44)];
    [backButton setImage:[UIImage imageNamed:@"common_icon_navigation_back_normal"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(dismissCtl) forControlEvents:UIControlEventTouchUpInside];
    [naviBar addSubview:backButton];
    
    [self.view addSubview:naviBar];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)dismissCtl
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
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
    cell.textLabel.text = [_dataSource objectAtIndex:indexPath.row];
    return cell;
}

@end
