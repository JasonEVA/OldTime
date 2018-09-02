//
//  MessageRelationInfoModel.m
//  MintcodeIM
//
//  Created by williamzhang on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "MessageRelationInfoModel.h"
#import "NSDictionary+IMSafeManager.h"

#define Dict_sqlID                          @"sqlId"
#define Dict_appName                        @"appName"
#define Dict_userName                       @"userName"
#define Dict_remark                         @"remark"
#define Dict_tag                            @"tag"
#define Dict_relationGroupId                @"relationGroupId"
#define Dict_nickName                       @"nickName"
#define Dict_relationAvatar                 @"relationAvatar"
#define Dict_relationModified               @"relationModified"
#define Dict_relationName                   @"relationName"
#define Dict_mobile               @"mobile"
#define Dict_relation             @"relation"

@implementation MessageRelationInfoModel

+ (MessageRelationInfoModel *)modelWithDict:(NSDictionary *)dict
{
    MessageRelationInfoModel * model = [[MessageRelationInfoModel alloc] init];
    model.appName      = [dict im_valueStringForKey:Dict_appName];
    model.nickName     = [dict im_valueStringForKey:Dict_nickName];
    model.relationName = [dict im_valueStringForKey:Dict_relationName];
    if (model.relationName.length == 0 ) {
        model.relationName = [dict im_valueStringForKey:@"userName"];
    }

    model.relationGroupId  = [[dict im_valueStringForKey:Dict_relationGroupId]longLongValue];
    model.remark           = [dict im_valueStringForKey:Dict_remark];
    model.tag              = [dict im_valueStringForKey:Dict_tag];
    
    model.relationModified = [[dict im_valueStringForKey:Dict_relationModified] longLongValue];
    model.mobile   = [dict im_valueStringForKey:Dict_mobile];
    model.relation = [[dict im_valueStringForKey:Dict_relation] boolValue];
    model.imNumber = [dict im_valueStringForKey:@"imNumber"];
    
    model.relationAvatar   = [dict im_valueStringForKey:Dict_relationAvatar];
    NSString *avatar = [dict im_valueStringForKey:@"avatar"];
    if ([avatar length]) model.relationAvatar = avatar;
    
    return model;
}

@end
