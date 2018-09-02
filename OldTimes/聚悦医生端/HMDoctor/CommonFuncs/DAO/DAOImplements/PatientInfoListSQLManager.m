//
//  PatientInfoListSQLManager.m
//  HMDoctor
//
//  Created by Andrew Shen on 2017/3/7.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "PatientInfoListSQLManager.h"
#import "NewPatientListInfoModel.h"
#import <FMDB/FMDatabase.h>
#import <FMDB/FMDatabaseAdditions.h>

static NSString *const kTableName = @"PatientInfoList"; //
static NSString *const kSQLID = @"SQLID"; //

static NSString *const kAge = @"age"; //
static NSString *const kAlertCount = @"alertCount"; // 预警次数
static NSString *const kAttentionStatus = @"attentionStatus"; // 关注状态 1：关注 2：未关注
static NSString *const kAvatar = @"avatar"; //
static NSString *const kDiseaseTitle = @"diseaseTitle"; // 疾病名称
static NSString *const kDiseaseId = @"diseaseId"; //
static NSString *const kIllDiagnose = @"illDiagnose"; // 诊断
static NSString *const kJoinDate = @"joinDate"; // 入组时间
static NSString *const kOrderMoney = @"orderMoney"; // 费用
static NSString *const kPaymentType = @"paymentType"; // 收费类型 1：免费 2：收费
static NSString *const kProductName = @"productName"; // 服务名称
static NSString *const kProductId = @"productId"; //
static NSString *const kSex = @"sex"; //
static NSString *const kStaffNames = @"staffNames"; //
static NSString *const kTeamName = @"teamName"; // 团队名称
static NSString *const kTeamId = @"teamId"; //
static NSString *const kUserId = @"userId"; //
static NSString *const kUserName = @"userName"; //
static NSString *const kUserTestDatas = @"userTestDatas"; // <##>
static NSString *const kImGroupId = @"imGroupId"; // IM群ID

// 第四版患者列表加入字段
static NSString *const kBlocId = @"blocId"; //集团Id
static NSString *const kBlocRank = @"blocRank"; //集团用户等级(默认 0) 0 无等级 1 普通 , 2 中层 , 3 VIP
static NSString *const kClassify = @"classify"; //
static NSString *const kRootTypeCode = @"rootTypeCode"; //
static NSString *const kIdCard = @"idCard"; //
static NSString *const kBlocName = @"blocName"; //集团名

@implementation PatientInfoListSQLManager

#pragma mark - SQL

/**
 *  创建表
 */
+ (void)createMessageTableWithDB:(FMDatabase *)db {
    NSString *strSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (%@ INTEGER primary key autoincrement, %@ INTEGER, %@ INTEGER, %@ INTEGER, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ REAL, %@ INTEGER, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ INTEGER, %@ TEXT, %@ TEXT, %@ TEXT, %@ INTEGER,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ TEXT,%@ TEXT);" ,
                        kTableName,
                        kSQLID,
                        kAge,
                        kAlertCount,
                        kAttentionStatus,
                        kAvatar,
                        kDiseaseTitle,
                        kDiseaseId,
                        kIllDiagnose,
                        kJoinDate,
                        kOrderMoney,
                        kPaymentType,
                        kProductName,
                        kProductId,
                        kSex,
                        kStaffNames,
                        kTeamName,
                        kTeamId,
                        kUserId,
                        kUserName,
                        kUserTestDatas,
                        kImGroupId,
                        kBlocId,
                        kBlocRank,
                        kClassify,
                        kRootTypeCode,
                        kIdCard,
                        kBlocName];
    // 创建表
    if (![db executeUpdate:strSql])
    {
        NSAssert(0, @"患者表创建失败");
    }
    [self p_alterPatientListTableWithDB:db];
}

// 删除内容
+ (BOOL)deleteTableData:(FMDatabase *)db {
    BOOL success = YES;;
    NSString *sqlString = [NSString stringWithFormat:@"delete from %@",kTableName];
    if (![db executeUpdate:sqlString])
    {
        success = NO;
        NSAssert(0, @"删除病人表失败");
    }
    return success;
}

