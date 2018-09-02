//
//  HMSetpPKMainTableViewCell.h
//  HMClient
//
//  Created by JasonWang on 2017/5/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//  步数PKcell

#import <UIKit/UIKit.h>

@class HMExercisePKModel;
@class HMLoseWeightPkModel;

typedef void(^HMSetpPKMainTableViewCellBlock)(NSInteger ranking);
@interface HMSetpPKMainTableViewCell : UITableViewCell
// 步数排行榜数据源方法
- (void)fillDataWithModel:(HMExercisePKModel *)model ranking:(NSInteger)ranking;

// 点赞回调
- (void)praiseClick:(HMSetpPKMainTableViewCellBlock)block;

// 减肥排行榜数据源方法
- (void)fillLoseWeightDataWithModel:(HMLoseWeightPkModel *)model ranking:(NSInteger)ranking;


@end
