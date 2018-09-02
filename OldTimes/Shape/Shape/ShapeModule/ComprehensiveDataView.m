//
//  ComprehensiveDataView.m
//  Shape
//
//  Created by Andrew Shen on 15/10/22.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "ComprehensiveDataView.h"
#import "UILabel+EX.h"
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "MuscleModel.h"

@interface ComprehensiveDataView()
@property (nonatomic, strong)  UILabel  *consumeTitle;          // 消耗标题
@property (nonatomic, strong)  UILabel  *consumeValue;          // 消耗值
@property (nonatomic, strong)  UILabel  *acountTitle;           // 训练次数标题
@property (nonatomic, strong)  UILabel  *acountValue;           // 训练次数值
@property (nonatomic, strong)  UILabel  *gradeTitle;            // 评分标题
@property (nonatomic, strong)  UILabel  *gradeValue;            // 评分耗值


@end
@implementation ComprehensiveDataView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configElements];
    }
    return self;
}

// 设置元素控件
- (void)configElements {
    [self addSubview:self.consumeTitle];
    [self addSubview:self.consumeValue];
    [self addSubview:self.acountTitle];
    [self addSubview:self.acountValue];
    [self addSubview:self.gradeTitle];
    [self addSubview:self.gradeValue];
    [self configConstraints];
}

- (void)configConstraints {
    [self.consumeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
    }];
    [self.consumeValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.consumeTitle);
        make.left.equalTo(self.consumeTitle.mas_right).offset(5).priority(250);
        make.left.greaterThanOrEqualTo(self.consumeTitle.mas_right).priority(200);
        make.right.lessThanOrEqualTo(self.acountTitle.mas_left).offset(-10).priority(260);
    }];
    [self.acountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.consumeTitle);
    }];
    
    [self.acountValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.consumeTitle);
        make.left.equalTo(self.acountTitle.mas_right).offset(5).priority(250);
        make.left.greaterThanOrEqualTo(self.acountTitle.mas_right).priority(200);
        make.right.lessThanOrEqualTo(self.gradeTitle.mas_left).offset(-10).priority(260);
    }];
    [self.gradeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.greaterThanOrEqualTo(self.acountValue.mas_right).offset(10).priority(MASLayoutPriorityDefaultLow);
        make.centerY.equalTo(self.consumeTitle);
        make.right.greaterThanOrEqualTo(self.gradeValue.mas_left).offset(-5).priority(250);
        make.right.equalTo(self.gradeValue.mas_left).priority(200);
        make.left.greaterThanOrEqualTo(self.acountValue.mas_right).offset(10).priority(260);
    }];
    [self.gradeValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.consumeTitle);
        make.right.equalTo(self);
    }];

}

// 设置总和数据
- (void)setComprehedsiveData:(MuscleModel *)model {
    [self.consumeValue setText:[NSString stringWithFormat:@"%ld",model.calories.integerValue]];
    [self.acountValue setText:[NSString stringWithFormat:@"%ld",model.trainingTimes.integerValue]];
    [self.gradeValue setText:[NSString stringWithFormat:@"%ld",model.score.integerValue]];
}
#pragma mark - Init
- (UILabel *)consumeTitle {
    if (!_consumeTitle) {
        _consumeTitle = [UILabel setLabel:_consumeTitle text:@"消耗(Kcal)" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor colorLightGray_898888]];
    }
    return _consumeTitle;
}
- (UILabel *)consumeValue {
    if (!_consumeValue) {
        _consumeValue = [UILabel setLabel:_consumeValue text:@"0" font:[UIFont fontWithName:fontName_BebasNeue size:fontSize_30] textColor:[UIColor whiteColor]];
    }
    return _consumeValue;
}
- (UILabel *)acountTitle {
    if (!_acountTitle) {
        _acountTitle = [UILabel setLabel:_acountTitle text:@"训练次数" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor colorLightGray_898888]];
    }
    return _acountTitle;
}
- (UILabel *)acountValue {
    if (!_acountValue) {
        _acountValue = [UILabel setLabel:_acountValue text:@"0" font:[UIFont fontWithName:fontName_BebasNeue size:fontSize_30] textColor:[UIColor whiteColor]];
    }
    return _acountValue;
}
- (UILabel *)gradeTitle {
    if (!_gradeTitle) {
        _gradeTitle = [UILabel setLabel:_gradeTitle text:@"综合评分" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor colorLightGray_898888]];
    }
    return _gradeTitle;
}
- (UILabel *)gradeValue {
    if (!_gradeValue) {
        _gradeValue = [UILabel setLabel:_gradeValue text:@"0" font:[UIFont fontWithName:fontName_BebasNeue size:fontSize_30] textColor:[UIColor whiteColor]];
    }
    return _gradeValue;
}

@end
