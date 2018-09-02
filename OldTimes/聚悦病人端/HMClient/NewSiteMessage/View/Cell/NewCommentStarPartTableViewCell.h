//
//  NewCommentStarPartTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2017/3/6.
//  Copyright © 2017年 YinQ. All rights reserved.
//  新版评价页 评星部分cell

#import <UIKit/UIKit.h>
@class NewCommentEvaluateTagModel;

@interface NewCommentStarPartTableViewCell : UITableViewCell
- (void)fillDataWithArray:(NSArray <NewCommentEvaluateTagModel *>*)array;
@end
