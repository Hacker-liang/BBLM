//
//  LMCommentsTableView.h
//  BBLM
//
//  Created by liangpengshuai on 4/21/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMShowCommentDetail.h"

@protocol LMCommentsTableViewDelegate <NSObject>

- (void)commentTableViewDidScroll:(CGPoint)offset;

@end

@interface LMCommentsTableView : UITableView

- (instancetype)initWithFrame:(CGRect)frame andShowId:(NSInteger)showId;

- (void)addNewComment:(LMShowCommentDetail *)comment;

@property (nonatomic, strong) NSMutableArray *commentsList;

@property (nonatomic, weak) UIViewController *containerCtl;

@property (nonatomic) BOOL hideNickName;   //是否隐藏用户名

@property (nonatomic, weak) id<LMCommentsTableViewDelegate> myDelegate;



@end
