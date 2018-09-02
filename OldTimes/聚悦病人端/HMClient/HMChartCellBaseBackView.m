//
//  HMChartCellBaseBackView.m
//  HMClient
//
//  Created by jasonwang on 2017/7/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMChartCellBaseBackView.h"

@interface HMChartCellBaseBackView ()
@property (nonatomic) NSInteger YCount;    // Y轴坐标点数量
@property (nonatomic, strong) HMSuperviseDetailModel *model;
@property (nonatomic) BOOL isShowSolidLine;  // 是否展示实线

@property (nonatomic) BOOL isShowRightLine;  // 是否展示右侧实线（最后一个cell展示）

@property (nonatomic) BOOL isShowHorizontalDottedLine;  // 是否展示横向虚线

@property (nonatomic) CGFloat maxTarget;

@property (nonatomic) CGFloat minTarget;

@property (nonatomic) SESuperviseType type;
@end

@implementation HMChartCellBaseBackView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUserInteractionEnabled:NO];
        [self setBackgroundColor:[UIColor clearColor]];
        self.YCount = 11;
    }
    return self;
    
}

- (void)drawRect:(CGRect)rect {

    [self JWBaseForm];
    
    switch (self.type) {
        case SESuperviseType_Common:
        {
            [self JWDrawNPointForm];
            break;
        }
        case SESuperviseType_Pressure:
        {
            [self JWDrawXYForm];
            break;
        }
        case SESuperviseType_Histogram:
        {
            [self JWDrowHistogramForm];
            break;
        }
        case SESuperviseType_PeakVelocity:
        {
            [self JWDrowFLSZForm];
            break;
        }
        case SESuperviseType_BloodGlucose:
        {
            [self JWDrawNPointForm];
            break;
        }
        default:
            break;
    }

    

}

- (void)fillDataWithModel:(HMSuperviseDetailModel *)model maxTarget:(CGFloat)maxTarget minTarget:(CGFloat)minTarget isShowSolidLine:(BOOL)isShowSolidLine isShowRightLinr:(BOOL)isShowRightLine type:(SESuperviseType)type{
    self.type = type;
    self.model = model;
    self.maxTarget = maxTarget;
    self.minTarget = minTarget;
    self.isShowSolidLine = isShowSolidLine;
    self.isShowRightLine = isShowRightLine;
    self.isShowHorizontalDottedLine = type != SESuperviseType_BloodGlucose;
    if (self.type == SESuperviseType_PeakVelocity) {
        // 峰流速值状态箭头
        if (self.subviews.count) {
            [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj removeFromSuperview];
            }];
        }
        __weak typeof(self) weakSelf = self;
        [model.datalist enumerateObjectsUsingBlock:^(HMSuperviseEachPointModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (obj.testResult.length) {
                CGPoint point = [strongSelf acquirePointWithTargetMax:strongSelf.maxTarget targetMin:strongSelf.minTarget target:obj.testValue.floatValue];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_sanjiao_yellow"]];
                [self addSubview:imageView];
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self);
                    make.bottom.equalTo(self.mas_top).offset(point.y-4);
                }];
            }

        }];
        
    }
    [self setNeedsDisplay];
}


- (CGPoint)acquirePointWithTargetMax:(CGFloat)maxTarget targetMin:(CGFloat)minTarget target:(CGFloat)target {
    
    return CGPointMake(self.frame.size.width / 2, MIN(MAX(((target - minTarget) / (maxTarget - minTarget)) * (0 - self.frame.size.height) + self.frame.size.height, 3), self.frame.size.height-3));
}

