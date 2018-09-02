//
//  RadarChartLayer.m
//  Shape
//
//  Created by Andrew Shen on 15/11/2.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "RadarChartLayer.h"
#import "UIColor+Hex.h"
#import "MyDefine.h"
#import "RadarGradientLayer.h"
#import "MuscleModel.h"


@interface RadarChartLayer()
@property (nonatomic, strong)  CAShapeLayer  *pathLayer;
@property (nonatomic, strong)  RadarGradientLayer  *gradientLayer;
@property (nonatomic)  NSInteger  maxScore; // 最大锻炼得分
@property (nonatomic, strong)  NSMutableDictionary<NSString * , NSNumber *>  *dictData; // <##>
@property (nonatomic, strong)  NSDictionary<NSString *, UIBezierPath *>  *dictDots; // <##>

@property (nonatomic)  CGFloat  sinValue; // <##>
@property (nonatomic)  CGFloat  radius; // <##>
@property (nonatomic)  CGFloat  outerRadius; // <##>

@end
@implementation RadarChartLayer


- (void)drawInContext:(CGContextRef)ctx {
    UIGraphicsPushContext(ctx);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // points
    CGPoint pointShoulder = CGPointMake(self.position.x - self.outerRadius, self.position.y); // 肩
    CGPoint pointChest = CGPointMake(self.position.x + self.outerRadius, self.position.y); // 胸
    CGPoint pointBack = CGPointMake(self.position.x - self.sinValue, self.position.y - self.sinValue); // 背
    CGPoint pointAbdominal = CGPointMake(self.position.x + self.sinValue, self.position.y + self.sinValue); // 腹肌
    CGPoint pointCalf = CGPointMake(self.position.x + self.sinValue, self.position.y - self.sinValue); // 小腿
    CGPoint pointArm = CGPointMake(self.position.x - self.sinValue, self.position.y + self.sinValue);// 上臂
    CGPoint pointTopY = CGPointMake(self.position.x, self.position.y - self.outerRadius); // y
    CGPoint pointThigh = CGPointMake(self.position.x, self.position.y + self.outerRadius); // 大腿
    
    UIBezierPath *dotShoulder = [UIBezierPath bezierPathWithArcCenter:pointShoulder radius:2.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];  // 肩
    UIBezierPath *dotChest = [UIBezierPath bezierPathWithArcCenter:pointChest radius:2.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];  // 胸
    UIBezierPath *dotBack = [UIBezierPath bezierPathWithArcCenter:pointBack radius:2.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];  // 背
    UIBezierPath *dotAbdominal = [UIBezierPath bezierPathWithArcCenter:pointAbdominal radius:2.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES]; // 腹肌
    UIBezierPath *dotCalf = [UIBezierPath bezierPathWithArcCenter:pointCalf radius:2.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES]; // 小腿
    UIBezierPath *dotArm = [UIBezierPath bezierPathWithArcCenter:pointArm radius:2.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES]; // 上臂
    UIBezierPath *dotThigh = [UIBezierPath bezierPathWithArcCenter:pointThigh radius:2.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES]; // 大腿
    NSArray *arrayMuscles = @[@"上臂",@"小腿",@"胸",@"肩",@"背",@"大腿",@"腹肌"];
    NSArray *dots = @[dotArm,dotCalf,dotChest,dotShoulder,dotBack,dotThigh,dotAbdominal];
    self.dictDots = [NSDictionary dictionaryWithObjects:dots forKeys:arrayMuscles];
    // bg
    UIBezierPath *circleBG = [UIBezierPath bezierPathWithArcCenter:self.position radius:self.radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [[UIColor colorLightBlack_2e2e2e] setFill];
    [circleBG fill];

    // circles
    UIBezierPath *circleA = [UIBezierPath bezierPathWithArcCenter:self.position radius:self.radius * 0.25 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    UIBezierPath *circleB = [UIBezierPath bezierPathWithArcCenter:self.position radius:self.radius * 0.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    UIBezierPath *circleC = [UIBezierPath bezierPathWithArcCenter:self.position radius:self.radius * 0.75 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    UIBezierPath *circleD = [UIBezierPath bezierPathWithArcCenter:self.position radius:self.outerRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    circleD.lineWidth = 5.0;

    // lines
    UIBezierPath *lineA = [UIBezierPath bezierPath];
    [lineA moveToPoint:pointShoulder];
    [lineA addLineToPoint:pointChest];
    
    UIBezierPath *lineB = [UIBezierPath bezierPath];
    [lineB moveToPoint:pointBack];
    [lineB addLineToPoint:pointAbdominal];
    
    UIBezierPath *lineC = [UIBezierPath bezierPath];
    [lineC moveToPoint:pointTopY];
    [lineC addLineToPoint:pointThigh];
    
    UIBezierPath *lineD = [UIBezierPath bezierPath];
    [lineD moveToPoint:pointCalf];
    [lineD addLineToPoint:pointArm];
    
    // stroke & fill


    [[UIColor lineDarkGray_4e4e4e] setStroke];
    [circleA stroke];
    [circleB stroke];
    [circleC stroke];
    [lineA stroke];
    [lineB stroke];
    [lineC stroke];
    [lineD stroke];
    [[UIColor colorWithR:146 g:118 b:110 alpha:0.3] setStroke];
    [circleD stroke];
    
    

    [[UIColor greenColor] setFill];
    [dotShoulder fill];
    [dotChest fill];
    [dotBack fill];
    [dotAbdominal fill];
    [dotCalf fill];
    [dotArm fill];
    [dotThigh fill];

    // 文字
    CGSize sizeNum = CGSizeMake(30, 12);
    CGSize sizeCN = CGSizeMake(35, 20);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];//段落样式
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *dictAttributesNum = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize_12],NSForegroundColorAttributeName:[UIColor colorLightGray_898888],NSParagraphStyleAttributeName:style};
    NSDictionary *dictAttributesCN = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize_15],NSForegroundColorAttributeName:[UIColor whiteColor],NSParagraphStyleAttributeName:style};

    [@"25" drawInRect:CGRectMake(self.position.x - 15, self.position.y - self.radius * 0.25, sizeNum.width,sizeNum.height) withAttributes:dictAttributesNum];
    [@"50" drawInRect:CGRectMake(self.position.x - 15, self.position.y - self.radius * 0.5, sizeNum.width,sizeNum.height) withAttributes:dictAttributesNum];
    [@"75" drawInRect:CGRectMake(self.position.x - 15, self.position.y - self.radius * 0.75, sizeNum.width,sizeNum.height) withAttributes:dictAttributesNum];
    [@"100" drawInRect:CGRectMake(self.position.x - 15, self.position.y - self.radius, sizeNum.width,sizeNum.height) withAttributes:dictAttributesNum];
    
    [@"肩" drawInRect:CGRectMake(pointShoulder.x - 35, pointShoulder.y - 10, sizeCN.width,sizeCN.height) withAttributes:dictAttributesCN];
    [@"胸" drawInRect:CGRectMake(pointChest.x, pointChest.y - 10, sizeCN.width,sizeCN.height) withAttributes:dictAttributesCN];
    [@"背" drawInRect:CGRectMake(pointBack.x - 35, pointBack.y - 20, sizeCN.width,sizeCN.height) withAttributes:dictAttributesCN];
    [@"腹肌" drawInRect:CGRectMake(pointAbdominal.x + 2, pointAbdominal.y, sizeCN.width,sizeCN.height) withAttributes:dictAttributesCN];
    [@"大腿" drawInRect:CGRectMake(pointThigh.x - 17.5, pointThigh.y + 5, sizeCN.width,sizeCN.height) withAttributes:dictAttributesCN];
    [@"小腿" drawInRect:CGRectMake(pointCalf.x + 2, pointCalf.y - 20, sizeCN.width,sizeCN.height) withAttributes:dictAttributesCN];
    [@"上臂" drawInRect:CGRectMake(pointArm.x - 35, pointArm.y, sizeCN.width,sizeCN.height) withAttributes:dictAttributesCN];

    [self drawLines:context];
    CGContextSaveGState(context);
    CGContextRestoreGState(context);
    UIGraphicsPopContext();
}

