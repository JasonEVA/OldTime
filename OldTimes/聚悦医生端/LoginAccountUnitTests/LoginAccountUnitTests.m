//
//  LoginAccountUnitTests.m
//  LoginAccountUnitTests
//
//  Created by yinquan on 17/3/15.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LoginAccount.h"

@interface LoginAccountUnitTests : XCTestCase
{
    LoginAccountUtil* accountUtil;
}
@end

@implementation LoginAccountUnitTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    accountUtil = [[LoginAccountUtil alloc] init];
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

//测试获取登录账号列表
- (void) testQueryLoginAccounts
{
    NSArray* accounts = [accountUtil queryAccountList];
    XCTAssertNotNil(accounts);
    XCTAssert(accounts.count > 0);
    if (accounts)
    {
        NSLog(@"accounts count = %ld", accounts.count);
        
        [accounts enumerateObjectsUsingBlock:^(LoginAccountModel* model, NSUInteger idx, BOOL * _Nonnull stop)
        {
            NSLog(@"account staffName = %@, account = %@", model.staffName, model.loginAccount);
        }];
        
        
    }
}

//测试获取当前登录账号
- (void) testGetCurrentLoginAccount
{
    LoginAccountModel* model = [accountUtil currentLoginAccount];
    XCTAssertNotNil(model);
    NSLog(@"current logined staffName = %@", model.staffName);
}

//测试添加登录账号
- (void) testAppendLoginAccount
{
    NSString* account = @"wangchen";
    NSString* password = @"123456";
    NSString* staffName = @"王晨";
    
    [accountUtil appendAccount:account password:password staffName:staffName userPortrait:staffName];
    
    //获取当前登录用户
    LoginAccountModel* model = [accountUtil currentLoginAccount];
    //验证是否添加成功
    XCTAssertNotNil(model);
    XCTAssertNotNil(model.loginAccount);
    XCTAssert([model.loginAccount isEqualToString:account]);
}


- (BOOL) accountIsExisted:(NSString*) account
{
    if (!account || account.length == 0)
    {
        return NO;
    }
    NSArray* accounts = [accountUtil queryAccountList];
    __block BOOL isExisted = NO;
    if (accounts)
    {
        [accounts enumerateObjectsUsingBlock:^(LoginAccountModel* model, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if([model.loginAccount isEqualToString:account])
             {
                 isExisted = YES;
                 *stop = YES;
             }
         }];
    }
    
    return isExisted;
}

//测试删除登录账号
- (void) testDeleteLoginAccount
{
    NSString* account = @"wangchen";
    
    if (![self accountIsExisted:account])
    {
        NSLog(@"account %@ is not existed.", account);
    }
    
    [accountUtil deleteAccount:account];
    
    BOOL isExisted = [self accountIsExisted:account];
    XCTAssert(!isExisted);
}

@end
