//
//  UploadUserAlbumViewController.m
//  PeachTravel
//
//  Created by liangpengshuai on 9/18/15.
//  Copyright © 2015 com.aizou.www. All rights reserved.
//

#import "UploadUserAlbumViewController.h"
#import "UploadUserPhotoOperationView.h"
#import "UploadUserAlbumCollectionViewCell.h"
#import "UserAlbumOverViewTableViewController.h"
#import "UserAlbumPreviewViewController.h"
#import "UploadUserPhotoStatus.h"
#import "UserAlbumManager.h"
#import "LMShowManager.h"

@interface UploadUserAlbumViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UploadUserPhotoOperationView *containterView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic, strong) UIView *locationBgView;
@property (nonatomic, strong) UIButton *locationButton;
@property (nonatomic, strong) UIView *publishBgView;

@property (nonatomic, strong) NSMutableArray *uploadSuccessImageList;   //上传成功的图片

@property (nonatomic, strong) NSMutableArray *userAlbumUploadStatusList;

@end

@implementation UploadUserAlbumViewController

static NSString * const reuseIdentifier = @"uploadPhotoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _library = [[ALAssetsLibrary alloc] init];
    self.navigationItem.title = @"图片发布";
    self.view.backgroundColor = APP_PAGE_COLOR;
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.delegate = self;
    _containterView = [UploadUserPhotoOperationView uploadUserPhotoView];
    CGFloat height = [UploadUserPhotoOperationView heigthWithPhotoCount:_selectedPhotos.count + 1];
    _containterView.frame = CGRectMake(0, 0, self.view.bounds.size.width, height);
    CGFloat scrollViewHeight = height > _scrollView.bounds.size.height ? height : _scrollView.bounds.size.height+1;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, scrollViewHeight+1);

    _containterView.frame = CGRectMake(0, 0, self.view.bounds.size.width, height);
    _containterView.collectionView.dataSource = self;
    _containterView.collectionView.delegate = self;
    [_containterView.collectionView registerNib:[UINib nibWithNibName:@"UploadUserAlbumCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    [_scrollView addSubview:_containterView];
    [self.view addSubview:_scrollView];
    
    /*
    _locationBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_containterView.frame), kWindowWidth, 45)];
    _locationBgView.backgroundColor = [UIColor whiteColor];
    _locationButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 0, kWindowWidth-100, 45)];
    [_locationButton setImage:[UIImage imageNamed:@"icon_publish_location"] forState:UIControlStateNormal];
    [_locationButton addTarget:self action:@selector(changeUserLocation) forControlEvents:UIControlEventTouchUpInside];
    [_locationBgView addSubview:_locationButton];
    [_scrollView addSubview:_locationBgView];
     */
    
    _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_backBtn setTitleColor:COLOR_TEXT_I forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoHasSelected:) name:@"uploadUserAlbumNoti" object:nil];
    
    UIButton *uploadBtn = [[UIButton alloc] initWithFrame:CGRectMake((kWindowWidth-200)/2, 0, 200, 40)];
    [uploadBtn setTitle:@"发布" forState:UIControlStateNormal];
    [uploadBtn setBackgroundImage:[ConvertMethods createImageWithColor:APP_THEME_COLOR] forState:UIControlStateNormal];
    [uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [uploadBtn addTarget:self action:@selector(uploadUserAlbum) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, kWindowWidth, 20)];
    title.text = @"成功发布视频将增加10个辣度,照片增加5个辣度";
    title.textColor = COLOR_TEXT_II;
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:12.0];
    _publishBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_containterView.frame)+20, kWindowWidth, 80)];
    [_publishBgView addSubview:uploadBtn];
    [_publishBgView addSubview:title];
    [_scrollView addSubview:_publishBgView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.containterView.collectionView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)goBack
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定放弃编辑？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert showAlertViewWithBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self dismissCtl];
        } else {
            
        }
    }];
}

- (void)dismissCtl
{
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];

    }
}

- (void)renderContentView
{
    CGFloat height = [UploadUserPhotoOperationView heigthWithPhotoCount:_selectedPhotos.count + 1];
    _containterView.frame = CGRectMake(0, 0, self.view.bounds.size.width, height);
    CGFloat scrollViewHeight = height > _scrollView.bounds.size.height ? height : _scrollView.bounds.size.height+1;
    [_scrollView setContentSize:CGSizeMake(_scrollView.bounds.size.width, scrollViewHeight)];
    [_containterView.collectionView reloadData];

    _publishBgView.frame = CGRectMake(0, CGRectGetMaxY(_containterView.frame)+20, kWindowWidth, 80);
    _uploadSuccessImageList = [[NSMutableArray alloc] initWithCapacity:_selectedPhotos.count];

}

- (NSMutableArray *)userAlbumUploadStatusList
{
    if (!_userAlbumUploadStatusList) {
        _userAlbumUploadStatusList = [[NSMutableArray alloc] init];
    }
    return _userAlbumUploadStatusList;
}

- (void)deleteSelectImages:(UIButton *)sender
{
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [self renderContentView];
}

