//
//  MainConsoleUtil.m
//  HMDoctor
//
//  Created by yinquan on 2017/5/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "MainConsoleUtil.h"

NSString * const kMainConsoleFunctionNotificationName = @"MainConsoleFunctionNotification";

@interface MainConsolePathHelper : NSObject

+ (NSString*) mainFunctionsPath:(NSInteger) userId;
@end

@implementation MainConsolePathHelper

+ (NSString*) mainFunctionsPath:(NSInteger) userId
{
    NSString* userDir = [PathHelper userDir:userId];
    NSString* mainFunctionsPath = [userDir stringByAppendingPathComponent:@"mainfunctions.plist"];
    return mainFunctionsPath;
}
@end

static MainConsoleUtil* shareInstance = nil;

@interface MainConsoleUtil ()
<TaskObserver>

@end

@implementation MainConsoleUtil

+ (MainConsoleUtil*) shareInstance
{
    if (!shareInstance) {
        shareInstance = [[MainConsoleUtil alloc] init];
    }
    
    return shareInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self loadMainFunctions];
    }
    return self;
}

- (void) loadMainFunctions
{
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    NSMutableDictionary* postDict = [NSMutableDictionary dictionary];
    [postDict setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"MainConsoleFunctionsTask" taskParam:postDict TaskObserver:self];
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (taskError != StepError_None) {
        NSLog(@"");
    }
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
    
    if ([taskname isEqualToString:@"MainConsoleFunctionsTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[MainConsoleFunctionRetModel class]])
        {
            MainConsoleFunctionRetModel* retModel = taskResult;
            _staffRole = retModel.staffRole;
            _staffRoleString = [retModel staffRoleString];
            __block NSMutableArray* functionList = [NSMutableArray array];
            
            for (NSInteger status = 0; status < 3; status++) {
                NSLog(@"Append function model %ld", status);
                [retModel.functionList enumerateObjectsUsingBlock:^(MainConsoleFunctionModel* functionModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (functionModel.status == status) {
                        [functionList addObject:functionModel];
                        return ;
                    }
                   
                }];
            }
            
            _mainFunctions = functionList;
            
            [self makeMainFunctionList];
        }
    }
}

- (void) saveSelectedMainFunctions:(NSArray*) functions
{
    if (!functions) {
        return;
    }
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    
    NSString* mainFunctionsPath = [MainConsolePathHelper mainFunctionsPath:staff.userId];
    
    if (functions) {
        [NSKeyedArchiver archiveRootObject:functions toFile:mainFunctionsPath];
    }
    
    _selectedFunctions = [NSMutableArray arrayWithArray:functions];
    _unSelectedFunctions = [NSMutableArray arrayWithArray:[self unSelectedFunctions]];
}

- (NSArray*) savedMainFunctions
{
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    NSString* mainFunctionsPath = [MainConsolePathHelper mainFunctionsPath:staff.userId];
    if (!mainFunctionsPath || ![[NSFileManager defaultManager] fileExistsAtPath:mainFunctionsPath]) {
        return nil;
    }
    
    NSArray* functions = [NSKeyedUnarchiver unarchiveObjectWithFile:mainFunctionsPath];
    return functions;
}

- (void) makeMainFunctionList
{
//    _unSelectedFunctions = nil;
    NSMutableArray* savedFunctionList = [NSMutableArray arrayWithArray:[self savedMainFunctions]];
    if (!savedFunctionList || !self.savedMainFunctions) {
        [self.mainFunctions enumerateObjectsUsingBlock:^(MainConsoleFunctionModel* model, NSUInteger idx, BOOL * _Nonnull stop)
        {
            if (model.status == 0 || model.status == 1) {
                [savedFunctionList addObject:model];
            }
        }];
        [self saveSelectedMainFunctions:savedFunctionList];
        _selectedFunctions = savedFunctionList;
        
    }
    else
    {
        [self.mainFunctions enumerateObjectsUsingBlock:^(MainConsoleFunctionModel* model, NSUInteger idx, BOOL * _Nonnull stop)
         {
             //保证所有必选项都已经被选择
             if (model.status == 0 ) {
                 __block BOOL isSelected = NO;
                 
                 [_selectedFunctions enumerateObjectsUsingBlock:^(MainConsoleFunctionModel* selectedModel, NSUInteger idx, BOOL * _Nonnull stop)
                 {
                     isSelected = [selectedModel.functionCode isEqualToString:model.functionCode];
                     if (isSelected)
                     {
                         *stop = YES;
                         return;
                     }
                 }];
                 
                 if (!isSelected) {
                     [_selectedFunctions addObject:model];
                 }
             }
         }];
        
        [savedFunctionList enumerateObjectsUsingBlock:^(MainConsoleFunctionModel* savedModel, NSUInteger savedIdx, BOOL * _Nonnull savedStop)
         {
             __block BOOL isValid = NO;
            [self.mainFunctions enumerateObjectsUsingBlock:^(MainConsoleFunctionModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([model.functionCode isEqualToString:savedModel.functionCode])
                {
                    isValid = YES;
                    [savedFunctionList replaceObjectAtIndex:savedIdx withObject:model];
                    *stop = YES;
                    return ;
                }
            }];
             
             if (!isValid) {
                 [savedFunctionList removeObject:savedModel];
             }
        }];
        
        [self saveSelectedMainFunctions:savedFunctionList];
        _selectedFunctions = savedFunctionList;

    }
    
//    [self unSelectedFunctions];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMainConsoleFunctionNotificationName object:nil];
}

- (NSArray*) unSelectedFunctions
{
    
    _unSelectedFunctions = [NSMutableArray array];
    [self.mainFunctions enumerateObjectsUsingBlock:^(MainConsoleFunctionModel* model, NSUInteger mainidx, BOOL * _Nonnull mainstop) {
        
        if (model.status != 0 && model.status != 3)
        {
            [_unSelectedFunctions addObject:model];
        }
    }];

    return _unSelectedFunctions;
}
@end
