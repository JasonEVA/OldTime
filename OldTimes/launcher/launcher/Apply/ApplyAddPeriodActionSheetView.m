//
//  ApplyAddPeriodActionSheetView.m
//  launcher
//
//  Created by Kyle He on 15/8/15.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyAddPeriodActionSheetView.h"
#import "UIView+Util.h"
#import "MyDefine.h"
#import "Category.h"
#import "Masonry.h"
#import <DateTools.h>
//字典中存的key
#define STARTTIME @"StartTime"    //开始时间
#define ENDTIME   @"EndTime"      //终了时间
#define WHOLEDAY  @"WholeDay"     //整天

@interface ApplyAddPeriodActionSheetView()

/**
 *  容器view
 */
@property (nonatomic, strong) UIView *contentView;
/**
 *  取消按钮
 */
@property (nonatomic, strong) UIButton *btnCancel;
/**
 *  时间选择器
 */
@property(nonatomic, strong) UIDatePicker *datePicer;
/**
 *  右上角的确认按钮
 */
@property(nonatomic, strong) UIButton *okBtn;
/**
 *  中间的segment
 */
@property( nonatomic, strong) UISegmentedControl *segCtrl;
/**
 *  右上角的红色开关
 */
@property(nonatomic, strong) UISwitch *whileDaySwitch;
/**
 *  与开关一起的标签
 */
@property(nonatomic, strong) UILabel *timeLbl;

@property(nonatomic, strong) NSMutableDictionary *timeDataDic;
@end


@implementation ApplyAddPeriodActionSheetView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        [self addSubview:self.contentView];
        [self addSubview:self.btnCancel];
        [self createFrame];
        [self.timeDataDic setValue:[self.datePicer date] forKey:STARTTIME];
        [self.timeDataDic setValue:[[self.datePicer date] dateByAddingHours:1] forKey:ENDTIME];
    }
    return  self;
}

#pragma mark - Logical Part
- (void)pickerValueChange
{
    if (self.segCtrl.selectedSegmentIndex == 0)
    {
        [self.timeDataDic setValue:[self.datePicer date] forKey:STARTTIME];
        if ([[self.timeDataDic objectForKey:STARTTIME] isLaterThan:[self.timeDataDic objectForKey:ENDTIME]])
        {
            [self.timeDataDic setValue:[[self.datePicer date] dateByAddingHours:1] forKey:ENDTIME];
        }
    }
    
    if (self.segCtrl.selectedSegmentIndex == 1)
    {
        if (self.datePicer.date == [self.datePicer.date earlierDate:[self.timeDataDic objectForKey:STARTTIME]])
        {
            self.datePicer.date = [[self.timeDataDic objectForKey:STARTTIME] dateByAddingTimeInterval:60*60];
            [self.timeDataDic setValue:[self.datePicer date] forKey:ENDTIME];
        }
        else
        {
            [self.timeDataDic setValue:[self.datePicer date] forKey:ENDTIME];
        }
    }
    
}

- (void)setStartDate:(NSDate *)startDate endDate:(NSDate *)endDate WholeDay:(BOOL)wholeDay {
    [self.timeDataDic setValue:startDate forKey:STARTTIME];
    [self.timeDataDic setValue:endDate forKey:ENDTIME];
    
    self.whileDaySwitch.on = wholeDay;
    [self SwitchValueChanged:self.whileDaySwitch];
    [self segChange:self.segCtrl];
}

//设置datePicker的时间选择
- (void)segChange:(UISegmentedControl *)segControl
{
    if (segControl.selectedSegmentIndex ==0 )
    {
        NSDate *tempdate = [self.timeDataDic objectForKey:STARTTIME];
        [self.datePicer setDate:tempdate animated:YES];
    }
    else
    {
        NSDate *tempdate = [self.timeDataDic objectForKey:ENDTIME];
        [self.datePicer setDate:tempdate animated:YES];
    }
//    if (segControl.selectedSegmentIndex ==0 )
//    {   //如果有值则显示已保存过的时间
//        if ([self.timeDataDic objectForKey:STARTTIME])
//        {
//            NSDate *tempdate = [self.timeDataDic objectForKey:STARTTIME];
//            [self.datePicer setDate:tempdate animated:YES];
//            [self.timeDataDic setValue:[self.datePicer date] forKey:STARTTIME];
//        }
//    }
//
//    //选择第二个部分时
//    if (segControl.selectedSegmentIndex == 1)
//    {   //如果第2个有选择
//        NSDate *temp = nil;
//        if([self.timeDataDic objectForKey:STARTTIME])
//        {
//            temp = [self.timeDataDic objectForKey:STARTTIME];
//        }else
//        {
//            temp = [NSDate date];
//        }
//        temp = [temp dateByAddingTimeInterval:60*60];
//        [self.datePicer setDate:temp animated:YES];
//        [self.timeDataDic setValue:[self.datePicer date] forKey:ENDTIME];
//    }
}

