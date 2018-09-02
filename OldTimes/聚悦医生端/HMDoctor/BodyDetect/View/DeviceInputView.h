//
//  DeviceInputView.h
//  HMClient
//
//  Created by lkl on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceInputControl : UIControl

@property (nonatomic, readonly) UITextField* tfValue;

- (void) setName:(NSString*) name unit:(NSString*)unit;
- (void) setPlaceholder:(NSString*) placeholder;

//设置键盘类型
- (void)setKeyboardType:(UIKeyboardType)keyboardType;
- (void)setArrowHide:(BOOL)isHide;
@end

@interface DeviceTestTimeControl : UIControl

@property (nonatomic, readonly) UILabel *lbtestTime;
- (void)setArrowHide:(BOOL)isHide;
@end


@interface DeviceTestPeriodControl : UIControl

@property (nonatomic,strong) UILabel *lbtestPeriod;

- (void) setName:(NSString*) name;
- (void)setTestPeriod:(NSString *)testPeriod;
- (void)setArrowHide:(BOOL)isHide;
@end

@interface DeviceManualInputControl : UIControl
@property (nonatomic, readonly) UILabel* lbValue;

- (void) setName:(NSString*) name unit:(NSString*)unit;
- (void)setLabelValue:(NSString *)aValue;
- (void)setSubLabelText:(NSString *)subString;
- (void)setArrowHide:(BOOL)isHide;
@end
