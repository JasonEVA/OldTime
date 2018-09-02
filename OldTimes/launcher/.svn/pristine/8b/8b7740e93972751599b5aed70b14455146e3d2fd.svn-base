//
//  ATDailyAttendanceHeadView.h
//  Clock
//
//  Created by SimonMiao on 16/7/26.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ATDailyAttendanceHeadViewBlock)(NSUInteger btnIndex,NSNumber *timestamp);

@interface ATDailyAttendanceHeadView : UIView

@property (nonatomic, strong) NSNumber *currentTimestamp;
@property (nonatomic, assign) BOOL enbleClockInBtn; //!< 设置下班按钮是否可以点击
@property (nonatomic, copy) ATDailyAttendanceHeadViewBlock block;

- (void)dailyClock:(ATDailyAttendanceHeadViewBlock)block;

@end
