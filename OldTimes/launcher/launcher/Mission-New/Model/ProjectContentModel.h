//
//  ProjectContentModel.h
//  launcher
//
//  Created by TabLiu on 16/2/17.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  项目

#import <Foundation/Foundation.h>

@interface ProjectContentModel : NSObject

@property (nonatomic,strong) NSString * showId ; // 项目ID
@property (nonatomic,strong) NSString * name ;   // 项目名
@property (nonatomic,assign) long long  teamNumber ; // 项目成员数量
@property (nonatomic,assign) NSInteger  unFinishedTask ; // 未完成
@property (nonatomic,assign) NSInteger  allTask ; // 全部
@property (nonatomic,strong) NSString * createUser ; // 创建人

- (id)initWithDict:(NSDictionary *)dic;

@end
