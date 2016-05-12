//
//  LMShowZanListViewController.m
//  BBLM
//
//  Created by liangpengshuai on 5/4/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMShowZanListViewController.h"
#import "LMShowZanTableViewCell.h"
#import "LMUserManager.h"
#import "MJRefresh.h"
#import "LMShowManager.h"
#import "LMUserProfileViewController.h"

@interface LMShowZanListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<LMUserDetailModel *> *dataSource;
@property (nonatomic) NSInteger page;

@end

@implementation LMShowZanListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NSMutableArray alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = APP_PAGE_COLOR;
    _tableView.separatorColor = COLOR_LINE;
    [_tableView registerNib:[UINib nibWithNibName:@"LMShowZanTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.navigationItem.title = @"点赞的";
    
    _page = 1;
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [LMShowManager asyncLoadZanUserOfShowWithShowId:_showId page:_page pageSize:20 completionBlock:^(BOOL isSuccess, NSArray<LMUserDetailModel *> *userList) {
            if (isSuccess) {
                [_dataSource removeAllObjects];
                
                [_dataSource addObjectsFromArray:userList];
                [self.tableView reloadData];
                _page++;
                if (userList.count < 20) {
                    [self.tableView.footer endRefreshingWithNoMoreData];
                }
                
            }
            [self.tableView.header endRefreshing];
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

- (void)loadMoreData
{
    [LMShowManager asyncLoadZanUserOfShowWithShowId:_showId page:_page pageSize:20 completionBlock:^(BOOL isSuccess, NSArray<LMUserDetailModel *> *userList) {
        if (isSuccess) {
            [_dataSource addObjectsFromArray:userList];
            [self.tableView reloadData];
            _page++;
            if (userList.count < 20) {
                [self.tableView.footer endRefreshingWithNoMoreData];
            }
            
        }
        [self.tableView.header endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMShowZanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.userModel = [_dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LMUserProfileViewController *ctl = [[LMUserProfileViewController alloc] init];
    ctl.userId = [_dataSource objectAtIndex:indexPath.row].userId;
    [self.navigationController pushViewController:ctl animated:YES];
}

@end
