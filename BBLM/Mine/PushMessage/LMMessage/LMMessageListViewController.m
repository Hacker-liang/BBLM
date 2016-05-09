//
//  LMMessageListViewController.m
//  BBLM
//
//  Created by liangpengshuai on 5/4/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMMessageListViewController.h"
#import "LMMessageTableViewCell.h"
#import "LMUserManager.h"
#import "MJRefresh.h"
#import "LMUserProfileViewController.h"
#import "LMShowDetailViewController.h"
#import "LMPushMessageDetail.h"

@interface LMMessageListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <LMPushMessageDetail *>*dataSource;
@property (nonatomic) NSInteger page;

@end

@implementation LMMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NSMutableArray alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = APP_PAGE_COLOR;
    _tableView.separatorColor = COLOR_LINE;
    [_tableView registerNib:[UINib nibWithNibName:@"LMMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.navigationItem.title = @"芭比消息";
    
    _page = 1;
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        
        NSString *url = [NSString stringWithFormat:@"%@message/barbie", BASE_API];
        [LMNetworking GET:url parameters:@{@"memberId": [NSNumber numberWithInteger:[LMAccountManager shareInstance].account.userId],
                                           @"page": [NSNumber numberWithInteger:_page],
                                           @"pageSize": [NSNumber numberWithInteger:10]
                                           } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                               if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
                                                   [_dataSource removeAllObjects];
                                                   NSMutableArray *retList = [[NSMutableArray alloc] init];
                                                   for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
                                                       LMPushMessageDetail *msg = [[LMPushMessageDetail alloc] initWithJson:dic];
                                                       [retList addObject:msg];
                                                       [_dataSource addObjectsFromArray:retList];
                                                       [self.tableView reloadData];
                                                       _page++;
                                                       if (retList.count < 10) {
                                                           [self.tableView.footer endRefreshingWithNoMoreData];
                                                       }
                                                   }
                                               }
                                               [self.tableView.header endRefreshing];
                                               
                                           } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
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
    NSString *url = [NSString stringWithFormat:@"%@message/barbie", BASE_API];
    [LMNetworking GET:url parameters:@{@"memberId": [NSNumber numberWithInteger:[LMAccountManager shareInstance].account.userId],
                                       @"page": [NSNumber numberWithInteger:_page],
                                       @"pageSize": [NSNumber numberWithInteger:10]
                                       } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                           if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
                                               NSMutableArray *retList = [[NSMutableArray alloc] init];
                                               for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
                                                   LMPushMessageDetail *msg = [[LMPushMessageDetail alloc] initWithJson:dic];
                                                   [retList addObject:msg];
                                                   [_dataSource addObjectsFromArray:retList];
                                                   [self.tableView reloadData];
                                                   _page++;
                                                   if (retList.count < 10) {
                                                       [self.tableView.footer endRefreshingWithNoMoreData];
                                                   }
                                               }
                                           }
                                           [self.tableView.footer endRefreshing];
                                           
                                       } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                                           [self.tableView.footer endRefreshing];
                                           
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
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.pushMessage = [_dataSource objectAtIndex:indexPath.row];
    cell.avatarButton.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
