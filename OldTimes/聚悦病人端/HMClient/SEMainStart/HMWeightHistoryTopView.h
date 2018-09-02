//
//  HMWeightHistoryTopView.h
//  HMClient
//
//  Created by jasonwang on 2017/8/8.
//  Copyright © 2017年 YinQ. All rights reserved.
//  体重历史头部view

#import <UIKit/UIKit.h>

@interface HMWeightHistoryTopView : UIView
typedef void(^AddNextPageBlock)();

@property (nonatomic) NSInteger page;
// 增加数据源
- (void)addDataWithDataList:(NSArray *)dataList maxTarget:(CGFloat)maxTarget minTarget:(CGFloat)minTarget;
// 加载下一页数据回调
- (void)addNextPageAction:(AddNextPageBlock)block;
@end
