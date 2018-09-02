//
//  BloodSugarResultDetectTimeView.m
//  HMClient
//
//  Created by yinqaun on 16/5/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodSugarResultDetectTimeView.h"

@interface BloodSugarResultDetectTimeView ()
{
    UILabel* lbTime;
    UILabel* lbTimeName;
    
    UILabel* lbDetectTime;
    UILabel* lbDetectTimeName;
}
@end

@implementation BloodSugarResultDetectTimeView

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
        [lbTime setFont:[UIFont font_28]];
        [lbTime setTextColor:[UIColor commonGrayTextColor]];
        [lbTime setText:@"测试时间: "];
        
        lbTimeName = [[UILabel alloc]init];
        [self addSubview:lbTimeName];
        [lbTimeName setFont:[UIFont font_28]];
        [lbTimeName setTextColor:[UIColor commonGrayTextColor]];
        [lbTimeName setText:@"测试时段: "];
        
        lbDetectTime = [[UILabel alloc]init];
        [self addSubview:lbDetectTime];
        [lbDetectTime setFont:[UIFont font_28]];
        [lbDetectTime setTextColor:[UIColor commonTextColor]];
        
        lbDetectTimeName = [[UILabel alloc]init];
        [self addSubview:lbDetectTimeName];
        [lbDetectTimeName setFont:[UIFont font_28]];
        [lbDetectTimeName setTextColor:[UIColor commonTextColor]];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [lbTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.top.equalTo(self).with.offset(10);
    }];
    
    [lbTimeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTime);
        make.top.equalTo(lbTime.mas_bottom).offset(5);
    }];
    
    [lbDetectTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTime.mas_right);
        make.top.equalTo(lbTime);
        make.height.equalTo(lbTime);
    }];
    
    [lbDetectTimeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTimeName.mas_right);
        make.top.equalTo(lbTimeName);
        make.height.equalTo(lbTimeName);
    }];
}

- (void) setDetectResult:(BloodSugarDetectResult*) result
{
    if (!result)
    {
        return;
    }
    
    NSDate* detectTime = [NSDate dateWithString:result.testTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    NSString* timeStr = [detectTime formattedDateWithFormat:@"yyyy-MM-dd HH:mm"];
    [lbDetectTime setText:timeStr];

    [lbDetectTimeName setText:result.detectTimeName];
}

@end
