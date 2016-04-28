//
//  LMHotShowListViewController.m
//  BBLM
//
//  Created by liangpengshuai on 4/26/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMHotShowListViewController.h"
#import "LMShowManager.h"
#import "MJRefresh.h"
#import "LMShowTableViewCell.h"
#import "LMShowDetailViewController.h"

@interface LMHotShowListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger page;
@property (nonatomic, strong) NSMutableArray<LMShowDetailModel *> *dataSource;

@end

@implementation LMHotShowListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"辣度榜";
    
    _dataSource = [[NSMutableArray alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = COLOR_LINE;
    [_tableView registerNib:[UINib nibWithNibName:@"LMShowTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    UIButton *aboutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [aboutButton setTitle:@"辣度规则" forState:UIControlStateNormal];
    aboutButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [aboutButton setTitleColor:APP_THEME_COLOR forState:UIControlStateNormal];
    [aboutButton addTarget:self action:@selector(aboutAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aboutButton];

    _tableView.dataSource = self;
    _tableView.delegate = self;
    _page = 1;
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [LMShowManager asyncLoadHotShowWithPage:_page pageSize:10 completionBlock:^(BOOL isSuccess, NSArray<LMShowDetailModel *> *showList) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)aboutAction:(UIButton *)sender
{
    
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
    return [LMShowTableViewCell heightOfShowListCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.showDetail = [_dataSource objectAtIndex:indexPath.row];
    [cell.actionButton setImage:[UIImage imageNamed:@"icon_showList_more"] forState:UIControlStateNormal];
    if (indexPath.section < 5) {
        cell.rankLabel.hidden = NO;
        cell.rankBgImageView.hidden = NO;
        cell.rankLabel.text = [NSString stringWithFormat:@"%ld", indexPath.section+1];
    } else {
        cell.rankLabel.hidden = YES;
        cell.rankBgImageView.hidden = YES;
    }
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
















