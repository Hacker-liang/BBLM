//
//  UserShowCollectionViewController.m
//  BBLM
//
//  Created by liangpengshuai on 4/26/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "UserShowCollectionViewController.h"
#import "LMShowManager.h"
#import "MJRefresh.h"
#import "LMSimpleShowTableViewCell.h"
#import "LMShowDetailViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface UserShowCollectionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger page;
@property (nonatomic, strong) NSMutableArray<LMShowDetailModel *> *dataSource;

@property (nonatomic, strong) MPMoviePlayerController *playerController;

@end

@implementation UserShowCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    
    _dataSource = [[NSMutableArray alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = COLOR_LINE;
    [_tableView registerNib:[UINib nibWithNibName:@"LMSimpleShowTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _page = 1;
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [LMShowManager asyncLoadUserCollectionShowWithUserId:[LMAccountManager shareInstance].account.userId page:_page pageSize:10 completionBlock:^(BOOL isSuccess, NSArray<LMShowDetailModel *> *showList) {
            [self.tableView.header endRefreshing];
            if (isSuccess) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:showList];
                [self.tableView reloadData];
                _page++;
            }
        }];
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.header = header;
    [header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_playerController stop];
    [_playerController.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadMoreData
{
    [LMShowManager asyncLoadHotShowWithPage:_page pageSize:10 completionBlock:^(BOOL isSuccess, NSArray<LMShowDetailModel *> *showList) {
        [self.tableView.footer endRefreshing];
        if (isSuccess) {
            [_dataSource addObjectsFromArray:showList];
            [self.tableView reloadData];
            _page++;
        }
    }];
}

- (void)playVideo:(UIButton *)sender
{
    if (self.playerController.view.superview) {
        [self.playerController.view removeFromSuperview];
        [self.playerController stop];
    }
    NSURL *url = [NSURL URLWithString:[_dataSource objectAtIndex:sender.tag].videoUrl];
    
    
    self.playerController.contentURL = url;
    LMSimpleShowTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]];
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
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [LMSimpleShowTableViewCell heightOfShowListCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMSimpleShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.showDetail = [_dataSource objectAtIndex:indexPath.section];
    [cell.actionButton setImage:[UIImage imageNamed:@"icon_showList_more"] forState:UIControlStateNormal];
    cell.rankBgImageView.hidden = YES;
    [cell.playVideoButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LMShowDetailViewController *ctl = [[LMShowDetailViewController alloc] init];
    ctl.showId = [_dataSource objectAtIndex:indexPath.section].itemId;
    [self.navigationController pushViewController:ctl animated:YES];
}

@end
















