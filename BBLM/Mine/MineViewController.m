//
//  MineViewController.m
//  BBLM
//
//  Created by liangpengshuai on 4/13/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "MineViewController.h"
#import "MineHeaderView.h"
#import "LMUserTagsAddViewController.h"
#import "LMUserProfileViewController.h"
#import "LMEditUserProfileViewController.h"


@interface MineViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) MineHeaderView *headerView;

@property (nonatomic, strong) LMUserDetailModel *userInfo;


@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userInfo = [LMAccountManager shareInstance].account;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = COLOR_LINE;
    _dataSource = @[@"我的辣妈空间", @"我的收藏", @"辣度规则", @"关于芭比辣妈", @"退出"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 150)];
    [_headerView.addTagButton addTarget:self action:@selector(addUserTags:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.avatarButton addTarget:self action:@selector(showUserProfile:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.editUserInfoButton addTarget:self action:@selector(editUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    _headerView.userInfo = _userInfo;
    self.navigationItem.title = _userInfo.nickname;

    [LMUserManager asyncLoadUserInfoWithUserId:[LMAccountManager shareInstance].account.userId completionBlock:^(BOOL isSuccess, LMUserDetailModel *userInfo) {
        if (isSuccess) {
            _userInfo = userInfo;
            _headerView.userInfo = _userInfo;
            self.navigationItem.title = _userInfo.nickname;
        }
        
    }];
    _tableView.tableHeaderView = _headerView;
    self.navigationItem.title = _userInfo.nickname;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addUserTags:(UIButton *)sender
{
    LMUserTagsAddViewController *ctl = [[LMUserTagsAddViewController alloc] init];
    ctl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctl animated:YES];
}


- (void)showUserProfile:(UIButton *)sender
{
    LMUserProfileViewController *ctl = [[LMUserProfileViewController alloc] init];
    ctl.userId = [LMAccountManager shareInstance].account.userId;
    ctl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)editUserInfo:(UIButton *)sender
{
    LMEditUserProfileViewController *ctl = [[LMEditUserProfileViewController alloc] init];
    ctl.userInfo = _userInfo;
    ctl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctl animated:YES];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        LMUserProfileViewController *ctl = [[LMUserProfileViewController alloc] init];
        ctl.userId = [LMAccountManager shareInstance].account.userId;
        ctl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }
    
}




@end
