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

@interface UploadUserAlbumViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UploadUserPhotoOperationView *containterView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic, strong) UIView *locationBgView;
@property (nonatomic, strong) UIButton *locationButton;

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
    
    _locationBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_containterView.frame), kWindowWidth, 45)];
    _locationBgView.backgroundColor = [UIColor whiteColor];
    _locationButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 0, kWindowWidth-100, 45)];
    [_locationButton setImage:[UIImage imageNamed:@"icon_publish_location"] forState:UIControlStateNormal];
    [_locationButton addTarget:self action:@selector(changeUserLocation) forControlEvents:UIControlEventTouchUpInside];
    [_locationBgView addSubview:_locationButton];
    [_scrollView addSubview:_locationBgView];
    
    _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_backBtn setTitleColor:COLOR_TEXT_I forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    
    UIButton *uploadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [uploadBtn setTitle:@"上传" forState:UIControlStateNormal];
    [uploadBtn setTitleColor:COLOR_TEXT_I forState:UIControlStateNormal];
    [uploadBtn addTarget:self action:@selector(uploadUserAlbum) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:uploadBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoHasSelected:) name:@"uploadUserAlbumNoti" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.containterView.collectionView reloadData];
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
    _locationBgView.frame = CGRectMake(0, CGRectGetMaxY(_containterView.frame), kWindowWidth, 45);
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
    [_userAlbumUploadStatusList removeAllObjects];
    
    for (int i = 0; i < _selectedPhotos.count; i++) {
        
        UploadUserPhotoStatus *status = [[UploadUserPhotoStatus alloc] init];
        status.isBegin = YES;
        [_userAlbumUploadStatusList addObject:status];
        
        ALAsset *asset = [_selectedPhotos objectAtIndex:i];
        ALAssetRepresentation* representation = [asset defaultRepresentation];
        CGImageRef ref = [representation fullScreenImage];
        UIImage *uploadImage = [UIImage imageWithCGImage:ref];
//        [UserAlbumManager uploadUserAlbumPhoto:uploadImage withPhotoDesc:_containterView.textView.text progress:^(CGFloat progressValue) {
//            [self uploadIncrementWithProgress:progressValue itemIndex:i];
//            
//        } completion:^(BOOL isSuccess, AlbumImageModel *image) {
//            [self uploadCompletion:isSuccess  albumImage:image itemIndex:i];
//        }];
    }
}

- (void)uploadIncrementWithProgress:(float)progress itemIndex:(NSInteger)index
{
    UploadUserAlbumCollectionViewCell *cell = (UploadUserAlbumCollectionViewCell *)[_containterView.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    UploadUserPhotoStatus *status = [_userAlbumUploadStatusList objectAtIndex:index];
    status.uploadProgressValue = progress;
    cell.uploadStatus = status;
}

/*
- (void)uploadCompletion:(BOOL)isSuccess albumImage:(AlbumImageModel *)albumImage itemIndex:(NSInteger)index
{
    if (isSuccess) {
        [[AccountManager shareAccountManager].account.userAlbum insertObject:albumImage atIndex:0];
    }
    UploadUserAlbumCollectionViewCell *cell = (UploadUserAlbumCollectionViewCell *)[_containterView.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    UploadUserPhotoStatus *status = [_userAlbumUploadStatusList objectAtIndex:index];
    status.isFailure = !isSuccess;
    status.isSuccess = isSuccess;
    status.isFinish = YES;
    cell.uploadStatus = status;
    
    for (UploadUserPhotoStatus *status in _userAlbumUploadStatusList) {
        if (!status.isFinish) {
            return;
        }
    }
    [SVProgressHUD showHint:@"上传完成"];
    [_backBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_backBtn removeTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn addTarget:self action:@selector(dismissCtl) forControlEvents:UIControlEventTouchUpInside];
}
*/
- (void)choseMorePhotos
{
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


