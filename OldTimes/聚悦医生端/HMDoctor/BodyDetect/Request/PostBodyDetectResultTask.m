//
//  PostBodyDetectResultTask.m
//  HMClient
//
//  Created by yinqaun on 16/5/9.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PostBodyDetectResultTask.h"

@implementation PostBodyDetectResultTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserTestDataService:@"addUserTestData"];
    return postUrl;
}


- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSString* count = [dicResp valueForKey:@"count"];
        NSString* recordId = [dicResp valueForKey:@"testDataId"];
        NSString* prevWariningKpiCode = [dicResp valueForKey:@"prevWariningKpiCode"];
        
        NSString *YQService = [dicResp valueForKey:@"YQService"];
        
        NSMutableDictionary* dicResult = [[NSMutableDictionary alloc] init];
        if (recordId && [recordId isKindOfClass:[NSString class]])
        {
            // _taskResult = recordId;
            [dicResult setValue:recordId forKey:@"recordId"];
        }
        if (count) {
            [dicResult setValue:count forKey:@"count"];
        }
        if (prevWariningKpiCode) {
            [dicResult setValue:prevWariningKpiCode forKey:@"prevWariningKpiCode"];
        }
        
        if (YQService) {
            [dicResult setValue:YQService forKey:@"YQService"];
        }
        _taskResult = dicResult;
    }
}
@end
