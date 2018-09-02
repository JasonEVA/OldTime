//
//  CalendarPageControlPointView.m
//  launcher
//
//  Created by Conan Ma on 15/7/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarPageControlPointView.h"
#import "MyDefine.h"
#import "UIColor+Hex.h"

@interface CalendarPageControlPointView()
@property (nonatomic, strong) NSArray *arrLabels;
@property (nonatomic, strong) NSArray *arrImgs;
@end

@implementation CalendarPageControlPointView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.lblMonth];
        [self addSubview:self.lblWeek];
//        [self addSubview:self.lblDay];
        
        [self addSubview:self.imgViewMonth];
        [self addSubview:self.imgViewWeek];
//        [self addSubview:self.imgViewDay];
    }
    return self;
}

- (void)setSelectedColor:(NSInteger)index
{
    for (int i = 0; i < 2; i++)
    {
        if (i == index)
        {
            UILabel *lbl = [self.arrLabels objectAtIndex:index];
            lbl.textColor = [UIColor themeBlue];
            UIImageView *img = [self.arrImgs objectAtIndex:index];
            [img setBackgroundColor:[UIColor themeBlue]];
        }
        else
        {
            UILabel *lbl = [self.arrLabels objectAtIndex:i];
            lbl.textColor = [UIColor mtc_colorWithW:192];
            UIImageView *img = [self.arrImgs objectAtIndex:i];
            [img setBackgroundColor:[UIColor mtc_colorWithW:192]];
        }
    }
}

- (UILabel *)lblMonth
{
    if (!_lblMonth)
    {
        _lblMonth = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        _lblMonth.font = [UIFont systemFontOfSize:15];
        _lblMonth.text = LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH);
        _lblMonth.textAlignment = NSTextAlignmentCenter;
        _lblMonth.textColor = [UIColor themeBlue];
    }
    return _lblMonth;
}

- (UILabel *)lblWeek
{
    if (!_lblWeek)
    {
        _lblWeek = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 40, 30)];
        _lblWeek.font = [UIFont systemFontOfSize:15];
        _lblWeek.text = LOCAL(CALENDAR_SCHEDULEBYWEEK_WEEK);
        _lblWeek.textAlignment = NSTextAlignmentCenter;
        _lblWeek.textColor = [UIColor mtc_colorWithW:192];
    }
    return _lblWeek;
}

//- (UILabel *)lblDay
//{
//    if (!_lblDay)
//    {
//        _lblDay = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 40, 30)];
//        _lblDay.font = [UIFont systemFontOfSize:11];
//        _lblDay.text = @"日";
//        _lblDay.textAlignment = NSTextAlignmentCenter;
//        _lblDay.textColor = COLOR_LAYER_GRAY;
//    }
//    return _lblDay;
//}

- (UIImageView *)imgViewMonth
{
    if (!_imgViewMonth)
    {
        _imgViewMonth = [[UIImageView alloc] initWithFrame:CGRectMake(17, 28, 6, 6)];
        [_imgViewMonth setBackgroundColor:[UIColor themeBlue]];
        _imgViewMonth.layer.cornerRadius = 3.0f;
    }
    return _imgViewMonth;
}

- (UIImageView *)imgViewWeek
{
    if (!_imgViewWeek)
    {
        _imgViewWeek = [[UIImageView alloc] initWithFrame:CGRectMake(57, 28, 6, 6)];
        [_imgViewWeek setBackgroundColor:[UIColor mtc_colorWithW:192]];
        _imgViewWeek.layer.cornerRadius = 3.0f;
    }
    return _imgViewWeek;
}

//- (UIImageView *)imgViewDay
//{
//    if (!_imgViewDay)
//    {
//        _imgViewDay = [[UIImageView alloc] initWithFrame:CGRectMake(97, 28, 6, 6)];
//        [_imgViewDay setBackgroundColor:COLOR_LAYER_GRAY];
//        _imgViewDay.layer.cornerRadius = 4.0f;
//    }
//    return _imgViewDay;
//}

- (NSArray *)arrLabels
{
    if (!_arrLabels)
    {
        _arrLabels = [[NSArray alloc] initWithObjects:self.lblMonth,self.lblWeek, nil];
    }
    return _arrLabels;
}

- (NSArray *)arrImgs
{
    if (!_arrImgs)
    {
        _arrImgs = [[NSArray alloc] initWithObjects:self.imgViewMonth,self.imgViewWeek, nil];
    }
    return _arrImgs;
}
@end
