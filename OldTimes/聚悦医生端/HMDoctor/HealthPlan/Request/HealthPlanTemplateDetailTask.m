//
//  HealthPlanTemplateDetailTask.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/29.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanTemplateDetailTask.h"

@interface HealthPlanTemplateDetailTask ()

@property (nonatomic, strong) NSString* typeCode;
@end

@implementation HealthPlanTemplateDetailTask

- (id) initWithTaskId:(NSString*) taskId
{
    self = [super initWithTaskId:taskId];
    if (self) {
        if (taskParam && [taskParam isKindOfClass:[NSDictionary class]])
        {
            _typeCode = [taskParam valueForKey:@"typeCode"];
        }
    }
    return self;
}

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postHealthyPlanTemplateServiceUrl:@"getSubTemplateDetails"];
    return postUrl;
}


- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    __block NSMutableArray* criteriaModels = [NSMutableArray array];
    
    if ([self.typeCode isEqualToString:@"survey"] ||
        [self.typeCode isEqualToString:@"wards"] ||
        [self.typeCode isEqualToString:@"assessment"]) {
        //随访、评估、查房模版
        if([stepResult isKindOfClass:[NSArray class]])
        {
            NSArray* array = (NSArray*) stepResult;
            [array enumerateObjectsUsingBlock:^(NSDictionary* dict, NSUInteger idx, BOOL * _Nonnull stop)
            {
                HealthPlanDetCriteriaModel* criteriaModel = [[HealthPlanDetCriteriaModel alloc] init];
                criteriaModel.periodType = [dict valueForKey:@"periodType"];
                criteriaModel.periodValue = [dict valueForKey:@"periodValue"];
                criteriaModel.surveyMoudleId = [dict valueForKey:@"surveyMoudleId"];
                criteriaModel.surveyMoudleName = [dict valueForKey:@"surveyMoudleName"];
                
                [criteriaModels addObject:criteriaModel];
            }];
        }
    
        _taskResult = criteriaModels;
        return;
    }
    if ([self.typeCode isEqualToString:@"test"])
    {
        //监测
        if([stepResult isKindOfClass:[NSArray class]])
        {
            NSArray* array = (NSArray*) stepResult;
            [array enumerateObjectsUsingBlock:^(NSDictionary* dict, NSUInteger idx, BOOL * _Nonnull stop)
             {
                 NSMutableDictionary* modelDictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
                 NSArray* targets = [dict valueForKey:@"targets"];
                 if (targets) {
                     [modelDictionary setValue:targets forKey:@"testTargets"];
                 }
                 
                 NSArray* alertTime = [dict valueForKey:@"alertTime"];
                 if (alertTime) {
                     [modelDictionary setValue:alertTime forKey:@"alertTimes"];
                 }
                 
                 NSArray* warning = [dict valueForKey:@"warning"];
                 if (warning) {
                     [modelDictionary setValue:warning forKey:@"warnings"];
                 }
                 
                 HealthPlanDetCriteriaModel* criteriaModel = [HealthPlanDetCriteriaModel mj_objectWithKeyValues:modelDictionary];
                 [criteriaModels addObject:criteriaModel];
             }];
            _taskResult = criteriaModels;
            return;
        }
        

    }
    if ([self.typeCode isEqualToString:@"sports"]) {
        //运动
        if([stepResult isKindOfClass:[NSDictionary class]])
        {
            NSMutableDictionary* modelDictionary = [NSMutableDictionary dictionaryWithDictionary:stepResult];
            NSNumber* sportsTimes = [stepResult valueForKey:@"sportsTimes"];
            if (sportsTimes &&( [sportsTimes isKindOfClass:[NSNumber class]] || [sportsTimes isKindOfClass:[NSString class]]))
            {
                [modelDictionary setValue:[NSString stringWithFormat:@"%ld", sportsTimes.integerValue] forKey:@"sportsTimes"];
            }
            
            NSArray* sportsType = [stepResult valueForKey:@"sportsType"];
            if (sportsType) {
                [modelDictionary setValue:sportsType forKey:@"sportType"];
            }
            
            HealthPlanDetCriteriaModel* criteriaModel = [HealthPlanDetCriteriaModel mj_objectWithKeyValues:modelDictionary];
            
            [criteriaModels addObject:criteriaModel];
            _taskResult = criteriaModels;
            return;
        }
    }
    
    if ([self.typeCode isEqualToString:@"mentality"])
    {
        //心理
        if([stepResult isKindOfClass:[NSDictionary class]])
        {
            HealthPlanDetCriteriaModel* criteriaModel = [HealthPlanDetCriteriaModel mj_objectWithKeyValues:stepResult];
            if (!criteriaModel.target)
            {
                criteriaModel.target = @"";
            }
            [criteriaModels addObject:criteriaModel];
            _taskResult = criteriaModels;
            return;

        }
    }
    
    if ([self.typeCode isEqualToString:@"live"] ||
        [self.typeCode isEqualToString:@"nutrition"])
    {
        //生活、营养
        if([stepResult isKindOfClass:[NSDictionary class]])
        {
            HealthPlanDetCriteriaModel* criteriaModel = [HealthPlanDetCriteriaModel mj_objectWithKeyValues:stepResult];
            [criteriaModels addObject:criteriaModel];
            _taskResult = criteriaModels;
            return;
        }
        
    }
    
    if ([self.typeCode isEqualToString:@"review"])
    {
        //复查
        if([stepResult isKindOfClass:[NSArray class]])
        {
            NSArray* array = (NSArray*) stepResult;
            [array enumerateObjectsUsingBlock:^(NSDictionary* dict, NSUInteger idx, BOOL * _Nonnull stop)
             {
                 HealthPlanDetCriteriaModel* criteriaModel = [HealthPlanDetCriteriaModel mj_objectWithKeyValues:dict];
                 [criteriaModels addObject:criteriaModel];
             }];
        }
        
        _taskResult = criteriaModels;
        return;
    }
    
//    if([stepResult isKindOfClass:[NSDictionary class]])
//    {
//        HealthPlanSubTemplateModel* detailModel = [HealthPlanSubTemplateModel mj_objectWithKeyValues:currentStep.stepResult];
//        _taskResult = detailModel;
//        return;
//    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
