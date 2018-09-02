//
//  MissionDatePickerCell.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//  时间选择器

#import <UIKit/UIKit.h>

@class MissionDatePickerCell;
@protocol MissionDatePickerCellDelegate <NSObject>

@optional
- (void)MissionDatePickerCellCallBack_didSelectAtIndexPath:(NSIndexPath *)indexPath date:(NSDate *)date isWholeDay:(BOOL)isWholdDay isNone:(BOOL)isNone;
@end
@interface MissionDatePickerCell : UITableViewCell

@property (nonatomic, strong)  NSIndexPath  *indexPath; // <##>

+ (NSString *)identifier;
//设置最大最小日期
- (void)setMyMaxDate:(NSDate *)MaxDate MinDate:(NSDate *)MinDate;

- (void)setDate:(NSDate *)date;

- (void)wholeDayIsOn:(BOOL)isOn;

@property (nonatomic, weak) id<MissionDatePickerCellDelegate> delegate;

@end
