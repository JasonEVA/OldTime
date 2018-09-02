//
//  CalendarMonthTableViewCell.h
//  Titans
//
//  Created by Wythe Zhou on 10/29/14.
//  Copyright (c) 2014 Remon Lv. All rights reserved.
//

//

#import <UIKit/UIKit.h>
#import "CalendarMonthDataModel.h"
#import "CalendarDayCellView.h"
#import "CalendarDateDataModel.h"
#import "CalendarDayCellView.h"
#import "CalendarDateDataModel.h"

@class CalendarMonthTableViewCell;

@protocol CalendarMonthTableViewCellDelegate <NSObject>

- (void)CalendarMonthTableViewCellDelegateCallBack_DayCellClickedWithCalendarMonthDataModel:(CalendarMonthDataModel *)monthDataModel calendarDateDataModel:(CalendarDateDataModel *)dateDataModel Cell:(CalendarMonthTableViewCell *)Cell;

@end

@interface CalendarMonthTableViewCell : UITableViewCell <CalendarDayCellViewDelegate>
{
//    UILabel *_textLabel;        // 测试用
    
    CGFloat _wCell;                 // 整个 Cell 的宽度
    CGFloat _hCellLine;             // 一行数据的高度 50
    
    CGFloat _yMarginLabelMonth;     // 月份 label 的上距离
    CGFloat _hLabelMonth;     // 高度
    CGFloat _wLabelMonth;     // 宽度
    
    CGFloat _xMarginDayCellView;    // 左边距离
    CGFloat _yMarginDayCellView;    // 上边距离
    CGFloat _xGapDayCellView;       // 两个单元格之间的距离
    CGFloat _wDayCellView;          // 子天数 View 的宽度
    CGFloat _hDayCellView;          //              高度
    
    CGFloat _hLine;                 // 分割线高
    
    UIColor *_colorLine;            // 分割线颜色
    UIColor *_colorLabelMonth;      // 月份标示中的字体颜色
    UIFont *_fontLabelMonth;        // month 的字体
    
    UILabel *_labelMonth;           // 用来指示月份
    NSMutableArray *_arrayDayCell;       // 用来放每天的小格子
    NSMutableArray *_arrayLine;          // 放分割线数组
    
    NSArray *_arrayMonthTitle;      // 月份的标题
}

@property (nonatomic, strong) CalendarMonthDataModel *_monthDataModel;

@property (nonatomic, weak) id <CalendarMonthTableViewCellDelegate> delegate;

// 设置 Model，会自动调用更新
- (void)setMonthDataModel:(CalendarMonthDataModel *)monthDataModel;

// 更新元素信息
- (void)refreshComponents;

@end
