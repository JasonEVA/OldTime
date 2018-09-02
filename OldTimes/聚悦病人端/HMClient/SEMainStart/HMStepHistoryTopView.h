//
//  HMStepHistoryTopView.h
//  HMClient
//
//  Created by jasonwang on 2017/8/4.
//  Copyright © 2017年 YinQ. All rights reserved.
//  步数记录头部view

#import <UIKit/UIKit.h>
#import "HMGroupPKEnum.h"

@class HMStepHistoryModel;

typedef void(^AddNextPageBlock)();
typedef void(^selectedModelBlock)(HMStepHistoryModel *HMStepHistoryModel);
typedef void(^isScrollingBlock)(BOOL isScrolling);

@interface HMStepHistoryTopView : UIView
@property (nonatomic) NSInteger page;
@property (nonatomic) HMGroupPKScreening selectedType;

- (void)addDataWithArray:(NSArray<HMStepHistoryModel *> *)array requstSize:(NSInteger)requstSize;
// 加载下一页数据回调
- (void)addNextPageAction:(AddNextPageBlock)block;
// 选中数据回调
- (void)configTable:(selectedModelBlock)block;
// 是否滚动回调
- (void)scrollCallBack:(isScrollingBlock)block;
// 无数据了调用
- (void)addEmptyData;
@end
