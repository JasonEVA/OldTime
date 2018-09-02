//
//  PatientInfoListSQLManager.h
//  HMDoctor
//
//  Created by Andrew Shen on 2017/3/7.
//  Copyright © 2017年 yinquan. All rights reserved.
//  患者列表数据库操作

#import <Foundation/Foundation.h>

@class FMDatabase, NewPatientListInfoModel;

@interface PatientInfoListSQLManager : NSObject

/**
 *  创建表
 */
+ (void)createMessageTableWithDB:(FMDatabase *)db;

#pragma mark - Insert & Update
// 删除内容
+ (BOOL)deleteTableData:(FMDatabase *)db;

// 插入单个患者信息
+ (BOOL)insertTableWithDB:(FMDatabase *)db patients:(NewPatientListInfoModel *)model;

// 更新关注状态
+ (BOOL)updatePatientStatus:(BOOL)follow patientID:(NSInteger)userID DB:(FMDatabase *)db;

#pragma mark - Query
// 查询患者信息
+ (NSArray<NewPatientListInfoModel *> *)queryPatientList:(FMDatabase *)db;

// 查询患者信息(根据某一字段去重)
+ (NSArray<NewPatientListInfoModel *> *)queryPatientList:(FMDatabase *)db removeDuplicateWithId:(NSString *)removeDuplicateId;

// 查询单个患者信息
+ (NewPatientListInfoModel *)queryPatientInfoWithPatientID:(NSInteger)patientID DB:(FMDatabase *)db;
@end
