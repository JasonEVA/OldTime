//
//  CalendarDayCellView.m
//  Titans
//
//  Created by Wythe Zhou on 11/3/14.
//  Copyright (c) 2014 Remon Lv. All rights reserved.
//

#import "CalendarDayCellView.h"
#import "NSDate+DateTools.h"
#import "CalendarLaunchrModel.h"
#import "MyDefine.h"

#define W_POINT 4 // 颜色点的宽度
#define INTERVAL_POINT 2 // 点的间隔

#define IMG_GREEN       @"calendar_green"
#define IMG_YELLOW      @"calendar_yellow"
#define IMG_BLUE        @"calendar_blue"
#define IMG_GREEN_SOLID @"calendar_greenSolid"

#define COLOR_BUTTON_BLACK [UIColor colorWithRed:63.0 / 255.0 green:63.0 / 255.0 blue:63.0 / 255.0 alpha:1.0]
#define COLOR_THEME_BLUE [UIColor colorWithRed:0 green:153.0/255 blue:255.0/255 alpha:1]         // 主题蓝
#define COLOR_CYCLE_RED  [UIColor colorWithRed:255.0 / 255.0 green:51.0 / 255.0 blue:102.0 / 255.0 alpha:1.0]
#define COLOR_CYCLE_GRAY [UIColor colorWithRed:175.0 / 255.0 green:175.0 / 255.0 blue:175.0 / 255.0 alpha:1.0]

typedef enum {
    ClearColor = 0,
    RedColor = 1,
    GrayColor = 2,
}CycleColor;

@implementation CalendarDayCellView

// frame 35 * 35
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initComponents];
    }
    return self;
}

// 初始化元素，只在第一次
- (void)initComponents
{
    _wButton = 35.0f;
    _hButton = 35.0f;
    _fontButtonTitle = [UIFont systemFontOfSize:17];
    
    _colorButtonTitleWhite = [UIColor whiteColor];
    _colorButtonTitleBlack = [UIColor blackColor];
    _colorButtonTitleGray  = [UIColor themeGray];
    _colorButtonTitleBlue  = [UIColor themeBlue];
    _colorButtonTitleRed   = [UIColor themeRed];
    
    _colorButtonBackgroundWhite = [UIColor whiteColor];
    _colorButtonBackgroundBlue = [UIColor themeBlue];
    _colorButtonBackgroundLightBlue = [UIColor colorWithRed:0.91 green:0.94 blue:0.98 alpha:1.0];
    _colorButtonBackgroundBlack = _colorButtonTitleBlack;
    _colorButtonBackgroundLightGray = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    
    CGRect viewFrame = CGRectMake((self.frame.size.width - 35)/2, 0, 35, 35);
    
    _button = [[UIButton alloc] initWithFrame:viewFrame];
    [_button setTitle:@"11" forState:UIControlStateNormal];
    _button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [_button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_button.layer setCornerRadius:4.0f];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self addSubview:_button];
    
    _arrayPoints = [NSMutableArray array];
}

// 设置 Model
- (void)setDateDataModel:(CalendarDateDataModel *)dateDataModel
{
    self._dateDataModel = dateDataModel;
    // 初始化其他属性
    [self setComponents];
}

// 设置元素
- (void)setComponents
{
    [_button setTitle:[NSString stringWithFormat:@"%ld", (long)self._dateDataModel._dayModel._dayNumber] forState:UIControlStateNormal];
    
    [self refreshStatus];
    
}

// 设置颜色点
- (void)setPoints:(BOOL)IsShowPoint withColor:(CycleColor)color
{
//    if (IsShowPoint)
//    {
        self.imgViewEventPoint.hidden = NO;
//    }
//    else
//    {
//        self.imgViewEventPoint.hidden = YES;
//    }
    
    switch (color)
    {
        case ClearColor:
            [self.imgViewEventPoint setBackgroundColor:[UIColor clearColor]];
            break;
        case RedColor:
//            [self.imgViewEventPoint setBackgroundColor:[UIColor redColor]];
            [self.imgViewEventPoint setBackgroundColor:COLOR_CYCLE_GRAY];
            break;
        case GrayColor:
            [self.imgViewEventPoint setBackgroundColor:COLOR_CYCLE_GRAY];
            break;
        default:[self.imgViewEventPoint setBackgroundColor:[UIColor clearColor]];
            break;
    }
}

// 刷新状态
- (void)refreshStatus
{
    // 判断是不是周末
    // 是不是今天
    // 有没有事情
    // 有没有被选中

    UIColor *colorTitleNormal;
    UIColor *colorBackground;

    if (self._dateDataModel._ifToday)
    {
        colorTitleNormal = _colorButtonTitleBlue;
        colorBackground = _colorButtonBackgroundWhite;
    }
    else
    {
        colorTitleNormal = self._dateDataModel._weekends ? _colorButtonTitleGray : _colorButtonTitleBlack;
    }
    
    for (int i = 0; i< self._dateDataModel._dayModel.arrayEventList.count; i++)
    {
        CalendarLaunchrModel *model = self._dateDataModel._dayModel.arrayEventList[i];
        if (model.eventType == eventType_company_festival || model.eventType == eventType_statutory_festival)
        {
            colorTitleNormal = _colorButtonTitleRed;
        }
    }

    [_button setTitleColor:colorTitleNormal forState:UIControlStateNormal];
    [_button setBackgroundColor:colorBackground];

    if (self._dateDataModel._dayModel.arrayEventList.count > 0)
    {
        if ([[self._dateDataModel._date dateByAddingDays:1] isEarlierThan:[NSDate date]])
        {
            [self setPoints:YES withColor:GrayColor];
        }else
        {
            [self setPoints:YES withColor:RedColor];
        }
    }
    else
    {
        [self setPoints:NO withColor:ClearColor];
    }
}

- (void)buttonClicked
{
//    NSLog(@"%d-%d-%d", self._dateDataModel._year, self._dateDataModel._month, self._dateDataModel._day);
    // 回调，把 Model 传送过去
    if ([self.delegate respondsToSelector:@selector(CalendarDayCellViewDelegateCallBack_ButtonClickedWithDateDataModel:)])
    {
        [self.delegate CalendarDayCellViewDelegateCallBack_ButtonClickedWithDateDataModel:self._dateDataModel];
    }
}

- (void)setDayCellViewSelected:(BOOL)isSelected
{
    
    if (isSelected)
    {
        if (!self._dateDataModel._ifToday)
        {
            [_button setBackgroundColor:COLOR_BUTTON_BLACK];
        }
        else
        {

            [_button setBackgroundColor:COLOR_THEME_BLUE];
        }
    }
    else
    {
        [_button setBackgroundColor:nil];
    }
    
    [_button setSelected:isSelected];
}

#pragma mark - init
- (UIImageView *)imgViewEventPoint
{
    if (!_imgViewEventPoint)
    {
        _imgViewEventPoint = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 5)/2, 34, 5, 5)];
        [_imgViewEventPoint setBackgroundColor:[UIColor redColor]];
        _imgViewEventPoint.layer.cornerRadius = 3.0f;
        _imgViewEventPoint.hidden = YES;
        [self addSubview:_imgViewEventPoint];
    }
    return _imgViewEventPoint;
}
@end
