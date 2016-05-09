//
//  LMCommentsTableView.m
//  BBLM
//
//  Created by liangpengshuai on 4/21/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMCommentsTableView.h"
#import "LMCommentsTableViewCell.h"
#import "LMShowCommentDetail.h"
#import "LMShowCommentManager.h"
#import "MJRefresh.h"

@interface LMCommentsTableView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *commentsList;
@property (nonatomic) NSInteger showId;

@property (nonatomic) NSInteger page;

@end

@implementation LMCommentsTableView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andShowId:(NSInteger)showId
{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        _showId = showId;
        [self initData];
    }
    return self;
}

- (void)initData
{
    _page = 1;
    self.allowsSelection = NO;
    self.backgroundColor = APP_PAGE_COLOR;
    _commentsList = [[NSMutableArray alloc] init];
    [self registerClass:[LMCommentsTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.separatorStyle = UITableViewCellSelectionStyleNone;
    self.dataSource = self;
    self.delegate = self;
    [LMShowCommentManager asyncLoadShowCommentsListWithShowId:_showId page:_page pageSize:10 completionBlock:^(BOOL isSuccess, NSArray<LMShowCommentDetail *> *commentList) {
        if (isSuccess) {
            [_commentsList removeAllObjects];
            [_commentsList addObjectsFromArray:commentList];
            if (commentList.count<10) {
                [self.footer endRefreshingWithNoMoreData];
            }
            [self reloadData];

            _page++;
        }
    }];
    
    self.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)loadMoreData
{
    [LMShowCommentManager asyncLoadShowCommentsListWithShowId:_showId page:_page pageSize:10 completionBlock:^(BOOL isSuccess, NSArray<LMShowCommentDetail *> *commentList) {
        if (isSuccess) {
            [_commentsList addObjectsFromArray:commentList];
            [self reloadData];
            _page++;
            if (commentList.count<10) {
                [self.footer endRefreshingWithNoMoreData];
            }
        }
        [self.footer endRefreshing];

    }];
}

- (void)addNewComment:(LMShowCommentDetail *)comment
{
    [_commentsList insertObject:comment atIndex:0];
    [self reloadData];
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentsList.count;
}

- (NSInteger)numberOfSections
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [LMCommentsTableViewCell heightWithCommentDetail:[_commentsList objectAtIndex:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[LMCommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.commentDetail = [_commentsList objectAtIndex:indexPath.row];
    return cell;
}

@end
