//
//  HealthPlanSectionHeaderView.m
//  HMClient
//
//  Created by Andrew Shen on 16/5/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthPlanSectionHeaderView.h"

@interface HealthPlanSectionHeaderView()
@property (nonatomic, strong)  UIButton  *btnDate; // <##>
@property (nonatomic, strong)  UILabel  *taskCount; // <##>
@property (nonatomic, strong)  UILabel  *finishedCount; // <##>
@end
@implementation HealthPlanSectionHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configElements];
    }
    return self;
}

- (void)configSectionHeaderDataWithDate:(NSString *)date todayTaskCount:(NSInteger)todayTaskCount finishedTaskCount:(NSInteger)finishedCount {
    [self.btnDate setTitle:date forState:UIControlStateNormal];
    [self.taskCount setText:[NSString stringWithFormat:@"今日任务 %ld",todayTaskCount]];
    [self.finishedCount setText:[NSString stringWithFormat:@"已完成 %ld",finishedCount]];
}

#pragma mark - Private Method
// 设置元素控件
- (void)configElements {
    
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    [self addSubview:self.btnDate];
    [self addSubview:self.taskCount];
    [self addSubview:self.finishedCount];

    [self.btnDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 25));
    }];
    [self.taskCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnDate.mas_right).offset(22.5);
        make.centerY.equalTo(self.btnDate);
    }];
    [self.finishedCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.taskCount.mas_right).offset(30);
        make.centerY.equalTo(self.taskCount);
    }];
}

// 设置数据
- (void)configData {
    
}

#pragma mark - Init

- (UIButton *)btnDate {
    if (!_btnDate) {
        _btnDate = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnDate setBackgroundColor:[UIColor mainThemeColor]];
        _btnDate.titleLabel.font = [UIFont font_22];
        [_btnDate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnDate setTitle:@"11-21" forState:UIControlStateNormal];
        _btnDate.layer.cornerRadius = 12.5;
        _btnDate.clipsToBounds = YES;
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_waterfal_downArrow"]];
        [_btnDate addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_btnDate);
            make.left.equalTo(_btnDate.titleLabel.mas_right).offset(3);
        }];
    }
    return _btnDate;
}

- (UILabel *)taskCount {
    if (!_taskCount) {
        _taskCount = [UILabel new];
        _taskCount.font = [UIFont font_26];
        _taskCount.textColor = [UIColor commonTextColor];
        _taskCount.text = @"今日任务 10";
    }
    return _taskCount;
}

- (UILabel *)finishedCount {
    if (!_finishedCount) {
        _finishedCount = [UILabel new];
        _finishedCount.font = [UIFont font_26];
        _finishedCount.textColor = [UIColor commonTextColor];
        _finishedCount.text = @"已完成 7";

    }
    return _finishedCount;
}
@end
