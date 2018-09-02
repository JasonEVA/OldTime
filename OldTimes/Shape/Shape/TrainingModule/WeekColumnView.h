//
//  WeekColumnView.h
//  Shape
//
//  Created by Andrew Shen on 15/11/11.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
// 周控件

#import <UIKit/UIKit.h>

@protocol WeekColumnViewDelegate <NSObject>

// 点击了第几个日期
- (void)WeekColumnViewDelegateCallBack_weekDayClicked:(NSInteger)weekDay;

@end
@interface WeekColumnView : UIView
@property (nonatomic, weak)  id <WeekColumnViewDelegate>  delegate; // <##>
@end
