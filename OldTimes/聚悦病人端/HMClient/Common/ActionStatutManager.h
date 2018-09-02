//
//  ActionStatutManager.h
//  HMClient
//
//  Created by Dee on 16/9/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//  用户数据分析

#import <Foundation/Foundation.h>

@interface ActionStatutManager : NSObject

@property(nonatomic, assign) BOOL  userStaticsticIsOn;

+ (instancetype)shareInstance;

- (void)addActionStatusWithPageName:(NSString *)pageName;

@end
