//
//  BodyWeightResultDetectTimeView.m
//  HMClient
//
//  Created by yinqaun on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BodyWeightResultDetectTimeView.h"

@interface BodyWeightResultDetectTimeView ()
{
    UILabel* lbTime;
    UILabel* lbDetectDate;
//    UILabel* lbDetectTime;
}
@end

@implementation BodyWeightResultDetectTimeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lbTime = [[UILabel alloc]init];
        [self addSubview:lbTime];
        [lbTime setFont:[UIFont font_30]];
        [lbTime setTextColor:[UIColor commonGrayTextColor]];
        [lbTime setText:@"测试时间:"];
        
        lbDetectDate = [[UILabel alloc]init];
        [self addSubview:lbDetectDate];
        [lbDetectDate setFont:[UIFont font_30]];
        [lbDetectDate setTextColor:[UIColor commonTextColor]];
        
//        lbDetectTime = [[UILabel alloc]init];
//        [self addSubview:lbDetectTime];
//        [lbDetectTime setFont:[UIFont font_30]];
//        [lbDetectTime setTextColor:[UIColor commonTextColor]];

        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [lbTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(@19);
    }];
    
    [lbDetectDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTime.mas_right).with.offset(4);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(@19);
    }];
    
//    [lbDetectTime mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(lbDetectDate.mas_right).with.offset(9);
//        make.centerY.equalTo(self);
//        make.height.mas_equalTo(@19);
//    }];
}

- (void) setDetectResult:(BodyWeightDetectResult*) result
{
    if (!result)
    {
        return;
    }
    
    NSDate* detectDate = [NSDate dateWithString:result.testTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    if (!detectDate)
    {
        detectDate = [NSDate dateWithString:result.testTime formatString:@"yyyy-MM-dd"];
    }
    
    NSString* dateStr = [detectDate formattedDateWithFormat:@"yyyy-MM-dd"];
    if ([detectDate isToday])
    {
        dateStr = @"今天";
    }
    if ([detectDate isYesterday])
    {
        dateStr = @"昨天";
    }
    [lbDetectDate setText:dateStr];
}
@end
