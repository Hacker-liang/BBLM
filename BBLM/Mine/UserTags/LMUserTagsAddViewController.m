//
//  LMUserTagsAddViewController.m
//  BBLM
//
//  Created by liangpengshuai on 4/15/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMUserTagsAddViewController.h"
#import "LMUserSetTagTableViewCell.h"
#import "InputTagTableViewCell.h"
#import "HotTagTableViewCell.h"

@interface LMUserTagsAddViewController () <UITableViewDataSource, UITableViewDelegate, LMUserSetTagTableViewCellDelegate, HotTagTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *hotTagsList;
@property (strong, nonatomic) NSMutableArray *selectedTagsList;

@end

@implementation LMUserTagsAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"标签设置";
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = COLOR_LINE;
    _hotTagsList = [@[@"90后", @"辣妹子", @"测试数据", @"90后", @"辣妹子", @"测试数据", @"90后", @"辣妹子", @"测试数据", @"90后", @"辣妹子", @"测试数据"] mutableCopy];

    [self.tableView registerNib:[UINib nibWithNibName:@"LMUserSetTagTableViewCell" bundle:nil] forCellReuseIdentifier:@"grabSetTagCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"InputTagTableViewCell" bundle:nil] forCellReuseIdentifier:@"inputTagCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HotTagTableViewCell" bundle:nil] forCellReuseIdentifier:@"hotTagCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUserInfo:(LMUserDetailModel *)userInfo
{
    _userInfo = userInfo;
    _selectedTagsList = [_userInfo.userTags mutableCopy];
}

- (void)addTagAction:(UIButton *)btn
{
    InputTagTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    if (cell.textField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"输入的标签不能为空"];
        return;
    }
    [self addUserTag:cell.textField.text];
    cell.textField.text = @"";
    [cell.textField resignFirstResponder];
}

- (void)addUserTag:(NSString *)tag
{
    [[LMAccountManager shareInstance] asyncAddUserTag:tag completionBlock:^(BOOL isSuccess, NSString *errorStr) {
        if (isSuccess) {
            for (NSString *temp in _selectedTagsList) {
                if ([temp isEqualToString:tag]) {
                    [_selectedTagsList removeObject:temp];
                    break;
                }
            }
            [_selectedTagsList addObject:tag];
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            _userInfo.userTags = _selectedTagsList;
            [_tableView reloadData];
        } else {
            if (errorStr) {
                [SVProgressHUD showErrorWithStatus:errorStr];
            } else {
                [SVProgressHUD showErrorWithStatus:@"添加失败"];
            }
        }
    }];
}

- (void)deleteUserTag:(NSString *)tag
{
    [[LMAccountManager shareInstance] asyncDeleteUserTag:tag completionBlock:^(BOOL isSuccess, NSString *errorStr) {
        if (isSuccess) {
            for (NSString *temp in _selectedTagsList) {
                if ([temp isEqualToString:tag]) {
                    [_selectedTagsList removeObject:temp];
                    break;
                }
            }
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            _userInfo.userTags = _selectedTagsList;
            [_tableView reloadData];

        } else {
            if (errorStr) {
                [SVProgressHUD showErrorWithStatus:errorStr];
            } else {
                [SVProgressHUD showErrorWithStatus:@"删除失败"];
            }
            
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [LMUserSetTagTableViewCell heigthOfCellWithDataSource:_selectedTagsList];
    } else if (indexPath.section == 1) {
        return 95.0;
        
    } else if (indexPath.section == 2){
        return [HotTagTableViewCell heigthOfCellWithDataSource:_hotTagsList];
    } else {
        return 44.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        LMUserSetTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"grabSetTagCell" forIndexPath:indexPath];
        cell.dataSource = _selectedTagsList;
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section == 1) {
        InputTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inputTagCell" forIndexPath:indexPath];
        [cell.addBtn addTarget:self action:@selector(addTagAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    } else {
        HotTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotTagCell" forIndexPath:indexPath];
        cell.dataSource = _hotTagsList;
        cell.delegate = self;
        return cell;
    }
}

#pragma mark - LMUserSetTagTableViewCellDelegate

- (void)setTagDidSelectItemAtIndex:(NSIndexPath *)indexPath
{
    [self deleteUserTag:[_selectedTagsList objectAtIndex:indexPath.row]];
    
}

#pragma mark - HotTagTableViewCellDelegate
- (void)hotTagDidSelectItemAtIndex:(NSIndexPath *)indexPath
{
    [self addUserTag:[_hotTagsList objectAtIndex:indexPath.row]];
}

@end
