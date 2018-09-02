//
//  PointRedemptionCalendarView.m
//  JYClientDemo
//
//  Created by yinquan on 2017/7/7.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "PointRedemptionCalendarView.h"
#import "PointRedemptionMonthRecordModel.h"

@interface PointRedemptionCalendarDateCell ()

@property (nonatomic, strong) UILabel* dateLabel;
@property (nonatomic, strong) UIImageView* pointFlagImageView;
@property (nonatomic, strong) UIImageView* giftImageView;
@property (nonatomic, strong) UILabel* extraScoreLabel;

@property (nonatomic, readonly) NSInteger day;

- (id) initWithDay:(NSInteger) day;

- (void) setExtraScore:(NSInteger) extraScore;
@end

@implementation PointRedemptionCalendarDateCell

- (id) initWithDay:(NSInteger) day
{
    self = [super init];
    if (self) {
        _day = day;
    }
    return self;
}

- (void) setIsSigned:(BOOL) isSigned
{
    [self.pointFlagImageView setHidden:!isSigned];
    if (isSigned) {
        [self.dateLabel setTextColor:[UIColor commonTextColor]];
        [self.giftImageView setImage:[UIImage imageNamed:@"point_gift_black"]];
        
    }
    else
    {
        [self.dateLabel setTextColor:[UIColor commonGrayTextColor]];
        [self.giftImageView setImage:[UIImage imageNamed:@"point_gift_gary"]];
        
    }
    [self.extraScoreLabel setHidden:isSigned];
}

- (void) setExtraScore:(NSInteger) extraScore
{
    [self.dateLabel setHidden:extraScore > 0];
    [self.giftImageView setHidden:!(extraScore > 0)];
    
//    [self.extraScoreLabel setHidden:!(extraScore > 0)];
    [self.extraScoreLabel setText:[NSString stringWithFormat:@"+%ld", extraScore]];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).with.offset(-4);
    }];
    
    [self.pointFlagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(12, 10));
        make.top.equalTo(self.dateLabel.mas_bottom);
    }];
    
    [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.centerY.equalTo(self).with.offset(-4);
    }];
    
    [self.extraScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.dateLabel.mas_bottom);
    }];
}

#pragma mark - settingAndGetting
- (UILabel*) dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        [self addSubview:_dateLabel];
        
        [_dateLabel setFont:[UIFont systemFontOfSize:17]];
        [_dateLabel setTextColor:[UIColor commonGrayTextColor]];
        [_dateLabel setText:[NSString stringWithFormat:@"%ld", self.day]];
    }
    return _dateLabel;
}

- (UIImageView*) pointFlagImageView
{
    if (!_pointFlagImageView) {
        _pointFlagImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"point_checked_icon"]];
        [self addSubview:_pointFlagImageView];
        [_pointFlagImageView setHidden:YES];
    }
    return _pointFlagImageView;
}

- (UIImageView*) giftImageView
{
    if (!_giftImageView) {
        _giftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"point_gift_gary"]];
        [self addSubview:_giftImageView];
        [_giftImageView setHidden:YES];
    }
    return _giftImageView;
}

- (UILabel*) extraScoreLabel
{
    if (!_extraScoreLabel) {
        _extraScoreLabel = [[UILabel alloc] init];
        [self addSubview:_extraScoreLabel];
        
        [_extraScoreLabel setFont:[UIFont systemFontOfSize:13]];
        [_extraScoreLabel setTextColor:[UIColor colorWithHexString:@"41CDC0"]];
       
    }
    return _extraScoreLabel;
}

@end

@interface PointRedemptionCalendarView ()
{
    
}

@property (nonatomic, strong) NSArray* weekdayLabels;
@property (nonatomic, strong) NSMutableArray* pointCalendarDateCells;

@property (nonatomic, readonly) NSInteger firstDayWeekday;
@property (nonatomic, readonly) NSDate* monthDate;

@end

@implementation PointRedemptionCalendarView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        NSDate* currentMonthDate = [NSDate date];
        NSString* currentMonthString = [currentMonthDate formattedDateWithFormat:@"yyyy-MM"];
        [self setMonth:currentMonthString];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.weekdayLabels enumerateObjectsUsingBlock:^(UILabel* weekdayLabel, NSUInteger idx, BOOL * _Nonnull stop) {
        [weekdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.height.mas_equalTo(@40);
            
            if (idx == 0) {
                make.left.equalTo(self);
            }
            else
            {
                UILabel* perLabel = self.weekdayLabels[idx - 1];
                make.left.equalTo(perLabel.mas_right);
                make.width.equalTo(perLabel);
                if (weekdayLabel == self.weekdayLabels.lastObject) {
                    make.right.equalTo(self);
                }
            }
        }];
    }];
    
    
}

