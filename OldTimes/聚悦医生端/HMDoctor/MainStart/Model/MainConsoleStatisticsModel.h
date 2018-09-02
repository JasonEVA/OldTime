//
//  MainConsoleStatisticsModel.h
//  HMDoctor
//
//  Created by yinquan on 2017/5/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainConsoleStatisticsModel : NSObject

@property (nonatomic, assign) NSInteger chargePatientCount;     //收费用户数量
@property (nonatomic, assign) NSInteger freePatientCount;       //随访用户数量
@property (nonatomic, assign) NSInteger newPatientCount;        //本周新入组数量
@property (nonatomic, assign) NSInteger blocPatientCount;       //集团用户数量
@property (nonatomic, assign) float income;                     //收益

@end
