//
//  AppScheduleModel.h
//  launcher
//
//  Created by Andrew Shen on 15/10/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  消息日程会议详情model

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

@interface AppScheduleModel : NSObject

@property (nonatomic, strong)  NSString  *title; // String 会议标题
@property (nonatomic)  long long  start; // Long 会议开始时间
@property (nonatomic)  long long  end; // Long 会议结束时间
@property (nonatomic, strong)  NSString  *roomName; // String 会议室名称
@property (nonatomic, strong)  NSString  *id; // String 会议的id
@property (nonatomic, strong)  NSString  *content; // String 会议内容
@property (nonatomic, strong)  NSString  *external; // String 外部会议地点
@property (nonatomic, strong) NSString *reason;

@property (nonatomic, assign) BOOL isAgree;

@end
