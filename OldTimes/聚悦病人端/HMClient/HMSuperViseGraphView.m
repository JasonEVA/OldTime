//
//  HMSuperViseGraphView.m
//  HMClient
//
//  Created by jasonwang on 2017/6/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSuperViseGraphView.h"
#define GRAPHVIEWHEIGHT       75
#define GRAPHVIEWWIDTH        160
#define LINRDISTANCE          37
#define BOTTOMLINEY              ((GRAPHVIEWHEIGHT-LINRDISTANCE) / 2.0)
#define TOPLINEY           ((GRAPHVIEWHEIGHT+LINRDISTANCE) / 2.0)

@interface HMSuperViseGraphView ()
@property (nonatomic, strong) NSMutableArray *pointArr;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic) CGFloat maxTarget;
@property (nonatomic) CGFloat minTarget;
@property (nonatomic, copy) NSArray *statusArr;
@property (nonatomic, copy) NSArray *colorArr;
@end

@implementation HMSuperViseGraphView

- (instancetype)init {
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.pointArr = [NSMutableArray array];
        self.dataArr = [NSMutableArray array];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *line1 = [UIBezierPath bezierPath];
    
    [line1 moveToPoint:CGPointMake(0,TOPLINEY)];
    
    [line1 addLineToPoint:CGPointMake(GRAPHVIEWWIDTH,TOPLINEY)];
    
    [line1 setLineWidth:1];
    
    CGFloat dashPattern[] = {3,1};// 3实线，1空白
    
    [line1 setLineDash:dashPattern count:1 phase:1];
    
    [[UIColor colorWithHexString:@"dfdfdf"] setStroke];
    
    [line1 stroke];
    
    UIBezierPath *line2 = [UIBezierPath bezierPath];
    
    [line2 moveToPoint:CGPointMake(0,BOTTOMLINEY)];
    
    [line2 addLineToPoint:CGPointMake(GRAPHVIEWWIDTH,BOTTOMLINEY)];
    
    [line2 setLineWidth:1];
    
    
    [line2 setLineDash:dashPattern count:1 phase:1];
    
    [[UIColor colorWithHexString:@"dfdfdf"] setStroke];
    
    [line2 stroke];
    
    [self.pointArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            // 二维数组
            NSArray *temp = obj;
            CGPoint pointOne = [temp.firstObject CGPointValue];
            CGPoint pointTwo = [temp.lastObject CGPointValue];

            // 画线
            UIBezierPath *pathLine = [UIBezierPath bezierPath];
            
            [pathLine moveToPoint:pointOne];
            
            [pathLine addLineToPoint:pointTwo];
            [self.colorArr[[self.statusArr[idx] integerValue]] setStroke];
            [pathLine stroke];
            
            // 画点
            UIBezierPath *pathOne = [UIBezierPath bezierPath];
            
            [pathOne addArcWithCenter:pointOne radius:2 startAngle:0.0 endAngle:180.0 clockwise:YES];
            [pathOne setLineWidth:1.5];
            
            [self.colorArr[[self.statusArr[idx] integerValue]] setStroke];

            [[UIColor whiteColor] setFill];
            [pathOne fill];

            [pathOne stroke];

            
            UIBezierPath *pathTwo = [UIBezierPath bezierPath];
            
            [pathTwo addArcWithCenter:pointTwo radius:2 startAngle:0.0 endAngle:180.0 clockwise:YES];
            [pathTwo setLineWidth:1.5];
            [self.colorArr[[self.statusArr[idx] integerValue]] setStroke];

            [[UIColor whiteColor] setFill];
            [pathTwo fill];
            [pathTwo stroke];
            
            
        }
        else {
            // 一维数组
            CGPoint point = [obj CGPointValue];
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            
            [path addArcWithCenter:point radius:2 startAngle:0.0 endAngle:180.0 clockwise:YES];
            [path setLineWidth:1.5];
            [self.colorArr[[self.statusArr[idx] integerValue]] setStroke];
            
            [[UIColor whiteColor] setFill];
            
            [path stroke];
        }
    }];
    

}

