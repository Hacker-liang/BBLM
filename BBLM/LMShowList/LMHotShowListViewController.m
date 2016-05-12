//
//  LMHotShowListViewController.m
//  BBLM
//
//  Created by liangpengshuai on 4/26/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

#import "LMHotShowListViewController.h"
#import "LMShowManager.h"
#import "MJRefresh.h"
#import "LMShowTableViewCell.h"
#import "LMShowDetailViewController.h"
#import "ShareActivity.h"
#import "CommonWebViewController.h"

@interface LMHotShowListViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger page;
@property (nonatomic, strong) NSMutableArray<LMShowDetailModel *> *dataSource;

@property (nonatomic, strong) MPMoviePlayerController *playerController;

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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_playerController stop];
    [_playerController.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)aboutAction:(UIButton *)sender
{
    CommonWebViewController *ctl = [[CommonWebViewController alloc] init];
    ctl.urlStr = [NSString stringWithFormat:@"%@resources/protocol/index.html", BASE_API];
    ctl.naviBarTitle = @"辣度规则";
    [self.navigationController pushViewController:ctl animated:YES];
    
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
    LMShowTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]];
    CGPoint point = [cell.coverImageView convertRect:CGRectZero toView:_tableView].origin;
    self.playerController.view.frame = CGRectMake(point.x, point.y, cell.coverImageView.bounds.size.width, cell.coverImageView.bounds.size.height);
    [_tableView addSubview:self.playerController.view];
    [self.playerController play];
}


- (void)showMoreAction:(UIButton *)sender
{
    LMShowDetailModel *show = [_dataSource objectAtIndex:sender.tag];
    NSString *colletcionStr = show.hasCollection ? @"取消收藏":@"收藏";
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:colletcionStr, @"分享", nil];
    sheet.tintColor = APP_THEME_COLOR;
    sheet.tag = sender.tag;
    [sheet showInView:self.view];
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
    return [LMShowTableViewCell heightOfShowListCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.showDetail = [_dataSource objectAtIndex:indexPath.section];
    [cell.actionButton setImage:[UIImage imageNamed:@"icon_showList_more"] forState:UIControlStateNormal];
    cell.actionButton.tag = indexPath.section;
    if (indexPath.section < 5) {
        cell.rankLabel.hidden = NO;
        cell.rankBgImageView.hidden = NO;
        cell.rankLabel.text = [NSString stringWithFormat:@"%ld", indexPath.section+1];
    } else {
        cell.rankLabel.hidden = YES;
        cell.rankBgImageView.hidden = YES;
    }
    [cell.playVideoButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    [cell.actionButton setImage:[UIImage imageNamed:@"icon_showList_more"] forState:UIControlStateNormal];
    [cell.actionButton addTarget:self action:@selector(showMoreAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LMShowDetailViewController *ctl = [[LMShowDetailViewController alloc] init];
    ctl.showId = [_dataSource objectAtIndex:indexPath.section].itemId;
    [self.navigationController pushViewController:ctl animated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    SEL selector = NSSelectorFromString(@"_alertController");
    if ([actionSheet respondsToSelector:selector])//ios8
    {
        UIAlertController *alertController = [actionSheet valueForKey:@"_alertController"];
        if ([alertController isKindOfClass:[UIAlertController class]])
        {
            alertController.view.tintColor = APP_THEME_COLOR;
        }
    } else { //ios7
        for( UIView * subView in actionSheet.subviews )
        {
            if( [subView isKindOfClass:[UIButton class]] )
            {
                UIButton * btn = (UIButton*)subView;
                [btn setTitleColor:APP_THEME_COLOR forState:UIControlStateNormal];
                [btn setTitleColor:APP_THEME_COLOR forState:UIControlStateHighlighted];
                
            }
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    LMShowDetailModel *show = [_dataSource objectAtIndex:actionSheet.tag];
    if (buttonIndex == 0) {
        if (![[LMAccountManager shareInstance] isLogin]) {
            LMLoginViewController *ctl = [[LMLoginViewController alloc] initWithCompletionBlock:^(BOOL isLogin, NSString *errorStr) {
                if (isLogin) {
                    
                } else {
                }
            }];
            [self presentViewController:ctl animated:YES completion:nil];
            
            return;
        }
        if (show.hasCollection) {
            [LMShowManager asyncCancelCollectionShowWithItemId:show.itemId completionBlock:^(BOOL isSuccess) {
                if (isSuccess) {
                    [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
                    show.hasCollection = NO;
                } else {
                    [SVProgressHUD showErrorWithStatus:@"取消收藏失败"];
                }
            }];
        } else {
            [LMShowManager asyncCollectionShowWithItemId:show.itemId completionBlock:^(BOOL isSuccess) {
                if (isSuccess) {
                    [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                    show.hasCollection = YES;
                } else {
                    [SVProgressHUD showErrorWithStatus:@"收藏失败"];
                }
            }];
        }
    } else if (buttonIndex == 1) {
        NSString *content;
        if (show.isVideo) {
            content = [NSString stringWithFormat:@"我分享了一张\"%@\"的短视频，速来围观", show.publishUser.nickname];
        } else {
            content = [NSString stringWithFormat:@"我分享了一张\"%@\"的照片，速来围观", show.publishUser.nickname];
            
        }
        NSString *shareUrl = [NSString stringWithFormat:@"%@/share?dynamicId=%ld", BASE_API, show.itemId];

        ShareActivity *shareView = [[ShareActivity alloc] initWithShareTitle:@"芭比辣妈,看全球辣妈的分享" andShareContent:content shareUrl:shareUrl shareImage:nil shareImageUrl:show.coverImage];
        [shareView showInViewController:self];
    }
}

@end













