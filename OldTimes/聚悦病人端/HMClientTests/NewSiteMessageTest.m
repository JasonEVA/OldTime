//
//  NewSiteMessageTest.m
//  HMClient
//
//  Created by jasonwang on 2017/3/20.
//  Copyright © 2017年 YinQ. All rights reserved.
//  新版站内信单元测试

#import <XCTest/XCTest.h>
#import "TaskManager.h"
#import "UserInfo.h"
#import "SiteMessageSecondEditionMainListModel.h"

//waitForExpectationsWithTimeout是等待时间，超过了就不再等待往下执行。
#define WAIT do {\
[self expectationForNotification:@"RSBaseTest" object:nil handler:nil];\
[self waitForExpectationsWithTimeout:30 handler:nil];\
} while (0);

#define NOTIFY \
[[NSNotificationCenter defaultCenter]postNotificationName:@"RSBaseTest" object:nil];

@interface NewSiteMessageTest : XCTestCase<TaskObserver>
@property (nonatomic, copy) NSArray <SiteMessageSecondEditionMainListModel *>*typeList;

@end

@implementation NewSiteMessageTest

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

- (void)testGetMessageTypeList
{
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [dicPost setValue:@(curUser.userId) forKey:@"userId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"NewSiteMessageGetMainListRequest" taskParam:dicPost TaskObserver:self];
    
    WAIT
}

- (void)GetMessageListWithType:(NSString *)typeCode {
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [dicPost setValue:@(curUser.userId) forKey:@"userId"];
    [dicPost setValue:typeCode forKey:@"typeCode"];
    [dicPost setValue:@(20) forKey:@"limit"];
    [dicPost setValue:@(0) forKey:@"timeStamp"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"NewSiteMessageGetMessageWithTypeRequest" taskParam:dicPost TaskObserver:self];
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
    if ([taskname isEqualToString:@"NewSiteMessageGetMainListRequest"]) {
//        NSArray *temp = (NSArray *)taskResult;
//        self.typeList = temp;
//        [self.typeList enumerateObjectsUsingBlock:^(SiteMessageSecondEditionMainListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [self GetMessageListWithType:obj.typeCode];
//        }];
    }

}
@end
