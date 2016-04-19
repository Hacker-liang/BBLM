//
//  UploadUserAlbumViewController.h
//  PeachTravel
//
//  Created by liangpengshuai on 9/18/15.
//  Copyright © 2015 com.aizou.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface UploadUserAlbumViewController : UIViewController

@property (nonatomic, strong) NSMutableArray<ALAsset *> *selectedPhotos;   //相册选中的图片

@end


