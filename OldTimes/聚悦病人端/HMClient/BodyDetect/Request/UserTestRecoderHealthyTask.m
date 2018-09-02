//
//  UserTestRecoderHealthyTask.m
//  HMClient
//
//  Created by lkl on 16/5/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UserTestRecoderHealthyTask.h"
#import "RecordHealthInfo.h"

@implementation UserTestRecoderHealthyTask

- (NSString*) postUrl
{
    NSString *postUrl = [ClientHelper postUserTestRelationService:@"getUserTestRecoderHealthy"];
    return postUrl;
}


- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        
        
        NSArray *healthPlanArray = [dicResp valueForKey:@"userHealthyPlans"];
        NSArray *testRecodHealthArray = [dicResp valueForKey:@"userTestRecoderHealthys"];
        
        NSMutableArray* healthPlanItems = [NSMutableArray array];
        NSMutableArray* testRecodHealthItems = [NSMutableArray array];
        NSMutableArray* otherTestRecordItems = [NSMutableArray array];
        
        if (healthPlanArray && [healthPlanArray isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicHealthPlan in healthPlanArray)
            {
                HealthPlanRecord *info = [HealthPlanRecord mj_objectWithKeyValues:dicHealthPlan];
                [healthPlanItems addObject:info];
            }
        }
        
        if (testRecodHealthArray && [testRecodHealthArray isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicTestRecod in testRecodHealthArray)
            {
                DeviceDetectRecord *info = [DeviceDetectRecord mj_objectWithKeyValues:dicTestRecod];
                if ([info.isShow isEqualToString:@"Y"])
                {
                    [testRecodHealthItems addObject:info];
                }else
                {
                    [otherTestRecordItems addObject:info];
                }
            }
        }
        
        //测试数据－测试哮喘
//        DeviceDetectRecord* temperatureDetect = [[DeviceDetectRecord alloc] init];
//        temperatureDetect.kpiCode = @"XD";
//        temperatureDetect.kpiName = @"心率";
//        temperatureDetect.isShow = @"Y";
//        [testRecodHealthItems addObject:temperatureDetect];
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        [dicResult setValue:healthPlanItems forKey:@"healthPlan"];
        [dicResult setValue:testRecodHealthItems forKey:@"testRecord"];
        [dicResult setValue:otherTestRecordItems forKey:@"otherTestRecord"];
        
        _taskResult = dicResult;
    }
    
}

@end


@implementation UpdateUserTestRelationTask

- (NSString*) postUrl
{
    NSString *postUrl = [ClientHelper postUserTestRelationService:@"updateUserTestRelation"];
    return postUrl;
}


@end



