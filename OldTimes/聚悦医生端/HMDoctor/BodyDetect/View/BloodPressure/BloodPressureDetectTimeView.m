//
//  BloodPressureDetectTimeView.m
//  HMClient
//
//  Created by yinqaun on 16/5/10.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodPressureDetectTimeView.h"
#import "BloodPressureDetectRecord.h"

@interface BloodPressureDetectTimeView ()
{
    UILabel* lbTime;
    UILabel* lbDetectDate;
    UILabel* lbDetectTime;
    UILabel* lbDetectPeriod;
}
@end

@implementation BloodPressureDetectTimeView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lbTime = [[UILabel alloc]init];
        [self addSubview:lbTime];
        [lbTime setFont:[UIFont systemFontOfSize:15]];
        [lbTime setTextColor:[UIColor commonGrayTextColor]];
        [lbTime setText:@"测试时间："];
        
        lbDetectDate = [[UILabel alloc]init];
        [self addSubview:lbDetectDate];
        [lbDetectDate setFont:[UIFont systemFontOfSize:15]];
        [lbDetectDate setTextColor:[UIColor commonTextColor]];
        
        lbDetectTime = [[UILabel alloc]init];
        [self addSubview:lbDetectTime];
        [lbDetectTime setFont:[UIFont systemFontOfSize:15]];
        [lbDetectTime setTextColor:[UIColor commonTextColor]];
        
        lbDetectPeriod = [[UILabel alloc]init];
        [self addSubview:lbDetectPeriod];
        [lbDetectPeriod setText:@"测试时段："];
        [lbDetectPeriod setFont:[UIFont font_30]];
        [lbDetectPeriod setTextColor:[UIColor commonGrayTextColor]];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [lbTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.top.equalTo(self).offset(10);
    }];
    
    [lbDetectDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTime.mas_right).with.offset(4);
        make.top.equalTo(lbTime.mas_top);
    }];
    
    [lbDetectTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbDetectDate.mas_right).with.offset(9);
        make.top.equalTo(lbTime.mas_top);
    }];
    
    [lbDetectPeriod mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTime.mas_left);
        make.top.equalTo(lbTime.mas_bottom).offset(10);
    }];
}

- (void) setDetectResult:(DetectResult*) result
{
    if (!result)
    {
        return;
    }
    
    NSDate* detectDate = [NSDate dateWithString:result.testTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    NSString* timeStr = [detectDate formattedDateWithFormat:@"HH:mm"];
    [lbDetectTime setText:timeStr];
    
    NSString* dateStr = [detectDate formattedDateWithFormat:@"yy-MM-dd"];
    if ([detectDate isToday])
    {
        dateStr = @"今天";
    }
    if ([detectDate isYesterday])
    {
        dateStr = @"昨天";
    }
    [lbDetectDate setText:dateStr];
    
    BloodPressureDetectResult* bpResult = (BloodPressureDetectResult*)result;
    if (!kStringIsEmpty(bpResult.testTimeName)) {
        [lbDetectPeriod setTextColor:[UIColor commonTextColor]];
        [lbDetectPeriod setAttributedText:[NSAttributedString getAttributWithChangePart:[NSString stringWithFormat:@"%@",bpResult.testTimeName] UnChangePart:@"测量时段：" UnChangeColor:[UIColor commonGrayTextColor] UnChangeFont:[UIFont font_30]]];
    }
}
@end
