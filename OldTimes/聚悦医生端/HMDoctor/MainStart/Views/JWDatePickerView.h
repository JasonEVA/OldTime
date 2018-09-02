//
//  JWDatePickerView.h
//  HMDoctor
//
//  Created by jasonwang on 2017/9/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^pickerBlock)(NSInteger clickTag);

@interface JWDatePickerView : UIView
@property (nonatomic, strong) UIDatePicker *datePicker;

- (instancetype)initWithFrame:(CGRect)frame dateMode:(UIDatePickerMode)mode backColor:(UIColor *)backColor maxDate:(NSDate *)maxDate block:(pickerBlock)block;

@end
