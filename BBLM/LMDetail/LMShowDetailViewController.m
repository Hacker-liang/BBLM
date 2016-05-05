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

@interface LMShowDetailViewController () <LMInputToolBarDelegate>

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
    [self.view addSubview:_tableView];
    
    _showDetailView = [[LMShowDetailView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 460)];
    [_showDetailView.playVideoButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    _tableView.tableHeaderView = _showDetailView;
    [_showDetailView.headerImageButton addTarget:self action:@selector(gotoPublishUserProfile:) forControlEvents:UIControlEventTouchUpInside];
    [_showDetailView.zanButton addTarget:self action:@selector(zanShowAction:) forControlEvents:UIControlEventTouchUpInside];

    [LMShowManager asyncLoadShowDetialWithShowId:_showId completionBlock:^(BOOL isSuccess, LMShowDetailModel *showDetail) {
        _showDetail = showDetail;
        _showDetailView.showDetail = _showDetail;
    }];
    
    _inputToolBar = [[LMInputToolBar alloc] initWithFrame:CGRectMake(0, kWindowHeight-49, kWindowWidth, 49)];
    _inputToolBar.delegate = self;
    [self.view addSubview:_inputToolBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_playerController stop];
    [_playerController.view removeFromSuperview];
}

- (void)gotoPublishUserProfile:(UIButton *)sender
{
    LMUserProfileViewController *ctl = [[LMUserProfileViewController alloc] init];
    ctl.userId = _showDetail.publishUser.userId;
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

- (void)zanShowAction:(UIButton *)sender
{
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
    if (!comment.length) {
        return;
    }
    [LMShowCommentManager asyncMakeComment2ShowWithShowId:_showId commentContent:comment completionBlock:^(BOOL isSuccess, LMShowCommentDetail *comment) {
        if (isSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"评论成功"];
            _inputToolBar.inputTextField.text = @"";
            [_tableView addNewComment:comment];
        } else {
            [SVProgressHUD showErrorWithStatus:@"评论失败"];
        }
    }];
}
@end
