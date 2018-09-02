//
//  ActionStatusManager.h
//  HMDoctor
//
//  Created by Dee on 16/9/26.
//  Copyright © 2016年 yinquan. All rights reserved.
//  用户数据分析

#import <Foundation/Foundation.h>

@interface ActionStatusManager : NSObject

@property(nonatomic, assign) BOOL  userStatisticsIsOn;

+ (ActionStatusManager *)shareInstance;

- (void)addActionStatusWithPageName:(NSString *)pageName;
@end
