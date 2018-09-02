//
//  MessageRelationInfoModel+SQLUtil.h
//  MintcodeIM
//
//  Created by williamzhang on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "MessageRelationInfoModel.h"

@class FMResultSet;

static NSString * const relationInfo_sqlId            = @"sqlId";
static NSString * const relationInfo_relationGroupId  = @"relationGroupId";
static NSString * const relationInfo_relationName     = @"relationName";
static NSString * const relationInfo_remark           = @"remark";
static NSString * const relationInfo_tag              = @"tag";
static NSString * const relationInfo_nickName         = @"nickName";
static NSString * const relationInfo_relationAvatar   = @"relationAvatar";
static NSString * const relationInfo_relationModified = @"relationModified";
static NSString * const relationInfo_appName          = @"appName";
static NSString * const relationInfo_imNumber         = @"imNumber";

@interface MessageRelationInfoModel (SQLUtil)

+ (instancetype)sql_initWithResult:(FMResultSet *)result;

@end
