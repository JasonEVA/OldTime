//
//  NewCommentDetailTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2017/3/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//  新版评价 评价内容详情cell

#import <UIKit/UIKit.h>

@class NewCommentDetailModel;

@interface NewCommentDetailTableViewCell : UITableViewCell
- (void)fillDataWithModel:(NewCommentDetailModel *)model;
@end
