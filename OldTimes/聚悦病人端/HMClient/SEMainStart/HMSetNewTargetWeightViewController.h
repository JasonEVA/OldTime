//
//  HMSetNewTargetWeightViewController.h
//  HMClient
//
//  Created by jasonwang on 2017/8/10.
//  Copyright © 2017年 YinQ. All rights reserved.
//  设置理想体重vc

#import "HMBasePageViewController.h"
#import "HMGroupPKEnum.h"

@interface HMSetNewTargetWeightViewController : HMBasePageViewController

- (instancetype)initWithType:(HMGroupPKSetTatgetWeightStep)type nowWeight:(CGFloat)nowWeight;

@property (nonatomic) CGFloat selectedTarget;     // 理想体重
@property (nonatomic) CGFloat selectedNowHeight;  // 当前身高
@property (nonatomic) CGFloat selectedNowWeight;  // 当前体重

@end
