//
//  BodyDetectUniversalPickerView.h
//  HMClient
//
//  Created by Dee on 16/10/8.
//  Copyright © 2016年 YinQ. All rights reserved.
//  通用选择的控件

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, kPickerType) {
    k_PickerType_Default = 0,           //默认控件，不做任何针对性处理
    k_PickerType_SportMode = 1,         //针对于运动方式
    k_PickerType_BloodSugar,            //针对于血糖
    k_PickerType_BloodPressure,         //针对于血压
};

typedef void(^dataCallBackBlock)( NSMutableArray *  selectedItems);

typedef void(^BodyDetectUniversalPickerSelectPicker)(NSInteger row, NSInteger col);

@interface BodyDetectUniversalPickerView : UIView


/**
 选择滚轮初始化方法
 
 @param dataArray 数据源
 @param array     默认选项数据
 @param type      控件类型
 @param block     回调方法

 */
- (instancetype)initWithDataArray:(NSArray *)dataArray detaultArray:(NSArray *)array pickerType:(kPickerType)type dataCallBackBlock:(dataCallBackBlock)block;

- (instancetype)initWithDataArray:(NSArray *)dataArray detaultArray:(NSArray *)array pickerType:(kPickerType)type selectBlock:(BodyDetectUniversalPickerSelectPicker)block;
@end
