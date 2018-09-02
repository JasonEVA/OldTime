//
//  HMHistoryCollectBaseTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 2017/1/4.
//  Copyright © 2017年 yinquan. All rights reserved.
//  历史记录收藏 基类cell

#import <UIKit/UIKit.h>

@class MessageBaseModel;
@interface HMHistoryCollectBaseTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *iconView;       //头像
@property (nonatomic, strong) UILabel *nikeNameLb;         //昵称
@property (nonatomic, strong) UILabel *timeLb;             //时间
- (void)setBaseDataWithModel:(MessageBaseModel *)model;
@end
