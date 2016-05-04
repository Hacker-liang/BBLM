//
//  LMUserProfileViewController.m
//  BBLM
//
//  Created by liangpengshuai on 4/18/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

#import "LMUserProfileViewController.h"
#import "LMUserPorfileHeaderView.h"
#import "LMShowTableViewCell.h"
#import "LMShowManager.h"
#import "LMShowDetailViewController.h"

#define pageCount   10

@interface LMUserProfileViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<LMShowDetailModel *> *dataSource;

@property (nonatomic, strong) MPMoviePlayerController *playerController;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) LMUserDetailModel *userInfo;

@property (nonatomic) BOOL isMyselfInfo;

@end

@implementation LMUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    _isMyselfInfo = [LMAccountManager shareInstance].account.userId == _userInfo.userId;

    _dataSource = [[NSMutableArray alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = COLOR_LINE;
    [_tableView registerNib:[UINib nibWithNibName:@"LMShowTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    LMUserPorfileHeaderView *headerView = [[LMUserPorfileHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 414)];
    _tableView.tableHeaderView = headerView;
    
    UIView *naviBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowWidth, 64)];
    naviBar.backgroundColor = APP_THEME_COLOR;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, kWindowWidth-160, 44)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:17.0];
    [naviBar addSubview:_titleLabel];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 44)];
    [backButton setImage:[UIImage imageNamed:@"common_icon_navigation_back_normal"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(dismissCtl) forControlEvents:UIControlEventTouchUpInside];
    [naviBar addSubview:backButton];
    
    [self.view addSubview:naviBar];
    
    [LMUserManager asyncLoadUserInfoWithUserId:[LMAccountManager shareInstance].account.userId completionBlock:^(BOOL isSuccess, LMUserDetailModel *userInfo) {
        if (isSuccess) {
            _userInfo = userInfo;
            _titleLabel.text = _userInfo.nickname;
            headerView.userInfo = userInfo;
        }
        
    }];
    
    [LMShowManager asyncLoadUserShowWithUserId:_userId page:1 pageSize:pageCount completionBlock:^(BOOL isSuccess, NSArray<LMShowDetailModel *> *showList) {
        if (isSuccess) {
            [_dataSource addObjectsFromArray:showList];
            [_tableView reloadData];
        }
    }];
    [LMUserManager asyncLoadUserRankInfoWithUserId:_userId completionBlock:^(BOOL isSuccess, NSDictionary *rankInfo) {
        if (isSuccess) {
            headerView.userRankInfo = rankInfo;
        }
    }];
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
    [_playerController stop];
    [_playerController.view removeFromSuperview];
}

- (void)dismissCtl
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)playVideo:(UIButton *)sender
{
    if (self.playerController.view.superview) {
        [self.playerController.view removeFromSuperview];
        [self.playerController stop];
    }
    NSURL *url = [NSURL URLWithString:[_dataSource objectAtIndex:sender.tag].videoUrl];

    self.playerController.contentURL = url;
    LMShowTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]];
    CGPoint point = [cell.coverImageView convertRect:CGRectZero toView:_tableView].origin;
    self.playerController.view.frame = CGRectMake(point.x, point.y, cell.coverImageView.bounds.size.width, cell.coverImageView.bounds.size.height);
    [_tableView addSubview:self.playerController.view];
    [self.playerController play];
}


#pragma mark - 懒加载代码
- (MPMoviePlayerController *)playerController
{
    if (_playerController == nil) {
        _playerController = [[MPMoviePlayerController alloc] init];
        _playerController.movieSourceType = MPMovieSourceTypeUnknown;
    }
    return _playerController;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [LMShowTableViewCell heightOfShowListCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.showDetail = [_dataSource objectAtIndex:indexPath.section];
    [cell.playVideoButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    cell.playVideoButton.tag = indexPath.section;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LMShowDetailViewController *ctl = [[LMShowDetailViewController alloc] init];
    ctl.showId = [_dataSource objectAtIndex:indexPath.section].itemId;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= -64 && [scrollView isEqual:_tableView]) {
        [scrollView setContentOffset:CGPointMake(0, -64)];
    }
}

@end
