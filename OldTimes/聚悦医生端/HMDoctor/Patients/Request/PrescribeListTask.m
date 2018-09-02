//
//  PrescribeListTask.m
//  HMDoctor
//
//  Created by lkl on 16/6/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PrescribeListTask.h"
#include "DrugInfo.h"
#import "PrescribeInfo.h"

//
@implementation showRecipeListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postRecipeServiceUrl:@"showRecipe"];
    return postUrl;
}

@end


@implementation PrescribeListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postRecipeServiceUrl:@"getUserRecipeList"];
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
        NSMutableArray* PrescribeItem = [[NSMutableArray alloc] init];;
        if (lstResp && [lstResp isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicTemp in lstResp)
            {
                PrescribeInfo* drug = [PrescribeInfo mj_objectWithKeyValues:dicTemp];
                [PrescribeItem addObject:drug];
            }
        }
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        [dicResult setValue:PrescribeItem forKey:@"list"];
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



@implementation CreateRecipeTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postRecipeServiceUrl:@"createRecipe"];
    return postUrl;
}

@end



@implementation StopRecipeTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postRecipeServiceUrl:@"stopRecipe"];
    return postUrl;
}

@end
