//
//  ZJKDatePickerSheet.m
//  ZJKPatient
//
//  Created by yinqaun on 15/5/7.
//  Copyright (c) 2015年 YinQ. All rights reserved.
//

#import "ZJKDatePickerSheet.h"

@interface ZJKDatePickerSheet()
{
    
}

@end

@implementation ZJKDatePickerSheet
- (instancetype)init {
    if (self = [super init]) {
        [self createPicker];
    }
    return self;
}

- (void) setDate:(NSString*) sDate
{
    if (!sDate || 0 == sDate.length)
    {
        return;
    }
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [formatter dateFromString:sDate];
    
    if (date && datePicker)
    {
        [datePicker setDate:date];
    }
}

- (void) createPicker
{
    datePicker = [[UIDatePicker alloc]init];
    [datePicker setWidth:kScreenWidth];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [pickerview addSubview:datePicker];
    
}

- (void) makeResult
{
    NSDate* date = datePicker.date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    sResult = [formatter stringFromDate:date];
}

@end

@implementation ZJkDateTimePickerSheet

- (void) setDate:(NSString*) sDate
{
    if (!sDate || 0 == sDate.length)
    {
        return;
    }
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:sDate];
    
    if (date && datePicker)
    {
        [datePicker setDate:date];
    }
}

- (void)createPicker
{
    datePicker = [[UIDatePicker alloc]init];
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [pickerview addSubview:datePicker];
    
}

- (void) makeResult
{
    NSDate* date = datePicker.date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    sResult = [formatter stringFromDate:date];
}

@end