- (void)drawLines:(CGContextRef)context {
    
    // 测试数据
    /*
//    CGPoint pointShoulder = CGPointMake(self.position.x - 140 * 0.4, self.position.y); // 肩
    CGPoint pointShoulder = CGPointMake(self.position.x, self.position.y); // 肩

    CGPoint pointChest = CGPointMake(self.position.x + 140 * 0.7, self.position.y); // 胸
    CGPoint pointBack = CGPointMake(self.position.x - [self sinValue:0.6], self.position.y - [self sinValue:0.6]); // 背
    CGPoint pointAbdominal = CGPointMake(self.position.x + [self sinValue:0.9], self.position.y + [self sinValue:0.9]); // 腹肌
//    CGPoint pointCalf = CGPointMake(self.position.x + [self sinValue:0.5], self.position.y - [self sinValue:0.5]); // 小腿
    CGPoint pointCalf = CGPointMake(self.position.x + [self sinValue:1], self.position.y - [self sinValue:1]); // 小腿

    CGPoint pointArm = CGPointMake(self.position.x - [self sinValue:0.8], self.position.y + [self sinValue:0.8]);// 上臂
    CGPoint pointThigh = CGPointMake(self.position.x, self.position.y + 140 * 0.45); // 大腿
    */

    // 真实数据
    CGPoint pointShoulder = CGPointMake(self.position.x - self.radius * [self percentageWithMuscleName:@"肩"], self.position.y); // 肩
    CGPoint pointChest = CGPointMake(self.position.x + self.radius * [self percentageWithMuscleName:@"胸"], self.position.y); // 胸
    CGPoint pointBack = CGPointMake(self.position.x - [self sinValue:[self percentageWithMuscleName:@"背"]], self.position.y - [self sinValue:[self percentageWithMuscleName:@"背"]]); // 背
    CGPoint pointAbdominal = CGPointMake(self.position.x + [self sinValue:[self percentageWithMuscleName:@"腹肌"]], self.position.y + [self sinValue:[self percentageWithMuscleName:@"腹肌"]]); // 腹肌
    CGPoint pointCalf = CGPointMake(self.position.x + [self sinValue:[self percentageWithMuscleName:@"小腿"]], self.position.y - [self sinValue:[self percentageWithMuscleName:@"小腿"]]); // 小腿
    CGPoint pointArm = CGPointMake(self.position.x - [self sinValue:[self percentageWithMuscleName:@"上臂"]], self.position.y + [self sinValue:[self percentageWithMuscleName:@"上臂"]]);// 上臂
    CGPoint pointThigh = CGPointMake(self.position.x, self.position.y + self.radius * [self percentageWithMuscleName:@"大腿"]); // 大腿
 
    
    UIBezierPath *line = [UIBezierPath bezierPath];
    [line moveToPoint:pointShoulder];
    [line addLineToPoint:pointBack];
    [line addLineToPoint:pointCalf];
    [line addLineToPoint:pointChest];
    [line addLineToPoint:pointAbdominal];
    [line addLineToPoint:pointThigh];
    [line addLineToPoint:pointArm];
    [line closePath];
    line.lineWidth = 1.0;

    self.pathLayer.frame = self.bounds;
    self.pathLayer.path = line.CGPath;
    self.pathLayer.strokeColor = [[UIColor whiteColor] CGColor];
    self.pathLayer.fillColor = nil;
    self.pathLayer.lineWidth = 2.5;
    [self.pathLayer setEdgeAntialiasingMask:kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge];
    [self addSublayer:self.pathLayer];
    
    [self.gradientLayer setFrame:self.bounds];
    [self.gradientLayer setMask:self.pathLayer];
    [self addSublayer:self.gradientLayer];
    
    // 设置点的颜色
    [[self colorOfPoint:pointShoulder] setFill];
    [self.dictDots[@"肩"] fill];
    [[self colorOfPoint:pointChest] setFill];
    [self.dictDots[@"胸"] fill];
    [[self colorOfPoint:pointBack] setFill];
    [self.dictDots[@"背"] fill];
    [[self colorOfPoint:pointAbdominal] setFill];
    [self.dictDots[@"腹肌"] fill];
    [[self colorOfPoint:pointCalf] setFill];
    [self.dictDots[@"小腿"] fill];
    [[self colorOfPoint:pointArm] setFill];
    [self.dictDots[@"上臂"] fill];
    [[self colorOfPoint:pointThigh] setFill];
    [self.dictDots[@"大腿"] fill];

}

