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
#import "UploadShowImageModel.h"
#import "UserAlbumManager.h"

@interface LMEditUserProfileViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

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
                [[LMAccountManager shareInstance] asyncChangeUserInfoWithChangeType:@"nickname" andChangeContent:tf.text completionBlock:^(BOOL isSuccess) {
                    if (isSuccess) {
                        _userInfo.nickname = tf.text;
                        [_tableView reloadData];
                    }
                }];
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
                [[LMAccountManager shareInstance] asyncChangeUserInfoWithChangeType:@"childAge" andChangeContent:[NSNumber numberWithInt:tf.text.intValue] completionBlock:^(BOOL isSuccess) {
                    if (isSuccess) {
                        _userInfo.babyAge = [tf.text integerValue];
                        [_tableView reloadData];
                    }
                }];
            }
        }];
        
    } else if (sender.tag == 4) {
        ZHPickView *pickView = [[ZHPickView alloc] init];
        [pickView setDataViewWithItem:@[@"白羊座",@"金牛座",@"双子座", @"巨蟹座",@"狮子座",@"处女座", @"天秤座",@"天蝎座",@"射手座", @"摩羯座", @"水瓶座", @"双鱼座"] title:@"选择星座"];
        [pickView showPickView:self.navigationController];
        pickView.block = ^(NSString *selectedStr)
        {
            [[LMAccountManager shareInstance] asyncChangeUserInfoWithChangeType:@"constellation" andChangeContent:selectedStr completionBlock:^(BOOL isSuccess) {
                if (isSuccess) {
                    _userInfo.xingzuo = selectedStr;
                    [_tableView reloadData];
                }
            }];

        };
       
    } else if (sender.tag == 5) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"输入所在城市" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *tf = [alertView textFieldAtIndex:0];
        [tf becomeFirstResponder];
        tf.text = _userInfo.locationCity;
        [alertView showAlertViewWithBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [[LMAccountManager shareInstance] asyncChangeUserInfoWithChangeType:@"city" andChangeContent:tf.text completionBlock:^(BOOL isSuccess) {
                    if (isSuccess) {
                        _userInfo.locationCity = tf.text;
                        [_tableView reloadData];
                    }
                }];

            }
        }];
        
    }
}

- (void)uploadIncrementWithProgress:(float)progress itemIndex:(NSInteger)index
{
    
}


- (void)uploadCompletion:(BOOL)isSuccess albumImage:(UploadShowImageModel *)albumImage itemIndex:(NSInteger)index
{
}

#pragma mark - UITableViewDataSource

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
        [cell.headerImageButton sd_setImageWithURL:[NSURL URLWithString:_userInfo.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar_default"]];
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
            [cell.contentButton setTitle:_userInfo.genderDesc forState:UIControlStateNormal];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *headerImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [UserAlbumManager uploadUserAlbumPhoto:headerImage withPhotoDesc:nil progress:^(CGFloat progressValue) {
        [SVProgressHUD showProgress:progressValue status:@"正在上传"];
        NSLog(@"%f", progressValue);
        
    } completion:^(BOOL isSuccess, UploadShowImageModel *image) {
        if (isSuccess) {
            [[LMAccountManager shareInstance] asyncChangeUserInfoWithChangeType:@"portrait" andChangeContent:image.imageId completionBlock:^(BOOL isSuccess) {
                if (isSuccess) {
                    LMEditUserAvatarTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    [cell.headerImageButton setImage:headerImage forState:UIControlStateNormal];
                }
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"修改失败"];
        }
        
    }];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 101) {  //选择上传头像方式
        UIImagePickerControllerSourceType sourceType;

        if (buttonIndex == 0) {
            sourceType  = UIImagePickerControllerSourceTypeCamera;
        } else if (buttonIndex == 1) {
            sourceType  = UIImagePickerControllerSourceTypePhotoLibrary;
        } else {
            return;
        }
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
        
    } else if (actionSheet.tag == 102) {  //选择性别
        [[LMAccountManager shareInstance] asyncChangeUserInfoWithChangeType:@"sex" andChangeContent:[NSNumber numberWithInteger:buttonIndex+1] completionBlock:^(BOOL isSuccess) {
            if (isSuccess) {
                _userInfo.gender = buttonIndex+1;
                [_tableView reloadData];
            }
        }];
    }
}

@end
