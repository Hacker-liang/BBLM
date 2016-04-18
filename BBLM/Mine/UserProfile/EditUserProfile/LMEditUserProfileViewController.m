//
//  LMEditUserProfileViewController.m
//  BBLM
//
//  Created by liangpengshuai on 4/18/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMEditUserProfileViewController.h"
#import "LMEditUserInfoTableViewCell.h"
#import "LMEditUserAvatarTableViewCell.h"
#import "ZHPickView.h"

@interface LMEditUserProfileViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation LMEditUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = @[@"头像", @"昵称", @"性别", @"孩子年龄", @"星座", @"城市"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.allowsSelection = NO;
    _tableView.separatorColor = COLOR_LINE;
    self.navigationItem.title = @"编辑资料";
    [_tableView registerNib:[UINib nibWithNibName:@"LMEditUserInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"LMEditUserAvatarTableViewCell" bundle:nil] forCellReuseIdentifier:@"avatarcell"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)changeUserInfo:(UIButton *)sender
{
    if (sender.tag == 0) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"上传头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
        sheet.tag = 101;
        [sheet showInView:self.view];
        
    } else if (sender.tag == 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入昵称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *tf = [alertView textFieldAtIndex:0];
        [tf becomeFirstResponder];
        tf.text = _userInfo.nickname;
        [alertView showAlertViewWithBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                
            }
        }];
        
    } else if (sender.tag == 2) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女", nil];
        sheet.tag = 102;
        [sheet showInView:self.view];
        
    } else if (sender.tag == 3) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"输入年龄" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *tf = [alertView textFieldAtIndex:0];
        [tf becomeFirstResponder];
        tf.text = [NSString stringWithFormat:@"%ld", _userInfo.babyAge];
        [alertView showAlertViewWithBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                
            }
        }];
        
    } else if (sender.tag == 4) {
        ZHPickView *pickView = [[ZHPickView alloc] init];
        [pickView setDataViewWithItem:@[@"白羊座",@"金牛座",@"双子座", @"巨蟹座",@"狮子座",@"处女座", @"天秤座",@"天蝎座",@"射手座", @"摩羯座", @"水瓶座", @"双鱼座"] title:@"选择星座"];
        [pickView showPickView:self.navigationController];
        pickView.block = ^(NSString *selectedStr)
        {
        };
       
    } else if (sender.tag == 5) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"输入所在城市" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *tf = [alertView textFieldAtIndex:0];
        [tf becomeFirstResponder];
        tf.text = _userInfo.locationCity;
        [alertView showAlertViewWithBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                
            }
        }];
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        LMEditUserAvatarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"avatarcell" forIndexPath:indexPath];
        cell.headerImageButton.layer.cornerRadius = 32;
        cell.headerImageButton.clipsToBounds = YES;
        [cell.headerImageButton addTarget:self action:@selector(changeUserInfo:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    } else {
        LMEditUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.contentButton.tag = indexPath.row;
        [cell.contentButton addTarget:self action:@selector(changeUserInfo:) forControlEvents:UIControlEventTouchUpInside];
        cell.typeLabel.text = [_dataSource objectAtIndex:indexPath.row];
        if (indexPath.row == 1) {
            [cell.contentButton setTitle:_userInfo.nickname forState:UIControlStateNormal];
        } else if (indexPath.row == 2) {
            [cell.contentButton setTitle:_userInfo.gender forState:UIControlStateNormal];
        } else if (indexPath.row == 3) {
            [cell.contentButton setTitle:[NSString stringWithFormat:@"%ld岁", _userInfo.babyAge] forState:UIControlStateNormal];
        } else if (indexPath.row == 4) {
            [cell.contentButton setTitle:_userInfo.xingzuo forState:UIControlStateNormal];
        } else if (indexPath.row == 5) {
            [cell.contentButton setTitle:_userInfo.locationCity forState:UIControlStateNormal];
        }
        return cell;
    }
    
    
}

@end
