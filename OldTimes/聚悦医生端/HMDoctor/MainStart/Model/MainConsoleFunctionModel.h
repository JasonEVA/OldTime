//
//  MainConsoleFunctionModel.h
//  HMDoctor
//
//  Created by yinquan on 2017/5/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainConsoleFunctionModel : NSObject

@property (nonatomic, retain) NSString* functionCode;
@property (nonatomic, retain) NSString* functionName;
@property (nonatomic, assign) NSInteger numInfo;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) NSInteger status;

@end

@interface MainConsoleFunctionRetModel : NSObject

@property (nonatomic, retain) NSString* staffRole;
@property (nonatomic, retain) NSArray* functionList;

- (NSString*) staffRoleString;

@end
