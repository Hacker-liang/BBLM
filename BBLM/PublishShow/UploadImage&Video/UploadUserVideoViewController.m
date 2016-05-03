//
//  UploadUserVideoViewController.m
//  PeachTravel
//
//  Created by liangpengshuai on 9/18/15.
//  Copyright © 2015 com.aizou.www. All rights reserved.
//

#import "UploadUserVideoViewController.h"
#import "UploadUserPhotoOperationView.h"
#import "UploadUserAlbumCollectionViewCell.h"
#import "UserAlbumOverViewTableViewController.h"
#import "UserAlbumPreviewViewController.h"
#import "UploadUserPhotoStatus.h"
#import "UserAlbumManager.h"
#import "LMShowManager.h"
#import <MediaPlayer/MediaPlayer.h>

@interface UploadUserVideoViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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

@implementation UploadUserVideoViewController

static NSString * const reuseIdentifier = @"uploadPhotoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _library = [[ALAssetsLibrary alloc] init];
    _uploadSuccessImageList = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"视频发布";
    self.view.backgroundColor = APP_PAGE_COLOR;
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.delegate = self;
    _containterView = [UploadUserPhotoOperationView uploadUserPhotoView];
    CGFloat height = [UploadUserPhotoOperationView heigthWithPhotoCount:1];
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
    
    
    UIButton *uploadBtn = [[UIButton alloc] initWithFrame:CGRectMake((kWindowWidth-200)/2, 0, 200, 40)];
    [uploadBtn setTitle:@"发布" forState:UIControlStateNormal];
    [uploadBtn setBackgroundImage:[ConvertMethods createImageWithColor:APP_THEME_COLOR] forState:UIControlStateNormal];
    [uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [uploadBtn addTarget:self action:@selector(uploadUserAlbum) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, kWindowWidth, 20)];
    title.text = @"成功发布视频将增加10个辣度";
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
    CGFloat height = [UploadUserPhotoOperationView heigthWithPhotoCount:1];
    _containterView.frame = CGRectMake(0, 0, self.view.bounds.size.width, height);
    CGFloat scrollViewHeight = height > _scrollView.bounds.size.height ? height : _scrollView.bounds.size.height+1;
    [_scrollView setContentSize:CGSizeMake(_scrollView.bounds.size.width, scrollViewHeight)];
    [_containterView.collectionView reloadData];

    _publishBgView.frame = CGRectMake(0, CGRectGetMaxY(_containterView.frame)+20, kWindowWidth, 80);

}

- (NSMutableArray *)userAlbumUploadStatusList
{
    if (!_userAlbumUploadStatusList) {
        _userAlbumUploadStatusList = [[NSMutableArray alloc] init];
    }
    return _userAlbumUploadStatusList;
}

- (void)uploadUserAlbum
{
    [self.view endEditing:YES];
    if (!_containterView.textView.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入视频描述"];
    }
    [self.userAlbumUploadStatusList removeAllObjects];
    [SVProgressHUD showWithStatus:@"正在上传"];
    
    UploadUserPhotoStatus *status = [[UploadUserPhotoStatus alloc] init];
    status.isBegin = YES;
    [_userAlbumUploadStatusList addObject:status];

    [UserAlbumManager uploadUserVideo:_selectedVideoPath coverImagePath:_selectedVideoCoverPath withDesc:_containterView.textView.text  progress:^(CGFloat progressValue) {
        [self uploadIncrementWithProgress:progressValue itemIndex:0];

    } completion:^(BOOL isSuccess, NSString *videoKey, NSString *coverImageKey) {
        UploadUserAlbumCollectionViewCell *cell = (UploadUserAlbumCollectionViewCell *)[_containterView.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        UploadUserPhotoStatus *status = [_userAlbumUploadStatusList objectAtIndex:0];
        status.isFailure = !isSuccess;
        status.isSuccess = isSuccess;
        status.isFinish = YES;
        cell.uploadStatus = status;
        if (isSuccess) {
            [LMShowManager asyncPublishVidwoWithCoverImageKey:coverImageKey videoKey:videoKey desc:_containterView.textView.text completionBlock:^(BOOL isSuccess, NSInteger showId) {
                if (isSuccess) {
                    [SVProgressHUD showSuccessWithStatus:@"发布成功"];
                    [self performSelector:@selector(dismissCtl) withObject:nil afterDelay:0.3];
                    
                } else {
                    [SVProgressHUD showErrorWithStatus:@"发布失败"];
                }
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"发布失败"];
        }
       

    }];
}

- (void)uploadIncrementWithProgress:(float)progress itemIndex:(NSInteger)index
{
    UploadUserAlbumCollectionViewCell *cell = (UploadUserAlbumCollectionViewCell *)[_containterView.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    UploadUserPhotoStatus *status = [_userAlbumUploadStatusList objectAtIndex:index];
    status.uploadProgressValue = progress;
    cell.uploadStatus = status;
}

- (void)playVideo:(UIButton *)sender
{
    NSURL *url = [NSURL fileURLWithPath: _selectedVideoPath];

    MPMoviePlayerViewController *ctl = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [self presentViewController:ctl animated:YES completion:nil];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UploadUserAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.deleteButton.hidden = YES;
    cell.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:_selectedVideoCoverPath]];
//    for (UIView *views in cell.subviews) {
//        if (views.tag == 101) {
//            [views removeFromSuperview];
//        }
//    }
//    UIButton *playButton = [[UIButton alloc] initWithFrame:cell.bounds];
//    [playButton setImage:[UIImage imageNamed:@"icon_playVideo"] forState:UIControlStateNormal];
//    [playButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
//    [playButton setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]];
//    playButton.tag = 101;
//    [cell addSubview:playButton];
    UploadUserPhotoStatus *status = [_userAlbumUploadStatusList objectAtIndex:indexPath.row];
    cell.uploadStatus = status;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self playVideo:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end


