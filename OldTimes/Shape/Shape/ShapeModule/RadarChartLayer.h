//
//  RadarChartLayer.h
//  Shape
//
//  Created by Andrew Shen on 15/11/2.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@class MuscleModel;

@interface RadarChartLayer : CALayer

// 设置数据
- (void)setRadarChartData:(NSArray<MuscleModel *> *)muscleData;
@end
