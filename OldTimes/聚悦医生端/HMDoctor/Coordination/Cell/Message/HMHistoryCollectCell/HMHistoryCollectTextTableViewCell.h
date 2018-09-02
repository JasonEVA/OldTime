//
//  HMHistoryCollectTextTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 2017/1/4.
//  Copyright © 2017年 yinquan. All rights reserved.
//  历史记录收藏文本cell

#import "HMHistoryCollectBaseTableViewCell.h"
@class MessageBaseModel;
@interface HMHistoryCollectTextTableViewCell : HMHistoryCollectBaseTableViewCell
- (void)setDataWithModel:(MessageBaseModel *)model;
@end
