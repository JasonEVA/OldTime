//
//  HealthPlanEditPeriodControl.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/24.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanEditPeriodControl.h"

@implementation HealthPlanEditPeriodControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        [self layoutElements];
    }
    return self;
}

- (void) layoutElements
{
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(13, 13));
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
    }];
    
    [self.periodTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.right.equalTo(self.arrowImageView.mas_left);
    }];
}

- (void) setPeriodTypeStr:(NSString*) periodTypeStr
{
    NSString* periodTypeString = [self periodTypeString:periodTypeStr.integerValue];
    [self.periodTypeLabel setText:periodTypeString];
}

- (NSString*) periodTypeString:(PeriodType) periodType
{
    NSString* periodTypeString = nil;
    
    switch (periodType) {
        case PeriodType_Week:
        {
            periodTypeString = @"周";
            break;
        }
        case PeriodType_Day:
        {
            periodTypeString = @"日";
            break;
        }
        case PeriodType_Month:
        {
            periodTypeString = @"月";
            break;
        }
            
    }
    
    return periodTypeString;
}

#pragma mark settingAndGetting
- (UILabel*) periodTypeLabel
{
    if (!_periodTypeLabel) {
        _periodTypeLabel = [[UILabel alloc] init];
        [self addSubview:_periodTypeLabel];
        
        [_periodTypeLabel setFont:[UIFont systemFontOfSize:15]];
        [_periodTypeLabel setTextColor:[UIColor commonTextColor]];
        [_periodTypeLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _periodTypeLabel;
}

- (UIImageView*) arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_down_list_arrow"]];
        [self addSubview:_arrowImageView];
    }
    return _arrowImageView;
}


@end
