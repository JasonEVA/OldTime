//
//  HealthPlanSectionHeaderView.h
//  HMClient
//
//  Created by Andrew Shen on 16/5/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//  健康计划headerview

#import <UIKit/UIKit.h>

@interface HealthPlanSectionHeaderView : UIView

- (void)configSectionHeaderDataWithDate:(NSString *)date todayTaskCount:(NSInteger)todayTaskCount finishedTaskCount:(NSInteger)finishedCount;
@end