- (void) setMonthlyPointRecordModels:(NSArray*) models
{
    [models enumerateObjectsUsingBlock:^(PointRedemptionMonthRecordModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate* date = [NSDate dateWithString:model.attendanceTime formatString:@"yyyy-MM-dd"];
        NSInteger day = [date day];
        if (day > [self.monthDate daysInMonth]) {
            return;
        }
        PointRedemptionCalendarDateCell* cell = self.pointCalendarDateCells[day - 1];
        
        [cell setIsSigned:model.isSigned];
        
        [cell setExtraScore:model.extraScore];
    }];
}

- (void) layoutPointCalendar
{
    CGFloat cellwidth = (kScreenWidth - 30 - 50)/7;
    [self.pointCalendarDateCells enumerateObjectsUsingBlock:^(PointRedemptionCalendarDateCell* cell, NSUInteger idx, BOOL * _Nonnull stop) {
        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(cellwidth, 45));
            if (idx == 0) {
                make.left.equalTo(self).with.offset((self.firstDayWeekday - 1) * cellwidth);
                UILabel* weekdayLabel = self.weekdayLabels.firstObject;
                make.top.equalTo(weekdayLabel.mas_bottom);
            }
            else
            {
                PointRedemptionCalendarDateCell* percell = self.pointCalendarDateCells[idx - 1];
                if (((self.firstDayWeekday - 1 + idx) % 7) == 0) {
                    //换行
                    make.left.equalTo(self);
                    make.top.equalTo(percell.mas_bottom);
                }
                else
                {
                    make.top.equalTo(percell);
                    make.left.equalTo(percell.mas_right);
                }
            }
            
            if (cell == self.pointCalendarDateCells.lastObject) {
                make.bottom.equalTo(self);
            }
        }];
    }];
}

- (void) setMonth:(NSString*) monthString
{
    NSDate* monthDate = [NSDate dateWithString:monthString formatString:@"yyyy-MM"];
    _monthDate = monthDate;
    
    NSString* firstDayInMonth = [monthDate formattedDateWithFormat:@"yyyy-MM-dd"];
    NSLog(@"firstDayInMonth %@", firstDayInMonth);
    
    NSInteger daysInMonth = [monthDate daysInMonth];
    _firstDayWeekday = [monthDate weekday];
    
    if (!_pointCalendarDateCells) {
        _pointCalendarDateCells = [NSMutableArray array];
    }
    else
    {
        [_pointCalendarDateCells enumerateObjectsUsingBlock:^(PointRedemptionCalendarDateCell* cell, NSUInteger idx, BOOL * _Nonnull stop) {
            [cell removeFromSuperview];
        }];
        
        [_pointCalendarDateCells removeAllObjects];
    }
    
    //TODO: 创建日历控件
    for (NSInteger day = 1; day <= daysInMonth; ++day) {
        PointRedemptionCalendarDateCell* cell = [[PointRedemptionCalendarDateCell alloc] initWithDay:day];
        [self addSubview:cell];
        [_pointCalendarDateCells addObject:cell];
    }
    
    [self layoutPointCalendar];
}

#pragma mark settingAndGetting
- (NSArray*) weekdayLabels
{
    if (!_weekdayLabels) {
        NSMutableArray* weekdayLabels = [NSMutableArray array];
        NSArray* weekdays = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
        [weekdays enumerateObjectsUsingBlock:^(NSString* weekday, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel* weekdayLabel = [[UILabel alloc] init];
            [self addSubview:weekdayLabel];
            [weekdayLabels addObject:weekdayLabel];
            
            [weekdayLabel setTextAlignment:NSTextAlignmentCenter];
            [weekdayLabel setBackgroundColor:[UIColor colorWithHexString:@"62D5C0"]];
            [weekdayLabel setTextColor:[UIColor whiteColor]];
            [weekdayLabel setFont:[UIFont systemFontOfSize:13]];
            [weekdayLabel setText:weekday];
        }];
        
        _weekdayLabels = weekdayLabels;
    }
    return _weekdayLabels;
}

@end