- (void)JWBaseForm {
    if (!self.isShowSolidLine) {
        UIBezierPath *line1 = [UIBezierPath bezierPath];
        
        [line1 moveToPoint:CGPointMake(0.5,0)];
        
        [line1 addLineToPoint:CGPointMake(0.5,self.frame.size.height)];
        
        [line1 setLineWidth:1];
        
        CGFloat dashPattern[] = {3,1};// 3实线，1空白
        
        [line1 setLineDash:dashPattern count:1 phase:1];
        
        
        [[UIColor colorWithHexString:@"dfdfdf"] setStroke];
        
        [line1 stroke];
    }
    else {
        UIBezierPath *line2 = [UIBezierPath bezierPath];
        
        [line2 moveToPoint:CGPointMake(0.5,0)];
        
        [line2 addLineToPoint:CGPointMake(0.5,self.frame.size.height)];
        
        [line2 setLineWidth:1];
        
        [[UIColor colorWithHexString:@"dfdfdf"] setStroke];
        
        [line2 stroke];
    }
    
    if (self.isShowRightLine) {
        UIBezierPath *line3 = [UIBezierPath bezierPath];
        
        [line3 moveToPoint:CGPointMake(self.frame.size.width - 0.5,0)];
        
        [line3 addLineToPoint:CGPointMake(self.frame.size.width - 0.5,self.frame.size.height)];
        
        [line3 setLineWidth:1];
        
        [[UIColor colorWithHexString:@"dfdfdf"] setStroke];
        
        [line3 stroke];
    }
    
    if (self.YCount > 0 && self.isShowHorizontalDottedLine) {
        CGFloat YheightUnit = self.frame.size.height / self.YCount;
        for (NSInteger i = 0; i < self.YCount; i++) {
            UIBezierPath *pathLine = [UIBezierPath bezierPath];
            
            [pathLine moveToPoint:CGPointMake(0, YheightUnit * (i+1))];
            
            [pathLine addLineToPoint:CGPointMake(self.frame.size.width, YheightUnit * (i+1))];
            
            [pathLine setLineWidth:1];
            CGFloat dashPattern[] = {3,1};// 3实线，1空白
            
            [pathLine setLineDash:dashPattern count:1 phase:1];
            
            [[UIColor colorWithHexString:@"dfdfdf"] setStroke];
            
            [pathLine stroke];
        }
    }
}

- (void)JWDrawXYForm {
    // 二维数组
    CGPoint pointOne = [self acquirePointWithTargetMax:self.maxTarget targetMin:self.minTarget target:self.model.datalist.firstObject.testValue.floatValue];
    CGPoint pointTwo = [self acquirePointWithTargetMax:self.maxTarget targetMin:self.minTarget target:self.model.datalist.lastObject.testValue.floatValue];
    
    // 画线
    UIBezierPath *pathLine = [UIBezierPath bezierPath];
    
    [pathLine moveToPoint:pointOne];
    
    [pathLine addLineToPoint:pointTwo];
    if (!self.model.datalist.firstObject.status && !self.model.datalist.firstObject.status) {
        [[UIColor colorWithHexString:@"3DCABA" alpha:1] setStroke];
    }
    else {
        [[UIColor colorWithHexString:@"ff9c37" alpha:1] setStroke];
    }
    [pathLine stroke];
    
    // 画点
    UIBezierPath *pathOne = [UIBezierPath bezierPath];
    
    [pathOne addArcWithCenter:pointOne radius:2 startAngle:0.0 endAngle:180.0 clockwise:YES];
    [pathOne setLineWidth:1.5];
    if (!self.model.datalist.firstObject.status && !self.model.datalist.firstObject.status) {
        [[UIColor mainThemeColor] setStroke];
    }
    else {
        [[UIColor colorWithHexString:@"ff9c37"] setStroke];
    }
    [[UIColor whiteColor] setFill];
    [pathOne fill];
    
    [pathOne stroke];
    
    
    UIBezierPath *pathTwo = [UIBezierPath bezierPath];
    
    [pathTwo addArcWithCenter:pointTwo radius:2 startAngle:0.0 endAngle:180.0 clockwise:YES];
    [pathTwo setLineWidth:1.5];
    if (!self.model.datalist.firstObject.status && !self.model.datalist.firstObject.status) {
        [[UIColor colorWithHexString:@"3DCABA" alpha:1] setStroke];
    }
    else {
        [[UIColor colorWithHexString:@"ff9c37" alpha:1] setStroke];
    }
    [[UIColor whiteColor] setFill];
    [pathTwo fill];

    [pathTwo stroke];

}

