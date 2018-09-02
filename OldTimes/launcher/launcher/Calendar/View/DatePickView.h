//
//  DatePickView.h
//  launcher
//
//  Created by Conan Ma on 15/8/26.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerDelegate <NSObject>
- (void)getNewDateWhenPickViewValueChanged:(NSDate *)date;
@end

@interface DatePickView : UIPickerView
@property (nonatomic, weak) id<DatePickerDelegate>Valuedelegate;
@property (nonatomic, strong) NSMutableArray *arrYearsWithMandD;
@property (nonatomic, strong) NSMutableArray *arrHour;
@property (nonatomic, strong) NSMutableArray *arrMinute;
@property (nonatomic, strong) NSDate *SelectedDate;
//不用
- (void)SetDate:(NSDate *)date;
- (void)setpickviewWithDate:(NSDate *)date;
@end
