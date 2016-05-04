//
//  MyCommentsListViewController.m
//  BBLM
//
//  Created by liangpengshuai on 5/4/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "MyCommentsListViewController.h"
#import "MyCommentTableViewCell.h"
#import "LMUserManager.h"
#import "MJRefresh.h"

@interface MyCommentsListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic) NSInteger page;

@end

@implementation MyCommentsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NSMutableArray alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = APP_PAGE_COLOR;
    _tableView.separatorColor = COLOR_LINE;
    [_tableView registerNib:[UINib nibWithNibName:@"MyCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.navigationItem.title = @"评论我的";
    
    _page = 1;
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        
        [LMUserManager asyncLoadUserCommentsListInfoWithUserId:[LMAccountManager shareInstance].account.userId page:_page pageSize:10 completionBlock:^(BOOL isSuccess, NSArray<LMShowCommentDetail *> *commentList) {
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
    [LMUserManager asyncLoadUserCommentsListInfoWithUserId:[LMAccountManager shareInstance].account.userId page:_page pageSize:10 completionBlock:^(BOOL isSuccess, NSArray<LMShowCommentDetail *> *commentList) {
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
    MyCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.commentDetail = [_dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
