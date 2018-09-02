//
//  PointRedemptionWeeklyControl.m
//  JYClientDemo
//
//  Created by yinquan on 2017/7/7.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "PointRedemptionWeeklyControl.h"

@interface PointRedemptionWeeklyCell : UIView

@property (nonatomic, readonly) UILabel* dayLabel;
@property (nonatomic, readonly) UILabel* monthLable;
@property (nonatomic, readonly) UIImageView* pointFlagImageView;
@property (nonatomic, readonly) UIImageView* giftImageView;

- (void) showGiftImage:(BOOL) show;
- (void) setDate:(NSDate*) date;
@end

@implementation PointRedemptionWeeklyCell

@synthesize dayLabel = _dayLabel;
@synthesize monthLable = _monthLable;
@synthesize pointFlagImageView = _pointFlagImageView;
@synthesize giftImageView = _giftImageView;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.mas_equalTo(@16);
    }];
    [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.monthLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.dayLabel.mas_top).with.offset(-3);
//        make.top.equalTo(self).with.offset(4);
    }];
    
    [self.pointFlagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(5, 5));
        make.top.equalTo(self.dayLabel.mas_bottom).with.offset(3.5);
    }];
}

- (void) showGiftImage:(BOOL) show
{
    [self.dayLabel setHidden:show];
    [self.giftImageView setHidden:!show];
}


- (void) showPointFlag:(BOOL) show
{
    [self.pointFlagImageView setHidden:!show];
    
}

- (void) setDate:(NSDate*) date
{
    if (!date) {
        return;
    }
    
    long day= [date day];
    long month = [date month];
    
    [self.dayLabel setText:[NSString stringWithFormat:@"%ld", day]];
    [self.monthLable setText:[NSString stringWithFormat:@"%ld月", month]];
    
    [self.monthLable setHidden:(![date isToday])];
    if ([date isToday])
    {
        [self.dayLabel setTextColor:[UIColor whiteColor]];
    }
    else
    {
        [self.dayLabel setTextColor:[UIColor commonControlBorderColor]];
    }
}
#pragma mark settingAndGetting
- (UILabel*) dayLabel
{
    if (!_dayLabel)
    {
        _dayLabel = [[UILabel alloc] init];
        [self addSubview:_dayLabel];
        
        [_dayLabel setFont:[UIFont systemFontOfSize:16]];
    }
    return _dayLabel;
}

- (UILabel*) monthLable
{
    if (!_monthLable)
    {
        _monthLable = [[UILabel alloc] init];
        [_monthLable setTextColor:[UIColor whiteColor]];
        [self addSubview:_monthLable];
        [_monthLable setFont:[UIFont systemFontOfSize:12]];
    }
    
    return _monthLable;
}

- (UIImageView*) pointFlagImageView
{
    if (!_pointFlagImageView) {
        _pointFlagImageView = [[UIImageView alloc] init];
        [self addSubview:_pointFlagImageView];
        
        [_pointFlagImageView setBackgroundColor:[UIColor whiteColor]];
        _pointFlagImageView.layer.cornerRadius = 2.5;
        _pointFlagImageView.layer.masksToBounds = YES;
        [_pointFlagImageView setHidden:YES];
    }
    return _pointFlagImageView;
}

- (UIImageView*) giftImageView
{
    if (!_giftImageView) {
        _giftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"point_gift_white"]];
        [self addSubview:_giftImageView];
        [_giftImageView setHidden:YES];
        
       
    }
    return _giftImageView;
}
@end



@interface PointRedemptionWeeklyControl ()

@property (nonatomic, readonly) NSArray* pointCells;
@end

@implementation PointRedemptionWeeklyControl
@synthesize pointCells = _pointCells;

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.pointCells enumerateObjectsUsingBlock:^(PointRedemptionWeeklyCell* cell, NSUInteger idx, BOOL * _Nonnull stop) {
        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            if (idx == 0)
            {
                make.left.equalTo(self).with.offset(10);
            }
            else
            {
                PointRedemptionWeeklyCell* perCell = self.pointCells[idx - 1];
                make.left.equalTo(perCell.mas_right);
                make.width.equalTo(perCell);
            }
            
            if (cell == self.pointCells.lastObject) {
                make.right.equalTo(self).with.offset(-10);
            }
        }];
    }];
}

- (void) setContinuityDays:(NSInteger) continuityDays
             lastPointDate:(NSString*) lastPointDateString;
{
    NSDate* lastPointDate = [NSDate dateWithString:lastPointDateString formatString:@"yyyy-MM-dd HH:mm:ss"];
    if (!lastPointDate)
    {
        lastPointDate = [NSDate dateWithString:lastPointDateString formatString:@"yyyy-MM-dd"];
    }
    
    if (continuityDays >= 8) {
        continuityDays = continuityDays % 7;
        if (0 == continuityDays) {
            continuityDays = 7;
        }
    }
    
    NSDate* startPointDate = nil;
    if (continuityDays == 0 || !lastPointDate)
    {
        //没有连续签到
        startPointDate = [NSDate date];
        continuityDays = 0;
    }
    else
    {
        startPointDate = [lastPointDate dateBySubtractingDays:continuityDays - 1];
    }
    
    
    for (NSInteger index = 0; index < 8; ++index)
    {
        PointRedemptionWeeklyCell* cell = self.pointCells[index];
        [cell setDate:[startPointDate dateByAddingDays:index]];
        
        [cell showPointFlag:(index < continuityDays)];
        
        if (index == 6) {
            [cell showGiftImage:YES];
        }
    }
}

#pragma mark - settingAndGetting
- (NSArray*) pointCells
{
    if (!_pointCells) {
        NSMutableArray* pointCells = [NSMutableArray array];
        for (NSInteger index = 0; index < 8; ++index) {
            PointRedemptionWeeklyCell* cell = [[PointRedemptionWeeklyCell alloc] init];
            [self addSubview:cell];
            [pointCells addObject:cell];
            [cell setUserInteractionEnabled:NO];
            
            
        }
        
        _pointCells = pointCells;
    }
    return _pointCells;
}

@end
