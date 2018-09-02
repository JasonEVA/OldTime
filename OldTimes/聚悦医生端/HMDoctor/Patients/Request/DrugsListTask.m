//
//  DrugsListTask.m
//  HMDoctor
//
//  Created by lkl on 16/6/20.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "DrugsListTask.h"
#import "DrugInfo.h"

@implementation DrugsListTask

@end

@implementation SearchDrugsTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postRecipeServiceUrl:@"searchDrugs"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    //NSLog(@"%@",stepResult);
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSNumber* numCount = [dicResp valueForKey:@"count"];
        NSArray* lstResp = [dicResp valueForKey:@"list"];
        NSMutableArray* drugItems = [NSMutableArray array];
        if (lstResp && [lstResp isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicAppoint in lstResp)
            {
                DrugInfo* drug = [DrugInfo mj_objectWithKeyValues:dicAppoint];
                [drugItems addObject:drug];
            }
        }
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        [dicResult setValue:drugItems forKey:@"list"];
        if (numCount && [numCount isKindOfClass:[NSNumber class]])
        {
            [dicResult setValue:numCount forKey:@"count"];
        }
        
        _taskResult = dicResult;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
    
}

@end

@implementation DrugsUsageListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postRecipeServiceUrl:@"getDrugsUsageList"];
    return postUrl;
}
@end

@implementation DrugsFrequencyListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postRecipeServiceUrl:@"getDrugsFrequencyList"];
    return postUrl;
}

@end

@implementation DrugUnitListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postRecipeServiceUrl:@"getDrugsUnitList"];
    return postUrl;
}

@end

