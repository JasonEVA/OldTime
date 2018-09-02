//
//  MessageRelationGroupModel.m
//  MintcodeIM
//
//  Created by williamzhang on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "MessageRelationGroupModel.h"
#import "NSDictionary+IMSafeManager.h"
#import "MessageRelationInfoModel.h"

#define Dict_sqlID                    @"sqlId"
#define Dict_relationGroupId          @"relationGroupId"
#define Dict_relationGroupName        @"relationGroupName"
#define Dict_relationList             @"relationList"

@implementation MessageRelationGroupModel

+ (MessageRelationGroupModel *)modelWithDict:(NSDictionary *)dict
{
    MessageRelationGroupModel * model = [[MessageRelationGroupModel alloc] init];
    model.relationGroupId   = [[dict im_valueStringForKey:Dict_relationGroupId] longLongValue];
    model.relationGroupName = [dict im_valueStringForKey:Dict_relationGroupName];
    model.isDefault         = [dict im_valueBoolForKey:@"defaultNameFlag"];
    model.defaultNameFlag   = [dict im_valueNumberForKey:@"defaultNameFlag"];
    
    model.relationList = [[NSMutableArray alloc] init];
    
    NSArray * array = [dict im_valueArrayForKey:Dict_relationList];
    if (array) {
        for (int i = 0; i < array.count; i ++) {
            MessageRelationInfoModel * infoModel = [MessageRelationInfoModel modelWithDict:array[i]];
            [model.relationList addObject:infoModel];
        }
    }
    return model;
}

@end
