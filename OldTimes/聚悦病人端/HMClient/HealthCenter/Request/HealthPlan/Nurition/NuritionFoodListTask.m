//
//  NuritionFoodListTask.m
//  HMClient
//
//  Created by yinqaun on 16/6/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NuritionFoodListTask.h"
#import "FoodListItem.h"

@implementation NuritionFoodListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postCommonHealthyPlanServiceUrl:@"getFoodsList"];
    return postUrl;
}


- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSNumber* numCount = [dicResp valueForKey:@"count"];
        NSArray* lstResp = [dicResp valueForKey:@"list"];
        NSMutableArray* foodlist = [NSMutableArray array];
        if (lstResp && [lstResp isKindOfClass:[NSArray class]])
        {
            
            for (NSDictionary* dicService in lstResp)
            {
                FoodListItem* food = [FoodListItem mj_objectWithKeyValues:dicService];
                [foodlist addObject:food];
            }
            
        }
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        [dicResult setValue:foodlist forKey:@"list"];
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
