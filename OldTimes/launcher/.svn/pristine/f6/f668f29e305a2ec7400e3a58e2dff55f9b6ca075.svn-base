//
//  ApplyAddPeriodActionSheetView.h
//  launcher
//
//  Created by Kyle He on 15/8/15.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  期间的时间选择页

#import <UIKit/UIKit.h>

@protocol ApplyAddPeriodActionSheetViewDelegate <NSObject>

@optional
- (void)callBackWithDic:(NSDictionary*)dic;
- (void)closeSwitch;

@end

@interface ApplyAddPeriodActionSheetView : UIView

@property( nonatomic, strong ) id<ApplyAddPeriodActionSheetViewDelegate>delegate ;
@property (nonatomic, strong) id identifier;

- (void)setStartDate:(NSDate *)startDate endDate:(NSDate *)endDate WholeDay:(BOOL)wholeDay;

@end