- (void)uploadUserAlbum
{
    [self.view endEditing:YES];
    if (!_containterView.textView.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入图片描述"];
        return;
    }
    if (_containterView.textView.text.length > 140) {
        [SVProgressHUD showErrorWithStatus:@"描述字数不能多余140个字"];
        return;
    }
    if (!_selectedPhotos.count) {
        [SVProgressHUD showErrorWithStatus:@"抱歉，请您上传图片"];
        return;
    }
    [_userAlbumUploadStatusList removeAllObjects];
    [SVProgressHUD showWithStatus:@"正在上传"];
    
    for (int i = 0; i < _selectedPhotos.count; i++) {
        
        UploadUserPhotoStatus *status = [[UploadUserPhotoStatus alloc] init];
        status.isBegin = YES;
        [_userAlbumUploadStatusList addObject:status];
        
        ALAsset *asset = [_selectedPhotos objectAtIndex:i];
        ALAssetRepresentation* representation = [asset defaultRepresentation];
        CGImageRef ref = [representation fullScreenImage];
        UIImage *uploadImage = [UIImage imageWithCGImage:ref];
        [UserAlbumManager uploadUserAlbumPhoto:uploadImage withPhotoDesc:_containterView.textView.text progress:^(CGFloat progressValue) {
            [self uploadIncrementWithProgress:progressValue itemIndex:i];
            
        } completion:^(BOOL isSuccess, UploadShowImageModel *image) {
            [self uploadCompletion:isSuccess  albumImage:image itemIndex:i];
        }];
    }
}

- (void)uploadIncrementWithProgress:(float)progress itemIndex:(NSInteger)index
{
    UploadUserAlbumCollectionViewCell *cell = (UploadUserAlbumCollectionViewCell *)[_containterView.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    UploadUserPhotoStatus *status = [_userAlbumUploadStatusList objectAtIndex:index];
    status.uploadProgressValue = progress;
    cell.uploadStatus = status;
}


- (void)uploadCompletion:(BOOL)isSuccess albumImage:(UploadShowImageModel *)albumImage itemIndex:(NSInteger)index
{
    UploadUserAlbumCollectionViewCell *cell = (UploadUserAlbumCollectionViewCell *)[_containterView.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    UploadUserPhotoStatus *status = [_userAlbumUploadStatusList objectAtIndex:index];
    status.isFailure = !isSuccess;
    status.isSuccess = isSuccess;
    status.isFinish = YES;
    cell.uploadStatus = status;
    
    if (albumImage) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:albumImage forKey:[NSString stringWithFormat:@"%ld", index]];
        
        [_uploadSuccessImageList addObject:dic];
    }
    
    for (UploadUserPhotoStatus *status in _userAlbumUploadStatusList) {
        if (!status.isFinish) {
            return;
        }
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [_uploadSuccessImageList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSInteger index1 = [((NSDictionary *)obj1).allKeys.firstObject integerValue];
        NSInteger index2 = [((NSDictionary *)obj2).allKeys.firstObject integerValue];
        if (index1 > index2) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    for (NSDictionary *dic in _uploadSuccessImageList) {
        [tempArray addObject:[dic.allValues firstObject]];
    }
    _uploadSuccessImageList = tempArray;
    
    [LMShowManager asyncPublishImageWithImageList:_uploadSuccessImageList desc:_containterView.textView.text completionBlock:^(BOOL isSuccess, NSInteger showId) {
        if (isSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"postNewShow" object:nil];
            [self performSelector:@selector(dismissCtl) withObject:nil afterDelay:0.3];

        } else {
            [SVProgressHUD showErrorWithStatus:@"发布失败"];
        }
    }];
}

- (void)choseMorePhotos
{
    if (_selectedPhotos.count == 9) {
        [SVProgressHUD showErrorWithStatus:@"最多只能选择9张图片"];
        return;
    }
    UIActionSheet *sheetDelegate = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"还可以选择%ld张图片", (5-_selectedPhotos.count)] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    [sheetDelegate showInView:self.view];
}

- (void)photoHasSelected:(NSNotification *)noti
{
    NSMutableArray *selectedPhotos = [noti.userInfo objectForKey:@"images"];
    self.selectedPhotos = [[NSMutableArray alloc] initWithArray:selectedPhotos];
    [self renderContentView];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    
    } else if (buttonIndex == 1) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:_selectedPhotos];
        UserAlbumOverViewTableViewController *ctl = [[UserAlbumOverViewTableViewController alloc] init];
        ctl.selectedPhotos = tempArray;
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:ctl] animated:YES completion:nil];
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UploadUserAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (indexPath.row == _selectedPhotos.count) {
        cell.image = [UIImage imageNamed:@"icon_big_add_photo.png"];
        cell.deleteButton.hidden = YES;
    } else {
        cell.deleteButton.hidden = NO;
        ALAsset *asset = _selectedPhotos[indexPath.row];
        cell.image = [UIImage imageWithCGImage:asset.thumbnail];
        [cell.deleteButton addTarget:self action:@selector(deleteSelectImages:) forControlEvents:UIControlEventTouchUpInside];
        cell.deleteButton.tag = indexPath.row;
    }
    
    if (self.userAlbumUploadStatusList.count >= indexPath.row+1) {
        UploadUserPhotoStatus *status = [_userAlbumUploadStatusList objectAtIndex:indexPath.row];
        cell.uploadStatus = status;
        if (status.isSuccess) {
            cell.deleteButton.hidden = YES;
        } else {
            cell.deleteButton.hidden = NO;
        }
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _selectedPhotos.count) {
        [self choseMorePhotos];
    } else {
        UserAlbumPreviewViewController *ctl = [[UserAlbumPreviewViewController alloc] init];
        ctl.currentIndex = indexPath.row;
        ctl.dataSource = _selectedPhotos;
        ctl.selectedPhotos = self.selectedPhotos;
        [self.navigationController pushViewController: ctl animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if( [picker sourceType] == UIImagePickerControllerSourceTypeCamera )
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [_library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error )
         {
             NSLog(@"IMAGE SAVED TO PHOTO ALBUM");
             [_library assetForURL:assetURL resultBlock:^(ALAsset *asset )
              {
                  [_selectedPhotos addObject:asset];
                  [self renderContentView];
              }
                     failureBlock:^(NSError *error )
              {
                  NSLog(@"Error loading asset");
              }];
         }];
    }


}
@end


