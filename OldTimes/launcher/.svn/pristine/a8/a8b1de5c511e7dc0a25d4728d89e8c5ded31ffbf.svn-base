//
//  MessageRelationGroupModel+SQLUtil.m
//  MintcodeIM
//
//  Created by williamzhang on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "MessageRelationGroupModel+SQLUtil.h"
#import <FMDB/FMResultSet.h>

@implementation MessageRelationGroupModel (SQLUtil)

+ (instancetype)sql_initWithResult:(FMResultSet *)result {
    MessageRelationGroupModel *model = [MessageRelationGroupModel new];
    
    model.sqlId             = [result longForColumn:relationGroup_sqlId];
    model.relationGroupId   = [result longForColumn:relationGroup_relationGroupId];
    model.relationGroupName = [result stringForColumn:relationGroup_relationGroupName];
    model.createDate        = [result longLongIntForColumn:relationGroup_createDate];
    model.isDefault         = [result boolForColumn:relationGroup_isDefault];
    model.defaultNameFlag   = @([result longForColumn:relationGroup_defaultNameFlag]);
    
    return model;
}

@end