- (void)JWDrawNPointForm {
    [self.model.datalist enumerateObjectsUsingBlock:^(HMSuperviseEachPointModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [self acquirePointWithTargetMax:self.maxTarget targetMin:self.minTarget target:obj.testValue.floatValue];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:point radius:2 startAngle:0.0 endAngle:180.0 clockwise:YES];
        [path setLineWidth:1.5];
        if (obj.status < 1) {
            [[UIColor colorWithHexString:@"3DCABA" alpha:1] setStroke];
        }
        else {
            [[UIColor colorWithHexString:@"ff9c37" alpha:1] setStroke];
        }        [[UIColor whiteColor] setFill];
        
        [path stroke];
    }];
    
   
}

- (void)JWDrowFLSZForm {
    __weak typeof(self) weakSelf = self;
    [self.model.datalist enumerateObjectsUsingBlock:^(HMSuperviseEachPointModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        CGPoint point = [strongSelf acquirePointWithTargetMax:strongSelf.maxTarget targetMin:strongSelf.minTarget target:obj.testValue.floatValue];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:point radius:2 startAngle:0.0 endAngle:180.0 clockwise:YES];
        [path setLineWidth:1.5];
        if (obj.timeStage == 0) {
            //早
            [[UIColor colorWithHexString:@"67c5f6" alpha:1] setStroke];
        }
        else if (obj.timeStage == 1) {
            // 晚
            [[UIColor colorWithHexString:@"0f6ba8" alpha:1] setStroke];

        }
        else {
            // 其他
            [[UIColor colorWithHexString:@"dfdfdf" alpha:1] setStroke];
        }        [[UIColor whiteColor] setFill];
        
        [path stroke];
    }];

}


- (void)JWDrowHistogramForm {
    __block CGPoint pointOne;
    __block CGPoint pointTwo;

    [self.model.datalist enumerateObjectsUsingBlock:^(HMSuperviseEachPointModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.subKpiCode isEqualToString:@"NL_SUB_DAY"] && obj.testValue.floatValue > 0) {
            pointOne = [self acquirePointWithTargetMax:self.maxTarget targetMin:self.minTarget target:obj.testValue.floatValue];
            UIBezierPath *pathLineOne = [UIBezierPath bezierPath];
            [pathLineOne moveToPoint:CGPointMake(pointOne.x-2.5, pointOne.y)];
            
            [pathLineOne addLineToPoint:CGPointMake(pointOne.x - 2.5, self.frame.size.height)];
            
            [[UIColor colorWithHexString:@"67c5f6"] setStroke];
            
            [pathLineOne setLineWidth:2.5];
            
            [pathLineOne stroke];

        }
        if ([obj.subKpiCode isEqualToString:@"NL_SUB_NIGHT"] && obj.testValue.floatValue > 0) {
            pointTwo = [self acquirePointWithTargetMax:self.maxTarget targetMin:self.minTarget target:obj.testValue.floatValue];
            
            UIBezierPath *pathLineTwo = [UIBezierPath bezierPath];
            [pathLineTwo moveToPoint:CGPointMake(pointTwo.x + 2.5, pointTwo.y)];
            
            [pathLineTwo addLineToPoint:CGPointMake(pointTwo.x + 2.5, self.frame.size.height)];
            
            [[UIColor colorWithHexString:@"0f6ba8"] setStroke];
            
            [pathLineTwo setLineWidth:2.5];
            
            [pathLineTwo stroke];
        }
    }];
    

    
   

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
