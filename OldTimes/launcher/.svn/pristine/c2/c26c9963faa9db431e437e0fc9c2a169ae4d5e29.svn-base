//
//  ProjectModel.h
//  launcher
//
//  Created by William Zhang on 15/9/8.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  项目Model

#import <Foundation/Foundation.h>

@interface ProjectModel : NSObject

@property (nonatomic, copy) NSString *showId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger teamNumber;
@property (nonatomic, assign) NSInteger unFinishedTask;
/** 任务数量(allTask) */
@property (nonatomic, assign) NSInteger taskCounts;
/** 专为taskCounts输出string */
@property (nonatomic, readonly) NSString *taskCountsString;

@property (nonatomic, strong) NSMutableArray *arrayMembers;

@property (nonatomic,strong) NSString * createUser ; // 创建人

- (instancetype)initWithDict:(NSDictionary *)dict;
- (instancetype)initWithName:(NSString *)name count:(NSInteger)count;

@end
