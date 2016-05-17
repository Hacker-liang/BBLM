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
#import "LMUserProfileViewController.h"

@interface LMCommentsTableView ()<UITableViewDelegate, UITableViewDataSource>

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

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
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
    [self registerClass:[LMCommentsTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.separatorStyle = UITableViewCellSelectionStyleNone;
    self.dataSource = self;
    self.delegate = self;
    _commentsList = [[NSMutableArray alloc] init];

    if (_showId > 0) {
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
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.refreshingTitleHidden = YES;
        [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        self.footer = footer;
    }
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

- (void)showUserProfile:(UIButton *)sender
{
    LMUserProfileViewController *ctl = [[LMUserProfileViewController alloc] init];
    LMShowCommentDetail *comment = [_commentsList objectAtIndex:sender.tag];
    ctl.userId = comment.user.userId;
    [self.containerCtl.navigationController pushViewController:ctl animated:YES];
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
    return 0;
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
    cell.avatarImageButton.tag = indexPath.row;
    [cell.avatarImageButton addTarget:self action:@selector(showUserProfile:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_myDelegate) {
        [_myDelegate commentTableViewDidScroll:scrollView.contentOffset];
    }
    
}

@end
