//
//  DetectSceneListTask.m
//  HMDoctor
//
//  Created by yinquan on 2017/10/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "DetectSceneListTask.h"
#import "DetectSceneModel.h"

@implementation DetectSceneListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserTestDataService:@"getAllTestEnv"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if (stepResult && [stepResult isKindOfClass:[NSArray class]])
    {
        NSMutableArray<DetectSceneModel*>* detectScenes = [NSMutableArray array];
        
        NSArray<NSDictionary*>* dictList = (NSArray<NSDictionary*>*) stepResult;
        [dictList enumerateObjectsUsingBlock:^(NSDictionary * dict, NSUInteger idx, BOOL * _Nonnull stop)
         {
             DetectSceneModel* model = [DetectSceneModel mj_objectWithKeyValues:dict];
             [detectScenes addObject:model];
         }];
        _taskResult = detectScenes;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