#pragma mark - initilizer
- (UIButton *)btnCancel
{
    if (!_btnCancel)
    {
        _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(5, self.frame.size.height - 50 - 65, self.frame.size.width - 10, 50)];
        _btnCancel.layer.cornerRadius = 4.0f;
        _btnCancel.backgroundColor = [UIColor whiteColor];
        [_btnCancel setTitle:LOCAL(CANCEL) forState:UIControlStateNormal];
        [_btnCancel setTitleColor:[UIColor themeBlue] forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
        _btnCancel.clipsToBounds = YES;
    }
    return _btnCancel;
}

- (UIView *)contentView {
    if (!_contentView)
    {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(5, self.frame.size.height - 230 - 55 - 65, self.frame.size.width - 10, 230)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 5.0;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIDatePicker *)datePicer
{
    if (!_datePicer)
    {
        _datePicer = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        _datePicer.datePickerMode = UIDatePickerModeDate;
//        [_datePicer setMinimumDate:[NSDate date]];
        [_datePicer addTarget:self action:@selector(pickerValueChange) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicer;
}

- (UILabel *)timeLbl
{
    if (!_timeLbl)
    {
        _timeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLbl.text = LOCAL(APPLY_ALLDAY);
        _timeLbl.font = [UIFont systemFontOfSize:15.0];
    }
    return _timeLbl;
}

- (UISegmentedControl *)segCtrl
{
    if (!_segCtrl)
    {
        _segCtrl = [[UISegmentedControl alloc] initWithItems:@[LOCAL(APPLY_BEGIN_TIME),LOCAL(APPLY_END_TIME)]];
        _segCtrl.selectedSegmentIndex = 0;
        _segCtrl.tintColor = [UIColor themeBlue];
        [_segCtrl addTarget:self action:@selector(segChange:) forControlEvents:UIControlEventValueChanged];
           }
    return _segCtrl;
}

- (UIButton *)okBtn
{
    if (!_okBtn)
    {
        _okBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _okBtn.expandSize = CGSizeMake(60 , 60);
        [_okBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_okBtn setBackgroundImage:[UIImage imageNamed:@"Calendar_check"] forState:UIControlStateNormal];
    }
    return _okBtn;
}

- (UISwitch *)whileDaySwitch
{
    if (!_whileDaySwitch)
    {
        _whileDaySwitch = [[UISwitch alloc] init];
        [_whileDaySwitch setOn:YES];
        [_whileDaySwitch addTarget:self action:@selector(SwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _whileDaySwitch;
}

- (NSMutableDictionary *)timeDataDic
{
    if (!_timeDataDic)
    {
        _timeDataDic = [[NSMutableDictionary alloc] init];
    }
    return _timeDataDic;
}
#pragma mark - Private Method

- (void)show {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.contentView.frame = CGRectMake(5, self.frame.size.height, self.frame.size.width - 10, 230);
    self.btnCancel.frame = CGRectMake(5, self.frame.size.height +230, self.frame.size.width - 10, 50);
    [window addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.contentView.frame = CGRectMake(5, self.frame.size.height - 230 - 55, self.frame.size.width - 10, 230);
        self.btnCancel.frame = CGRectMake(5, self.frame.size.height - 50, self.frame.size.width - 10, 50);
    } completion:^(BOOL finished) {
        self.contentView.frame = CGRectMake(5, self.frame.size.height - 230 - 55, self.frame.size.width - 10, 230);
        self.btnCancel.frame = CGRectMake(5, self.frame.size.height - 50, self.frame.size.width - 10, 50);
    }];
}

- (void)dismiss
{
    [self.timeDataDic setObject:[NSNumber numberWithBool:self.whileDaySwitch.on] forKey:WHOLEDAY];
    
    if ([self.delegate respondsToSelector:@selector(callBackWithDic:)]) {
        [self.delegate callBackWithDic:self.timeDataDic];
    }
    [self removeFromSuperview];
}

- (void)remove
{
    if ([self.delegate respondsToSelector:@selector(closeSwitch)]) {
        [self.delegate closeSwitch];
    }
    
    [self removeFromSuperview];
}

- (void)SwitchValueChanged:(UISwitch *)Switch
{
    [self.timeDataDic setValue:[NSNumber numberWithBool:Switch.on] forKey:WHOLEDAY];
    if (Switch.on)
    {
        [self.datePicer setDatePickerMode:UIDatePickerModeDate];
        self.datePicer.minimumDate = [NSDate date];
    }
    else
    {
        [self.datePicer setDatePickerMode:UIDatePickerModeDateAndTime];
    }
    
    [self pickerValueChange];
}

#pragma mark - createFram

- (void)createFrame
{
    
    [self.contentView addSubview:self.datePicer];
    [self.datePicer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(80);
    }];
 
    [self.contentView addSubview:self.timeLbl];
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.contentView addSubview:self.whileDaySwitch];
    [self.whileDaySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLbl).offset(-7);
        make.left.equalTo(self.timeLbl.mas_right).offset(10);
    }];
    
    [self.contentView addSubview:self.okBtn];
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(10);
        make.width.height.equalTo(@(20));
    }];
    
    [self.contentView addSubview:self.segCtrl];
    [self.segCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.datePicer.mas_top).offset(-5);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.equalTo(@(self.frame.size.width - 180));
        make.height.equalTo(@25);
    }];
}


@end
