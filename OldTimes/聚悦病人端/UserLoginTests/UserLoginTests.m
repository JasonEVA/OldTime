//
//  UserLoginTests.m
//  UserLoginTests
//
//  Created by yinquan on 17/3/8.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <XCTest/XCTest.h>

//waitForExpectationsWithTimeout是等待时间，超过了就不再等待往下执行。
#define WAIT do {\
[self expectationForNotification:@"RSBaseTest" object:nil handler:nil];\
[self waitForExpectationsWithTimeout:30 handler:nil];\
} while (0);

#define NOTIFY \
[[NSNotificationCenter defaultCenter]postNotificationName:@"RSBaseTest" object:nil];

@interface UserLoginTests : XCTestCase
<TaskObserver>
{
    UserInfo* loginedUser;
}
@end

@implementation UserLoginTests

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

- (void) testUserLogin
{
    NSString* loginacct = @"510202198103181810";
    NSString* loginpwd = @"123456";
    NSMutableDictionary* dicParam = [NSMutableDictionary dictionary];
    [dicParam setValue:loginacct forKey:@"logonAcct"];
    [dicParam setValue:loginpwd forKey:@"password"];
    
//    [self.view showWaitView:@"用户登录中..."];
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserLoginTask" taskParam:dicParam TaskObserver:self];
    
    WAIT
    XCTAssertNotNil(loginedUser);
}

- (void) testLoadUserInfo
{
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserInfoTask" taskParam:nil TaskObserver:self];
    WAIT
    UserInfo* userInfo = [[UserInfoHelper defaultHelper] currentUserInfo];
    XCTAssertNotNil(userInfo);
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
    if (taskname && taskname.length > 0)
    {
        if ([taskname isEqualToString:@"UserLoginTask"])
        {
            XCTAssertNotNil(taskResult);
            XCTAssert([taskResult isKindOfClass:[NSDictionary class]]);
            NSDictionary* respDic = (NSDictionary*) taskResult;
            NSDictionary* userDict = respDic[@"user"];
            XCTAssertNotNil(userDict);
            loginedUser = [UserInfo mj_objectWithKeyValues:userDict];
            return;
        }
        if ([taskname isEqualToString:@"UserInfoTask"])
        {
            return;
        }
        
    }
}
@end
