//
//  PointRedemptionMonthRecordModel.h
//  HMClient
//
//  Created by yinquan on 2017/7/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointRedemptionMonthRecordModel : NSObject

@property (nonatomic, retain) NSString* attendanceTime;
@property (nonatomic, assign) NSInteger extraScore;
@property (nonatomic, assign) BOOL isSigned;

@end
