//
//  LMShowDetailViewController.m
//  BBLM
//
//  Created by liangpengshuai on 4/21/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMShowDetailViewController.h"
#import "LMShowManager.h"
#import "LMShowCommentManager.h"
#import "LMShowDetailView.h"
#import "LMInputToolBar.h"

@interface LMShowDetailViewController ()

@property (nonatomic, strong) LMCommentsTableView *tableView;

@property (nonatomic, strong) LMShowDetailModel *showDetail;
@property (nonatomic, strong) LMShowDetailView *showDetailView;
@property (nonatomic, strong) LMInputToolBar *inputToolBar;

@end

@implementation LMShowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"作品详情";
    
    _tableView = [[LMCommentsTableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) andShowId: _showId];
    [self.view addSubview:_tableView];
    
    _showDetailView = [[LMShowDetailView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 460)];
    _tableView.tableHeaderView = _showDetailView;

    [LMShowManager asyncLoadShowDetialWithShowId:_showId completionBlock:^(BOOL isSuccess, LMShowDetailModel *showDetail) {
        _showDetail = showDetail;
        NSMutableArray *users = [[NSMutableArray alloc] init];
        for (int i = 0; i<10; i++) {
            LMUserDetailModel *user = [[LMUserDetailModel alloc] init];
            [users addObject:user];
        }
        _showDetail.zanUserList = users;
        _showDetailView.showDetail = _showDetail;
    }];
    
    _inputToolBar = [[LMInputToolBar alloc] initWithFrame:CGRectMake(0, kWindowHeight-49, kWindowWidth, 49)];
    [self.view addSubview:_inputToolBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
