//
//  MessageRelationGroupModel+SQLUtil.h
//  MintcodeIM
//
//  Created by williamzhang on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "MessageRelationGroupModel.h"

@class FMResultSet;

static NSString *const relationGroup_sqlId             = @"sqlId";
static NSString *const relationGroup_relationGroupId   = @"relationGroupId";
static NSString *const relationGroup_relationGroupName = @"relationGroupName";
static NSString *const relationGroup_createDate        = @"createDate";
static NSString *const relationGroup_isDefault         = @"isDefault";
static NSString *const relationGroup_defaultNameFlag   = @"defaultNameFlag";

@interface MessageRelationGroupModel (SQLUtil)

+ (instancetype)sql_initWithResult:(FMResultSet *)result;

@end
