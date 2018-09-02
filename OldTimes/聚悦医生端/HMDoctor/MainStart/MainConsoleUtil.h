//
//  MainConsoleUtil.h
//  HMDoctor
//
//  Created by yinquan on 2017/5/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainConsoleFunctionModel.h"

extern NSString * const kMainConsoleFunctionNotificationName;

@interface MainConsoleUtil : NSObject

+ (MainConsoleUtil*) shareInstance;

@property (nonatomic, readonly) NSString* staffRole;
@property (nonatomic, readonly) NSString* staffRoleString;
@property (nonatomic, readonly) NSArray* mainFunctions; //服务器返回的列表
@property (nonatomic, retain) NSMutableArray* selectedFunctions;
@property (nonatomic, retain) NSMutableArray* unSelectedFunctions;

- (void) loadMainFunctions;

- (void) saveSelectedMainFunctions:(NSArray*) functions;
@end
