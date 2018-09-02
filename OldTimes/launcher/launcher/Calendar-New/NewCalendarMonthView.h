//
//  NewCalendarMonthView.h
//  launcher
//
//  Created by williamzhang on 16/3/3.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  新版日程月视图


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RequestType) {
    k_getLastYearEventData = 0,
    k_getNextYearEventData
};
@class NewCalendarMonthDataModel;
@class NewCalendarYearAndMonthNumberView;

@protocol NewCalendarMonthViewDelegate <NSObject>

- (void)presentVCWithDate:(NSDate *)date;

- (void)getMoreEventDataWithType:(RequestType)type;

- (void)SetTodayColor:(BOOL)isToday;
- (void)newCalendarMonthViewDelegateDidTitleViewChangeWithYearsText:(NSString *)year MonthsText:(NSString *)month;

@end

@interface NewCalendarMonthView : UIView

@property(nonatomic, strong) NSMutableDictionary  *eventDictionary;

@property(nonatomic, strong) UITableView   *tableView;

@property(nonatomic, weak) NewCalendarYearAndMonthNumberView  *titleView;

@property(nonatomic, weak) id  <NewCalendarMonthViewDelegate>delegate;

@property(nonatomic, strong)  NewCalendarMonthDataModel *currentDateModel;

@property (nonatomic, copy, readonly) NSString *currentMonthTitle;

@property (nonatomic, copy, readonly) NSString *currentYearTitle;

- (BOOL)isTodayVisible;
@end
