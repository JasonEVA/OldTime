//
//  HMSuperViseHistogramView.m
//  HMClient
//
//  Created by jasonwang on 2017/6/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSuperViseHistogramView.h"
#import "HMEachTestModel.h"

#define GRAPHVIEWHEIGHT       75
#define GRAPHVIEWWIDTH        160
#define LINRDISTANCE          37
#define BOTTOMLINEY              ((GRAPHVIEWHEIGHT-LINRDISTANCE) / 2.0)
#define TOPLINEY           ((GRAPHVIEWHEIGHT+LINRDISTANCE) / 2.0)

@interface HMSuperViseHistogramView ()

@property (nonatomic, strong) NSMutableArray *pointArr;
@property (nonatomic) CGFloat maxTarget;
@property (nonatomic) CGFloat minTarget;

@end

@implementation HMSuperViseHistogramView

- (instancetype)init {
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.pointArr = [NSMutableArray array];
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

    [self.pointArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            // 二维数组
            [obj enumerateObjectsUsingBlock:^(id  _Nonnull pointsObj, NSUInteger pointsIdx, BOOL * _Nonnull stop) {
                HMEachTestModel *model = (HMEachTestModel *)pointsObj;
                UIBezierPath *pathLineOne = [UIBezierPath bezierPath];
                CGPoint point = model.pointValue.CGPointValue;
                [pathLineOne moveToPoint:point];

                [pathLineOne addLineToPoint:CGPointMake(point.x, TOPLINEY)];
                if (model.isMorning) {
                    [[UIColor colorWithHexString:@"67c5f6"] setStroke];
                }
                else {
                    [[UIColor colorWithHexString:@"0f6ba8"] setStroke];
                }
                [pathLineOne setLineWidth:1.5];

                [pathLineOne stroke];

            }];
            
        }
        
    }];
    
    
}

- (CGPoint)acquirePointWithTargetMax:(CGFloat)maxTarget targetMin:(CGFloat)minTarget target:(CGFloat)target count:(NSInteger)count index:(NSInteger)index isLeft:(BOOL)isLeft{
    CGFloat offset = 0;
    if (isLeft) {
        offset = -3;
    }
    else {
        offset = 3;
    }
    return CGPointMake((GRAPHVIEWWIDTH / count) * index + (GRAPHVIEWWIDTH / (count * 2)) + offset, MIN(MAX(((target - minTarget) / (maxTarget - minTarget)) * (BOTTOMLINEY - TOPLINEY) + TOPLINEY, 3), GRAPHVIEWHEIGHT-3));
}

- (void)fillDataWithArr:(NSArray *)array maxTarget:(CGFloat)maxTarget minTarget:(CGFloat)minTarget {
    [self.pointArr removeAllObjects];
    
    self.maxTarget = maxTarget;
    self.minTarget = minTarget;
    __weak typeof(self) weakSelf = self;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        NSArray <HMEachTestModel *>*tempArr = obj;
        [tempArr enumerateObjectsUsingBlock:^(HMEachTestModel * _Nonnull pointobj, NSUInteger pointidx, BOOL * _Nonnull pointstop) {
            pointobj.isMorning = [pointobj.kpiCode isEqualToString:@"NL_SUB_DAY"];
            pointobj.pointValue = [NSValue valueWithCGPoint:[strongSelf acquirePointWithTargetMax:strongSelf.maxTarget targetMin:strongSelf.minTarget target:pointobj.testValue.floatValue count:array.count index:idx isLeft:pointobj.isMorning]];
        }];
        [strongSelf.pointArr addObject:tempArr];
    }];
    
    [self setNeedsDisplay];
}
@end
