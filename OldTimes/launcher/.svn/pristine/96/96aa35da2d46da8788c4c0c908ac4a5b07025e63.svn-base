//
//  ContactBookMag.m
//  launcher
//
//  Created by TabLiu on 16/3/16.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ContactBookMag.h"
#import "UnifiedUserInfoManager.h"
#import "ContactPersonDetailInformationModel.h"
#import "ContactDepartmentImformationModel.h"

static NSString * const lastUpadteTime = @"lastUpadteTime";
static NSString * const cShowId = @"cShowId";
static NSString * const showId = @"showId";
static NSString * const name = @"name";
static NSString * const ContactBookMag_KEY = @"ContactBookMag_KEY";

@interface ContactBookMag ()

@end

@implementation ContactBookMag

+ (ContactBookMag *)share
{
    static ContactBookMag *msgSqlMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        msgSqlMgr = [[ContactBookMag alloc] init];
    });
    return msgSqlMgr;
}
#pragma mark -  判断是否更新
- (BOOL)deptIsChangeWithData:(NSDictionary *)dict parentId:(NSString *)parentId;
{
    BOOL isChange;
    NSString * key = [self getDeptTimeWithDict:parentId];
    long long newTime = [[dict objectForKey:lastUpadteTime] longLongValue];
    long long oldTime = [[[NSUserDefaults standardUserDefaults] objectForKey:key] longLongValue];
    if (oldTime) { //存在,表示已经加载过
        if (newTime == oldTime) {  // 时间戳相等 没变化
            isChange = NO;
        }else {
            NSString * dateKey = [self getDeptDataWithParentId:parentId];
            
            NSArray * keyArray = [[NSUserDefaults standardUserDefaults] objectForKey:ContactBookMag_KEY];
            if ([keyArray containsObject:dateKey]) {
                NSMutableArray * muArray = [NSMutableArray arrayWithArray:keyArray];
                [muArray removeObject:dateKey];
                [[NSUserDefaults standardUserDefaults] setValue:muArray forKey:ContactBookMag_KEY];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:dateKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            isChange = YES;
        }
    }else {
        [[NSUserDefaults standardUserDefaults] setValue:@(newTime) forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        isChange = YES;
    }
    return isChange;
}
- (BOOL)userIsChangeWithData:(NSDictionary *)dict deptId:(NSString *)deptId;
{
    BOOL isChange;
    NSString * key = [self getUserTimeWithDict:deptId];
    long long newTime = [[dict objectForKey:lastUpadteTime] longLongValue];
    long long oldTime = [[[NSUserDefaults standardUserDefaults] objectForKey:key] longLongValue];
    if (oldTime) { //存在,表示已经加载过
        if (newTime == oldTime) {  // 时间戳相等 没变化
            isChange = NO;
        }else {
            NSString * dateKey = [self geUserDataWithDeptId:deptId];
            NSArray * keyArray = [[NSUserDefaults standardUserDefaults] objectForKey:ContactBookMag_KEY];
            if ([keyArray containsObject:dateKey]) {
                NSMutableArray * muArray = [NSMutableArray arrayWithArray:keyArray];
                [muArray removeObject:dateKey];
                [[NSUserDefaults standardUserDefaults] setValue:muArray forKey:ContactBookMag_KEY];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:dateKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            isChange = YES;
        }
    }else {
        [[NSUserDefaults standardUserDefaults] setValue:@(newTime) forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        isChange = YES;
    }
    return isChange;
}

#pragma mark - get data
- (NSMutableArray *)getBranchDataWithParentId:(NSString *)parentId
{
    NSString * key = [self getDeptDataWithParentId:parentId];
    NSArray * jsonarray = [self getDataWithKey:key];
    if (jsonarray == nil) {
        return nil;
    }
    return [self getBranchModelWithArray:jsonarray];
}
- (NSMutableArray *)getMemberWithDeptId:(NSString *)deptId
{
    NSString * key = [self geUserDataWithDeptId:deptId];
    NSArray * jsonarray = [self getDataWithKey:key];
    if (jsonarray == nil) {
        return nil;
    }
    return [self getMemberModelWithArray:jsonarray];
}
- (NSArray *)getDataWithKey:(NSString *)key
{
    NSArray * keyArray = [[NSUserDefaults standardUserDefaults] objectForKey:ContactBookMag_KEY];
    if (![keyArray containsObject:key]) {
        return nil;
    }
    NSArray * jsonarray;
    NSData *jsonData = [[NSUserDefaults standardUserDefaults] objectForKey:key];;
    if (jsonData) {
        NSError *error;
        jsonarray = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    }else {
        jsonarray = nil;
    }
    return jsonarray;
}

#pragma mark - 保存

- (void)saveBranchData:(NSArray *)array key:(NSString *)parentId
{
    [self saveDataWithArray:array key:[self getDeptDataWithParentId:parentId]];
}
- (void)saveMemberData:(NSArray *)array key:(NSString *)deptId
{
    [self saveDataWithArray:array key:[self geUserDataWithDeptId:deptId]];
}

- (void)saveDataWithArray:(NSArray *)array key:(NSString *)key
{
    if ([NSJSONSerialization isValidJSONObject:array]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
        NSArray * keyArray = [[NSUserDefaults standardUserDefaults] objectForKey:ContactBookMag_KEY];
        if (![keyArray containsObject:key]) {
            NSMutableArray * muArray = [NSMutableArray arrayWithArray:keyArray];
            [muArray addObject:key];
            [[NSUserDefaults standardUserDefaults] setValue:muArray forKey:ContactBookMag_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [[NSUserDefaults standardUserDefaults] setValue:jsonData forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - key
// 获取时间戳key
- (NSString *)getUserTimeWithDict:(NSString *)dict
{
    return [NSString stringWithFormat:@"ContactBookMag_UserTime_%@",dict];
}
- (NSString *)getDeptTimeWithDict:(NSString *)dict
{
    return [NSString stringWithFormat:@"ContactBookMag_DeptTime_%@",dict];
}
// 获取数据key
- (NSString *)getDeptDataWithParentId:(NSString *)parentId
{
    if (!parentId) {
        parentId= @"";
    }
    return [NSString stringWithFormat:@"ContactBookMag_DeptData_%@",parentId];
}
- (NSString *)geUserDataWithDeptId:(NSString *)deptId
{
    if (!deptId) {
        deptId = @"";
    }
    return [NSString stringWithFormat:@"ContactBookMag_UserData_%@",deptId];
}


#pragma mark - 转化为Model

- (NSMutableArray *)getBranchModelWithArray:(NSArray *)array
{
    if (!array.count) {
        return [NSMutableArray array];
    }
    NSMutableArray *array1 = [NSMutableArray array];
    for (NSDictionary *personDict in array) {
        if (!personDict) {
            continue;
        }
        ContactDepartmentImformationModel *model = [[ContactDepartmentImformationModel alloc] initWithDict:personDict];
        [array1 addObject:model];
    }
    return array1;
}

- (NSMutableArray *)getMemberModelWithArray:(NSArray *)data
{
    if (!data.count) {
        return [NSMutableArray array];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    // 筛选重复人员
    NSMutableDictionary *dictExisted = [NSMutableDictionary dictionary];
    
    for (NSDictionary *dict in data) {
        if (!dict) {
            continue;
        }
        
        ContactPersonDetailInformationModel *model = [[ContactPersonDetailInformationModel alloc] initWithDict:dict];
        
        ContactPersonDetailInformationModel *existedModel = [dictExisted objectForKey:model.show_id];
        if (existedModel) {
            NSMutableArray *arrayTmp = [NSMutableArray arrayWithArray:existedModel.u_dept_id];
            [arrayTmp addObjectsFromArray:model.u_dept_id];
            existedModel.u_dept_id = [NSArray arrayWithArray:arrayTmp];
            
            arrayTmp = [NSMutableArray arrayWithArray:existedModel.d_name];
            [arrayTmp addObjectsFromArray:model.d_name];
            existedModel.d_name = [NSArray arrayWithArray:arrayTmp];
            
            arrayTmp = [NSMutableArray arrayWithArray:existedModel.d_parentid_show_id];
            [arrayTmp addObjectsFromArray:model.d_parentid_show_id];
            existedModel.d_parentid_show_id = [NSArray arrayWithArray:arrayTmp];
            
            arrayTmp = [NSMutableArray arrayWithArray:existedModel.d_path_name];
            [arrayTmp addObjectsFromArray:model.d_path_name];
            existedModel.d_path_name = [NSArray arrayWithArray:arrayTmp];
            
            continue;
        }
        [dictExisted setObject:model forKey:model.show_id];
        [array addObject:model];
    }
    return array;
}

@end
