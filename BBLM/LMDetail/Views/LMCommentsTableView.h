//
//  LMCommentsTableView.h
//  BBLM
//
//  Created by liangpengshuai on 4/21/16.
//  Copyright © 2016 com.xuejian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMShowCommentDetail.h"

@interface LMCommentsTableView : UITableView

- (instancetype)initWithFrame:(CGRect)frame andShowId:(NSInteger)showId;

- (void)addNewComment:(LMShowCommentDetail *)comment;

@property (nonatomic, strong) NSMutableArray *commentsList;

@property (nonatomic, weak) UIViewController *containerCtl;


@end