// 插入内容
+ (BOOL)insertTableWithDB:(FMDatabase *)db patients:(NewPatientListInfoModel *)model {
    BOOL success = YES;
    NSString *sqlString = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                           kTableName,
                           kAge,
                           kAlertCount,
                           kAttentionStatus,
                           kAvatar,
                           kDiseaseTitle,
                           kDiseaseId,
                           kIllDiagnose,
                           kJoinDate,
                           kOrderMoney,
                           kPaymentType,
                           kProductName,
                           kProductId,
                           kSex,
                           kStaffNames,
                           kTeamName,
                           kTeamId,
                           kUserId,
                           kUserName,
                           kUserTestDatas,
                           kImGroupId,
                           kBlocId,
                           kBlocRank,
                           kClassify,
                           kRootTypeCode,
                           kIdCard,
                           kBlocName];
    if (![db executeUpdate:sqlString,@(model.age),@(model.alertCount),@(model.attentionStatus),model.avatar,model.diseaseTitle,model.diseaseId,model.illDiagnose,model.joinDate,@(model.orderMoney),@(model.paymentType),model.productName,model.productId,model.sex,model.staffNames,model.teamName,model.teamId,@(model.userId),model.userName,[model.userTestDatas mj_JSONString],model.imGroupId,@(model.blocId),@(model.blocRank),@(model.classify),model.rootTypeCode,model.idCard,model.blocName])
    {
        success = NO;
        NSAssert(0, @"插入病人表失败");
    }
    
    return success;
}

// 更新关注状态
+ (BOOL)updatePatientStatus:(BOOL)follow patientID:(NSInteger)userID DB:(FMDatabase *)db {
    BOOL success = YES;
    NSString *sqlString = [NSString stringWithFormat:@"update '%@' set %@ = '%d' where %@ = '%ld'",
                           kTableName,
                           kAttentionStatus,
                           follow ? 1 : 2,
                           kUserId,
                           userID];
    if (![db executeUpdate:sqlString]) {
        success = NO;
        NSAssert(0, @"更新关注状态失败");
    }
    return success;
}

#pragma mark - Query
// 查询
+ (NSArray<NewPatientListInfoModel *> *)queryPatientList:(FMDatabase *)db {
    NSMutableArray<NewPatientListInfoModel *> *array = [NSMutableArray array];
    NSString *sqlString = [NSString stringWithFormat:@"select * from '%@'",kTableName];
    FMResultSet *result = [db executeQuery:sqlString];
    while ([result next]) {
        NewPatientListInfoModel *model = [NewPatientListInfoModel mj_objectWithKeyValues:[result resultDictionary]];
        if (!model) {
            continue;
        }
        model.userTestDatas = [[result stringForColumn:kUserTestDatas] mj_JSONObject];
        [array addObject:model];
    }
    return array;
}
// 根据某一字段去重取数据
+ (NSArray<NewPatientListInfoModel *> *)queryPatientList:(FMDatabase *)db removeDuplicateWithId:(NSString *)removeDuplicateId{
    NSMutableArray<NewPatientListInfoModel *> *array = [NSMutableArray array];
    NSString *sqlString = [NSString stringWithFormat:@"select *, count(distinct %@) from '%@' group by %@",removeDuplicateId,kTableName,removeDuplicateId];
    FMResultSet *result = [db executeQuery:sqlString];
    while ([result next]) {
        NewPatientListInfoModel *model = [NewPatientListInfoModel mj_objectWithKeyValues:[result resultDictionary]];
        if (!model) {
            continue;
        }
        model.userTestDatas = [[result stringForColumn:kUserTestDatas] mj_JSONObject];
        [array addObject:model];
    }
    return array;
}

+ (NewPatientListInfoModel *)queryPatientInfoWithPatientID:(NSInteger)patientID DB:(FMDatabase *)db{
    NSString *sqlString = [NSString stringWithFormat:@"select * from '%@' where %@ = '%ld'",kTableName, kUserId, patientID];
    FMResultSet *result = [db executeQuery:sqlString];
    while ([result next]) {
        NewPatientListInfoModel *model = [NewPatientListInfoModel mj_objectWithKeyValues:[result resultDictionary]];
        model.userTestDatas = [[result stringForColumn:kUserTestDatas] mj_JSONObject];
        return model;
    }
    return nil;
}

#pragma mark - Private Method
// 新增列
+ (void)p_alterPatientListTableWithDB:(FMDatabase *)db {
    if (![db columnExists:@"blocId" inTableWithName:kTableName])              [db executeUpdate:@"alter TABLE PatientInfoList add blocId interger default 0"];
    if (![db columnExists:@"blocRank" inTableWithName:kTableName])              [db executeUpdate:@"alter TABLE PatientInfoList add blocRank interger default 0"];

    if (![db columnExists:@"classify" inTableWithName:kTableName])              [db executeUpdate:@"alter TABLE PatientInfoList add classify interger default 0"];

    if (![db columnExists:@"rootTypeCode" inTableWithName:kTableName]) [db executeUpdate:@"alter TABLE PatientInfoList add rootTypeCode text"];
    if (![db columnExists:@"idCard" inTableWithName:kTableName]) [db executeUpdate:@"alter TABLE PatientInfoList add idCard text"];
    if (![db columnExists:@"blocName" inTableWithName:kTableName]) [db executeUpdate:@"alter TABLE PatientInfoList add blocName text"];
}



@end
