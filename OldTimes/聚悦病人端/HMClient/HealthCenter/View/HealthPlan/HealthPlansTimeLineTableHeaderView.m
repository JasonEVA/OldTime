//
//  HealthPlansTimeLineTableHeaderView.m
//  HMClient
//
//  Created by yinqaun on 16/6/7.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthPlansTimeLineTableHeaderView.h"



@implementation HealthPlansTimeLineHeaderDateView

- (id) init
{
    self = [super init];
    if (self)
    {
        vDate = [[UIView alloc]init];
        [self addSubview:vDate];
        [vDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(@21);
        }];
        [vDate setBackgroundColor:[UIColor mainThemeColor]];
        vDate.layer.cornerRadius = 10.5;
        vDate.layer.masksToBounds = YES;
        [vDate setUserInteractionEnabled:NO];
        
        lbDate = [[UILabel alloc]init];
        [vDate addSubview:lbDate];
        [lbDate setFont:[UIFont font_20]];
        [lbDate setTextColor:[UIColor whiteColor]];
        
        [lbDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(vDate).with.offset(10);
            make.centerY.equalTo(vDate);
        }];
        
        NSDate* dateToday = [NSDate date];
        NSString* dateStr = [dateToday formattedDateWithFormat:@"MM-dd"];
        [lbDate setText:dateStr];
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_waterfal_downArrow"]];
        [vDate addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(lbDate.mas_right).offset(5);
        }];

    }
    return self;
}

- (void) setDateStr:(NSString*) dateStr
{
    NSDate* date = [NSDate dateWithString:dateStr formatString:@"yyyy-MM-dd"];
    NSString* dateString = [date formattedDateWithFormat:@"MM-dd"];
    
    [lbDate setText:dateString];
}

@end

@interface HealthPlansTimeLineTableHeaderView ()
{
    
    //UIView* lineView;
    UILabel* lbTotalPlans;
    UILabel* lbCompletePlans;
}
@end

@implementation HealthPlansTimeLineTableHeaderView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        _dateView = [[HealthPlansTimeLineHeaderDateView alloc]init];
        [self addSubview:_dateView];
        [_dateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(60, 30));
            make.left.equalTo(self).with.offset(12.5);
        }];
        //[_dateView addTarget:self action:@selector(dateControlClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView* lineView = [[UIView alloc]init];
        [self addSubview:lineView];
        [lineView setBackgroundColor:[UIColor mainThemeColor]];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@1);
            make.top.equalTo(_dateView.mas_bottom).with.offset(-5);
            make.bottom.equalTo(self);
            make.left.equalTo(self).with.offset(53);
        }];
        
        lbTotalPlans = [[UILabel alloc]init];
        [self addSubview:lbTotalPlans];
        [lbTotalPlans setFont:[UIFont font_24]];
        [lbTotalPlans setTextColor:[UIColor commonTextColor]];
        [lbTotalPlans setText:@"任务  0"];
        [lbTotalPlans mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_dateView.mas_right).with.offset(22);
            make.centerY.equalTo(self);
        }];
        
        lbCompletePlans = [[UILabel alloc]init];
        [self addSubview:lbCompletePlans];
        [lbCompletePlans setFont:[UIFont font_24]];
        [lbCompletePlans setTextColor:[UIColor commonTextColor]];
        [lbCompletePlans setText:@"已完成  0"];
        [lbCompletePlans mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbTotalPlans.mas_right).with.offset(28);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}



- (void) setTotalPlansCount:(NSInteger) totalPlanCount
{
    [lbTotalPlans setText:[NSString stringWithFormat:@"任务  %ld", totalPlanCount]];
}

- (void) setCompletePlansCount:(NSInteger) completePlanCount
{
    [lbCompletePlans setText:[NSString stringWithFormat:@"已完成  %ld", completePlanCount]];
}

- (void) setDateString:(NSString*) dateStr
{
    [_dateView setDateStr:dateStr];
}

@end
