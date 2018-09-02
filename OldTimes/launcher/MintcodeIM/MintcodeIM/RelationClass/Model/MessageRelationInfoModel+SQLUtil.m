//
//  MessageRelationInfoModel+SQLUtil.m
//  MintcodeIM
//
//  Created by williamzhang on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "MessageRelationInfoModel+SQLUtil.h"
#import <FMDB/FMResultSet.h>

@implementation MessageRelationInfoModel (SQLUtil)

+ (instancetype)sql_initWithResult:(FMResultSet *)result {
    MessageRelationInfoModel *model = [MessageRelationInfoModel new];
    
    model.sqlId            = [result longForColumn:relationInfo_sqlId];
    model.relationGroupId  = [result longForColumn:relationInfo_relationGroupId];
    model.relationName     = [result stringForColumn:relationInfo_relationName];
    model.remark           = [result stringForColumn:relationInfo_remark];
    model.tag              = [result stringForColumn:relationInfo_tag];
    model.nickName         = [result stringForColumn:relationInfo_nickName];
    model.relationAvatar   = [result stringForColumn:relationInfo_relationAvatar];
    model.relationModified = [result longLongIntForColumn:relationInfo_relationModified];
    model.appName          = [result stringForColumn:relationInfo_appName];
    model.imNumber         = [result stringForColumn:relationInfo_imNumber];
    
    return model;
}

@end
