//
//  LMShowDetailModel.m
//  BBLM
//
//  Created by liangpengshuai on 4/13/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import "LMShowDetailModel.h"

@implementation LMShowDetailModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithJson:(id)json
{
    if (self = [super init]) {
        _itemId = [[json objectForKey:@"dynamicId"] integerValue];
        _videoImage = [json objectForKey:@"videoPictureUrl"];
        _videoUrl = [json objectForKey:@"videoUrl"];
        if ([[json objectForKey:@"pictureUrl"] length]) {
            _imageList = [[json objectForKey:@"pictureUrl"] componentsSeparatedByString:@","];
        }
        _heat = [[json objectForKey:@"heat"] integerValue];
        _commentCount = [[json objectForKey:@"commentCount"] integerValue];
        _publishDateDesc = [json objectForKey:@"commitdate"];
        _showDesc = [json objectForKey:@"words"];
        _zanCount = [[json objectForKey:@"praiseCount"] integerValue];
        _hasZan = [[json objectForKey:@"hasPraised"] boolValue];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in [json objectForKey:@"praiseList"]) {
            LMUserDetailModel *user = [[LMUserDetailModel alloc] initWithJson:dic];
            [tempArray addObject:user];
        }
        _zanUserList = tempArray;
        _publishUser = [[LMUserDetailModel alloc] init];
        _publishUser.userId = [[json objectForKey:@"memberId"] integerValue];
        _publishUser.nickname = [json objectForKey:@"nickname"];
        _publishUser.avatar = [json objectForKey:@"portrait"];
        _publishUser.hasFocused = [[json objectForKey:@"hasFocused"] boolValue];
        
        _firstComment = [[LMShowCommentDetail alloc] init];
        _firstComment.commentId = [[json objectForKey:@"firstCommentId"] integerValue];
        _firstComment.user = [[LMUserDetailModel alloc] init];
        _firstComment.user.nickname = [json objectForKey:@"firstCommentNickname"];
        _firstComment.user.avatar = [json objectForKey:@"firstCommentPortrait"];

    }
    return self;
}

- (BOOL)isVideo
{
    if ([_imageList count]) {
        return NO;
    }
    return YES;
}

- (NSString *)coverImage
{
    if (self.isVideo) {
        return _videoImage;
    } else {
        return [_imageList firstObject];
    }
}
@end
