//
//  MissionDetailModel.h
//  launcher
//
//  Created by William Zhang on 15/9/8.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  任务详情Model

#import "MissionMainViewModel+Util.h"
#import "CalendarLaunchrModel.h"

@class ProjectModel;

@interface MissionDetailModel : MissionMainViewModel

/** 所属项目 */
@property (nonatomic, strong) ProjectModel *project;
/** 可以nil */
@property (nonatomic, strong) NSArray *tagArray;
@property (nonatomic, assign) calendar_remindType remindType;
@property (nonatomic, assign) calendar_repeatType repeatType;
/** 附件 */
@property (nonatomic, strong) NSMutableArray *attachMentArray;
/** 分配人员 */
@property (nonatomic, strong) NSMutableArray *personArray;
/** 备注 */
@property (nonatomic, copy) NSString *comment;



- (instancetype)initWithDict:(NSDictionary *)dict;

@end
