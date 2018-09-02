//
//  RadarChartView.m
//  Shape
//
//  Created by Andrew Shen on 15/11/2.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "RadarChartView.h"
#import <Masonry.h>
#import "MuscleModel.h"
#import "RadarChartLayer.h"

@interface RadarChartView()

@property (nonatomic, strong)  RadarChartLayer  *chartLayer; // <##>
@end

@implementation RadarChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.chartLayer = [RadarChartLayer layer];
        self.chartLayer.frame = self.bounds;
        self.chartLayer.contentsScale = [UIScreen mainScreen].scale;
//        [self.chartLayer setNeedsDisplay];
        [self.layer addSublayer:self.chartLayer];
        
    }
    return self;
}

//- (void)updateConstraints {
////    self.chartLayer.bounds = self.bounds;
////    [self.chartLayer setNeedsDisplay];
//
//    [super updateConstraints];
//}

// 设置数据
- (void)setRadarChartViewData:(NSArray<MuscleModel *> *)muscleData {
//    self.chartLayer.frame = self.bounds;
    [self.chartLayer setRadarChartData:muscleData];
}
@end
