//
//  LMPushMessageViewController.m
//  BBLM
//
//  Created by liangpengshuai on 4/15/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMPushMessageViewController.h"
#import "LMPushMessageTableViewCell.h"
#import "LMPushMessageDetailTableViewCell.h"
#import "MyCommentsListViewController.h"
#import "MyZanListViewController.h"
#import "LMMessageListViewController.h"

@interface LMPushMessageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger commentUnreadCnt;
@property (nonatomic) NSInteger zanUnreadCnt;
@property (nonatomic) NSInteger lmbbUnreadCnt;

@end

@implementation LMPushMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = APP_PAGE_COLOR;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = APP_PAGE_COLOR;                                 
    _tableView.separatorColor = COLOR_LINE;
    [_tableView registerNib:[UINib nibWithNibName:@"LMPushMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"LMPushMessageDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellDetail"];
    self.navigationItem.title = @"消息";
    
    [self loadUnreadMessageCount];

}

- (void)loadUnreadMessageCount
{
    NSString *url = [NSString stringWithFormat:@"%@message/count", BASE_API];
    [LMNetworking GET:url parameters:@{@"memberId": [NSNumber numberWithInteger: [LMAccountManager shareInstance].account.userId]} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            _commentUnreadCnt = [[[responseObject objectForKey:@"data"] objectForKey:@"commentUnread"] integerValue];
            _zanUnreadCnt = [[[responseObject objectForKey:@"data"] objectForKey:@"praiseUnread"] integerValue];
            _lmbbUnreadCnt = [[[responseObject objectForKey:@"data"] objectForKey:@"barbieUnread"] integerValue];
            [self.tableView reloadData];
        } else {
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        LMPushMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.contentLabel.text = @"评论";
        if (_commentUnreadCnt>0) {
            cell.unReadCntLabel.text = [NSString stringWithFormat:@"%ld", _commentUnreadCnt];
            cell.unReadCntLabel.hidden = NO;
        } else {
            cell.unReadCntLabel.text = @"1";
            cell.unReadCntLabel.hidden = YES;
            
        }
        cell.headerImageView.image = [UIImage imageNamed:@"icon_pushMessage_comment"];
        return cell;
    }
    if (indexPath.row == 1) {
        LMPushMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.contentLabel.text = @"赞我的";
        if (_zanUnreadCnt>0) {
            cell.unReadCntLabel.text = [NSString stringWithFormat:@"%ld", _zanUnreadCnt];
            cell.unReadCntLabel.hidden = NO;
        } else {
            cell.unReadCntLabel.hidden = YES;
            cell.unReadCntLabel.text = @"";

        }
        cell.headerImageView.image = [UIImage imageNamed:@"icon_pushMessage_zan"];
        return cell;
    }
    if (indexPath.row == 2) {
        LMPushMessageDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellDetail" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.nicknameLabel.text = @"芭比";
        cell.headerImageView.image = [UIImage imageNamed:@"icon_pushMessage_bb"];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        MyCommentsListViewController *ctl = [[MyCommentsListViewController alloc] init];
        _commentUnreadCnt = 0;
        [self.navigationController pushViewController:ctl animated:YES];
        [LMUserManager asyncMakeMessageReadWithUserId:[LMAccountManager shareInstance].account.userId andMessageType:1 completionBlock:^(BOOL isSuccess) {
            
        }];
        
    } else if (indexPath.row == 1) {
        MyZanListViewController *ctl = [[MyZanListViewController alloc] init];
        _zanUnreadCnt = 0;
        [self.navigationController pushViewController:ctl animated:YES];
        [LMUserManager asyncMakeMessageReadWithUserId:[LMAccountManager shareInstance].account.userId andMessageType:2 completionBlock:^(BOOL isSuccess) {
            
        }];
        
    } else {
        LMMessageListViewController *ctl = [[LMMessageListViewController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
        [LMUserManager asyncMakeMessageReadWithUserId:[LMAccountManager shareInstance].account.userId andMessageType:3 completionBlock:^(BOOL isSuccess) {
            
        }];
        
    }

}

@end
