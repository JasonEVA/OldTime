//
//  HealthPlanTests.m
//  HMDoctor
//
//  Created by lkl on 2017/3/24.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TaskManager.h"
#import "UserInfo.h"

#define WAIT do {\
[self expectationForNotification:@"RSBaseTest" object:nil handler:nil];\
[self waitForExpectationsWithTimeout:30 handler:nil];\
} while (0);

#define NOTIFY \
[[NSNotificationCenter defaultCenter]postNotificationName:@"RSBaseTest" object:nil];

@interface HealthPlanTests : XCTestCase <TaskObserver>

@end

@implementation HealthPlanTests

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

//待处理健康计划任务
- (void)testHealthPlanTask
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    [dicPost setValue:@[@"1",@"2",@"3"] forKey:@"status"];
    
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:20] forKey:@"rows"];

    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthPlanMessionListTask" taskParam:dicPost TaskObserver:self];
    
    WAIT
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
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
    
    if ([taskname isEqualToString:@"HealthPlanMessionListTask"])
    {
        XCTAssertNotNil(taskResult);
        XCTAssert([taskResult isKindOfClass:[NSDictionary class]],@"数据请求错误");
    }
}


@end
