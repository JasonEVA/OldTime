//
//  BloodPressureResultHealthGuideView.m
//  HMClient
//
//  Created by lkl on 16/5/9.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodPressureResultHealthGuideView.h"

@interface BloodPressureResultHealthGuideView ()
{
    UILabel *lbtitle;
    UIView *lineView;
    UILabel *lbValue;
    UIView *bottomlineView;
}

@end

@implementation BloodPressureResultHealthGuideView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lbtitle = [[UILabel alloc] init];
        [lbtitle setFont:[UIFont font_28]];
        [lbtitle setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self addSubview:lbtitle];
        
        lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:[UIColor commonCuttingLineColor]];
        [self addSubview:lineView];

        lbValue = [[UILabel alloc] init];
        [lbValue setFont:[UIFont font_26]];
        [lbValue setNumberOfLines:0];
        [lbValue setText:@"●本次测量是结果…………"];
        [lbValue setTextColor:[UIColor colorWithHexString:@"666666"]];
        [self addSubview:lbValue];
        
        bottomlineView = [[UIView alloc] init];
        [bottomlineView setBackgroundColor:[UIColor commonCuttingLineColor]];
        [self addSubview:bottomlineView];

        [self subViewsLayout];
    }
    return self;
}

- (void)subViewsLayout
{
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.top.equalTo(self);
        make.height.mas_equalTo(@35);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbtitle.mas_bottom);
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [lbValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).with.offset(10);
        make.left.equalTo(self).with.offset(12.5);
        make.right.equalTo(self).with.offset(-12.5);
    }];
    
    [bottomlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.mas_bottom).with.offset(-1);
    }];
}

- (void)setTitle:(NSString*)title
{
    [lbtitle setText:title];
}

- (void) setValueString:(NSString*) aValue
{
    [lbValue setText:[NSString stringWithFormat:@"● %@",aValue]];
}

@end
