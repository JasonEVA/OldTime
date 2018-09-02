//
//  BloodPressureInquiryChartControl.m
//  HMClient
//
//  Created by lkl on 16/5/9.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodPressureInquiryChartControl.h"

@interface BloodPressureInquiryChartControl ()
{
    UILabel *lbtitle;
    UIImageView *icon;
}

@end

@implementation BloodPressureInquiryChartControl

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lbtitle = [[UILabel alloc] init];
        
        [lbtitle setFont:[UIFont font_30]];
        [lbtitle setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self addSubview:lbtitle];
        
        icon = [[UIImageView alloc] init];
        [icon setImage:[UIImage imageNamed:@"icon_x_arrows"]];
        [self addSubview:icon];


        [self subViewsLayout];
    }
    return self;
}

- (void) setSurveyModuleName:(NSString*) modulename
{
    [lbtitle setText:modulename];
}

- (void)subViewsLayout
{
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-12);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(10, 15));
    }];
    
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).with.offset(12.5);
        make.centerY.mas_equalTo(self);
        //make.size.mas_equalTo(CGSizeMake(150, 20));
        make.right.lessThanOrEqualTo(icon).with.offset(-5);
    }];
    
    
}

@end
