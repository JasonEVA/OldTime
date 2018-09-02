//
//  ASDatePicker.h
//  AnimationDemo
//
//  Created by Andrew Shen on 2017/1/5.
//  Copyright © 2017年 AndrewShen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ASDatePickerCompletionHandler)(BOOL confirm, NSDate *date);
@interface ASDatePicker : UIView

@property (nonatomic, strong) NSDate *minimumDate; // specify min/max date range. default is nil. When min > max, the values are ignored. Ignored in countdown timer mode
@property (nonatomic, strong) NSDate *maximumDate; // default is nil

- (void)setDate:(NSDate *)date animated:(BOOL)animated; // if animated is YES, animate the wheels of time to display the new date

- (instancetype)initWithToolbar:(BOOL)showToolbar;
- (void)addDatePickerCompletionNoti:(ASDatePickerCompletionHandler)handler;
@end
