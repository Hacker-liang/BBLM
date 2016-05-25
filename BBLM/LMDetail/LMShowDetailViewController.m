//
//  LMShowDetailViewController.m
//  BBLM
//
//  Created by liangpengshuai on 4/21/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

#import "LMShowDetailViewController.h"
#import "LMShowManager.h"
#import "LMShowCommentManager.h"
#import "LMShowDetailView.h"
#import "LMInputToolBar.h"
#import "LMUserProfileViewController.h"
#import "LMShowZanListViewController.h"
#import "ShareActivity.h"

@interface LMShowDetailViewController () <LMInputToolBarDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) LMCommentsTableView *tableView;

@property (nonatomic, strong) LMShowDetailModel *showDetail;
@property (nonatomic, strong) LMShowDetailView *showDetailView;
@property (nonatomic, strong) LMInputToolBar *inputToolBar;

@property (nonatomic, strong) MPMoviePlayerController *playerController;

@end

@implementation LMShowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"作品详情";
    
    _tableView = [[LMCommentsTableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight-49) andShowId: _showId];
    _tableView.containerCtl = self;
    [self.view addSubview:_tableView];

    [LMShowManager asyncLoadShowDetialWithShowId:_showId completionBlock:^(BOOL isSuccess, LMShowDetailModel *showDetail) {
        _showDetail = showDetail;
        CGFloat height = [LMShowDetailView heithWithShowDetail:_showDetail];
        _showDetailView = [[LMShowDetailView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, height)];
        [_showDetailView.playVideoButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
        _tableView.tableHeaderView = _showDetailView;
        [_showDetailView.headerImageButton addTarget:self action:@selector(gotoPublishUserProfile:) forControlEvents:UIControlEventTouchUpInside];
        [_showDetailView.zanButton addTarget:self action:@selector(zanShowAction:) forControlEvents:UIControlEventTouchUpInside];
        [_showDetailView.zanUserCntButton addTarget:self action:@selector(showMoreZanUserAction:) forControlEvents:UIControlEventTouchUpInside];
        [_showDetailView.moreActionButton addTarget:self action:@selector(showMoreAction:) forControlEvents:UIControlEventTouchUpInside];
        _showDetailView.containerCtl = self;
        _showDetailView.showDetail = _showDetail;
    }];
    
    _inputToolBar = [[LMInputToolBar alloc] initWithFrame:CGRectMake(0, kWindowHeight-49, kWindowWidth, 49)];
    _inputToolBar.delegate = self;
    [self.view addSubview:_inputToolBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)gotoPublishUserProfile:(UIButton *)sender
{
    LMUserProfileViewController *ctl = [[LMUserProfileViewController alloc] init];
    ctl.userId = _showDetail.publishUser.userId;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)showMoreZanUserAction:(UIButton *)sender
{
    LMShowZanListViewController *ctl = [[LMShowZanListViewController alloc] init];
    ctl.showId = _showId;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)playVideo:(UIButton *)sender
{
    if (self.playerController.view.superview) {
        [self.playerController.view removeFromSuperview];
        [self.playerController stop];
    }
    NSURL *url = [NSURL URLWithString:_showDetail.videoUrl];
    
    self.playerController.contentURL = url;
    
    self.playerController.view.frame = _showDetailView.contentImageView.bounds;
    [_showDetailView.contentImageView addSubview:self.playerController.view];
    [self.playerController play];
}

- (void)showMoreAction:(UIButton *)sender
{
    LMShowDetailModel *show = _showDetail;
    NSString *colletcionStr = show.hasCollection ? @"取消收藏":@"收藏";
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:colletcionStr, @"分享", nil];
    sheet.tintColor = APP_THEME_COLOR;
    sheet.tag = sender.tag;
    [sheet showInView:self.view];
}


- (void)showPlusNoti:(CGPoint)startPoint
{
    UILabel *plusLabel = [[UILabel alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y-20, 30, 20)];
    plusLabel.text = @"+1";
    plusLabel.textColor = APP_THEME_COLOR;
    plusLabel.font  =[UIFont systemFontOfSize:14.0];
    [self.view addSubview:plusLabel];
    [UIView animateWithDuration:1 animations:^{
        plusLabel.frame = CGRectMake(startPoint.x, startPoint.y-80, 30, 20);
        plusLabel.alpha = 0;
        
    } completion:^(BOOL finished) {
        [plusLabel removeFromSuperview];
    }];
}

- (void)zanShowAction:(UIButton *)sender
{
    if (![[LMAccountManager shareInstance] isLogin]) {
        LMLoginViewController *ctl = [[LMLoginViewController alloc] initWithCompletionBlock:^(BOOL isLogin, NSString *errorStr) {
            if (isLogin) {
                
            } else {
            }
        }];
        [self presentViewController:ctl animated:YES completion:nil];
        
        return;
    }
    if (!sender.selected) {
        [LMShowManager asyncZanShowWithItemId:_showDetail.itemId completionBlock:^(BOOL isSuccess) {
            if (isSuccess) {
                LMUserDetailModel *user = [[LMUserDetailModel alloc] init];
                user.userId = [LMAccountManager shareInstance].account.userId;
                user.nickname = [LMAccountManager shareInstance].account.nickname;
                user.avatar = [LMAccountManager shareInstance].account.avatar;

                NSMutableArray *userList = [[NSMutableArray alloc] initWithArray:_showDetail.zanUserList];
                [userList addObject:user];
                _showDetail.zanUserList = userList;
                _showDetail.hasZan = YES;
                _showDetailView.showDetail = _showDetail;
            }
        }];
    } else {
        [LMShowManager asyncCancelZanShowWithItemId:_showDetail.itemId completionBlock:^(BOOL isSuccess) {
            if (isSuccess) {
                NSMutableArray *userList = [[NSMutableArray alloc] initWithArray:_showDetail.zanUserList];

                for (LMUserDetailModel *user in userList) {
                    if (user.userId == [LMAccountManager shareInstance].account.userId) {
                        [userList removeObject:user];
                        break;
                    }
                }
                _showDetail.zanUserList = userList;
                _showDetail.hasZan = NO;
                _showDetailView.showDetail = _showDetail;
            }
        }];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - LMInputToolBarDelegate

- (void)toolbarSendComment:(NSString *)comment
{
    if (![[LMAccountManager shareInstance] isLogin]) {
        LMLoginViewController *ctl = [[LMLoginViewController alloc] initWithCompletionBlock:^(BOOL isLogin, NSString *errorStr) {
            if (isLogin) {
                
            } else {
            }
        }];
        [self presentViewController:ctl animated:YES completion:nil];
        
        return;
    }
    if (!comment.length) {
        return;
    }
    _inputToolBar.inputTextField.text = @"";

    [LMShowCommentManager asyncMakeComment2ShowWithShowId:_showId commentContent:comment completionBlock:^(BOOL isSuccess, LMShowCommentDetail *comment) {
        if (isSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"评论成功"];
            [_tableView addNewComment:comment];
        } else {
            [SVProgressHUD showErrorWithStatus:@"评论失败"];
        }
    }];
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
    LMShowDetailModel *show = _showDetail;
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
