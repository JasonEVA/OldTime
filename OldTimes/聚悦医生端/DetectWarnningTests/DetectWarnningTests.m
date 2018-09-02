//
//  DetectWarnningTests.m
//  DetectWarnningTests
//
//  Created by yinquan on 17/3/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UserAlertInfo.h"

#define WAIT do {\
[self expectationForNotification:@"RSBaseTest" object:nil handler:nil];\
[self waitForExpectationsWithTimeout:30 handler:nil];\
} while (0);

#define NOTIFY \
[[NSNotificationCenter defaultCenter]postNotificationName:@"RSBaseTest" object:nil];

@interface DetectWarnningTests : XCTestCase
<TaskObserver>
{
    NSInteger totalCount;
    NSArray* warnlist;
    NSArray* warnRecordList;
}
@end

@implementation DetectWarnningTests

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

- (void) testLoadUnDealUserWarningList
{
    NSInteger startRows = 0;
    NSInteger rows = 20;
    
    NSInteger status = 0;//未处理
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:startRows] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:rows] forKey:@"rows"];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    [dicPost setValue:[NSNumber numberWithInteger:status] forKey:@"doStatus"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserAlertListTask" taskParam:dicPost TaskObserver:self];

    
    WAIT
    
    NSLog(@"warnning list count =%ld", totalCount);
    
    if (totalCount > 0 && warnlist.count > 0)
    {
        [warnlist enumerateObjectsUsingBlock:^(UserAlertInfo* warninfo, NSUInteger idx, BOOL * _Nonnull stop)
         {
             NSLog(@"username = %@, testTime = %@", warninfo.userName, warninfo.testTime);
             NSLog(@"testValue = %@", warninfo.dataDets.testValue);
         }];
    }
}

//测试获取所有监测预警
- (void) testLoadAllUserWarningList
{
    NSInteger startRows = 0;
    NSInteger rows = 20;
    
    NSInteger status = 1;//所有预警
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:startRows] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:rows] forKey:@"rows"];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    [dicPost setValue:[NSNumber numberWithInteger:status] forKey:@"doStatus"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserAlertListTask" taskParam:dicPost TaskObserver:self];
    
    
    WAIT
    
    NSLog(@"warnning list count =%ld", totalCount);
    
    if (totalCount > 0 && warnlist.count > 0)
    {
        [warnlist enumerateObjectsUsingBlock:^(UserAlertInfo* warninfo, NSUInteger idx, BOOL * _Nonnull stop)
         {
             NSLog(@"username = %@, testTime = %@", warninfo.userName, warninfo.testTime);
             NSLog(@"testValue = %@", warninfo.dataDets.testValue);
         }];
    }
}

//测试近期预警及处理记录
- (void) testNearlyAlertList
{
    NSInteger userId = 11770;
    
    NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)userId] forKey:@"userId"];
    //[dicPost setValue:[NSString stringWithFormat:@"%ld",(long)alertInfo.staffId] forKey:@"staffId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserWarningRecordTask" taskParam:dicPost TaskObserver:self];
    
    WAIT
    
    if (warnRecordList && warnRecordList.count > 0)
    {
        [warnRecordList enumerateObjectsUsingBlock:^(UserWarningRecord* record, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"WarningRecord %@ doway = %@", record.testValue, record.doWay);
            NSLog(@"doTime %@", record.doDate);
        }];
    }
}

//测试近期是否有相同的预警处理方式
- (void) testNearbyAlertDeal
{
    NSInteger userId = 11770;
    NSArray* doWayTypeArray = @[@"TZYJZ",@"TZYY",@"JXJC",@"TZFZ",@"LXHZ"];
    NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)userId] forKey:@"userId"];
    
    NSString *type = [doWayTypeArray objectAtIndex:2];
    [dicPost setValue:type forKey:@"type"];
    [dicPost setValue:@"XL" forKey:@"kpiCode"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"checkAlertIsAppearTask" taskParam:dicPost TaskObserver:self];
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
    
    if ([taskname isEqualToString:@"UserAlertListTask"])
    {
        XCTAssertNotNil(taskResult);
        XCTAssertTrue([taskResult isKindOfClass:[NSDictionary class]]);
        NSDictionary* respDict = (NSDictionary*) taskResult;
        NSNumber* countNumber = respDict[@"count"];
        XCTAssertNotNil(countNumber);
        totalCount = countNumber.integerValue;
        warnlist = respDict[@"list"];
//        XCTAssert(warnlist.count > 0);
    }
    
    
    if ([taskname isEqualToString:@"UserWarningRecordTask"])
    {
        XCTAssertNotNil(taskResult);
        XCTAssertTrue([taskResult isKindOfClass:[NSArray class]]);
        warnRecordList = (NSArray*) taskResult;
        
    }
    
    if ([taskname isEqualToString:@"checkAlertIsAppearTask"])
    {
        XCTAssertNotNil(taskResult);
        NSLog(@"result class is %@", [taskResult class]);
    }
}
@end
