//
//  DeviceTestTimeSelectView.h
//  HMClient
//
//  Created by Dee on 16/10/8.
//  Copyright © 2016年 YinQ. All rights reserved.
//  测试时间控件

#import <UIKit/UIKit.h>
typedef void(^dateCallBackBlock)(NSDate * selectedTime);
@interface DeviceTestTimeSelectView : UIView

/**
 时间选择回调
 
 */
- (void)getSelectedItemWithBlock:(dateCallBackBlock)block;

/**
 设置选择器的时间
 
 @param date NSDate
 */
- (void)setDate:(NSDate *)date;

/**
 设置时间选择控件的显示样式

 @param model UIDatePickerMode
 */
- (void)setDateModel:(UIDatePickerMode )mode;
@end
