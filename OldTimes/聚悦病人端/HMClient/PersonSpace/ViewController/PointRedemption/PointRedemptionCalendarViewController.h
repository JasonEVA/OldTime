//
//  PointRedemptionCalendarViewController.h
//  JYClientDemo
//
//  Created by yinquan on 2017/7/10.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PointRedemptionCalendarView.h"

@interface PointRedemptionCalendarHubView : UIView

@property (nonatomic, strong) PointRedemptionCalendarView* calendarView;
@property (nonatomic, strong) UILabel* dateLabel;
@property (nonatomic, strong) UIButton* closeButton; //close_button_icon


@end

@interface PointRedemptionCalendarViewController : UIViewController

@property (nonatomic, strong) PointRedemptionCalendarHubView* hubView;
@property (nonatomic, readonly) NSDate* monthDate;

+ (void) show;

- (void) loadPointRedemptionRecords:(NSString*) monthString;
- (void) setMonthlyPointRecordModels:(NSArray*) models;

@end
