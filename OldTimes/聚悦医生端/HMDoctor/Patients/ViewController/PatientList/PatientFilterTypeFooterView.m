//
//  PatientFilterTypeFooterView.m
//  HMDoctor
//
//  Created by Andrew Shen on 2016/12/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientFilterTypeFooterView.h"

@interface PatientFilterTypeFooterView ()
@property (nonatomic, copy)  PatientFilterTypeFooterButtonClicked  buttonClicked; // <##>
@end
@implementation PatientFilterTypeFooterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self p_configElements];
    }
    return self;
}

- (void)addNotiForFilterTypeFooterButtonClicked:(PatientFilterTypeFooterButtonClicked)block {
    self.buttonClicked = block;
}
// 设置元素控件
- (void)p_configElements {
    
    // 设置数据
    [self p_configData];
    
    // 设置约束
    [self p_configConstraints];
}

// 设置数据
- (void)p_configData {
    
}

// 设置约束
- (void)p_configConstraints {
    UIButton *reset = [UIButton buttonWithType:UIButtonTypeCustom];
    reset.titleLabel.font = [UIFont font_32];
    [reset setTitle:@"重置" forState:UIControlStateNormal];
    [reset setTitleColor:[UIColor commonBlackTextColor_333333] forState:UIControlStateNormal];
    [reset setBackgroundImage:[UIImage imageColor:[UIColor whiteColor] size:CGSizeMake(1, 1) cornerRadius:0] forState:UIControlStateNormal];
    [reset addTarget:self action:@selector(p_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    reset.tag = 0;
    [self addSubview:reset];
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    confirm.titleLabel.font = [UIFont font_32];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirm setBackgroundImage:[UIImage imageColor:[UIColor mainThemeColor] size:CGSizeMake(1, 1) cornerRadius:0] forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(p_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    confirm.tag = 1;
    [self addSubview:confirm];
    [@[reset, confirm] mas_distributeViewsAlongAxis:0 withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [@[reset, confirm] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
    }];
    
    UIView *headLine = [UIView new];
    [headLine setBackgroundColor:[UIColor commonControlBorderColor]];
    [self addSubview:headLine];
    [headLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - Event Response
- (void)p_buttonClicked:(UIButton *)sender {
    if (self.buttonClicked) {
        self.buttonClicked(sender);
    }
}

@end
