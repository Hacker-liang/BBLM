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
    _commentsList = [[NSMutableArray alloc] init];
    [self registerClass:[LMCommentsTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.separatorColor = COLOR_LINE;
    self.dataSource = self;
    self.delegate = self;
    [LMShowCommentManager asyncLoadShowCommentsListWithShowId:_showId page:_page pageSize:10 completionBlock:^(BOOL isSuccess, NSArray<LMShowCommentDetail *> *commentList) {
        if (isSuccess) {
            [_commentsList removeAllObjects];
            [_commentsList addObjectsFromArray:commentList];
            [self reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentsList.count;
}

- (NSInteger)numberOfSections
{
    return 1;
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
