//
//  HealthCenterMonitorTypeCollectionViewCell.m
//  HMClient
//
//  Created by Andrew Shen on 16/5/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthCenterMonitorTypeCollectionViewCell.h"
#import "HealthCenterMonitorTypeBloodPressureView.h"



@interface HealthCenterMonitorTypeCollectionViewCell()
@property (nonatomic, strong)  HealthCenterMonitorTypeBloodPressureView  *bloodPressureView; // <##>
@end

@implementation HealthCenterMonitorTypeCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configElements];
    }
    return self;
}

#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    self.backgroundColor = [UIColor commonBackgroundColor];

    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    [self.contentView addSubview:self.bloodPressureView];
    [self.bloodPressureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

// 设置数据
- (void)configData {
    
}

#pragma mark - Init

- (HealthCenterMonitorTypeBloodPressureView *)bloodPressureView {
    if (!_bloodPressureView) {
        _bloodPressureView = [HealthCenterMonitorTypeBloodPressureView new];
    }
    return _bloodPressureView;
}
@end
