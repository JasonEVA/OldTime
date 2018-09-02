//
//  CalendarMakeSureMapTableViewCell.h
//  launcher
//
//  Created by William Zhang on 15/8/3.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  日历确认事件地图Cell

#import <UIKit/UIKit.h>

@class PlaceModel;

@interface CalendarMakeSureMapTableViewCell : UITableViewCell

+ (NSString *)identifier;
+ (CGFloat)height;

/** 设置地图位置 */
- (void)mapWithPlaceModel:(PlaceModel *)placeModel;

/** 设置箭头，不设置则是定位图片 */
- (void)setAccessoryDisclosureIndicator;

@end
