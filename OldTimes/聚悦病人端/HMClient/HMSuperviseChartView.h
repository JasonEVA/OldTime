//
//  HMSuperviseChartView.h
//  HMClient
//
//  Created by jasonwang on 2017/7/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//  监测详情图表view

#import <UIKit/UIKit.h>
#import "HMSuperviseEnum.h"


typedef void(^AddNextPageBlock)();

@interface HMSuperviseChartView : UIView

@property (nonatomic) NSInteger page;  // 加载页数
@property (nonatomic) SESuperviseScreening selectedScreening;
@property (nonatomic, strong) UICollectionView *collectionView;

- (instancetype)initWithFrame:(CGRect)frame kpiCode:(NSString *)kpiCode;

// 增加数据源
- (void)addDataWithDataList:(NSArray *)dataList maxTarget:(CGFloat)maxTarget minTarget:(CGFloat)minTarget;

// 加载下一页数据回调
- (void)addNextPageAction:(AddNextPageBlock)block;
@end
