//
//  ContactBookMag.h
//  launcher
//
//  Created by TabLiu on 16/3/16.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactBookMag : NSObject

+ (ContactBookMag *)share;

// re 是否变化
- (BOOL)deptIsChangeWithData:(NSDictionary *)dict parentId:(NSString *)parentId;
- (BOOL)userIsChangeWithData:(NSDictionary *)dict deptId:(NSString *)deptId;

/** 如果为 nil 表示没有加载过 为@[]需要比对*/
- (NSMutableArray *)getBranchDataWithParentId:(NSString *)parentId;//部门
/** 如果为 nil 表示没有加载过*/
- (NSMutableArray *)getMemberWithDeptId:(NSString *)deptId;//成员
// 保存  在request中进行
- (void)saveBranchData:(NSArray *)array key:(NSString *)parentId;
- (void)saveMemberData:(NSArray *)array key:(NSString *)deptId;

- (NSString *)getUserTimeWithDict:(NSString *)dict;
- (NSString *)getDeptTimeWithDict:(NSString *)dict;

@end
