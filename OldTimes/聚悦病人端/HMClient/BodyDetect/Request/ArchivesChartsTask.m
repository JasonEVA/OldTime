//
//  ArchivesChartsTask.m
//  HMClient
//
//  Created by lkl on 2017/5/10.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "ArchivesChartsTask.h"
#import "ArchivesChartsModel.h"

@implementation ArchivesChartsTask


- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postHealthPlan2Service:@"getUserArchivesTest"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if (stepResult && [stepResult isKindOfClass:[NSArray class]])
    {
        NSArray *dicResp = (NSArray *)stepResult;
        NSMutableArray *resultArrary = [NSMutableArray array];
        
        [dicResp enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
            ArchivesChartsModel *model = [ArchivesChartsModel mj_objectWithKeyValues:dic];
            
            [resultArrary addObject:model];
        }];
        
        _taskResult = resultArrary;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
