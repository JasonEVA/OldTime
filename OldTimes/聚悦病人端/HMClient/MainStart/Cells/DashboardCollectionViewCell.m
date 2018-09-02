//
//  DashboardCollectionViewCell.m
//  HMClient
//
//  Created by Andrew Shen on 2016/11/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//  自定义dashboardView

#import "DashboardCollectionViewCell.h"
#import "DashboardView.h"
#import "MainStartHealthTargetModel.h"

static CGFloat const kCircleRadius = 52.5;
static CGFloat const kCircleWidth = 20.0;
static CGFloat const kBackCircleAngle = M_PI * 4.0 / 3.0;
static CGFloat const kHighlightCircleAngle = M_PI * 8.0 / 9.0;

@interface DashboardCollectionViewCell ()
@property (nonatomic, strong)  DashboardView  *dashboardView; // <##>
@property (nonatomic, strong)  UILabel  *measuredValue; // 测量值
@property (nonatomic, strong)  UILabel  *measuredName; // 测量名称
@property (nonatomic, strong)  UILabel  *targetMin; // <##>
@property (nonatomic, strong)  UILabel  *targetMax; // <##>

@end

@implementation DashboardCollectionViewCell

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
    self.measuredValue.text = targetData.testValue;
    self.targetMin.text = targetData.targetValue;
    self.targetMax.text = targetData.targetMaxValue;
    if (targetData.testValue.floatValue >= targetData.targetValue.floatValue && targetData.testValue.floatValue <= targetData.targetMaxValue.floatValue) {
        self.measuredValue.textColor = [UIColor mainThemeColor];
    }
    else {
        self.measuredValue.textColor = [UIColor commonRedColor];
    }
    CGFloat angle = [self p_pointerViewRotateAngleCal:targetData];
    [self.dashboardView animatePointWithAngle:MAX(0, angle)];
}

#pragma mark - Private Method
- (void)p_configElements {
    [self.contentView addSubview:self.dashboardView];
    [self.dashboardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(105, 105));
    }];
    [self.dashboardView insertSubview:self.targetMin belowSubview:self.dashboardView.pointerView];
    [self.targetMin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dashboardView.mas_centerY).offset(-(kCircleRadius - kCircleWidth) * sin(M_PI_2 - kHighlightCircleAngle * 0.5));
        make.left.equalTo(self.dashboardView.mas_centerX).offset(-(kCircleRadius - kCircleWidth) * cos(M_PI_2 - kHighlightCircleAngle * 0.5) + 1);
    }];
    [self.dashboardView insertSubview:self.targetMax belowSubview:self.dashboardView.pointerView];
    [self.targetMax mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.targetMin);
        make.right.equalTo(self.dashboardView.mas_centerX).offset((kCircleRadius - kCircleWidth) * cos(M_PI_2 - kHighlightCircleAngle * 0.5) - 1);
    }];
    
    [self.dashboardView insertSubview:self.measuredValue belowSubview:self.dashboardView.pointerView];
    [self.measuredValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.dashboardView.mas_centerY).offset(10);
    }];
    [self.contentView addSubview:self.measuredName];
    [self.measuredName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.measuredValue.mas_bottom).offset(5);
    }];
}

// 指针旋转角度计算
- (CGFloat)p_pointerViewRotateAngleCal:(MainStartHealthTargetModel *)model {
    CGFloat angle = 0;
    // 目标值外一般的角度
    CGFloat outRangeAngle = (kBackCircleAngle - kHighlightCircleAngle) * 0.5;
    if (model.testValue.floatValue < model.targetValue.floatValue) {
        // 目标最低值以下
        angle = outRangeAngle * ((model.testValue.floatValue - model.itemStartValue.floatValue) / (model.targetValue.floatValue - model.itemStartValue.floatValue));
    }
    else if (model.testValue.floatValue >= model.targetValue.floatValue && model.testValue.floatValue <= model.targetMaxValue.floatValue) {
        // 目标值范围
        angle = outRangeAngle + kHighlightCircleAngle * (model.testValue.floatValue - model.targetValue.floatValue) / (model.targetMaxValue.floatValue - model.targetValue.floatValue);
    }
    else {
        // 超过目标范围
        angle = outRangeAngle * ((model.testValue.floatValue - model.targetMaxValue.floatValue) / (model.itemEndValue.floatValue - model.targetMaxValue.floatValue)) + outRangeAngle + kHighlightCircleAngle;
    }
    return angle;
}

#pragma mark - Init
- (DashboardView *)dashboardView {
    if (!_dashboardView) {
        _dashboardView = [DashboardView new];
        [_dashboardView configCircleRadius:kCircleRadius lineWidth:kCircleWidth circleBGColcor:[UIColor commonRedColor] highlightColor:[UIColor mainThemeColor] maskColor:[UIColor colorWithHexString:@"e7fffd"]];
        [_dashboardView configBackCircleAngle:kBackCircleAngle highlightCircleAngle:kHighlightCircleAngle];
    }
    return _dashboardView;
}

- (UILabel *)measuredValue {
    if (!_measuredValue) {
        _measuredValue = [UILabel new];
        _measuredValue.font = [UIFont font_48];
        _measuredValue.textColor = [UIColor commonRedColor];
        _measuredValue.text = @"0";
    }
    return _measuredValue;
}

- (UILabel *)measuredName {
    if (!_measuredName) {
        _measuredName = [UILabel new];
        _measuredName.font = [UIFont font_30];
        _measuredName.textColor = [UIColor commonTextColor];
        _measuredName.text = @"空腹血糖";
    }
    return _measuredName;
}

- (UILabel *)targetMin {
    if (!_targetMin) {
        _targetMin = [UILabel new];
        _targetMin.font = [UIFont font_20];
        _targetMin.textColor = [UIColor mainThemeColor];
        _targetMin.text = @"0";
    }
    return _targetMin;
}

- (UILabel *)targetMax {
    if (!_targetMax) {
        _targetMax = [UILabel new];
        _targetMax.font = [UIFont font_20];
        _targetMax.textColor = [UIColor mainThemeColor];
        _targetMax.text = @"0";
    }
    return _targetMax;
}


@end
