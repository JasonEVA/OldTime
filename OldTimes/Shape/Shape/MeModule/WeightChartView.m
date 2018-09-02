//
//  WeightChartView.m
//  Shape
//
//  Created by Andrew Shen on 15/11/17.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "WeightChartView.h"
#import "UIColor+Hex.h"
#import "MyDefine.h"
#import "Weight.h"
#import "WeightModel.h"
#import "DateUtil.h"

static CGFloat const kLeftMargin = 35;
static CGFloat const kRightMargin = 17;
static CGFloat const kTopMargin = 63;

static CGFloat const kLineInterval = 54;

static CGFloat const kWordWidth = 30;
static CGFloat const kWordHeight = 20;

static CGFloat const kWeightInterval = 5;

static NSInteger const kLineCount = 4;
static NSInteger const kPeriod = 7;

@interface WeightChartView()
@property (nonatomic, strong)  NSMutableArray<NSDateComponents *>  *arrayDateComponents; // <##>
@property (nonatomic, strong)  NSMutableArray<NSString *>  *arrayYTitles; // <##>
@property (nonatomic, strong)  NSMutableArray  *arrayWeightData; // <##>
@property (nonatomic)  NSInteger  maxWeightNum; // <##>
@property (nonatomic)  CGFloat  weightInterval; // <##>

@end
@implementation WeightChartView

// 设置数据
- (void)setChartDateComponents:(NSArray<NSDateComponents *> *)components weightData:(NSArray<Weight *> *)weightData{
    [self.arrayDateComponents removeAllObjects];
    [self.arrayYTitles removeAllObjects];
    [self.arrayWeightData removeAllObjects];
    
    [self.arrayWeightData addObjectsFromArray:weightData];
    [self.arrayDateComponents addObjectsFromArray:components];
    
    // 计算体重
    [self calWeightTitlesWithWeightData:weightData];
    [self setNeedsDisplay];
}

