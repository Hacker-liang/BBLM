//
//  LMUserProfileViewController.m
//  BBLM
//
//  Created by liangpengshuai on 4/18/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

#import "LMUserProfileViewController.h"
#import "LMUserPorfileHeaderView.h"
#import "LMShowTableViewCell.h"
#import "LMShowManager.h"
#import "LMShowDetailViewController.h"
#import "ShareActivity.h"

#define pageCount   10

@interface LMUserProfileViewController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<LMShowDetailModel *> *dataSource;

@property (nonatomic, strong) MPMoviePlayerController *playerController;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *naviBar;

@property (nonatomic, strong) LMUserDetailModel *userInfo;

@property (nonatomic) BOOL isMyselfInfo;

@end

@implementation LMUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    _isMyselfInfo = [LMAccountManager shareInstance].account.userId == _userId;

    _dataSource = [[NSMutableArray alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = COLOR_LINE;
    [_tableView registerNib:[UINib nibWithNibName:@"LMShowTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    LMUserPorfileHeaderView *headerView = [[LMUserPorfileHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 414)];
    _tableView.tableHeaderView = headerView;
    
    _naviBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowWidth, 64)];
    _naviBar.backgroundColor = [APP_THEME_COLOR colorWithAlphaComponent:0];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, kWindowWidth-160, 44)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:17.0];
    [_naviBar addSubview:_titleLabel];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 44)];
    [backButton setImage:[UIImage imageNamed:@"icon_navi_back_white"] forState:UIControlStateNormal];
    backButton.tintColor = [UIColor whiteColor];
    [backButton addTarget:self action:@selector(dismissCtl) forControlEvents:UIControlEventTouchUpInside];
    [_naviBar addSubview:backButton];
    
    [self.view addSubview:_naviBar];
    
    [LMUserManager asyncLoadUserInfoWithUserId:_userId completionBlock:^(BOOL isSuccess, LMUserDetailModel *userInfo) {
        if (isSuccess) {
            _userInfo = userInfo;
            _titleLabel.text = _userInfo.nickname;
            headerView.userInfo = userInfo;
        }
        
    }];
    
    [LMShowManager asyncLoadUserShowWithUserId:_userId page:1 pageSize:pageCount completionBlock:^(BOOL isSuccess, NSArray<LMShowDetailModel *> *showList) {
        if (isSuccess) {
            [_dataSource addObjectsFromArray:showList];
            [_tableView reloadData];
        }
    }];
    [LMUserManager asyncLoadUserRankInfoWithUserId:_userId completionBlock:^(BOOL isSuccess, NSDictionary *rankInfo) {
        if (isSuccess) {
            headerView.userRankInfo = rankInfo;
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [_playerController stop];
    [_playerController.view removeFromSuperview];
}

- (void)dismissCtl
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)deleteShowAction:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定删除该条动态？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView showAlertViewWithBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [LMUserManager asyncDeleteUserShowWithUserId:_userId showId:[_dataSource objectAtIndex:sender.tag].itemId completionBlock:^(BOOL isSuccess) {
                if (isSuccess) {
                    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                    [_dataSource removeObjectAtIndex:sender.tag];
                    [_tableView deleteSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"删除失败"];
                }
            }];
        }
    }];
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
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [LMShowTableViewCell heightOfShowListCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.showDetail = [_dataSource objectAtIndex:indexPath.section];
    [cell.playVideoButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    cell.playVideoButton.tag = indexPath.section;
    cell.actionButton.tag = indexPath.section;
    cell.rankBgImageView.hidden = YES;
    cell.rankLabel.hidden = YES;
    if (_isMyselfInfo) {
        [cell.actionButton setImage:[UIImage imageNamed:@"icon_show_delete"] forState:UIControlStateNormal];
        [cell.actionButton addTarget:self action:@selector(deleteShowAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [cell.actionButton setImage:[UIImage imageNamed:@"icon_showList_more"] forState:UIControlStateNormal];
        [cell.actionButton addTarget:self action:@selector(showMoreAction:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= -64 && [scrollView isEqual:_tableView]) {
        [scrollView setContentOffset:CGPointMake(0, -64)];
    }
    CGFloat alpha = scrollView.contentOffset.y/100;
    _naviBar.backgroundColor = [APP_THEME_COLOR colorWithAlphaComponent:alpha];
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
