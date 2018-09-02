//
//  HMSEMainStartDashboardCollectionViewCell.m
//  HMClient
//
//  Created by JasonWang on 2017/5/4.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSEMainStartDashboardCollectionViewCell.h"
#import "SEDashboardView.h"
#import "MainStartHealthTargetModel.h"

static CGFloat const JWkCircleRadius = 52;
static CGFloat const JWkCircleWidth = 2;
static CGFloat const JWkBackCircleAngle = M_PI * 4.5 / 3.0;
static CGFloat const JWkHighlightCircleAngle = M_PI * 9.0 / 9.0;

@interface HMSEMainStartDashboardCollectionViewCell ()
@property (nonatomic, strong) SEDashboardView  *dashboardView; // <##>
@property (nonatomic, strong) UILabel *measuredValue; // 测量值
@property (nonatomic, strong) UILabel *measuredName; // 测量名称
@property (nonatomic, strong) UILabel *targetMin; // <##>
@property (nonatomic, strong) UILabel *targetMax; // <##>
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UILabel *unitLb;

@end
@implementation HMSEMainStartDashboardCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_configElements];
    }
    return self;
}

- (void)configTargetData:(MainStartHealthTargetModel *)targetData {
    self.measuredName.text = targetData.subKpiName;
    [self configMeasuredValue:targetData.testValue];
    self.targetMin.text = targetData.targetValue;
    self.targetMax.text = targetData.targetMaxValue;
    [self.unitLb setText:targetData.unit];
    [self.timeLb setText:[self acquireDateString:targetData]];
    if (targetData.testValue.floatValue >= targetData.targetValue.floatValue && targetData.testValue.floatValue <= targetData.targetMaxValue.floatValue) {
        self.measuredValue.textColor = [UIColor colorWithHexString:@"31c9ba"];
        [self.dashboardView.pointerView setHighlighted:NO];
    }
    else {
        self.measuredValue.textColor = [UIColor colorWithHexString:@"f25555"];
        [self.dashboardView.pointerView setHighlighted:YES];
    }
    CGFloat angle = [self p_pointerViewRotateAngleCal:targetData];
    [self.dashboardView animatePointWithAngle:MAX(0, angle)];
}

#pragma mark - Private Method

- (NSString *)acquireDateString:(MainStartHealthTargetModel *)model {
    NSString *date = model.defaultTestTime;
    NSString *tempString = @"";
    NSDate *tempDate = [NSDate dateWithString:date formatString:@"yyyy-MM-dd HH:mm:ss"];
    
    if (!tempDate) {
        tempDate = [NSDate dateWithString:date formatString:@"yyyy-MM-dd"];
    }
    
    if (tempDate.isToday) {
        if ([model.rootKpiCode isEqualToString:@"NL"] || [model.rootKpiCode isEqualToString:@"TZ"]) {
            tempString = @"今天";
        }
        else {
            tempString = [tempDate formattedDateWithFormat:@"HH:mm"];
        }
    }
    else if (tempDate.isYesterday) {
        tempString = @"昨天";
    }
    else {
        tempString = [tempDate formattedDateWithFormat:@"MM/dd"];
    }
    return tempString;
}

- (void)configMeasuredValue:(NSString *)testValue {
    NSInteger testFloat = testValue.length;
    if (testFloat > 4) {
        [self.measuredValue setFont:[UIFont systemFontOfSize:23]];
    }
    else {
        [self.measuredValue setFont:[UIFont systemFontOfSize:31]];

    }
    self.measuredValue.text = testValue;

}
- (void)p_configElements {
    [self.contentView addSubview:self.dashboardView];
    [self.dashboardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];
    [self.dashboardView insertSubview:self.targetMin belowSubview:self.dashboardView.pointerView];
    [self.targetMin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dashboardView.mas_centerY).offset(-(JWkCircleRadius - JWkCircleWidth) * sin(M_PI_2 - JWkHighlightCircleAngle * 0.5));
        make.left.equalTo(self.dashboardView.mas_centerX).offset(-(JWkCircleRadius - JWkCircleWidth) * cos(M_PI_2 - JWkHighlightCircleAngle * 0.5) + 1);
    }];
    [self.dashboardView insertSubview:self.targetMax belowSubview:self.dashboardView.pointerView];
    [self.targetMax mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.targetMin);
        make.right.equalTo(self.dashboardView.mas_centerX).offset((JWkCircleRadius - JWkCircleWidth) * cos(M_PI_2 - JWkHighlightCircleAngle * 0.5) - 1);
    }];
    
    [self.dashboardView insertSubview:self.measuredValue belowSubview:self.dashboardView.pointerView];
    [self.measuredValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.dashboardView);
        make.bottom.equalTo(self.dashboardView.mas_centerY).offset(10);
    }];
    
    [self.dashboardView insertSubview:self.unitLb belowSubview:self.dashboardView.pointerView];
    [self.unitLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dashboardView.mas_centerY).offset(5);
        make.centerX.equalTo(self.dashboardView);
    }];
    
    
    
    [self.contentView addSubview:self.timeLb];
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.dashboardView.mas_bottom).offset(-35);

    }];

    [self.contentView addSubview:self.measuredName];
    [self.measuredName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self.contentView);
        make.right.lessThanOrEqualTo(self.contentView);
    }];
    
    
}

