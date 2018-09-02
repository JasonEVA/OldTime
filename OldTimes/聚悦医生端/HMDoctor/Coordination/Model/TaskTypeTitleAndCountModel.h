//
//  TaskTypeTitleAndCountModel.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//  任务类型标题和任务数model

#import <Foundation/Foundation.h>

@interface TaskTypeTitleAndCountModel : NSObject

@property (nonatomic, assign)  NSInteger  tabInd; // 类型ID
@property (nonatomic, assign)  NSInteger  count; // 数量
@property (nonatomic, strong)  NSString  *tabName; // 类型名

@end
