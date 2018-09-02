//
//  HMSupervisePlanHeadView.m
//  HMClient
//
//  Created by jasonwang on 2017/6/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSupervisePlanHeadView.h"
#define CIRCLEWIDTH        6
@implementation HMSupervisePlanHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *titelLb = [UILabel new];
        [titelLb setText:@"注：图表显示最近7次的测量结果。"];
        [titelLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [titelLb setFont:[UIFont systemFontOfSize:13]];
        
        UIView *circleOne = [UIView new];
        [circleOne.layer setBorderColor:[[UIColor colorWithHexString:@"ff9c37"] CGColor]];
        [circleOne.layer setBorderWidth:1.5];
        [circleOne.layer setCornerRadius:CIRCLEWIDTH / 2];
        
        UILabel *overLb = [UILabel new];
        [overLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [overLb setFont:[UIFont systemFontOfSize:13]];
        [overLb setText:@"超出正常值"];
        
        UIView *circleTwo = [UIView new];
        [circleTwo.layer setBorderColor:[[UIColor mainThemeColor] CGColor]];
        [circleTwo.layer setBorderWidth:1.5];
        [circleTwo.layer setCornerRadius:CIRCLEWIDTH / 2];

        UILabel *normalLb = [UILabel new];
        [normalLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [normalLb setFont:[UIFont systemFontOfSize:13]];
        [normalLb setText:@"正常"];

        [self addSubview:titelLb];
        [self addSubview:circleOne];
        [self addSubview:overLb];
        [self addSubview:circleTwo];
        [self addSubview:normalLb];
    
        [titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(10);
        }];
        
        [overLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titelLb.mas_bottom).offset(5);
            make.left.equalTo(titelLb).offset(35);
        }];
        
        [circleOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(overLb.mas_left).offset(-5);
            make.centerY.equalTo(overLb);
            make.width.equalTo(@CIRCLEWIDTH);
            make.height.equalTo(@CIRCLEWIDTH);
        }];
        
        [circleTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(overLb.mas_right).offset(15);
            make.centerY.equalTo(overLb);
            make.width.equalTo(@CIRCLEWIDTH);
            make.height.equalTo(@CIRCLEWIDTH);
        }];
        
        [normalLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(overLb);
            make.left.equalTo(circleTwo.mas_right).offset(5);
        }];
        
        
    
    }
    return self;
}

@end