// 指针旋转角度计算
- (CGFloat)p_pointerViewRotateAngleCal:(MainStartHealthTargetModel *)model {
    CGFloat angle = 0;
    // 目标值外一般的角度
    CGFloat outRangeAngle = (JWkBackCircleAngle - JWkHighlightCircleAngle) * 0.5;
    if (model.testValue.floatValue < model.targetValue.floatValue) {
        // 目标最低值以下
        angle = outRangeAngle * ((model.testValue.floatValue - model.itemStartValue.floatValue) / (model.targetValue.floatValue - model.itemStartValue.floatValue));
        angle = MAX(angle, 0.15 * M_PI);
    }
    else if (model.testValue.floatValue >= model.targetValue.floatValue && model.testValue.floatValue <= model.targetMaxValue.floatValue) {
        // 目标值范围
        angle = outRangeAngle + JWkHighlightCircleAngle * (model.testValue.floatValue - model.targetValue.floatValue) / (model.targetMaxValue.floatValue - model.targetValue.floatValue);
    }
    else {
        // 超过目标范围
        angle = outRangeAngle * ((model.testValue.floatValue - model.targetMaxValue.floatValue) / (model.itemEndValue.floatValue - model.targetMaxValue.floatValue)) + outRangeAngle + JWkHighlightCircleAngle;
        angle = MIN(angle, 1.35 * M_PI);

    }
    return angle;
}

#pragma mark - Init
- (SEDashboardView *)dashboardView {
    if (!_dashboardView) {
        _dashboardView = [SEDashboardView new];
        [_dashboardView configCircleRadius:JWkCircleRadius lineWidth:JWkCircleWidth circleBGColcor:[UIColor colorWithHexString:@"f25555"] highlightColor:[UIColor colorWithHexString:@"31c9ba"] maskColor:[UIColor colorWithHexString:@"e7fffd"]];
        [_dashboardView configBackCircleAngle:JWkBackCircleAngle highlightCircleAngle:JWkHighlightCircleAngle];
        [_dashboardView setUserInteractionEnabled:NO];
    }
    return _dashboardView;
}

- (UILabel *)measuredValue {
    if (!_measuredValue) {
        _measuredValue = [UILabel new];
        _measuredValue.font = [UIFont systemFontOfSize:31];
        _measuredValue.textColor = [UIColor commonRedColor];
        _measuredValue.text = @"0";
    }
    return _measuredValue;
}

- (UILabel *)measuredName {
    if (!_measuredName) {
        _measuredName = [UILabel new];
        _measuredName.font = [UIFont systemFontOfSize:15];
        _measuredName.textColor = [UIColor commonTextColor];
        _measuredName.text = @"空腹血糖";
    }
    return _measuredName;
}

- (UILabel *)targetMin {
    if (!_targetMin) {
        _targetMin = [UILabel new];
        _targetMin.font = [UIFont systemFontOfSize:12];
        _targetMin.textColor = [UIColor colorWithHexString:@"666666"];
        _targetMin.text = @"0";
    }
    return _targetMin;
}

- (UILabel *)targetMax {
    if (!_targetMax) {
        _targetMax = [UILabel new];
        _targetMax.font = [UIFont systemFontOfSize:12];
        _targetMax.textColor = [UIColor colorWithHexString:@"666666"];
        _targetMax.text = @"0";
    }
    return _targetMax;
}

- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [UILabel new];
        _timeLb.font = [UIFont systemFontOfSize:12];
        _timeLb.textColor = [UIColor colorWithHexString:@"999999"];
        _timeLb.text = @"04/11";
    }
    return _timeLb;
}
- (UILabel *)unitLb {
    if (!_unitLb) {
        _unitLb = [UILabel new];
        _unitLb.font = [UIFont systemFontOfSize:12];
        _unitLb.textColor = [UIColor colorWithHexString:@"999999"];
        _unitLb.text = @"mmHg";
    }
    return _unitLb;
}

@end
