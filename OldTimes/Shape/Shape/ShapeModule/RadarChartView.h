//
//  RadarChartView.h
//  Shape
//
//  Created by Andrew Shen on 15/11/2.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MuscleModel;
@interface RadarChartView : UIView

// 设置数据
- (void)setRadarChartViewData:(NSArray<MuscleModel *> *)muscleData;
@end
