//
//  CalendarDayCollectionViewCell.m
//  launcher
//
//  Created by Conan Ma on 15/8/3.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarDayCollectionViewCell.h"
#import "CalendarLaunchrModel.h"
#import <DateTools/DateTools.h>
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "MyDefine.h"

typedef enum {
    ClearColor = 0,
    RedColor = 1,
    GrayColor = 2,
}CycleColor;

@implementation CalendarDayCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.Istoday = NO;
        [self.contentView addSubview:self.lblTitle];
        [self.contentView addSubview:self.ImgView];

        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView).offset(-5);
            make.width.height.equalTo(@30);
        }];
        
        [self.ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.lblTitle);
            make.top.equalTo(self.lblTitle.mas_bottom).offset(5);
            make.width.height.equalTo(@5);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    if (selected)
    {
        self.lblTitle.textColor = [UIColor whiteColor];
        self.lblTitle.backgroundColor = [UIColor themeBlue];
        self.IsSelected = YES;
        return;
    }

    if ((self.Weekday == 1 || self.Weekday == 7) && !self.Istoday)
    {
        self.lblTitle.textColor = [UIColor themeGray];
    }
    else if (self.Weekday != 1 && self.Weekday != 7 && !self.Istoday)
    {
        self.lblTitle.textColor = [UIColor blackColor];
    }
    else if (self.Istoday)
    {
        self.lblTitle.textColor = [UIColor themeBlue];
    }
    self.IsSelected = NO;
    self.lblTitle.backgroundColor = [UIColor whiteColor];
}

- (void)SetEventWithColor:(CycleColor)color
{
    switch (color)
    {
        case GrayColor:
        case RedColor:
//            [self.ImgView setBackgroundColor:[UIColor redColor]];
            [self.ImgView setBackgroundColor:[UIColor mtc_colorWithW:175]];
            break;
        case ClearColor:
        default:[self.ImgView setBackgroundColor:[UIColor clearColor]];
            break;
    }
}

- (void)setModel:(CalendarDateDataModel *)model
{
    if (model._weekends)
    {
        //设置周末的颜色
        self.lblTitle.textColor = [UIColor themeGray];
    }
    else
    {
        //设置非周末的颜色
        self.lblTitle.textColor = [UIColor blackColor];
    }
  
    for (int i = 0; i < model._dayModel.arrayEventList.count; i++)
    {
        CalendarLaunchrModel *eventmodel = model._dayModel.arrayEventList[i];
        if (eventmodel.eventType == eventType_company_festival || eventmodel.eventType == eventType_statutory_festival)
        {
            self.lblTitle.textColor = [UIColor themeRed];
        }
    }
    
    if (model._ifToday)
    {
        //今天的颜色
        self.lblTitle.textColor = [UIColor themeRed];
        self.Istoday = YES;
    }
    else
    {
        self.Istoday = NO;
    }
    
    if (model._dayModel.arrayEventList.count > 0)
    {
        if ([[model._date dateByAddingDays:1] isEarlierThan:[NSDate date]])
        {
            [self SetEventWithColor:GrayColor];
        }
        else
        {
            [self SetEventWithColor:RedColor];
        }
    }
    else
    {
        [self SetEventWithColor:ClearColor];
    }
    
    if (self.IsSelected)
    {
        self.lblTitle.textColor = [UIColor whiteColor];
    }
}

#pragma mark - init
- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.layer.cornerRadius = 5.0f;
        _lblTitle.clipsToBounds = YES;
        _lblTitle.textAlignment = NSTextAlignmentCenter;
        _lblTitle.backgroundColor = [UIColor clearColor];
    }
    return _lblTitle;
}

- (UIImageView *)ImgView
{
    if (!_ImgView)
    {
        _ImgView = [[UIImageView alloc] init];
        _ImgView.layer.cornerRadius = 2.5f;
        _ImgView.backgroundColor = [UIColor clearColor];
    }
    return _ImgView;
}
@end