// 计算体重
- (void)calWeightTitlesWithWeightData:(NSArray<Weight *> *)weightData {
    if (weightData.count > 0) {
        // 计算体重
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"weight" ascending:NO];
        NSArray *arrayTemp = [weightData sortedArrayUsingDescriptors:@[descriptor]];
        // 最大体重和最小体重
        WeightModel *maxWeight = [[WeightModel alloc] initWithEntity:arrayTemp.firstObject];
        WeightModel *minWeight = [[WeightModel alloc] initWithEntity:arrayTemp.lastObject];
        
        self.maxWeightNum = ceilf(maxWeight.weight.floatValue);
        NSInteger minWeightNum = floorf(minWeight.weight.floatValue);
        self.weightInterval = (self.maxWeightNum - minWeightNum) > kWeightInterval * 2 ? (self.maxWeightNum - minWeightNum) * 0.5 : kWeightInterval;
        for (NSInteger i = 0; i < kLineCount - 1; i ++) {
            [self.arrayYTitles addObject:[NSString stringWithFormat:@"%.0f",self.maxWeightNum - self.weightInterval * i]];
        }
    } else {
        [self.arrayYTitles addObjectsFromArray:@[@"55",@"50",@"45"]];
    }

}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGPoint weightUnit = CGPointMake(10, 15);
    NSMutableArray<NSValue *> *arrayStartPoint = [NSMutableArray arrayWithCapacity:kLineCount];
    NSMutableArray<NSValue *> *arrayEndPoint = [NSMutableArray arrayWithCapacity:kLineCount];
    for (NSInteger i = 0; i < kLineCount; i ++) {
        // start
        CGPoint lineStart = CGPointMake(kLeftMargin, kTopMargin + (i == kLineCount - 1 ? kLineInterval * (i - 0.5) : kLineInterval * i));
        [arrayStartPoint addObject:[NSValue valueWithCGPoint:lineStart]];
        // end
        CGPoint lineEnd = CGPointMake(self.frame.size.width - kRightMargin, lineStart.y);
        [arrayEndPoint addObject:[NSValue valueWithCGPoint:lineEnd]];

    }

    CGFloat XLineWidth = self.frame.size.width - kRightMargin - kLeftMargin;
    CGFloat XInterval = XLineWidth / 7.0;
    
    // Y轴
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];//段落样式
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *dictAttributesCN = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize_15],NSForegroundColorAttributeName:[UIColor whiteColor],NSParagraphStyleAttributeName:style};

    [@"体重(公斤)" drawInRect:CGRectMake(weightUnit.x, weightUnit.y, 100, kWordWidth) withAttributes:dictAttributesCN];
    for (NSInteger i = 0; i < kLineCount; i ++) {
        UIBezierPath *line = [UIBezierPath bezierPath];
        if (i < kLineCount - 1) {
            [self.arrayYTitles[i] drawInRect:CGRectMake(arrayStartPoint[i].CGPointValue.x - kWordWidth, arrayStartPoint[i].CGPointValue.y - kWordHeight * 0.5, kWordWidth, kWordHeight) withAttributes:dictAttributesCN];
            [line moveToPoint:arrayStartPoint[i].CGPointValue];
            [line addLineToPoint:arrayEndPoint[i].CGPointValue];
            CGFloat dashPattern[] = {3,1};// 3实线，1空白
            [line setLineDash:dashPattern count:1 phase:1];

        } else {
            [line moveToPoint:arrayStartPoint[i].CGPointValue];
            [line addLineToPoint:arrayEndPoint[i].CGPointValue];
        }
        [[UIColor grayColor] setStroke];
        [line stroke];

    }
    
    // X轴
    NSMutableArray<NSValue *> *arrayXTitlePoint = [NSMutableArray arrayWithCapacity:kPeriod];
    for (NSInteger i = 0; i < kPeriod ; i ++) {
        CGPoint XPoint = CGPointMake(kLeftMargin + XInterval * i, arrayStartPoint.lastObject.CGPointValue.y);
        [arrayXTitlePoint addObject:[NSValue valueWithCGPoint:XPoint]];
    }
    
    // 设置x轴title
    // 今天的日期
    NSDateComponents *todayComp = [DateUtil dateComponentsForDate:[NSDate date]];
    for (NSInteger i = 0; i < self.arrayDateComponents.count; i ++) {
        NSDateComponents *component = self.arrayDateComponents[i];
        
        NSString *title;
        if (i == 0) {
            title = [NSString stringWithFormat:@"%ld/%ld",component.month,component.day];
        } else if (component.day == todayComp.day) {
            title = @"今天";
        } else {
            title = [NSString stringWithFormat:@"%ld",component.day];
        }

        CGPoint point = arrayXTitlePoint[i].CGPointValue;
        if (i == 0) {
            [title drawInRect:CGRectMake(point.x - 30, point.y + 5, 60, kWordHeight) withAttributes:dictAttributesCN];
        } else {
            [title drawInRect:CGRectMake(point.x - 30, point.y + 5, 60, kWordHeight) withAttributes:dictAttributesCN];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:point];
            [path addLineToPoint:CGPointMake(point.x, point.y - 3)];
            [[UIColor grayColor] setStroke];
            [path stroke];

        }

    }
    
    // 曲线
    UIBezierPath *curve = [UIBezierPath bezierPath];
    curve.lineWidth = 2;
    curve.lineCapStyle = kCGLineCapRound;
    curve.lineJoinStyle = kCGLineJoinRound;

    NSDateComponents *firstComp = self.arrayDateComponents.firstObject;
    for (NSInteger i = 0; i < self.arrayWeightData.count; i ++) {
        WeightModel *model = self.arrayWeightData[i];
        NSDateComponents *currentComp = [DateUtil dateComponentsForDate:model.timeStamp];
        CGFloat x = arrayStartPoint.firstObject.CGPointValue.x + (currentComp.day - firstComp.day) * XInterval;
        CGFloat y = arrayStartPoint.firstObject.CGPointValue.y + (self.maxWeightNum - model.weight.floatValue) * (kLineInterval / self.weightInterval);
        CGPoint point = CGPointMake(x , y);
        if (i == 0) {
            [curve moveToPoint:point];
        } else {
            [curve addLineToPoint:point];
        }
        [[UIColor themeOrange_ff5d2b] setStroke];
        [[UIColor themeOrange_ff5d2b] setFill];
        [curve stroke];
        
        // 点
        UIBezierPath *dot = [UIBezierPath bezierPathWithArcCenter:point radius:3 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        [dot fill];

    }

}

- (NSMutableArray *)arrayDateComponents {
    if (!_arrayDateComponents) {
        _arrayDateComponents = [NSMutableArray arrayWithCapacity:kPeriod];
    }
    return _arrayDateComponents;
}

- (NSMutableArray *)arrayYTitles {
    if (!_arrayYTitles) {
        _arrayYTitles = [NSMutableArray arrayWithCapacity:kPeriod];
    }
    return _arrayYTitles;

}

- (NSMutableArray *)arrayWeightData {
    if (!_arrayWeightData) {
        _arrayWeightData = [NSMutableArray arrayWithCapacity:kPeriod];
    }
    return _arrayWeightData;
}
@end
