//
//  BloodPressureDataTests.m
//  HMClient
//
//  Created by lkl on 2017/3/27.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TaskManager.h"
#import "UserInfo.h"
#import "DetectRecord.h"
#import "BloodPressureDetectRecord.h"

//waitForExpectationsWithTimeout是等待时间，超过了就不再等待往下执行。
#define WAIT do {\
[self expectationForNotification:@"RSBaseTest" object:nil handler:nil];\
[self waitForExpectationsWithTimeout:30 handler:nil];\
} while (0);

#define NOTIFY \
[[NSNotificationCenter defaultCenter]postNotificationName:@"RSBaseTest" object:nil];

@interface BloodPressureDataTests : XCTestCase <TaskObserver>

@end

@implementation BloodPressureDataTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

//模拟上传血压数据
- (void)testUploadBloodPressureData
{
    NSMutableDictionary* dicValue = [NSMutableDictionary dictionary];
    [dicValue setValue:@"50" forKey:@"XL_OF_XY"];
    [dicValue setValue:@"120" forKey:@"SSY"];
    [dicValue setValue:@"80" forKey:@"SZY"];
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:dicValue forKey:@"testValue"];
    
    NSString* timeStr = @"2017-03-25 10:23:05";
    [dicPost setValue:timeStr forKey:@"testTime"];
    
    [dicPost setValue:@"1" forKey:@"inputMode"];
    [dicPost setValue:@"XY" forKey:@"kpiCode"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"PostBodyDetectResultTask" taskParam:dicPost TaskObserver:self];
    
    WAIT
}

//获取上传的血压数据
- (void)testGetDevicesData
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    NSInteger startRow = 0;
    NSInteger rows = 20;
    [dicPost setValue:[NSNumber numberWithInteger:startRow] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:rows] forKey:@"rows"];
    
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",curUser.userId] forKey:@"userId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"BloodPressureRecordsTask" taskParam:dicPost TaskObserver:self];
    
    WAIT
}

//获取上传的血压数据详情
- (void)testDataDetail
{
    NSString *testDataId = @"MB_27EB23C5E7F148CEA5BBD47F742CC6AC";
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:testDataId forKey:@"testDataId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"BloodPressureDetectResultTask" taskParam:dicPost TaskObserver:self];
    
    WAIT
}


#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    NSLog(@"--%@",errorMessage);
    XCTAssertTrue(taskError == StepError_None);
    
    NOTIFY
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"BloodPressureRecordsTask"]) {
        
        XCTAssertNotNil(taskResult);
        XCTAssertTrue([taskResult isKindOfClass:[NSDictionary class]]);
    }
    
    if ([taskname isEqualToString:@"BloodPressureDetectResultTask"])
    {
        XCTAssertNotNil(taskResult);
        XCTAssert([taskResult isKindOfClass:[DetectResult class]],@"数据错误");
        
        BloodPressureDetectResult* bpResult = (BloodPressureDetectResult*)taskResult;
        XCTAssert(bpResult.dataDets.SSY == 120,@"查询结果不一致");
        XCTAssert(bpResult.dataDets.SZY == 80,@"查询结果不一致");
        //NSLog(@"-----%ld %ld",bpResult.dataDets.SSY,bpResult.dataDets.SZY);
    }
}

@end
