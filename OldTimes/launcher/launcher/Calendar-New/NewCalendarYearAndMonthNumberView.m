//
//  NewCalendarYearAndMonthNumberView.m
//  launcher
//
//  Created by kylehe on 16/3/8.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCalendarYearAndMonthNumberView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
@interface NewCalendarYearAndMonthNumberView ()



@end

@implementation NewCalendarYearAndMonthNumberView



- (instancetype)initWithFrame:(CGRect)frame

{
    if (self = [super initWithFrame:frame])
    {
        [self createFrame];
    }
    return  self;
}



#pragma mark - privateMethod
- (void)createFrame
{
    [self addSubview:self.monthLbl];
    [self.monthLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
        make.width.equalTo(self);
    }];
    [self addSubview:self.yearLbl];
    [self.yearLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.monthLbl.mas_top);
        make.width.equalTo(self);
        make.height.equalTo(@20);
        make.centerX.equalTo(self);
    }];
}

#pragma amrk - setterAndGetter
- (UILabel *)yearLbl
{
    if (!_yearLbl)
    {
        _yearLbl = [[UILabel alloc] init];
        _yearLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _yearLbl;
}

- (UILabel *)monthLbl
{
    if (!_monthLbl)
    {
        _monthLbl = [[UILabel alloc] init];
        _monthLbl.textAlignment = NSTextAlignmentCenter;
        _monthLbl.textColor = [UIColor themeGray];
        _monthLbl.font = [UIFont systemFontOfSize:12.0f];
    }
    return _monthLbl;
}

@end
