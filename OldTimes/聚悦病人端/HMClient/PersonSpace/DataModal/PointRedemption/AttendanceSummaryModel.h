//
//  AttendanceSummaryModel.h
//  HMClient
//
//  Created by yinquan on 2017/7/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttendanceSummaryModel : NSObject

@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger totalScore;
@property (nonatomic, assign) NSInteger seriesNum;  //连续签到天数
@property (nonatomic, retain) NSString* attendanceTime;     //最后签到日期

@end
