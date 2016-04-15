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

@interface LMPushMessageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
        cell.headerImageView.image = [UIImage imageNamed:@"icon_pushMessage_comment"];
        return cell;
    }
    if (indexPath.row == 1) {
        LMPushMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.contentLabel.text = @"赞我的";
        cell.headerImageView.image = [UIImage imageNamed:@"icon_pushMessage_zan"];
        return cell;
    }
    if (indexPath.row == 2) {
        LMPushMessageDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellDetail" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.contentLabel.text = @"亲爱的芭比用户，恭喜您获得。。。";
        cell.nicknameLabel.text = @"芭比";
        cell.headerImageView.image = [UIImage imageNamed:@"icon_pushMessage_bb"];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
