//
//  HMSuperviseDetailXTYAxisView.m
//  HMClient
//
//  Created by jasonwang on 2017/7/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSuperviseDetailXTYAxisView.h"

#define YAXISWIDTH     50

@interface HMSuperviseDetailXTYAxisView ()
@property (nonatomic, copy) NSArray *pointArr;
@end

@implementation HMSuperviseDetailXTYAxisView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    if (self.pointArr && self.pointArr.count) {
        [self.pointArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSValue *value = (NSValue *)obj;
            CGPoint point = value.CGPointValue;
            UIBezierPath *pathLine = [UIBezierPath bezierPath];
            
            [pathLine moveToPoint:point];
            
            [pathLine addLineToPoint:CGPointMake(self.frame.size.width,point.y)];
            
            [pathLine setLineWidth:1];
            
            CGFloat dashPattern[] = {3,1};// 3实线，1空白
            
            [pathLine setLineDash:dashPattern count:1 phase:1];
            
            [[UIColor colorWithHexString:@"31c9ba"] setStroke];
            
            [pathLine stroke];
        }];
    }
    
}

- (void)fillDataWithMax:(CGFloat)max min:(CGFloat)min {
    CGPoint point78 = [self acquirePointWithTargetMax:max targetMin:min target:7.8];
    CGPoint point61 = [self acquirePointWithTargetMax:max targetMin:min target:6.1];
    CGPoint point39 = [self acquirePointWithTargetMax:max targetMin:min target:3.9];
    self.pointArr = @[[NSValue valueWithCGPoint:point78],[NSValue valueWithCGPoint:point61],[NSValue valueWithCGPoint:point39]];
    
    if (self.subviews && self.subviews.count) {
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }


    UILabel *label78 = [UILabel new];
    [label78 setText:@"7.8"];
    [label78 setFont:[UIFont systemFontOfSize:11]];
    [label78 setTextColor:[UIColor colorWithHexString:@"999999"]];
    
    [self addSubview:label78];
    [label78 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_top).offset(point78.y);
        make.right.equalTo(self.mas_left).offset(YAXISWIDTH - 5);
    }];
    
//    UILabel *label78Text = [UILabel new];
//    [label78Text setText:@"餐后血糖标准"];
//    [label78Text setFont:[UIFont systemFontOfSize:12]];
//    [label78Text setTextColor:[UIColor colorWithHexString:@"333333"]];
//    
//    [self addSubview:label78Text];
//    [label78Text mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).offset(point78.y+3);
//        make.left.equalTo(self).offset(YAXISWIDTH+3);
//    }];
    
    UILabel *label61 = [UILabel new];
    [label61 setText:@"6.1"];
    [label61 setFont:[UIFont systemFontOfSize:11]];
    [label61 setTextColor:[UIColor colorWithHexString:@"999999"]];
    
    [self addSubview:label61];
    [label61 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_top).offset(point61.y);
        make.right.equalTo(self.mas_left).offset(YAXISWIDTH - 5);
    }];
    
//    UILabel *label61Text = [UILabel new];
//    [label61Text setText:@"餐前血糖标准"];
//    [label61Text setFont:[UIFont systemFontOfSize:12]];
//    [label61Text setTextColor:[UIColor colorWithHexString:@"333333"]];
//    
//    [self addSubview:label61Text];
//    [label61Text mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).offset(point61.y+3);
//        make.left.equalTo(self).offset(YAXISWIDTH+3);
//    }];

    UILabel *label39 = [UILabel new];
    [label39 setText:@"3.9"];
    [label39 setFont:[UIFont systemFontOfSize:11]];
    [label39 setTextColor:[UIColor colorWithHexString:@"999999"]];
    
    [self addSubview:label39];
    [label39 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_top).offset(point39.y);
        make.right.equalTo(self.mas_left).offset(YAXISWIDTH - 5);
    }];
//    
//    UILabel *label39Text = [UILabel new];
//    [label39Text setText:@"低血糖标准"];
//    [label39Text setFont:[UIFont systemFontOfSize:12]];
//    [label39Text setTextColor:[UIColor colorWithHexString:@"999999"]];
//    
//    [self addSubview:label39Text];
//    [label39Text mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).offset(point39.y+3);
//        make.left.equalTo(self).offset(YAXISWIDTH+3);
//    }];

    
    
    [self setNeedsDisplay];

}

- (CGPoint)acquirePointWithTargetMax:(CGFloat)maxTarget targetMin:(CGFloat)minTarget target:(CGFloat)target {
    
    return CGPointMake(YAXISWIDTH, MIN(MAX(((target - minTarget) / (maxTarget - minTarget)) * (0 - self.frame.size.height) + self.frame.size.height, 3), self.frame.size.height-3));
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
