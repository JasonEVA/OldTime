//
//  NewCommentCollectionTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2017/3/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//  新版评价 标签选择cell

#import <UIKit/UIKit.h>

@class NewCommentSelectLabelModel;

@interface NewCommentCollectionTableViewCell : UITableViewCell
- (void)fillDataWithArray:(NSArray <NewCommentSelectLabelModel *>*)array;
@end
