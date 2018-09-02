//
//  HealthHistoryListTask.m
//  HMClient
//
//  Created by yinqaun on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthHistoryListTask.h"
#import "HealthHistoryItem.h"

@implementation HealthHistoryListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postHealthServiceUrl:@"getUserHealthHistorys"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*)stepResult;
        if (0 == lstResp.count)
        {
            return;
        }
        
        NSMutableArray* historyItems = [NSMutableArray array];
        for (NSDictionary* dicRow in lstResp)
        {
            NSDictionary* row = [dicRow valueForKey:@"row"];
            if (![row isKindOfClass:[NSDictionary class]])
            {
                continue;
            }
            HealthHistoryItem* item = [HealthHistoryItem mj_objectWithKeyValues:row];
            if (item.visitTime) {
                [historyItems addObject:item];
            }

        }
        
        _taskResult = historyItems;
    }

}

@end