- (CGPoint)acquirePointWithTargetMax:(CGFloat)maxTarget targetMin:(CGFloat)minTarget target:(CGFloat)target count:(NSInteger)count index:(NSInteger)index{
    return CGPointMake((GRAPHVIEWWIDTH / count) * index + (GRAPHVIEWWIDTH / (count * 2)), MIN(MAX(((target - minTarget) / (maxTarget - minTarget)) * (BOTTOMLINEY - TOPLINEY) + TOPLINEY, 3), GRAPHVIEWHEIGHT-3));
}

- (void)fillDataWithArr:(NSArray *)array maxTarget:(CGFloat)maxTarget minTarget:(CGFloat)minTarget statusArr:(NSArray *)statusArr{
    [self.dataArr removeAllObjects];
    [self.pointArr removeAllObjects];
    self.statusArr = statusArr;
    [self.dataArr addObjectsFromArray:array];
    self.maxTarget = maxTarget;
    self.minTarget = minTarget;
    __weak typeof(self) weakSelf = self;
    self.colorArr = @[[UIColor mainThemeColor],[UIColor colorWithHexString:@"ff9c37"]];
    
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat targetFlolt = [obj floatValue];
        [weakSelf.pointArr addObject:[NSValue valueWithCGPoint:[weakSelf acquirePointWithTargetMax:weakSelf.maxTarget targetMin:weakSelf.minTarget target:targetFlolt count:weakSelf.dataArr.count index:idx]]];
    }];
    
    [self setNeedsDisplay];
}


- (void)fillDataWithArrayOne:(NSArray *)arrayOne arrayTwo:(NSArray *)arrayTwo maxTarget:(CGFloat)maxTarget minTarget:(CGFloat)minTarget statusArr:(NSArray *)statusArr{

    if (arrayOne.count != arrayTwo.count || !arrayTwo.count) {
        return;
    }
    [self.dataArr removeAllObjects];
    [self.pointArr removeAllObjects];
    self.statusArr = statusArr;
    __weak typeof(self) weakSelf = self;

    [arrayOne enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.dataArr addObject:@[obj,arrayTwo[idx]]];
    }];
    self.maxTarget = maxTarget;
    self.minTarget = minTarget;
    self.colorArr = @[[UIColor mainThemeColor],[UIColor colorWithHexString:@"ff9c37"]];

    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *temp = obj;
        CGFloat targetOne = [temp.firstObject floatValue];
        CGFloat targetTwo = [temp.lastObject floatValue];
        
        [weakSelf.pointArr addObject:@[[NSValue valueWithCGPoint:[weakSelf acquirePointWithTargetMax:weakSelf.maxTarget targetMin:weakSelf.minTarget target:targetOne count:weakSelf.dataArr.count index:idx]],[NSValue valueWithCGPoint:[weakSelf acquirePointWithTargetMax:weakSelf.maxTarget targetMin:weakSelf.minTarget target:targetTwo count:weakSelf.dataArr.count index:idx]]]];
    }];
    
    [self setNeedsDisplay];

}

- (void)fillFLSZDataWithArr:(NSArray *)array maxTarget:(CGFloat)maxTarget minTarget:(CGFloat)minTarget statusArr:(NSArray *)statusArr {
    [self.dataArr removeAllObjects];
    [self.pointArr removeAllObjects];
    self.statusArr = statusArr;
    [self.dataArr addObjectsFromArray:array];
    self.maxTarget = maxTarget;
    self.minTarget = minTarget;
    __weak typeof(self) weakSelf = self;
    self.colorArr = @[[UIColor colorWithHexString:@"67c5f6"],[UIColor colorWithHexString:@"0f6ba8"],[UIColor colorWithHexString:@"dfdfdf"]];
    
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat targetFlolt = [obj floatValue];
        [weakSelf.pointArr addObject:[NSValue valueWithCGPoint:[weakSelf acquirePointWithTargetMax:weakSelf.maxTarget targetMin:weakSelf.minTarget target:targetFlolt count:weakSelf.dataArr.count index:idx]]];
    }];
    
    [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
