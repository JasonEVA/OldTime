//
//  CalendarDateDataModel.h
//  Titans
//
//  Created by Wythe Zhou on 10/29/14.
//  Copyright (c) 2014 Remon Lv. All rights reserved.
//

//  月历某天的数据模型

#import <Foundation/Foundation.h>
#import "DayModel.h"

@interface CalendarDateDataModel : NSObject
{

}


@property (nonatomic) NSInteger _year;
@property (nonatomic) NSInteger _month;
@property (nonatomic) NSInteger _weekday;
@property (nonatomic) DayModel  *_dayModel;
@property (nonatomic, strong) NSDate *_date;    // 这一天对应的 date 对象

@property (nonatomic) BOOL _weekends;           // 判断是不是周末
@property (nonatomic) BOOL _ifToday;     	    // 是不是今天
@property (nonatomic) BOOL _ifHaveEvents;       // 有没有事情
@property (nonatomic) BOOL _isSelected;         // 有没有被选中

- (void)setYear:(NSInteger) year month:(NSInteger)month day:(DayModel *)dayModel; // 设置时间信息，会自动更新其他内容

@end
