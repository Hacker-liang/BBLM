//
//  MyZanListViewController.m
//  BBLM
//
//  Created by liangpengshuai on 5/4/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "MyZanListViewController.h"
#import "MyZanTableViewCell.h"
#import "LMUserManager.h"
#import "MJRefresh.h"
#import "LMUserProfileViewController.h"
#import "LMShowDetailViewController.h"

@interface MyZanListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <LMShowZanDetail *>*dataSource;
@property (nonatomic) NSInteger page;

@end

@implementation MyZanListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NSMutableArray alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = APP_PAGE_COLOR;
    _tableView.separatorColor = COLOR_LINE;
    [_tableView registerNib:[UINib nibWithNibName:@"MyZanTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.navigationItem.title = @"赞我的";
    
    _page = 1;
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        
        [LMUserManager asyncLoadUserZanListInfoWithUserId:[LMAccountManager shareInstance].account.userId page:_page pageSize:10 completionBlock:^(BOOL isSuccess, NSArray<LMShowZanDetail *> *commentList) {
            if (isSuccess) {
                [_dataSource removeAllObjects];
                
                [_dataSource addObjectsFromArray:commentList];
                [self.tableView reloadData];
                _page++;
                if (commentList.count < 10) {
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
    [LMUserManager asyncLoadUserZanListInfoWithUserId:[LMAccountManager shareInstance].account.userId page:_page pageSize:10 completionBlock:^(BOOL isSuccess, NSArray<LMShowZanDetail *> *commentList) {
        if (isSuccess) {
            [_dataSource addObjectsFromArray:commentList];
            [self.tableView reloadData];
            _page++;
            if (commentList.count < 10) {
                [self.tableView.footer endRefreshingWithNoMoreData];
            }
        }
        [_tableView.footer endRefreshing];
        
    }];
}

- (void)gotoUserProfile:(UIButton *)sender
{
    LMShowZanDetail *zan = [_dataSource objectAtIndex:sender.tag];
    LMUserProfileViewController *ctl = [[LMUserProfileViewController alloc] init];
    ctl.userId = zan.user.userId;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyZanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.zanDetail = [_dataSource objectAtIndex:indexPath.row];
//    [cell.avatarButton addTarget:self action:@selector(gotoUserProfile:) forControlEvents:UIControlEventTouchUpInside];
    cell.avatarButton.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LMShowDetailViewController *ctl = [[LMShowDetailViewController alloc] init];
    ctl.showId = [_dataSource objectAtIndex:indexPath.row].showId;
    [self.navigationController pushViewController:ctl animated:YES];
}

@end