#pragma mark - Private Method
- (CGFloat)sinValue:(CGFloat)percentage {
    return [self lineLength:percentage] * sin(M_PI * 45.0 / 180.0);
}

- (CGFloat)lineLength:(CGFloat)percentage {
    return percentage * self.radius;
}

- (CGFloat)pointIncrement:(CGFloat)percentage {
    return [self lineLength:percentage] * tan(M_PI * 0.15 * 45.0 / 180.0) * sin(M_PI * 45.0 / 180.0);
}

- (CGFloat)percentageWithMuscleName:(NSString *)muscleName {
    CGFloat percentage = self.maxScore > 0 ? (CGFloat)self.dictData[muscleName].integerValue / (CGFloat)self.maxScore : 0;
    return percentage;
}
// 获取某个点的颜色
- (UIColor *)colorOfPoint:(CGPoint)point {
    return [self.gradientLayer colorOfPoint:point];
}

#pragma mark - Interface Method
// 设置数据
- (void)setRadarChartData:(NSArray<MuscleModel *> *)muscleData {
    // 置零初始化
    self.maxScore = 0;
    [self.dictData removeAllObjects];
    for (MuscleModel *model in muscleData) {
        self.maxScore = self.maxScore < model.score.integerValue ? model.score.integerValue : self.maxScore;
        self.dictData[model.muscleName] = model.score;
    }
    [self setNeedsDisplay];
}

#pragma mark - Init

- (CAShapeLayer *)pathLayer
{
    if (!_pathLayer)
    {
        _pathLayer = [CAShapeLayer layer];
    }
    return _pathLayer;
}

- (CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer)
    {
        _gradientLayer = [RadarGradientLayer layer];
        [_gradientLayer setNeedsDisplay];
    }
    return _gradientLayer;
}

- (NSMutableDictionary *)dictData {
    if (!_dictData) {
        _dictData = [NSMutableDictionary dictionaryWithCapacity:7];
    }
    return _dictData;
}

- (CGFloat)sinValue {
    return (self.outerRadius) * sin(M_PI * 45.0 / 180.0);
}

- (CGFloat)radius {
    return [UIScreen mainScreen].bounds.size.width * 0.38;
}

- (CGFloat)outerRadius {
    return self.radius + 2.5;
}
@end
